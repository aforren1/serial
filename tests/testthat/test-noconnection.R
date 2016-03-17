library(serial)
context("Don't need device")
con <- serialConnection()
test_that("Functions that do not need device work", {
  expect_that(con, is_a("serialConnection"))
  expect_that(find_devices(), is_a("character"))
})