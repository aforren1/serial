#' Writes data to serial interface. 
#' 
#' @param con serial connection
#' @param dat data string to write on the serial interface. This can either
#'                be a character string or any R object that can be coerced
#'                to a character string by the \code{\link{toString}} function,
#'                though the latter occurs with a warning. 
#'                See the example section in \code{\link{serial}}.
#' 
#' @usage write.serialConnection(con, dat)
#' @seealso \code{\link{serial}}
#' @examples
#'  # See the top package documentation
#'  
#'  \dontrun{write.serialConnection(con, "Hello World!")}
#' @export
write.serialConnection <- function(con, dat) {
  
  stopifnot(is(con, 'serialConnection'))
  if (!is(dat, 'character')) {
    warning('dat is not a character, coercing to character with toString().')
    dat <- toString(dat)
  }
  
  nl <- ifelse(con$newline, "", "-nonewline ")
  .Tcl(paste("puts ", nl, "$sdev_", con$port, " \"", dat, "\"", sep = ""))
  
  #   ..," \"", dat,"\"",.. -> quotes dat in TCL String
  #   with out quoting space and control characters this will fail 
  NULL
}

#' Reads from the serial interface.
#' 
#' This function reads from the serial interface as long as the buffer is not
#' empty. The read takes place per byte.
#' 
#' 
#' @param con serial connection
#' 
#' @usage read.serialConnection(con)
#' 
#' @return The result is a string, which can be converted to raw as necessary

#' @seealso \code{\link{serial}}
#' @examples
#'  # See the top package documentation
#' @export
read.serialConnection <- function(con) {
  stopifnot(is(con, 'serialConnection'))
  res <- ""
  while(1) {
    tmp <- tclvalue(.Tcl(paste("gets $sdev_", con$port, sep = "")))
    if (tmp == "") break
    res <- paste(res, tmp, sep = "")
  }
  res
}

#' Looks for active serial ports.
#' 
#' This function checks for active serial ports on the host device.
#' 
#' @usage check.devices()
#' 
#' @return A character vector with all active devices, or `character(0)` if no device is found.
#' 
#' @export
check.devices <- function() {
  os <- .Platform$OS.type
  if (identical(os, "unix")) {
    temp_dir <- "/dev/serial/by-id"
    if (file_test("-d", temp_dir)) {
      # check symbolic links
      cmmd <- 'ls -l /dev/serial/by-id | grep "\\->"'
      dev_info <- system(cmmd, intern = TRUE)
      regmatches(dev_info, regexpr('(?:tty).*', text = dev_info))
    } else {
      character(0)
    }
    
  } else if (identical(os, "windows")) {
    cmmd <- 'REG QUERY HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM'
    dev_info <- system(cmmd, intern = TRUE)
    regmatches(dev_info, regexpr('(?:COM)[0-9]{1,3}'))
  } else {
    stop("Unidentified platform.")
  }
}