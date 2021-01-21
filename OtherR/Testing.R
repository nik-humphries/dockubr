## Testing access


yourpackages <- c("gert", "sf", "rkafka", "dplyr")


dockubu::generateDockerText(yourpackages)
dockubu::generateDockerText(c("gert", "sf", "rkafka"))
dockubu::generateDockerText(c("sf"))
dockubu::generateDockerText(c("gert"))

dockubu::packageVectorFromlockfile("G:\\Projects\\renv.lock") %>%
  dockubu::generateDockerText()

deps = qq

createAptGet(deps)

dockerfile::createdeps(yourpackages)


dockubu::packageVectorFromlockfile("G:\\Projects\\renv.lock") %>%
  generateDockerText()
