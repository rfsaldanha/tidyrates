test_that("rate_adj_indirect works", {

  res <- rate_adj_indirect(.data = selvin_data_1960, .std = selvin_data_1940)

  expect_equal(nrow(res), 1)

})
