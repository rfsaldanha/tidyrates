## code to prepare `fleiss_data` dataset goes here
fleiss_data <- tibble::tibble(
  key =       c(rep("k1", 12), rep("k2", 12), rep("k3", 12), rep("k4", 12), rep("k5plus", 12)),
  age_group = rep(c(rep("Under 20", 2), rep("20-24", 2), rep("25-29", 2), rep("30-34", 2), rep("35-39", 2), rep("40 and over", 2)), 5),
  name =      rep(c("population", "events"), 30),
  value =     c(230061, 107, 329449, 141, 114920, 60, 39487, 40, 14208, 39, 3052, 25,
                72202, 25, 326701, 150, 208667, 110, 83228, 84, 28466, 82, 5375, 39,
                15050, 3, 175702, 71, 207081, 114, 117300, 103, 45026, 108, 8660, 75,
                2293, 1, 68800, 26, 132424, 64, 98301, 89, 46075, 137, 9834, 96,
                327, 0, 30666, 8, 123419, 63, 149919, 112, 104088, 262, 34392, 295)
)

usethis::use_data(fleiss_data, overwrite = TRUE, compress = "xz")
