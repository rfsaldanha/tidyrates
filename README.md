
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidyrates

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidyrates)](https://CRAN.R-project.org/package=tidyrates)
<!-- badges: end -->

The goal of tidyrates is to compute adjusted rates and other
epidemiological indicators in a tidy way, wrapping functions from the
`epitools` package.

## Installation

You can install the development version of tidyrates from
[GitHub](https://github.com/rfsaldanha/tidyrates) with:

``` r
# install.packages("devtools")
devtools::install_github("rfsaldanha/tidyrates")
```

## Example

``` r
library(tidyrates)

head(fleiss_data)
#>   key age_group       name  value
#> 1  k1  Under 20 population 230061
#> 2  k1  Under 20     events    107
#> 3  k1     20-24 population 329449
#> 4  k1     20-24     events    141
#> 5  k1     25-29 population 114920
#> 6  k1     25-29     events     60

standard_pop <- tibble::tibble(
    age_group = c("Under 20", "20-24", "25-29", "30-34", "35-39", "40 and over"),
    pop = c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
  )

rate_adj_direct(fleiss_data, .std = standard_pop, .keys = "key")
#> # A tibble: 5 × 5
#>   key    crude.rate adj.rate      lci      uci
#>   <chr>       <dbl>    <dbl>    <dbl>    <dbl>
#> 1 k1       0.000563 0.000923 0.000804 0.00106 
#> 2 k2       0.000676 0.000912 0.000824 0.00101 
#> 3 k3       0.000833 0.000851 0.000772 0.000942
#> 4 k4       0.00115  0.000927 0.000800 0.00115 
#> 5 k5plus   0.00167  0.000755 0.000677 0.00188
```
