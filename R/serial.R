#' Sets up the interface parameters.
#' 
#' @param port  the COM port name, should also work in Linux. Also, virtual COMs are 
#'              supported, meaning USB should work too.
#' @param mode  the communication mode "\code{<BAUD>, <PARITY>, <DATABITS>, <STOPBITS>}".
#' \describe{
#'    \item{\code{BAUD}}{sets the baud rate (bits per second).}
#'    \item{\code{PARITY}}{\emph{n, o, e, m, s} stands for "none", "odd", "even", "mark" and "space".}
#'    \item{\code{DATABITS}}{integer number of data bits. The value can range from 5 to 8.}
#'    \item{\code{STOPBITS}}{integer number of stop bits. This can be "1" or "2".}
#'        }       
#'              
#' @param buffering "\code{none}", for RS232 serial interface only; other modes don't work in this case.
#' @param newline \code{<BOOL>}, whether a new transmission starts with a newline or not.
#'                \describe{
#'                  \item{\code{TRUE} or 1}{send newline-char according to \code{<translation>} before transmitting.}
#'                  \item{\code{FALSE} or 0}{no newline.}
#'                          }
#' @param handshake determines the type of handshaking the communication.
#'                  \describe{
#'                    \item{"\code{none}"}{no handshake is done.}
#'                    \item{"\code{rtscts}"}{hardware handshake is enabled.}
#'                    \item{"\code{xonxoff}"}{software handshake via extra characters is enabled.}
#'                    }
#' 
#' @param eof \code{<CHAR>}, termination char of the datastream. It only makes sense
#'        if \code{<translation>} is "binary" and the stream is a file.
#' @param translation each transmitted string is terminated by the transmission
#'       character. This could be "lf", "cr", "crlf", or "binary".
#' @return An object of the class "\code{serialConnection}" is returned.
#' @seealso \code{\link{serial}} \code{\link{open}} \code{\link{close}}
#' @export
serialConnection <- function(port = "com1", mode = "115200,n,8,1", 
                             buffering = "none", newline = 0, eof = "",
                             translation = "lf", handshake= "none") {
  
  obj <- as.list(environment())
  class(obj) <- "serialConnection"
  obj
}

#' Function to initialize an serial interface.
#' 
#' This function initializes the serial interface and opens it for later usage. 
#' 
#' @name open
#' @method open serialConnection
#' @aliases open open.serialConnection
#' 
#' @param con Object of class \code{serialConnection}.
#' @param ... Currently ignored.
#' @seealso \code{\link{serialConnection}} \code{\link{close}}
#' @examples
#' \dontrun{
#' con <- serialConnection(port = 'com5')
#' open(con)
#' }
#' @importFrom tcltk .Tcl
#' @export
open.serialConnection <- function(con, ...) {
  ## set platform-dependent path
  os_path <- switch(.Platform$OS.type,
                    windows = "//./",
                    unix = "/dev/")
  ## set connection and variables
  .Tcl(paste("set sdev_", con$port," [open ", os_path, con$port, " r+]", sep = ""))
  ## '//./' defines the Windows path for the COM ports
  ## only in this way it is possible to use virtual ports as well
  ## the unix COM ports are located in '/dev/'
  
  ## set up configuration
  eof <- ifelse(con$eof == "", "", paste(" -eofchar ", con$eof, sep = ""))
  
  .Tcl(paste("fconfigure $sdev_",con$port,
              " -mode ", con$mode,
              " -buffering ", con$buffering,
              " -blocking 0", eof,
              " -translation ", con$translation,
              " -handshake ", con$handshake,
              " -timeout ", 5000, sep = ""))
  invisible(NULL)
  ## it seems that -eofchar doesn't work
  ## "buffering none" is recommended, other setings doesn't work to send 
}

#' Function to close a serial interface.
#' 
#' This function closes the corresponding connection.
#' 
#' @name close
#' @method close serialConnection
#' @aliases close close.serialConnection
#' @param con Object of class \code{serialConnection}.
#' @param ... Currently ignored.
#' 
#' @examples
#' \dontrun{
#' close(con)
#' }
#' 
#' @seealso \code{\link{serialConnection}} \code{\link{open}}
#' @importFrom tcltk .Tcl
#' @export
close.serialConnection <- function(con, ...) {
  .Tcl(paste("close $sdev_", con$port, sep = ""))
  invisible(NULL)
}


#' Reads from the serial interface.
#' 
#' This function reads from the serial interface as long as the buffer is not
#' empty. The read takes place per byte.
#' 
#' @name read_data
#' @param con Object of class \code{serialConnection}
#' @param ... Currently ignored.
#' 
#' @aliases read_data read.serialConnection read_data.serialConnection
#' 
#' @return The result is a string, which can be converted to raw as necessary.
#' @seealso \code{\link{serial}} \code{\link{write_data}}
#' @examples
#'# See `help(serial)` for a complete example.
#'\dontrun{
#'data_in <- read_data(con)
#'}
#' @importFrom tcltk .Tcl tclvalue
#' @export 
read_data.serialConnection <- function(con, ...) {
  res <- ""
  while(1) {
    tmp <- tclvalue(.Tcl(paste("gets $sdev_", con$port, sep = "")))
    if (tmp == "") break
    res <- paste(res, tmp, sep = "")
  }
  res
}


#' Writes data to the serial interface. 
#' 
#' @name write_data
#' @param con Object of class \code{serialConnection}
#' @param dat Data string to write on the serial interface. This must be a character string.
#' @param ... Currently ignored.
#' @aliases write_data write.serialConnection write_data.serialConnection
#' @seealso \code{\link{serial}} \code{\link{read_data}}
#' @examples
#'# See `help(serial)` for a complete example.
#'  
#'\dontrun{
#'write_data(con, "Hello World!")
#'write_data(con, 2) # error
#'}
#' @importFrom methods is
#' @importFrom tcltk .Tcl
#' @export 
write_data.serialConnection <- function(con, dat, ...) {
  
  if (!is(dat, 'character')) {
    stop("dat is not a character.")
  }
  
  nl <- ifelse(con$newline, "", "-nonewline ")
  .Tcl(paste("puts ", nl, "$sdev_", con$port, " \"", dat, "\"", sep = ""))
  #   ..," \"", dat,"\"",.. -> quotes dat in TCL String
  #   with out quoting space and control characters this will fail 
  invisible(NULL)
}
