# Generics

#' @export
write <- function(con, dat, ...) UseMethod("write")

#' @export
read <- function(con, ...) UseMethod("read")
