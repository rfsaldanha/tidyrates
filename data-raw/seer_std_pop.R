## code to prepare `seer_std_pop` dataset goes here

seer_std_pop <- readr::read_csv2(file = "data-raw/std_pop.csv") |>
  dplyr::select(age_group, pop = seer_std)

usethis::use_data(seer_std_pop, overwrite = TRUE)
