# Dockubu

## Summary

Takes a vector of package names. Returns the code to install dependencies for Docker / Ubuntu 18.04

Also can process a lock file to achieve the same effect (2 separate functions)

Last updated package lookup table on 20-01-2021 from https://packagemanager.rstudio.com/client/#/repos/1/overview

### Installation

There are a variety of methods for installing packages directly from gitlab. You may want to research these and find the most appropriate for you. 

You can try running the following code from within R Studio (assuming you know your gitlab username and password and your account has access to the repo):

    cred <- git2r::cred_user_pass(rstudioapi::askForPassword("Username"), 
                                  rstudioapi::askForPassword("Password"))
                                  
    devtools::install_git("https://gitlab.com/n-humphries-gen/dependency-generator-r-ubuntu.git", 
                          credentials = cred, 
                          build_opts = c("--no-resave-data"), 
                          build_vignettes = TRUE)


Alternatively, you could clone the entire repo and build manually.

### Getting Started

As follows

    library(dockubu)

    dockubu::generateDockerText(c("gert", "sf", "rkafka"))

    # Get list of packages from lockfile
    dockubu::packageVectorFromlockfile("G:\\Projects\\renv.lock")
    

### libgit2-dev

There is a dependency conflict relating to libcurl4-gnutls-dev, this external repo installs a version og libgit2 that doesn't require it.

This dep must be installed from a different source, if it's required, it will add it at the TOP of the dockerfile. It will look something like 
    `add-apt-repository 'deb [trusted=yes] http://ppa.launchpad.net/cran/libgit2/ubuntu <UBUNTU CODENAME> main'`

Here you should replace <UBUNTU CODENAME> with your ubuntu codename, e.g. focal. The code generated MUST go at the top. It'll look something like..
    `RUN apt-get update && \ 
    apt-get install -y software-properties-common 

    RUN add-apt-repository 'deb [trusted=yes] http://ppa.launchpad.net/cran/libgit2/ubuntu focal main' && \
    apt-get update && \
    apt-get -y install libgit2-dev`

## Project information

### **Status**
`DEVELOPMENT`

### **Authors**
* Nik Humphries (nik.humphries@arcadisgen.com)

### **Requirements**
* R installation and R packages (dplyr, magrittr, tibble, stringr)

### **Tags**
R

--------------------------------------------------------------------------------------

## Copyright

### **Copyright** 
Copyright (c) 2020 Arcadis Nederland B.V. 

Without prior written consent of Arcadis Nederland B.V., this code may not be published or duplicated. 
