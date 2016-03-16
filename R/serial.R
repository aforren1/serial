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