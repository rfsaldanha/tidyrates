# Internal statistical kernels. These implement the published methods rather
# than importing or vendoring epitools code. The public wrappers use 95% CIs.
#
# Direct: Fay MP, Feuer EJ (1997). Confidence intervals for directly
# standardized rates: a method based on the gamma distribution.
# Statistics in Medicine 16:791-801. doi:10.1002/(SICI)1097-0258(19970415)16:7<791::AID-SIM500>3.0.CO;2-#
#
# Indirect: log-normal confidence interval for the standardized incidence
# ratio, with standard error 1 / sqrt(observed events), rescaled by the
# reference crude rate. Keep this approximation for backward compatibility.

# A gamma distribution with mean m and variance v equals a scaled chi-square
# distribution with 2*m^2/v degrees of freedom.
.rate_gamma_quantile <- function(probability, mean, variance) {
  stats::qchisq(probability, df = 2 * mean^2 / variance) *
    (variance / (2 * mean))
}

.rate_direct <- function(count, pop, stdpop) {
  weights <- stdpop / sum(stdpop)
  adjusted <- sum(weights * (count / pop))
  variance <- sum(weights^2 * (count / pop^2))
  largest_weight <- max(weights / pop)

  c(
    crude.rate = sum(count) / sum(pop),
    adj.rate = adjusted,
    lci = .rate_gamma_quantile(0.025, adjusted, variance),
    uci = .rate_gamma_quantile(
      0.975, adjusted + largest_weight, variance + largest_weight^2
    )
  )
}

.rate_indirect <- function(count, pop, stdcount, stdpop) {
  observed <- sum(count)
  # Preserve the previous single-stratum behavior (no reference rates).
  reference_rates <- if (length(stdcount) > 1L && length(stdpop) > 0L) {
    stdcount / stdpop
  } else {
    numeric()
  }
  expected <- sum(reference_rates * pop)
  reference_crude <- sum(stdcount) / sum(stdpop)
  log_ratio <- log(observed / expected)
  margin <- stats::qnorm(0.975) / sqrt(observed)

  c(
    crude.rate = observed / sum(pop),
    adj.rate = (observed / expected) * reference_crude,
    lci = exp(log_ratio - margin) * reference_crude,
    uci = exp(log_ratio + margin) * reference_crude
  )
}
