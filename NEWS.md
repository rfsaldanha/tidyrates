# tidyrates (development version)

* Remove the `epitools` dependency. Direct and indirect rate calculations now
  use internal statistical kernels and the base R package `stats`.
* Preserve public arguments, output columns, grouping behavior, and numerical
  results, including non-finite results for degenerate inputs.
* Clarify that indirect confidence intervals use a log-normal approximation.
* Known pre-existing limitations, deliberately unchanged in this compatibility
  update: indirect adjustment constructs its reference from `.data` rather than
  `.std`; age strata are matched by row position, not by their labels; indirect
  adjustment with one stratum yields non-finite results. These require a separate
  behavior-changing fix and should be considered before interpreting results.

# tidyrates 0.0.1

* Functions for rate computation with direct and indirect adjustment.
