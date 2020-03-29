# stickr

<!-- badges: start -->
<!-- badges: end -->

The goal of stickr is to make it easier for you to include any RStudio hex stickers in your work.

The complete list of RStudio hex stickers is available on [GitHub](https://github.com/rstudio/hex-stickers).

## Installation

You can install the released version of stickr from [GitHub](https://github.com/akgold/stickr) with:

``` r
remotes::install_github("akgold/stickr")
```

## Example

This is a basic example which shows you how to find and download a sticker:

``` r
library(stickr)

# View the tidyverse sticker
stickr_view("tidyverse")

# Get the tidyverse sticker, downloads to temp file if no destfile specified
stickr_get("tidyverse")

# Get a sticker that's not in the RStudio repo
stickr_get("textmineR")

# But that's the old sticker, get the new one by name
stickr_get("textmineR", filename = "textmineR_v8.png")
```

A common use case would be to include in an [RMarkdown](https://rmarkdown.rstudio.com/) document, 
that would be done using `stickr_insert("tidyverse")`. If trying to insert inline, consider using `dpi` argument.

# Package Maintainers
Want to make sure users can get your sticker with `stickr`? Two steps!

1. Make sure your package's DESCRIPTION file includes a [URL and/or BugReport field field](https://www.r-bloggers.com/about-urls-in-description/) that points to your package's github repo.
2. Put your hex sticker in the `/man/figures` directory inside your package -- one named `logo.png` will be used by default, but other names are ok too.
