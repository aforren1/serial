#' Sets up the interface parameters.
#' 
#' @param port  COM port name, should also work in Linux. Also, virtual COMs are 
#'              supported -- USB should work too.
#' @param mode  communication mode "\code{<BAUD>, <PARITY>, <DATABITS>, <STOPBITS>}"
#' \describe{
#'    \item{\code{BAUD}}{sets the baud rate (bits per second)}
#'    \item{\code{PARITY}}{\emph{n, o, e, m, s} stands for "none", "odd", "even", "mark" and "space"}
#'    \item{\code{DATABITS}}{integer number of data bits. The value can range from 5 to 8}
#'    \item{\code{STOPBITS}}{integer number of stop bits. This can be "1" or "2"}
#'        }       
#'              
#' @param buffering "\code{none}", for RS232 serial interface only; other modes don't work in this case
#' @param newline \code{<BOOL>}, whether a new transmission starts with a newline or not
#'                \describe{
#'                  \item{\code{TRUE} or 1}{send newline-char according to \code{<translation>} before transmitting}
#'                  \item{\code{FALSE} or 0}{no newline}
#'                          }
#' @param handshake determines the type of handshaking the communication
#'                  \describe{
#'                    \item{"\code{none}"}{no handshake is done}
#'                    \item{"\code{rtscts}"}{hardware handshake is enabled}
#'                    \item{"\code{xonxoff}"}{software handshake via extra characters is enabled}
#'                    }
#' 
#' @param eof \code{<CHAR>}, termination char of the datastream. It only makes sense
#'        if \code{<translation>} is 'binary' and the stream is a file
#' @param translation each transmitted string is terminated by the transmission
#'       character. This could be 'lf', 'cr', 'crlf', or 'binary'
#' @return An object of the class "\code{serialConnection}" is returned.
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
#' @method open serialConnection
#' @aliases open
#' 
#' @param con Object of class \code{serialConnection}.
#' @param ... Currently ignored.
#' @seealso \code{\link{serialConnection}} \code{\link{close}}
#' @examples
#' \dontrun{
#' con <- serialConnection(port = 'com5')
#' open(con)
#' }
#' @import tcltk
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
  
  .Tcl( paste("fconfigure $sdev_",con$port,
              " -mode ", con$mode,
              " -buffering ", con$buffering,
              " -blocking 0", eof,
              " -translation ", con$translation,
              " -handshake ", con$handshake, sep = ""))
  invisible(NULL)
  ## it seems that -eofchar doesn't work
  ## "buffering none" is recommended, other setings doesn't work to send 
}

#' Function to close a serial interface.
#' 
#' This function closes the corresponding connection.
#' 
#' @method close serialConnection
#' @aliases close
#' @param con Object of class \code{serialConnection}.
#' @param ... Currently ignored.
#' 
#' @examples
#' \dontrun{
#' close(con)
#' }
#' 
#' @seealso \code{\link{serialConnection}} \code{\link{open}}
#' @import tcltk
#' @export
close.serialConnection <- function(con, ...) {
  .Tcl(paste("close $sdev_", con$port, sep = ""))
  invisible(NULL)
}

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

#' @export 
write_data.serialConnection <- function(con, dat, ...) {
  
  if (!is(dat, 'character')) {
    warning('dat is not a character, coercing to character with paste().')
    dat <- paste(dat)
  }
  
  nl <- ifelse(con$newline, "", "-nonewline ")
  .Tcl(paste("puts ", nl, "$sdev_", con$port, " \"", dat, "\"", sep = ""))
  #   ..," \"", dat,"\"",.. -> quotes dat in TCL String
  #   with out quoting space and control characters this will fail 
  invisible(NULL)
}
