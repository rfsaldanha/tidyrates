# tidyrates (development version)

* Remove the `epitools` dependency. Direct and indirect rate calculations now
  use internal statistical kernels and the base R package `stats`.
* The dependency replacement preserves public arguments, output columns,
  grouping behavior, and numerical results, including non-finite results for
  degenerate inputs.
* Clarify that indirect confidence intervals use a log-normal approximation.
* In a separate bug fix, indirect adjustment now uses event counts and
  populations from the supplied `.std` reference instead of `.data`. Adjusted
  rates and confidence limits can therefore change; crude rates are unchanged.
* Known pre-existing limitations: age strata are matched by row position, not
  by their labels; indirect adjustment with one stratum yields non-finite
  results. These should be considered before interpreting results.

# tidyrates 0.0.1

* Functions for rate computation with direct and indirect adjustment.
