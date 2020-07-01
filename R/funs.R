#' Get hex sticker from web
#'
#' This function *tries* to search for the sticker for the package you want. If
#' the package is one with a sticker in the
#' [rstudio/hex-stickers](https://github.com/rstudio/hex-stickers) repository,
#' it will come from there. If you want SVG rather than PNG, specify a filename.
#'
#' If not, this function attempts to get the package's GitHub repository from the
#' package description, and look for the sticker in the man/figures directory.
#'
#' In case this function cannot find the sticker, escape hatches are provided
#' for specifying the repository, path within the repository, and filename of the sticker
#' you want.
#'
#' Packages stored somewhere other than GitHub are currently unsupported.
#'
#' If you hit rate limits on GitHub API calls, consider setting the `GITHUB_PAT` environment variable.
#' See [gh::gh()] for details.
#'
#' @param name name of sticker, character of length 1
#' @param destfile destination, defaults to `NULL`
#' @param view show sticker after loading? Defaults to `TRUE`
#' @param filename filename of sticker in repository, use if auto-detection fails
#' @param repo repository name, use if auto-detection fails
#' @param path path within repository, use if auto-detection fails
#'
#' @return path to downloaded image
#' @export
#'
#' @examples
#' # Get a sticker
#' if(interactive()) r6 <- stickr_get("R6")
#' # Get a sticker in svg
#' if(interactive()) r6 <- stickr_get("R6", filename = "R6.svg")
#' # Get a particular sticker in the man/figures folder
#' if(interactive()) tm <- stickr_get("textmineR", filename = "textmineR_v8.png")
stickr_get <- function(name, destfile = NULL,
                       view = TRUE,
                       filename = NULL, path = NULL, repo = NULL) {

  if (is.null(repo)) {
    repo <-  pkg_repo(name)
  } else {
    repo
  }
  if (is.null(repo)) {
    stop("No GitHub repo. Make sure package is installed or specify repo option.")
  }

  path <- if(is.null(path)){
    stickr_path(filename, repo)
  }else{
    path
  }

  filename <- if (is.null(filename)){
    stickr_filename(name, repo, path)
  } else {
    filename
  }

  destfile <- check_destfile(destfile, name, filename)

  message(paste0("Getting ", name, " sticker from ",
                 file.path("https://github.com", repo, path, filename), "."))
  stickr_load(
    repo,
    path,
    filename,
    destfile
  )

  if (view) {
    stickr_see(destfile, name)
  }

  destfile
}

#' Add hex sticker in R Markdown document
#'
#' Using the `dpi` argument in `...` will help scale width. Higher
#' `dpi` will correspond to smaller images in rendered documents. In some quick
#' testing, a `dpi` of 5000 results in an approximately in-line sized image.
#'
#' If you hit rate limits on GitHub API calls, consider setting the `GITHUB_PAT` environment variable.
#' See [gh::gh()] for details.
#'
#' @inheritParams stickr_get
#' @param ... other arguments passed to [stickr_get()] and [knitr::include_graphics()], consider `dpi`
#'
#' @return Call to [knitr::include_graphics()]
#' @export
#'
#' @examples
#' # This returns a function, really only makes sense inside Rmd
#' if (interactive()) stickr_insert("R6")
stickr_insert <- function(name, ...) {
  requireNamespace("knitr", quietly = TRUE)

  args <- c(list(...), name = name)
  stickr_args <- args[names(args) %in% names(formals(stickr_get))]
  knitr_args <- args[!names(args) %in% names(formals(stickr_get))]

  destfile <- do.call(stickr_get, c(stickr_args, view = FALSE))
  do.call(knitr::include_graphics,c(knitr_args, path = destfile))
}

rs_stickr_list <- function(pic_type = "png") {
  resp <- get(rs_hex_repo, toupper(pic_type))

  names <- vapply(resp, function(x) x$name, character(1))
  names <- names[grepl(paste0("\\.", pic_type, "$"), names, ignore.case = TRUE)]
  substr(names, 1, nchar(names) - 4)
}

###### Internal Funcs
rs_hex_repo <- "rstudio/hex-stickers"
base_url <- function(repo) file.path("/repos", repo, "contents")

stickr_see <- function(path, name) {
  file.show(path, header = name, title = name)
}

get <- function(repo, path) {
  gh::gh(file.path(base_url(repo), path))
}

stickr_load <- function(repo, path, filename, destfile) {
  resp <- get(repo, file.path(path, filename))

  destfile <- file(destfile, "wb")
  base64enc::base64decode(what = resp$content, output = destfile)
  close(destfile)

  base64enc::base64decode(resp$content)
}

check_destfile <- function(destfile, name, filename) {
  if (!is.null(destfile) && !fs::dir_exists(fs::path_dir(destfile))) {
    stop("Path to destfile you requested does not exist.")
  }

  if (is.null(destfile)) {
    destfile <- tempfile()
    dir.create(destfile)
    destfile <- file.path(destfile, paste0(name, ".", get_filetype(filename)))
  }

  destfile
}

#### Path Getters

stickr_path <- function(filename, repo) {
  if (repo == rs_hex_repo) {
    return(get_filetype(filename, TRUE))
  } else  {
    return("man/figures")
  }
}

get_filetype <- function(x, toupper = FALSE) {
  val <- NULL
  if (is.null(x)) {
    val <- "png"
  } else {
    val <- substr(x, nchar(x) - 2, nchar(x))
  }

  stopifnot(val %in% c("png", "svg"))
  if (toupper) val <- toupper(val)
  val
}

#### Repo Getters

pkg_repo <- function(pkg) {
  if (pkg %in% rs_stickr_list()) return(rs_hex_repo)
  get_pkg_git(pkg)
}

get_pkg_git <- function(pkg) {
  desc <- tryCatch(utils::packageDescription(pkg),
                   warning = function(e) "Not Found")

  if (desc[1] == "Not Found") return(NULL)

  txt <- unclass(desc)[c("url", "bugreports",
                         "URL", "BugReports")]
  txt <- txt[!vapply(txt, is.null, logical(1))]
  if (length(txt) == 0) return(NULL)

  # paste looks stupid, but needed to make sure trailing / has match
  match <- stringr::str_match(
    paste0(txt, "/"),
    "github\\.com\\/(.+?\\/.+?)\\/"
  )[, 2]

  unique(match[!vapply(match, is.na, logical(1))])
}

get_gh_sticker_url <- function(repo, filename) {
  url <- base_url(repo)

  if (repo == rs_hex_repo) {
    url <- file.path(url, "PNG", filename)
  } else {


  }
}

###### Filename Creators

stickr_filename <- function(name, repo, path) {
  filename <- NULL
  if (repo == rs_hex_repo) {
    filename <- paste0(name, ".png")
  } else {
    filename <- gh_filename(repo, path)
    if (is.null(filename) || length(filename) == 0) {
      stop("Cannot detect logo file, consider using filename argument.")
    } else if (length(filename) > 1) {
      stop(paste(c("Multiple filenames found, provide *one* of these to filename argument: ",
                   paste(filename, collapse = ", "))))
    }
  }

  filename
}

gh_filename <- function(repo, path) {
  tryCatch({
    file_names <- vapply(get(repo, path), function(x) x$name, character(1))
    file_names[stringr::str_detect(file_names, "logo")]
  },
  error = function(e) {
    print(e)
    return(NULL)
  })
}

