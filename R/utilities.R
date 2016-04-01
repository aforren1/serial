# Utilities

#' Find serial ports in use.
#' 
#' This function checks for serial ports in use on the host device.
#' 
#' @usage find_devices()
#' 
#' @return A vector of strings containing the names of all active devices, or 
#' `character(0)` if no device is found.
#' @examples
#' \dontrun{
#' # Use the first active device.
#' available_devices <- find_devices()
#' 
#' con <- serialConnection(available_devices[1])
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
      regmatches(dev_info, regexpr('(?:tty).*', text = dev_info))
    } else {
      character(0)
    }
  } 
  
  else if (identical(os, "win")) {
    cmmd <- 'REG QUERY HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM'
    dev_info <- system(cmmd, intern = TRUE)
    regmatches(dev_info, regexpr('(?:COM)[0-9]{1,3}', text = dev_info))
  } 
  
  else if (identical(os, "osx")) {
    dev_info <- system('ls /dev/tty.*', intern = TRUE)
    gsub("/dev/", "", dev_info)
  } 
  
  else {
    stop("Unidentified platform.")
  }
}

# Try to find out the host operating system
get_os <- function() {
  ifelse(identical(.Platform$OS.type, 'windows'), 'win', 
               ifelse(grepl("darwin", R.version$os), 'osx', 'linux'))
}
