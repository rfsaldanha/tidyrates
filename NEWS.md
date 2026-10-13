# tidyrates 0.0.2

## Dependency changes

* Remove the `epitools` dependency. Direct and indirect rate calculations now
  use internal statistical kernels and the base R package `stats`.
* Preserve public arguments, output columns, grouping behavior, and the
  numerical methods previously supplied by `epitools`, including non-finite
  results for degenerate inputs.

## Bug fixes

* Fix `rate_adj_indirect()` to calculate reference event rates and the reference
  crude rate from `.std` instead of `.data`. Adjusted rates and confidence
  limits can therefore change; crude rates are unchanged.

## Documentation and tests

* Document the 95% Fay-Feuer gamma intervals for direct adjustment and the
  95% log-normal intervals for indirect adjustment. Update the package
  description, README, vignette, and generated R help.
* Add numerical regression tests against historical results, edge cases,
  grouping and custom-column tests, and tests verifying the use of `.std`.
* Run the R CMD check workflow on the `dev` branch.

## Known limitations

* Age strata are matched by row position, not by their labels. Supply reference
  age groups in the same row order as each group in `.data`.
* Indirect adjustment with one stratum yields non-finite results. Degenerate
  inputs and these pre-existing limitations should be considered before
  interpreting results.

# tidyrates 0.0.1

* Functions for rate computation with direct and indirect adjustment.
