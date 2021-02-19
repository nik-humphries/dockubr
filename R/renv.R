#' Quietly execute a function
#'
#' @param x A function
quiet <- function(x) {
  sink(tempfile())
  on.exit(sink())
  invisible(force(
    suppressMessages(x)
  ))
}

#' Check if renv is activated
#'
#' @return TRUE/FALSE if renv is active / not active
#' @export
#'
#' @examples
checkIfRenvActivated <- function() {

  #if(length(quiet(renv::status())) == 0) return(FALSE) else return(TRUE)
  if(length(quiet(renv::project())) == 0) return(FALSE) else return(TRUE)

}

#' Check if dockubu is in renv ignored packages
CheckifInRenv <- function() {

  if(checkIfRenvActivated() == TRUE) {
    if(!"dockubu" %in% renv::settings$ignored.packages() | length(renv::settings$ignored.packages() == 0)){
      message("It is recommended to include dockubu in the ignored packages by running dockubu::removeFromRenv()")
    }
  }

}

#' Add dockubu to ignored packages in renv
#'
#' @export
removeFromRenv <- function() {

  renv::settings$ignored.packages(
    unique(
      c("dockubu",
        renv::settings$ignored.packages()
        )
      )
    )

}

