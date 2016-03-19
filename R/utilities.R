# Utilities

#' Looks for serial ports in use.
#' 
#' This function checks for serial ports in use on the host device.
#' 
#' @usage find_devices()
#' 
#' @return A character vector with all active devices, or `character(0)` if no device is found.
#' @examples
#' \dontrun{
#' available_devices <- find_devices()
#' }
#' @importFrom utils file_test
#' @export
find_devices <- function() {
  os <- get_os()
  if (identical(os, "linux")) {
    if (file_test("-d", "/dev/serial/by-id")) { # dir only exists when device connected
      # check symbolic links
      cmmd <- 'ls -l /dev/serial/by-id | grep "\\->"'
      dev_info <- system(cmmd, intern = TRUE)
      regmatches(dev_info, regexpr('(?:tty).*|(?:cu).*', text = dev_info))
    } else {
      character(0)
    }
  } 
  
  else if (identical(os, "win")) {
    cmmd <- 'REG QUERY HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM'
    dev_info <- system(cmmd, intern = TRUE)
    regmatches(dev_info, regexpr('(?:COM)[0-9]{1,3}', text = dev_info))
  } 
  
  else if (identical(os, "mac")) {
    dev_info <- system('ls /dev/tty.*', intern = TRUE)
    regmatches(dev_info, regexpr("(?:tty).*|(?:cu).*", text = dev_info))
  } 
  
  else {
    stop("Unidentified platform.")
  }
}

# modified from https://github.com/hadley/rappdirs (MIT License, attribute!)
get_os <- function() {
  if (.Platform$OS.type == "windows") { 
    "win"
  } else if (Sys.info()["sysname"] == "Darwin") {
    "mac" 
  } else if (.Platform$OS.type == "unix") { 
    "linux" # maybe not correct, as this could catch solaris?
  } else {
    stop("Unknown OS")
  }
}