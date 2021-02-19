testthat::test_that("Can load packages from renv.lock", {

  testthat::expect_equal(
    length(packageVectorFromlockfile(lockfilepath = "datafortests/renv.lock")),
    97)
})
