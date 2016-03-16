#' @export 
write_data.serialConnection <- function(con, dat, ...) {
  
  if (!is(dat, 'character')) {
    warning('dat is not a character, coercing to character with toString().')
    dat <- toString(dat)
  }
  
  nl <- ifelse(con$newline, "", "-nonewline ")
  .Tcl(paste("puts ", nl, "$sdev_", con$port, " \"", dat, "\"", sep = ""))
  
  #   ..," \"", dat,"\"",.. -> quotes dat in TCL String
  #   with out quoting space and control characters this will fail 
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
  } else if (identical(os, "windows")) {
    cmmd <- 'REG QUERY HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM'
    dev_info <- system(cmmd, intern = TRUE)
    regmatches(dev_info, regexpr('(?:COM)[0-9]{1,3}', text = dev_info))
  } else if (identical(os, "osx")) {
    dev_info <- system('ls /dev/tty.*', intern = TRUE)
    regmatches(dev_info, regexpr("(?:tty).*", text = dev_info))
  } else {
    stop("Unidentified platform.")
  }
}