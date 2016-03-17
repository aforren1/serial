# Generics

#' Writes data to the serial interface. 
#' 
#' @param con Object of class \code{serialConnection}
#' @param dat Data string to write on the serial interface. This can either
#'                be a character string or any R object that can be coerced
#'                to a character string by the \code{\link{paste}} function,
#'                though the latter occurs with a warning. 
#'                See the example section in \code{\link{serial}}.
#' @param ... Currently ignored.
#' @aliases write_data.serialConnection write.serialConnection
#' @seealso \code{\link{serial}} \code{\link{read_data}}
#' @examples
#'# See the top package documentation for a complete example.
#'  
#'\dontrun{
#'write_data(con, "Hello World!")
#'write_data(con, 2) # coerce with warning
#'}
#' @export
write_data <- function(con, dat, ...) UseMethod("write_data")

#' Reads from the serial interface.
#' 
#' This function reads from the serial interface as long as the buffer is not
#' empty. The read takes place per byte.
#' 
#' @param con Object of class \code{serialConnection}
#' @param ... Currently ignored.
#' 
#' @aliases read_data.serialConnection read.serialConnection
#' 
#' @return The result is a string, which can be converted to raw as necessary.
#' @seealso \code{\link{serial}} \code{\link{write_data}}
#' @examples
#'# See the top package documentation for a complete example.
#'\dontrun{
#'data_in <- read_data(con)
#'}
#' @export
read_data <- function(con, ...) UseMethod("read_data")

