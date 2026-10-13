# Compute indirect adjusted rates with tibbles

Computes indirect adjusted rates and confidence intervals.

## Usage

``` r
rate_adj_indirect(
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

  A tibble with reference event counts and population values for each
  age group, in the same age-group row order as each group in `.data`.

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

Computes indirect adjusted rates and 95% log-normal confidence intervals
using `tibble` objects with multiple grouping keys and internal
statistical calculations.

A tibble (`.data`) must be informed containing key variables like year
and region code, and population and and events count (e.g. cases) per
age group. Check the `fleiss_data` for an example.

A tibble (`.std`) must be also supplied containing the age groups,
events and population size. By default, this tibble has three variables,
named `age_group`, `name` and `value`. Check the `selvin_data_1940` for
an example.

## Examples

``` r
rate_adj_indirect(.data = selvin_data_1960, .std = selvin_data_1940)
#> # A tibble: 1 × 4
#>   crude.rate adj.rate     lci     uci
#>        <dbl>    <dbl>   <dbl>   <dbl>
#> 1    0.00166  0.00143 0.00142 0.00143
```
