# Dockubu

## Summary

Takes a vector of package names. Returns the code to install dependencies for Docker / Ubuntu 18.04

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
