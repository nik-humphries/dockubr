#' Title
#'
#' @param yourpackages
#' @param dep_list
#'
#' @return
#' @export
#'
#' @examples
#' @importFrom magrittr %>%
extractDependencies <- function(yourpackages, dep_list = dep_list) {

  dep_list %>%
    dplyr::filter(package %in% yourpackages)

}

createAptGet <- function(deps) {

  libnames <- deps %>%
    dplyr::filter(type == "apt-get") %>%
    dplyr::distinct(dependency) %>%
    dplyr::mutate(dependency = stringr::str_extract(dependency, "(?<=apt-get\\sinstall\\s-y\\s).*$"))

  if(nrow(libnames) == 0) return()

  cat("RUN apt-get update -qq && apt-get -y --no-install-recommends install \\ ", "\n")

  for(aname in 1:nrow(libnames)) {
    if(aname < nrow(libnames) & nrow(libnames) > 1) {
      cat(libnames[aname, "dependency"] %>% dplyr::pull(), "\\", "\n")
    } else {
      cat(libnames[aname, "dependency"] %>% dplyr::pull(), "\n")
    }

  }

}

createRCMD <- function(deps) {

  libnames <- deps %>%
    dplyr::filter(type == "R CMD") %>%
    dplyr::distinct(dependency)

  if(nrow(libnames) == 0) return()

  for(aname in 1:nrow(libnames)) {

    if(aname == 1 & nrow(libnames) > 1) {
      cat("RUN", libnames[aname, "dependency"] %>% dplyr::pull(), "&& \\", "\n")
    } else if (aname == 1) {
      cat("RUN", libnames[aname, "dependency"] %>% dplyr::pull(), "\n")
    } else if(aname < nrow(libnames)) {
      cat(libnames[aname, "dependency"] %>% dplyr::pull(), "&& \\", "\n")
    } else {
      cat(libnames[aname, "dependency"] %>% dplyr::pull(), "\n")
    }

  }

}

createAddApt <- function(deps) {

  libnames <- deps %>%
    dplyr::filter(type == "Other")

  if(nrow(libnames) == 0) return()

  addapt <- libnames %>%
    dplyr::filter(stringr::str_detect(dependency, "add-apt-repository")) %>%
    dplyr::distinct(dependency)


  for(aname in 1:nrow(libnames)) {

    if(aname == 1 & nrow(libnames) > 1) {
      cat("RUN", libnames[aname, "dependency"] %>% dplyr::pull(), "&& \\", "\n")
    } else if (aname == 1) {
      cat("RUN", libnames[aname, "dependency"] %>% dplyr::pull(), "\n")
    } else if(aname < nrow(libnames)) {
      cat(libnames[aname, "dependency"] %>% dplyr::pull(), "&& \\", "\n")
    } else {
      cat(libnames[aname, "dependency"] %>% dplyr::pull(), "\n")
    }

  }

}

outputall <- function(yourpackages) {

  qq <- extractDependencies(yourpackages)

  createAddApt(qq)
  cat("\n")
  createAptGet(qq)
  cat("\n")
  createRCMD(qq)

}

