# Deprecated

#' Writes data to the serial interface. 
#'
#' Deprecated, please use \code{\link{write_data}}.
#' @param con Object of class \code{serialConnection}
#' @param dat Data string to write on the serial interface. This can either
#'                be a character string or any R object that can be coerced
#'                to a character string by the \code{\link{toString}} function,
#'                though the latter occurs with a warning. 
#'                See the example section in \code{\link{serial}}.
#' @param ... Currently ignored.
#'@export
write.serialConnection <- function(con, dat, ...) UseMethod("write_data")

#' Writes data to the serial interface. 
#'
#' Deprecated, please use \code{\link{read_data}}.
#' @param con Object of class \code{serialConnection}
#' @param ... Currently ignored.
#' @export
read.serialConnection <- function(con, ...) UseMethod("read_data")