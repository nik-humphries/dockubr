## Testing access


yourpackages <- c("gert", "sf", "rkafka", "dplyr")


dockubu::generateDockerText(yourpackages)
dockubu::generateDockerText(c("gert", "sf", "rkafka"))
dockubu::generateDockerText(c("sf"))
dockubu::generateDockerText(c("gert"))

deps = qq

createAptGet(deps)

dockerfile::createdeps(yourpackages)
