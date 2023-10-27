#' Compute direct adjusted rates with tibbles
#'
#' This function computes direct adjusted rates and confidence intervals with tidy data in a tibble.
#'
#' @param .data A tibble containing events counts and population per groups (e.g. age groups)
#' @param .std A vector with standard population values for each group
#' @param .keys Optional. A character vector with grouping variables, like year and region code.
#' @param .name_var Variable containing variable names. Defaults to `name`.
#' @param .value_var Variable containing values. Defaults to `value`.
#' @param .events_label Label used for events at the `name_var` variable. Defaults to `events`.
#' @param .population_label Label used for population at the `name_var` variable. Defautls to `population`.
#' @param .progress Whether to show a progress bar. Defaults to `TRUE`.
#'
#' @return A tibble with crude and adjusted rate, lower and upper confidence intervals.
#' @export
#'
#' @examples
#' standard <- c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
#' rate_adj_direct(fleiss_data, .std = standard)
rate_adj_direct <- function(.data, .std, .keys = NULL,
                            .name_var = "name", .value_var = "value",
                            .events_label = "events", .population_label = "population",
                            .progress = TRUE){

  # Group by keys, if available
  if(!is.null(.keys)){
    .data <- .data %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(.keys)))
  }

  # Pivot variables and split to list
  res_list <- .data %>%
    tidyr::pivot_wider(names_from = .name_var, values_from = .value_var) %>%
    dplyr::group_split(.keep = TRUE)

  # Map
  res <- purrr::map(.x = res_list, .f = function(x, std = .std){
    tibble::as_tibble(
      t(
        epitools::ageadjust.direct(
          count = get({.events_label}, x),
          pop = get({.population_label}, x),
          stdpop = std
        )
      ))
  }, .progress = .progress) %>%
    purrr::list_rbind()

  # Add keys to result, if available
  if(!is.null(.keys)){
    res <- res %>%
      dplyr::bind_cols(dplyr::group_keys(.data)) %>%
      dplyr::relocate(.keys)
  }

  # Retun result
  return(res)
}
