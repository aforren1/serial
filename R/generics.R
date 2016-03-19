# Generics

write_data <- function(con, dat, ...) UseMethod("write_data")

read_data <- function(con, ...) UseMethod("read_data")

