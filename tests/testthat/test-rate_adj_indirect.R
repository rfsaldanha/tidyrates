test_that("rate_adj_indirect works", {

  res <- rate_adj_indirect(.data = selvin_data_1960, .std = selvin_data_1940)

  expect_equal(nrow(res), 1)

})

test_that("Selvin rates match the 1940 reference", {
  # Reference calculation: epitools 0.5-10.1 ageadjust.indirect with
  # the 1960 counts/populations and 1940 standard counts/populations.
  expected <- c(crude.rate = 0.00166087444392518,
                adj.rate = 0.00142564661008956,
                lci = 0.00141792255451206,
                uci = 0.00143341274203744)
  result <- rate_adj_indirect(selvin_data_1960, selvin_data_1940,
                              .progress = FALSE)
  expect_equal(unlist(result), expected, tolerance = 1e-12)
})
