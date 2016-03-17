# this test only works on linux, and is dependent 
# on already having a virtual device set up (which I failed to do in travis)
# library(serial)
# context('test virtual device')
# 
# con <- serialConnection('tnt0')
# con2 <- serialConnection('tnt1')
# test_that("Functions work for virtual device", {
#   expect_silent(open(con))
#   expect_silent(open(con2))
#   expect_silent(write_data(con, 'test'))
#   expect_warning(write_data(con, 2))
#   expect_is(read_data(con), 'character') #TODO: actually read *some* input
#   expect_silent(close(con))
#   expect_silent(close(con2))
# })