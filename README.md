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

# list available stickers 
stickr_list()

# View the tidyverse sticker
stickr_view("tidyverse")
# Get the tidyverse sticker, downloads to temp file if no destfile specified
stickr_get("tidyverse")
```

A common use case would be to include in an [RMarkdown](https://rmarkdown.rstudio.com/) document, 
that would be done using `stickr_insert("tidyverse")`.
