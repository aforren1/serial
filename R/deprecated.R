# Deprecated

#' @export
write.serialConnection <- function(con, dat, ...) UseMethod("write_data")

#' @export
read.serialConnection <- function(con, ...) UseMethod("read_data")