test_that("rate_adj_direct works", {

  standard <- c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
  res <- rate_adj_direct(fleiss_data, .std = standard, .keys = "key", name_var = "name")

  expect_equal(nrow(res), 5)
})
