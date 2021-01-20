#' extractDependencies
#'
#' @param yourpackages list of packages passed by user
#' @param dep_list dependency list
#'
#' @return
#'
#' @importFrom magrittr %>%
extractDependencies <- function(yourpackages) {

  package <- NULL

  dep_list2 <- dep_list %>%
    dplyr::filter(package %in% yourpackages)

  notfound <- yourpackages[!yourpackages %in% (dep_list2 %>% dplyr::distinct(package) %>% dplyr::pull())]
  if(length(notfound) > 0) message(paste0("The following packages have no dependencies found: ", paste0(notfound, collapse = ", ")))

  return(dep_list2)

  }

#' asdad
#'
#' @param deps Doesn't matyter
#'
#' @return
#'
#' @importFrom magrittr %>%
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

#' dddddd
#'
#' @param deps dasdasd
#'
#' @return
#'
#' @importFrom magrittr %>%
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

#' aaaaaaaaaaa
#'
#' @param deps
#'
#' @return
#'
#' @importFrom magrittr %>%
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

#' Output the thing to copy / paste into your dockerfile
#'
#' @param yourpackages Vector of package names
#'
#' @return Console output to copy into your docker file
#' @export
generateDockerText <- function(yourpackages) {

  if(class(yourpackages) != "character") stop("Class of package vector is not character")

  qq <- extractDependencies(yourpackages)

  void_sink <- createAddApt(qq)
  cat("\n")
  void_sink <- createAptGet(qq)
  cat("\n")
  void_sink <- createRCMD(qq)

}

