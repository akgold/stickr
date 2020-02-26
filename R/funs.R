#' Get hex sticker from web
#'
#' If you hit rate limits on github API calls, consider setting the GITHUB_PAT environment variable.
#' See \code{\link[gh:gh]{?gh::gh}} for details.
#'
#' @param name name of sticker, character of length 1
#' @param pic_type one of "svg" or "png", defaults to "png"
#' @param destfile destination, defaults to NULL
#' @param view show sticker after loading? Defaults to TRUE
#'
#' @return path to downloaded image
#' @export
#'
#' @examples
#' r6 <- stickr_get("R6")
stickr_get <- function(name, pic_type = "png", destfile = NULL, view = TRUE) {
  name <- stickr_name(name, pic_type)
  destfile <- check_destfile(destfile, name)

  stickr_load(
    file.path(toupper(pic_type), name),
    destfile
  )

  if (view) {
    stickr_see(destfile, name)
  }

  destfile
}

#' Add hex sticker in Rmd doc
#'
#' Using the \code{dpi} argument in \code{...} will help scale width. Higher
#' dpi will correspond to smaller images in rendered documents. In some quick
#' testing, a dpi of 5000 results in an approximately in-line sized image.
#'
#' If you hit rate limits on github API calls, consider setting the GITHUB_PAT environment variable.
#' See \code{\link[gh:gh]{?gh::gh}} for details.
#'
#' @inheritParams stickr_get
#' @param ... other arguments passed to \code{\link[knitr:include_graphics]{?knitr::include_graphics}}, consider \code{dpi}
#'
#' @return call to \code{\link[knitr:include_graphics]{?knitr::include_graphics}}
#' @export
#'
#' @examples
#' stickr_insert("R6")
stickr_insert <- function(name, pic_type = "png", destfile = NULL, ...) {
  requireNamespace("knitr", quietly = TRUE)

  destfile <- stickr_get(name, pic_type, destfile)
  knitr::include_graphics(destfile, ...)
}

#' List available stickers
#'
#' @inherit stickr_get
#'
#' @return character vector of sticker names
#' @export
#'
#' @examples
#' stickr_list()
stickr_list <- function(pic_type = "png") {
  pic_type <- check_type(pic_type)

  resp <- get(toupper(pic_type))

  names <- vapply(resp, function(x) x$name, character(1))
  names <- names[grepl(paste0("\\.", pic_type, "$"), names, ignore.case = TRUE)]
  substr(names, 1, nchar(names) - 4)
}

#' View RStudio Stickers
#'
#' @inherit stickr_get
#'
#' @return file where sticker is, invisibly
#' @export
#'
#' @examples
#' stickr_view("R6")
stickr_view <- function(name, pic_type = "png") {
  full_name <- stickr_name(name, pic_type)
  img <- stickr_get(name, pic_type)

  stickr_see(img, full_name)
  invisible(img)
}

###### Internal Funcs

base_url <- "/repos/rstudio/hex-stickers/contents"

stickr_see <- function(path, name) {
  file.show(path, header = name, title = name)
}

get <- function(path) {
  gh::gh(file.path(base_url, path))
}

stickr_load <- function(path, destfile) {
  resp <- get(path)

  destfile <- file(destfile, "wb")
  base64enc::base64decode(what = resp$content, output = destfile)
  close(destfile)

  base64enc::base64decode(resp$content)
}

check_destfile <- function(destfile, name) {
  if (!is.null(destfile) && !fs::dir_exists(fs::path_dir(destfile))) {
    stop("Path to destfile you requested does not exist.")
  }

  if (is.null(destfile)) {
    destfile <- tempfile()
    dir.create(destfile)
    destfile <- file.path(destfile, name)
  }

  destfile
}

stickr_name <- function(name, pic_type) {
  pic_type <- check_type(pic_type)

  if (!name %in% stickr_list(pic_type)) {
    stop("Name does not appear for this pic_type, check stickr_list().")
  }

  name <- paste0(name, ".", pic_type)

  name
}

check_type <- function(x) {
  x <- tolower(x)
  stopifnot(x %in% c("png", "svg"))
  x
}


