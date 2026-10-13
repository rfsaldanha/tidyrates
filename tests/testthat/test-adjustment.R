test_that("internal kernels reproduce legacy numerical results", {
  for (case in legacy_rates) {
    direct <- suppressWarnings(.rate_direct(case$count, case$pop, case$stdpop))
    indirect <- suppressWarnings(.rate_indirect(
      case$count, case$pop, case$stdcount, case$stdpop
    ))
    expect_equal(direct, case$direct, tolerance = 1e-12)
    expect_equal(indirect, case$indirect, tolerance = 1e-12)
    expect_identical(is.nan(direct), is.nan(case$direct))
    expect_identical(is.nan(indirect), is.nan(case$indirect))
  }
})

rate_input <- function(count, pop) {
  tibble::tibble(
    age_group = rep(letters[seq_along(count)], 2),
    name = rep(c("events", "population"), each = length(count)),
    value = c(count, pop)
  )
}

test_that("direct public output matches the legacy reference", {
  case <- legacy_rates$ordinary
  data <- rate_input(case$count, case$pop)
  std <- tibble::tibble(age_group = letters[1:3], population = case$stdpop)
  result <- rate_adj_direct(data, std, .progress = FALSE)
  expect_s3_class(result, "tbl_df")
  expect_identical(names(result), names(case$direct))
  expect_equal(unlist(result), case$direct, tolerance = 1e-12)
})

test_that("direct adjustment retains multiple keys and custom column names", {
  case <- legacy_rates$ordinary
  data <- dplyr::bind_rows(
    dplyr::mutate(rate_input(case$count, case$pop), region = "B", year = 2021L),
    dplyr::mutate(rate_input(case$count * 2, case$pop), region = "A", year = 2020L)
  )
  data <- dplyr::rename(data, age = age_group, measure = name, amount = value)
  data$measure[data$measure == "events"] <- "deaths"
  data$measure[data$measure == "population"] <- "people"
  std <- tibble::tibble(age = letters[1:3], people = case$stdpop)
  result <- rate_adj_direct(
    data, std, .keys = c("region", "year"), .name_var = "measure",
    .value_var = "amount", .age_group_var = "age", .age_group_pop_var = "people",
    .events_label = "deaths", .population_label = "people", .progress = FALSE
  )
  expect_identical(names(result), c("region", "year", names(case$direct)))
  expect_identical(result$region, c("A", "B"))
  expect_identical(result$year, c(2020L, 2021L))
  expect_equal(unlist(result[2, names(case$direct)]), case$direct, tolerance = 1e-12)
  expect_equal(result$adj.rate, c(0.016, 0.008))
})

test_that("indirect wrapper preserves its existing reference behavior", {
  # Characterization, not desired statistical behavior: the wrapper currently
  # uses .data as its reference. Fixing that is outside dependency replacement.
  data <- rate_input(c(10, 20, 30), c(1000, 2000, 5000))
  std <- rate_input(c(12, 15, 42), c(1500, 2500, 4000))
  result <- rate_adj_indirect(data, std, .progress = FALSE)
  expected <- c(crude.rate = 0.0075, adj.rate = 0.0075,
                lci = 0.00582333288312025, uci = 0.0096594168887457)
  expect_s3_class(result, "tbl_df")
  expect_identical(names(result), names(expected))
  expect_equal(unlist(result), expected, tolerance = 1e-12)
  std$value <- std$value * 2
  expect_equal(rate_adj_indirect(data, std, .progress = FALSE), result)
})

test_that("public wrappers retain validation", {
  data <- rate_input(c(1, 2), c(100, 200))
  std <- tibble::tibble(age_group = c("a", "b"), population = c(200, 300))
  expect_error(rate_adj_direct(as.data.frame(data), std))
  expect_error(rate_adj_direct(data, std, .keys = "unknown"))
  expect_error(rate_adj_direct(data, std, .events_label = "unknown"))
  std$age_group <- c("a", "c")
  expect_error(rate_adj_direct(data, std))
  expect_error(rate_adj_indirect(data, rate_input(c(1, 2), c(100, 200)),
                                 .population_label = "unknown"))
})
