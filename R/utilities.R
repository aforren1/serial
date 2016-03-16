# Utilities

#' Writes data to serial interface. 
#' 
#' @param con serial connection
#' @param dat data string to write on the serial interface. This can either
#'                be a character string or any R object that can be coerced
#'                to a character string by the \code{\link{toString}} function,
#'                though the latter occurs with a warning. 
#'                See the example section in \code{\link{serial}}.
#' @param ... unused for now.
#' @method write_data serialConnection
#' @aliases write_data.serialConnection
#' @usage write_data(con, dat, ...)
#' @seealso \code{\link{serial}}
#' @examples
#'  # See the top package documentation
#'  
#'  \dontrun{write_data(con, "Hello World!")}
#' @method write_data serialConnection
#' @export
write_data <- function(con, dat, ...) UseMethod("write_data")

#' Reads from the serial interface.
#' 
#' This function reads from the serial interface as long as the buffer is not
#' empty. The read takes place per byte.
#' 
#' @method read_data serialConnection
#' 
#' @param con serial connection
#' @param ... unused for now.
#' 
#' @aliases read_data.serialConnection
#' @usage read_data(con, ...)
#' 
#' @return The result is a string, which can be converted to raw as necessary

#' @seealso \code{\link{serial}}
#' @examples
#'  # See the top package documentation
#' @method read_data serialConnection
#' @export
read_data <- function(con, ...) UseMethod("read_data")