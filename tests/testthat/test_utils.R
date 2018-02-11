context("utils tests")

test_that("server_address return a string", {

  subdomain <- "main"
  exp_address <- "main.hydroscope.gr"

  expect_equal(server_address(subdomain), exp_address)

})

test_that("server_alive fails", {

  subdomain <- "xxx"
  expect_error(server_alive(subdomain))
})
