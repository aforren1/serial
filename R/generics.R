# Generics

#' @export
write_data <- function(con, dat, ...) UseMethod("write_data")

#' @export
read_data <- function(con, ...) UseMethod("read_data")
