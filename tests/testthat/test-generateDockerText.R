testthat::test_that("With PPA", {

  testthat::expect_error(
    quiet(
      dockubu::generateDockerText(c("gert", "sf", "rkafka", "dplyr"), ppa = TRUE)
    ),
    NA
  )

})

testthat::test_that("Without PPA", {

  testthat::expect_error(
    quiet(
      dockubu::generateDockerText(c("gert", "sf", "rkafka", "dplyr"), ppa = FALSE)
    ),
    NA
  )

})
