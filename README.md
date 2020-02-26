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
## basic example code
stickr_list()
stickr_get("R6", destfile = here::here("img/R6.png"))
```

A common use case would be to include in an [RMarkdown](https://rmarkdown.rstudio.com/) document, 
that would be done using `r stickr_insert("R6")`.
