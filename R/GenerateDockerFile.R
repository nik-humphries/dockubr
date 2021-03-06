#' extractDependencies
#'
#' @param yourpackages Vector of packages as passed by the user
#'
#' @return
#'
#' @importFrom magrittr %>%
extractDependencies <- function(yourpackages) {

  package <- NULL

  dep_list2 <- dockubu::dep_list %>%
    dplyr::filter(package %in% yourpackages)

  notfound <- yourpackages[!yourpackages %in% (dep_list2 %>% dplyr::distinct(package) %>% dplyr::pull())]
  if(length(notfound) > 0) message(paste0("The following packages have no dependencies found: ", paste0(notfound, collapse = ", ")))

  return(dep_list2)

  }

#' Create the text that does the apt-get commands, this needs to run after addapt
#'
#' @param deps Dependency lookup table (package, dependency, type)
#'
#' @return
#'
#' @importFrom magrittr %>%
createAptGet <- function(deps) {

  libnames <- deps %>%
    dplyr::filter(type == "apt-get") %>%
    dplyr::distinct(dependency) %>%
    dplyr::mutate(dependency = stringr::str_extract(dependency, "(?<=apt-get\\sinstall\\s-y\\s).*$"))

  libnames <- libnames %>%
    dplyr::filter(!stringr::str_detect(dependency, "libgit2-dev"))

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

#' Execute the R CMD commands
#'
#' @param deps Dependency lookup table (package, dependency, type)
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

#' Create the add-apt parts for installing from external repos. This MUST be run first.
#'
#' @param deps Dependency lookup table (package, dependency, type)
#' @param ppa Some base images don't work properly with ppa, if it doesn't set this to FALSE and it will try and hard code
#' the path to the PPA. If you set this to FALSE, you must set your version of Ubuntu (e.g. focal etc.)
#'
#' @return
#'
#' @importFrom magrittr %>%
createAddApt <- function(deps, ppa = TRUE) {


  libnames <- deps %>%
    dplyr::filter(type == "Other")

  if(nrow(libnames) == 0) return()

  # First add the necessary bits to enable add-apt

  cat("RUN apt-get update && \\", "\n")
  cat("apt-get install -y software-properties-common", "\n")
  cat("\n")

  # Filter to just distinct entries
  addapt <- libnames %>%
    dplyr::filter(stringr::str_detect(dependency, "add-apt-repository")) %>%
    dplyr::distinct(dependency)


  # Hardcoded fix fot libgit2
  # Replace the add ppa with a custom one
  # This needs to be done sometimes, but not other times ... So add a switch for this
  # May need to hardcode these in for other PPA's.

  if(ppa == FALSE) {
      addapt <- addapt %>%
                  dplyr::mutate(dependency =
                                 dplyr::case_when(
                                   stringr::str_detect(dependency, "ppa:cran/libgit2") ~ stringr::str_replace(dependency, "-y ppa:cran/libgit2", "'deb [trusted=yes] http://ppa.launchpad.net/cran/libgit2/ubuntu <UBUNTU CODENAME> main'"),
                                   TRUE ~ dependency
                                 ))
  }


  for(aname in 1:nrow(addapt)) {

    if(aname == 1) {
      cat("RUN", addapt[aname, "dependency"] %>% dplyr::pull(), "&& \\", "\n")
    } else if(aname < nrow(addapt)) {
      cat(addapt[aname, "dependency"] %>% dplyr::pull(), "&& \\", "\n")
    } else {
      cat(addapt[aname, "dependency"] %>% dplyr::pull(), "\n")
    }

  }

  # Hardcoded fix for libgit2-dev

  if(sum(stringr::str_detect(libnames$dependency, "ppa:cran/libgit2")) > 0) {
    cat("apt-get update && \\", "\n")
    cat("apt-get -y install libgit2-dev", "\n")
  } else {
    cat("apt-get update", "\n")
  }

}

#' Output the thing to copy / paste into your dockerfile
#'
#' @param yourpackages Vector of package names
#' @param ppa TRUE / FALSE - Output the ppa or the hardcoded link for external repos
#'
#' @return Console output to copy into your docker file
#' @export
#'
#' @examples
#' somepackages <- c("gert", "sf", "rkafka", "dplyr")
#' generateDockerText(somepackages)
#' generateDockerText(somepackages, ppa = FALSE)
generateDockerText <- function(yourpackages, ppa = TRUE) {

  CheckifInRenv()

  if(class(yourpackages) != "character") stop("Class of package vector is not character")

  qq <- extractDependencies(yourpackages)

  void_sink <- createAddApt(qq, ppa)
  cat("\n")
  void_sink <- createAptGet(qq)
  cat("\n")
  void_sink <- createRCMD(qq)

}


