#' Compute direct adjusted rates with tibbles
#'
#' Computes direct adjusted rates and confidence intervals.
#'
#' This functions wraps the `epitools` \link[epitools]{ageadjust.direct} function to compute direct adjusted rates and "exact" confidence intervals using `tibble` objects with multiple grouping keys.
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
#' @importFrom rlang :=
#'
#' @examples
#' standard_pop <- c(63986.6, 186263.6, 157302.2, 97647.0, 47572.6, 12262.6)
#' rate_adj_direct(fleiss_data, .std = standard_pop)
rate_adj_direct <- function(.data, .std, .keys = NULL,
                            .name_var = "name", .value_var = "value",
                            .age_group_var = "age_group",
                            .age_group_pop_var = "pop",
                            .events_label = "events",
                            .population_label = "population",
                            .progress = TRUE){
  # Assert type
  checkmate::assert_tibble(.data)
  checkmate::assert_tibble(.std)
  checkmate::assert_vector(.keys, null.ok = TRUE)
  checkmate::assert_string(.name_var)
  checkmate::assert_string(.value_var)
  checkmate::assert_string(.age_group_var)
  checkmate::assert_string(.age_group_pop_var)
  checkmate::assert_string(.events_label)
  checkmate::assert_string(.population_label)
  checkmate::assert_logical(.progress)

  # Assert content
  for(f in .keys) checkmate::assert_choice(f, names(.data))
  checkmate::assert_choice(.name_var, names(.data))
  checkmate::assert_choice(.value_var, names(.data))
  checkmate::assert_choice(.age_group_var, names(.data))
  checkmate::assert_choice(.age_group_var, names(.std))
  checkmate::assert_choice(.age_group_pop_var, names(.std))
  checkmate::assert_choice(.events_label, unique(get({.name_var}, .data)))
  checkmate::assert_choice(.population_label, unique(get({.name_var}, .data)))

  # Group by keys, if available
  if(!is.null(.keys)){
    .data <- .data %>%
      dplyr::group_by(dplyr::across(dplyr::all_of(.keys)))
  }

  # Assure age group factor order
  .data <- .data %>%
    dplyr::mutate(!!dplyr::sym(.age_group_var) := forcats::fct_relevel(!!dplyr::sym(.age_group_var), sort))

  .std <- .std %>%
    dplyr::mutate(!!dplyr::sym(.age_group_var) := forcats::fct_relevel(!!dplyr::sym(.age_group_var), sort))

  # Pivot variables and split to list
  res_list <- .data %>%
    tidyr::pivot_wider(names_from = .name_var, values_from = .value_var) %>%
    dplyr::group_split(.keep = TRUE)

  # Map
  res <- purrr::map(.x = res_list, .f = function(x, std = get({.age_group_pop_var}, .std)){
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
