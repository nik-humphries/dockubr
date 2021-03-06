% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/renv_get.R
\name{packageVectorFromlockfile}
\alias{packageVectorFromlockfile}
\title{Get vector of packages in lock file}
\usage{
packageVectorFromlockfile(lockfilepath = NULL)
}
\arguments{
\item{lockfilepath}{Must be the path to a lock file generated by RENV. If NULL it will look for renv.lock in project root}
}
\value{
A vector of package names
}
\description{
Get vector of packages in lock file
}
