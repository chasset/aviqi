% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/apply-policy.R
\name{stopOrGo}
\alias{stopOrGo}
\title{Stop or Go}
\usage{
stopOrGo(df)
}
\arguments{
\item{df}{Dataframe received in the pipeline}
}
\value{
Dataframe \code{df}
}
\description{
Depending on the choosen policy and the number of errors found,
it decides if it stops or continues the pipeline process.
}
