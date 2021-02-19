testthat::test_that("Dep list from renv.lock no PPA", {

  testthat::expect_error(
    quiet(lockFileDeps(lockfilepath = "datafortests/renv.lock")),
    NA)

})

testthat::test_that("Dep list from renv.lock w PPA", {

  testthat::expect_error(
    quiet(lockFileDeps(lockfilepath = "datafortests/renv.lock", ppa = TRUE)),
    NA)

})
