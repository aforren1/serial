.onAttach <- function(...) {
  if (grepl("darwin", R.version$os) & length(list.files("/opt/X11/bin", pattern = "Xquartz")) == 0) {
    cat("X11 is required. Please visit http://xquartz.macosforge.org to download and install Xquartz.")
    stop()
  } 
}