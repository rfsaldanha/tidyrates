test_that("rate_adj_direct works", {

  standard_pop <- tibble::tibble(
    age_group = c("Under 20", "20-24", "25-39", "30-34", "35-39", "40 and over"),
    pop = c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
  )

  res <- rate_adj_direct(fleiss_data, .std = standard_pop, .keys = "key")

  expect_equal(nrow(res), 5)
})
