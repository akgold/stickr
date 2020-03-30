library(testthat)

test_that("git repo getting works", {
  expect_equal(get_pkg_git("stickr"), "akgold/stickr")
  expect_equal(get_pkg_git("textmineR"), "TommyJones/textmineR")
  expect_equal(get_pkg_git("tidytext"), "juliasilge/tidytext")
})
