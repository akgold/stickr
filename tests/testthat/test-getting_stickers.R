get_filename <- function(x, name) substr(x, nchar(x) - (nchar(name) + 3), nchar(x))

test_that("Getting Stickers Works", {
  f <- stickr_get("R6", view  = FALSE)
  expect_equal(get_filename(f, "r6"), "R6.png")
  expect_true(file.exists(f))

  f <- stickr_get("R6", filename = "R6.svg", view = FALSE)
  expect_equal(get_filename(f, "r6"), "R6.svg")
  expect_true(file.exists(f))

  f <- stickr_get("tidytext", view = FALSE)
  expect_equal(get_filename(f, "tidytext"), "tidytext.png")
  expect_true(file.exists(f))

  f <- stickr_get("textmineR", filename = "textmineR_v8.png", view = FALSE)
  expect_equal(get_filename(f, "textmineR"), "textmineR.png")
  expect_true(file.exists(f))
})

test_that("Inserting Stickers Works", {
  f <- stickr_insert("R6", filename = "R6.svg", dpi = 500)
  expect_equal(get_filename(f[1], "r6"), "R6.svg")
  expect_true(file.exists(f[1]))
  expect_equal(class(f), c("knit_image_paths", "knit_asis"))
  expect_equal(attr(f, "dpi"), 500)
})
