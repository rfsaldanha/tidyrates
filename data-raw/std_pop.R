## code to prepare `seer_std` dataset goes here

std_pop <- readr::read_csv2(file = "data-raw/std_pop.csv")

usethis::use_data(std_pop, overwrite = TRUE)
