# Utilities

#' Looks for serial ports in use.
#' 
#' This function checks for serial ports in use on the host device.
#' 
#' @usage check_devices()
#' 
#' @return A character vector with all active devices, or `character(0)` if no device is found.
#' @examples
#' \dontrun{
#' available_devices <- check_devices()
#' }
#' @importFrom utils file_test
#' @export
check_devices <- function() {
  os <- ifelse(identical(.Platform$OS.type, 'windows'), 'windows', 
               ifelse(grep('linux', R.version$platform), 'linux', 'osx'))
  
  if (identical(os, "linux")) {
    if (file_test("-d", "/dev/serial/by-id")) { # only exists when device connected
      # check symbolic links
      cmmd <- 'ls -l /dev/serial/by-id | grep "\\->"'
      dev_info <- system(cmmd, intern = TRUE)
      regmatches(dev_info, regexpr('(?:tty).*', text = dev_info))
    } else {
      character(0)
    }
  } 
  
  else if (identical(os, "windows")) {
    cmmd <- 'REG QUERY HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM'
    dev_info <- system(cmmd, intern = TRUE)
    regmatches(dev_info, regexpr('(?:COM)[0-9]{1,3}', text = dev_info))
  } 
  
  else if (identical(os, "osx")) {
    dev_info <- system('ls /dev/tty.*', intern = TRUE)
    regmatches(dev_info, regexpr("(?:tty).*", text = dev_info))
  } 
  
  else {
    stop("Unidentified platform.")
  }
}

#' Writes data to the serial interface. 
#' 
#' @param con Object of class \code{serialConnection}
#' @param dat Data string to write on the serial interface. This can either
#'                be a character string or any R object that can be coerced
#'                to a character string by the \code{\link{toString}} function,
#'                though the latter occurs with a warning. 
#'                See the example section in \code{\link{serial}}.
#' @param ... Currently ignored.
#' @method write_data serialConnection
#' @aliases write_data.serialConnection
#' @usage write_data(con, dat, ...)
#' @seealso \code{\link{serial}} \code{\link{read_data}}
#' @examples
#'# See the top package documentation for a complete example.
#'  
#'\dontrun{
#'write_data(con, "Hello World!")
#'write_data(con, 2) # coerce with warning
#'}
#' @method write_data serialConnection
#' @export
write_data <- function(con, dat, ...) UseMethod("write_data")

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

#' Reads from the serial interface.
#' 
#' This function reads from the serial interface as long as the buffer is not
#' empty. The read takes place per byte.
#' 
#' @method read_data serialConnection
#' 
#' @param con Object of class \code{serialConnection}
#' @param ... Currently ignored.
#' 
#' @aliases read_data.serialConnection
#' @usage read_data(con, ...)
#' 
#' @return The result is a string, which can be converted to raw as necessary.

#' @seealso \code{\link{serial}} \code{\link{write_data}}
#' @examples
#'# See the top package documentation for a complete example.
#'\dontrun{
#'data_in <- read_data(con)
#'}
#' @method read_data serialConnection
#' @export
read_data <- function(con, ...) UseMethod("read_data")

#' Writes data to the serial interface. 
#'
#' Deprecated, please use \code{\link{read_data}}.
#' @param con Object of class \code{serialConnection}
#' @param ... Currently ignored.
#' @export
read.serialConnection <- function(con, ...) UseMethod("read_data")