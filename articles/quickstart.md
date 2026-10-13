# Quick start guide

The objective of this package is to compute rates adjusted by a
reference population or other rate. This is a very common procedure in
epidemiology, allowing the comparison of rates of a event (like
mortality) among groups that have different age distributions.

The package computes age-adjusted rates internally in a tidy way,
allowing computation for several groups using key variables, such as
year and region. Direct rates use 95% Fay-Feuer gamma confidence
intervals; indirect rates retain the 95% log-normal intervals used in
earlier versions.

## Setup

### Installing the package

``` r

devtools::install_github("rfsaldanha/tidyrates")
```

### Load the package

``` r

library(tidyrates)
```

## Direct adjusted rate

### Events and population data

Let’s use the Fleiss dataset, quoted by the `epitools` package (Fleiss,
1981, p. 249 ).

``` r

population <- c(230061, 329449, 114920, 39487, 14208, 3052,
72202, 326701, 208667, 83228, 28466, 5375, 15050, 175702,
207081, 117300, 45026, 8660, 2293, 68800, 132424, 98301, 
46075, 9834, 327, 30666, 123419, 149919, 104088, 34392, 
319933, 931318, 786511, 488235, 237863, 61313)

population <- matrix(population, 6, 6, 
dimnames = list(c("Under 20", "20-24", "25-29", "30-34", "35-39",
"40 and over"), c("1", "2", "3", "4", "5+", "Total")))

count <- c(107, 141, 60, 40, 39, 25, 25, 150, 110, 84, 82, 39,
3, 71, 114, 103, 108, 75, 1, 26, 64, 89, 137, 96, 0, 8, 63, 112,
262, 295, 136, 396, 411, 428, 628, 530)
count <- matrix(count, 6, 6, 
dimnames = list(c("Under 20", "20-24", "25-29", "30-34", "35-39",
"40 and over"), c("1", "2", "3", "4", "5+", "Total")))
```

``` r

population
#>                  1      2      3      4     5+  Total
#> Under 20    230061  72202  15050   2293    327 319933
#> 20-24       329449 326701 175702  68800  30666 931318
#> 25-29       114920 208667 207081 132424 123419 786511
#> 30-34        39487  83228 117300  98301 149919 488235
#> 35-39        14208  28466  45026  46075 104088 237863
#> 40 and over   3052   5375   8660   9834  34392  61313
```

``` r

count
#>               1   2   3   4  5+ Total
#> Under 20    107  25   3   1   0   136
#> 20-24       141 150  71  26   8   396
#> 25-29        60 110 114  64  63   411
#> 30-34        40  84 103  89 112   428
#> 35-39        39  82 108 137 262   628
#> 40 and over  25  39  75  96 295   530
```

The Fleiss data present events (`count` object) and population
(`population` object) for six age groups on five different groups (from
1 to 5+).

The `tidyrates` package present the same Fleiss data in a tidy way, with
a tibble in long format.

``` r

fleiss_data
#>       key   age_group       name  value
#> 1      k1    Under 20 population 230061
#> 2      k1    Under 20     events    107
#> 3      k1       20-24 population 329449
#> 4      k1       20-24     events    141
#> 5      k1       25-29 population 114920
#> 6      k1       25-29     events     60
#> 7      k1       30-34 population  39487
#> 8      k1       30-34     events     40
#> 9      k1       35-39 population  14208
#> 10     k1       35-39     events     39
#> 11     k1 40 and over population   3052
#> 12     k1 40 and over     events     25
#> 13     k2    Under 20 population  72202
#> 14     k2    Under 20     events     25
#> 15     k2       20-24 population 326701
#> 16     k2       20-24     events    150
#> 17     k2       25-29 population 208667
#> 18     k2       25-29     events    110
#> 19     k2       30-34 population  83228
#> 20     k2       30-34     events     84
#> 21     k2       35-39 population  28466
#> 22     k2       35-39     events     82
#> 23     k2 40 and over population   5375
#> 24     k2 40 and over     events     39
#> 25     k3    Under 20 population  15050
#> 26     k3    Under 20     events      3
#> 27     k3       20-24 population 175702
#> 28     k3       20-24     events     71
#> 29     k3       25-29 population 207081
#> 30     k3       25-29     events    114
#> 31     k3       30-34 population 117300
#> 32     k3       30-34     events    103
#> 33     k3       35-39 population  45026
#> 34     k3       35-39     events    108
#> 35     k3 40 and over population   8660
#> 36     k3 40 and over     events     75
#> 37     k4    Under 20 population   2293
#> 38     k4    Under 20     events      1
#> 39     k4       20-24 population  68800
#> 40     k4       20-24     events     26
#> 41     k4       25-29 population 132424
#> 42     k4       25-29     events     64
#> 43     k4       30-34 population  98301
#> 44     k4       30-34     events     89
#> 45     k4       35-39 population  46075
#> 46     k4       35-39     events    137
#> 47     k4 40 and over population   9834
#> 48     k4 40 and over     events     96
#> 49 k5plus    Under 20 population    327
#> 50 k5plus    Under 20     events      0
#> 51 k5plus       20-24 population  30666
#> 52 k5plus       20-24     events      8
#> 53 k5plus       25-29 population 123419
#> 54 k5plus       25-29     events     63
#> 55 k5plus       30-34 population 149919
#> 56 k5plus       30-34     events    112
#> 57 k5plus       35-39 population 104088
#> 58 k5plus       35-39     events    262
#> 59 k5plus 40 and over population  34392
#> 60 k5plus 40 and over     events    295
```

