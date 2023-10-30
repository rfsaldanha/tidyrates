## code to prepare `who_std_pop` dataset goes here

who_std_pop <- readr::read_csv2(file = "data-raw/std_pop.csv") |>
  dplyr::select(age_group, pop = who_std)

usethis::use_data(who_std_pop, overwrite = TRUE)
