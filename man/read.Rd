% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/serial.R
\name{read}
\alias{read}
\alias{read.serialConnection}
\title{Reads from the serial interface.}
\usage{
\method{read}{serialConnection}(con, ...)
}
\arguments{
\item{con}{Object of class \code{serialConnection}}

\item{...}{Currently ignored.}
}
\value{
The result is a string, which can be converted to raw as necessary.
}
\description{
This function reads from the serial interface as long as the buffer is not
empty. The read takes place per byte.
}
\examples{
# See `help(serial)` for a complete example.
\dontrun{
data_in <- read(con)
}
}
\seealso{
\code{\link{serial}} \code{\link{write}}
}