The `key` variable refers to the groups, `age_group` to the age groups,
`name` separates the `values` into events and population.

*You may use this same structure for your use case data.*

### Reference population data

The Fleiss example uses the average population as standard population
reference.

``` r

standard<-apply(population[,-6], 1, mean)
standard
#>    Under 20       20-24       25-29       30-34       35-39 40 and over 
#>     63986.6    186263.6    157302.2     97647.0     47572.6     12262.6
```

Using `tidyrates`, we must supply a tibble with two variables: age group
and population.

``` r

standard_pop <- tibble::tibble(
    age_group = c("Under 20", "20-24", "25-29", "30-34", "35-39", "40 and over"),
    population = c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
  )
```

### Rate computation

To use the direct adjustment procedure, `tidyrate` present the
`rate_adj_direct` function. The `.data` argument must be a tibble with
the events and population data, and the `.std` argument must be standard
population tibble. The `.keys` argument must point to grouping variables
on the `.data` tibble, if available.

The `rate_adj_direct` will compute the crude rate, adjusted rate and
confidence intervals for each group.

``` r

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

## Indirect adjusted rate

### Events and population data

Let’s use the Selvin dataset, quoted by the `epitools` package (Selvin,
2004).

``` r

dth40 <- c(45, 201, 320, 670, 1126, 3160, 9723, 17935,
22179, 13461, 2238)

pop40 <- c(906897, 3794573, 10003544, 10629526, 9465330,
8249558, 7294330, 5022499, 2920220, 1019504, 142532)
```

The `tidyrates` present the same dataset in a tidy way.

``` r

selvin_data_1940
#> # A tibble: 22 × 3
#>    age_group name   value
#>    <chr>     <chr>  <dbl>
#>  1 <1        events    45
#>  2 1-4       events   201
#>  3 5-14      events   320
#>  4 15-24     events   670
#>  5 25-34     events  1126
#>  6 35-44     events  3160
#>  7 45-54     events  9723
#>  8 55-64     events 17935
#>  9 65-74     events 22179
#> 10 75-84     events 13461
#> # ℹ 12 more rows
```

### Events and population reference data

``` r

dth60 <- c(141, 926, 1253, 1080, 1869, 4891, 14956, 30888,
41725, 26501, 5928)

pop60 <- c(1784033, 7065148, 15658730, 10482916, 9939972,
10563872, 9114202, 6850263, 4702482, 1874619, 330915)
```

The `tidyrates` present the same dataset in a tidy way.

``` r

selvin_data_1960
#> # A tibble: 22 × 3
#>    age_group name   value
#>    <chr>     <chr>  <dbl>
#>  1 <1        events   141
#>  2 1-4       events   926
#>  3 5-14      events  1253
#>  4 15-24     events  1080
#>  5 25-34     events  1869
#>  6 35-44     events  4891
#>  7 45-54     events 14956
#>  8 55-64     events 30888
#>  9 65-74     events 41725
#> 10 75-84     events 26501
#> # ℹ 12 more rows
```

### Rate computation

To use the indirect adjustment procedure, `tidyrate` present the
`rate_adj_indirect` function. The `.data` argument must be a tibble with
the events and population data, and the `.std` argument must be also a
tibble with the events and population data. The `.keys` argument must
point to grouping variables on the `.data` tibble, if available.

The `rate_adj_indirect` will compute the crude rate, adjusted rate and
confidence intervals for each group. Reference age-specific rates and
the reference crude rate are computed from `.std`. Supply its age groups
in the same row order as in each group of `.data`.

``` r

rate_adj_indirect(selvin_data_1940, selvin_data_1960)
#> # A tibble: 1 × 4
#>   crude.rate adj.rate     lci     uci
#>        <dbl>    <dbl>   <dbl>   <dbl>
#> 1    0.00120  0.00138 0.00137 0.00139
```
