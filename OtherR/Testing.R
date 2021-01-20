## Testing access


yourpackages <- c("gert", "sf", "rkafka")

outputall(yourpackages)

deps = qq

createAptGet(deps)

dockerfile::createdeps(yourpackages)
