library(serial)
context("Don't need device")
con <- serialConnection()
test_that("Functions that do not need device work", {
  expect_is(con, "serialConnection")
  expect_is(find_devices(), "character") # might fail on solaris
})