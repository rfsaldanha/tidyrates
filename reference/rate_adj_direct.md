# Compute direct adjusted rates with tibbles

Computes direct adjusted rates and confidence intervals.

## Usage

``` r
rate_adj_direct(
  .data,
  .std,
  .keys = NULL,
  .name_var = "name",
  .value_var = "value",
  .age_group_var = "age_group",
  .age_group_pop_var = "population",
  .events_label = "events",
  .population_label = "population",
  .progress = TRUE
)
```

## Arguments

- .data:

  A tibble containing events counts and population per groups (e.g. age
  groups)

- .std:

  A vector with standard population values for each group

- .keys:

  Optional. A character vector with grouping variables, like year and
  region code.

- .name_var:

  Variable containing variable names. Defaults to `name`.

- .value_var:

  Variable containing values. Defaults to `value`.

- .age_group_var:

  Variable name of age groups. Defaults to `age_group`.

- .age_group_pop_var:

  Variable name of population size on `.std`. Defaults to `population`.

- .events_label:

  Label used for events at the `name_var` variable. Defaults to
  `events`.

- .population_label:

  Label used for population at the `name_var` variable. Defautls to
  `population`.

- .progress:

  Whether to show a progress bar. Defaults to `TRUE`.

## Value

A tibble with crude and adjusted rate, lower and upper confidence
intervals.

## Details

Computes direct adjusted rates and 95% Fay-Feuer gamma confidence
intervals using `tibble` objects with multiple grouping keys and
internal statistical calculations.

A tibble (`.data`) must be informed containing key variables like year
and region code, and population and and events count (e.g. cases) per
age group. Check the `fleiss_data` for an example.

A tibble (`.std`) must be also supplied containing the age groups and
population size. By default, this tibble has two variables, named
`age_group` and `pop`.

## Examples

``` r
standard_pop <- tibble::tibble(
   age_group = c("Under 20", "20-24", "25-29", "30-34", "35-39", "40 and over"),
   population = c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
 )
rate_adj_direct(fleiss_data, .std = standard_pop)
#> # A tibble: 1 × 4
#>   crude.rate adj.rate     lci     uci
#>        <dbl>    <dbl>   <dbl>   <dbl>
#> 1   0.000895  0.00437 0.00414 0.00546
```
