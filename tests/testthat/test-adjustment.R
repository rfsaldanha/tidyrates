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

test_that("indirect wrapper uses the supplied reference", {
  case <- legacy_rates$ordinary
  data <- rate_input(case$count, case$pop)
  std <- rate_input(case$stdcount, case$stdpop)
  result <- rate_adj_indirect(data, std, .progress = FALSE)
  expect_s3_class(result, "tbl_df")
  expect_identical(names(result), names(case$indirect))
  expect_equal(unlist(result), case$indirect, tolerance = 1e-12)
  expect_false(isTRUE(all.equal(result$adj.rate, result$crude.rate)))

  # Change the reference age distribution, not just its overall scale.
  other <- rate_input(c(42, 15, 12), case$stdpop)
  changed <- rate_adj_indirect(data, other, .progress = FALSE)
  expect_equal(changed$crude.rate, result$crude.rate)
  expect_false(isTRUE(all.equal(changed$adj.rate, result$adj.rate)))
  expect_false(isTRUE(all.equal(changed$lci, result$lci)))
  expect_false(isTRUE(all.equal(changed$uci, result$uci)))
})

test_that("each indirect group uses the same supplied reference", {
  case <- legacy_rates$ordinary
  std <- rate_input(case$stdcount, case$stdpop)
  group_b <- rate_input(case$count, case$pop)
  group_a <- rate_input(case$count * 2, case$pop)
  data <- dplyr::bind_rows(
    dplyr::mutate(group_b, region = "B", year = 2021L),
    dplyr::mutate(group_a, region = "A", year = 2020L)
  )
  result <- rate_adj_indirect(data, std, .keys = c("region", "year"),
                              .progress = FALSE)
  expect_identical(result$region, c("A", "B"))
  expect_identical(result$year, c(2020L, 2021L))
  expect_equal(result[, names(case$indirect)], dplyr::bind_rows(
    rate_adj_indirect(group_a, std, .progress = FALSE),
    rate_adj_indirect(group_b, std, .progress = FALSE)
  ))
  expect_equal(unlist(result[2, names(case$indirect)]), case$indirect,
               tolerance = 1e-12)
  expect_equal(result$adj.rate, c(2, 1) * unname(case$indirect["adj.rate"]))
})

test_that("indirect reference supports custom columns and labels", {
  case <- legacy_rates$ordinary
  rename_input <- function(x) {
    x <- dplyr::rename(x, age = age_group, measure = name, amount = value)
    x$measure[x$measure == "events"] <- "deaths"
    x$measure[x$measure == "population"] <- "people"
    x
  }
  result <- rate_adj_indirect(
    rename_input(rate_input(case$count, case$pop)),
    rename_input(rate_input(case$stdcount, case$stdpop)),
    .name_var = "measure", .value_var = "amount", .age_group_var = "age",
    .age_group_pop_var = "people", .events_label = "deaths",
    .population_label = "people", .progress = FALSE
  )
  expect_equal(unlist(result), case$indirect, tolerance = 1e-12)
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
