# Generics

#' @export
read <- function(con, ...) UseMethod("read")

#' @export
write <- function(x, ...) UseMethod("write")

#' @export
write.default <- function(x, ...) base::write(x, ...)