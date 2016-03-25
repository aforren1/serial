# # Try to catch incomplete tcltk on osx
# .onAttach <- function(...) {
#   if (grepl("darwin", R.version$os) & 
#       length(list.files("/opt/X11/bin", pattern = "Xquartz")) == 0) {
#     packageStartupMessage(paste("X11 is required. Please visit",
#                                 "http://xquartz.macosforge.org",
#                                 "to download and install Xquartz."))
#     stop()
#   } 
# }