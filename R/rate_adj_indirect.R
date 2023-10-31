rate_adj_indirect <- function(.data,
                            .std,
                            .keys = NULL,
                            .name_var = "name",
                            .value_var = "value",
                            .age_group_var = "age_group",
                            .age_group_pop_var = "population",
                            .events_label = "events",
                            .population_label = "population",
                            .progress = TRUE){
  # Assert type
  # checkmate::assert_tibble(.data)
  # checkmate::assert_tibble(.std)
  # checkmate::assert_vector(.keys, null.ok = TRUE)
  # checkmate::assert_string(.name_var)
  # checkmate::assert_string(.value_var)
  # checkmate::assert_string(.age_group_var)
  # checkmate::assert_string(.age_group_pop_var)
  # checkmate::assert_string(.events_label)
  # checkmate::assert_string(.population_label)
  # checkmate::assert_logical(.progress)

  # Assert content
  # for(f in .keys) checkmate::assert_choice(f, names(.data))
  # checkmate::assert_choice(.name_var, names(.data))
  # checkmate::assert_choice(.value_var, names(.data))
  # checkmate::assert_choice(.age_group_var, names(.data))
  # checkmate::assert_choice(.age_group_var, names(.std))
  # checkmate::assert_choice(.age_group_pop_var, names(.std))
  # checkmate::assert_choice(.events_label, unique(get({.name_var}, .data)))
  # checkmate::assert_choice(.population_label, unique(get({.name_var}, .data)))
  # checkmate::assert_set_equal(sort(unique(get({.age_group_var}, .data))), sort(unique(get({.age_group_var}, .std))))

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

  # Pivot variables from reference events and population
  std_list <- .data %>%
    tidyr::pivot_wider(names_from = .name_var, values_from = .value_var)

  # Map
  res <- purrr::map(.x = res_list, .f = function(x, stdcount = get({.events_label}, std_list), stdpop = get({.age_group_pop_var}, std_list)){
    tibble::as_tibble(
      t(
        epitools::ageadjust.indirect(
          count = get({.events_label}, x),
          pop = get({.population_label}, x),
          stdcount = stdcount,
          stdpop = stdpop
        )$rate
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
