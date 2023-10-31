## code to prepare `selvin_data_60` and `selvin_data_40` dataset goes here

selvin_data_1960 <- tibble::tibble(
  age_group = rep(c("<1", "1-4", "5-14", "15-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75-84", "85+"), 2),
  name = c(rep("events", 11), rep("population", 11)),
  value = c(c(141, 926, 1253, 1080, 1869, 4891, 14956, 30888, 41725, 26501, 5928), c(1784033, 7065148, 15658730, 10482916, 9939972, 10563872, 9114202, 6850263, 4702482, 1874619, 330915))
)

usethis::use_data(selvin_data_1960, overwrite = TRUE)

selvin_data_1940 <- tibble::tibble(
  age_group = rep(c("<1", "1-4", "5-14", "15-24", "25-34", "35-44", "45-54", "55-64", "65-74", "75-84", "85+"), 2),
  name = c(rep("events", 11), rep("population", 11)),
  value = c(c(45, 201, 320, 670, 1126, 3160, 9723, 17935, 22179, 13461, 2238), c(906897, 3794573, 10003544, 10629526, 9465330, 8249558, 7294330, 5022499, 2920220, 1019504, 142532))
)

usethis::use_data(selvin_data_1940, overwrite = TRUE)
