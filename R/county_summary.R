#' Summarize GAA Pitch Counts by County
#'
#' Generate summary statistics of GAA pitch counts by county, with optional
#' filtering by province. Returns a data frame sorted alphabetically by county
#' name.
#'
#' @param province Optional character string to filter by province. Valid values
#'   are "Connacht", "Leinster", "Munster", "Ulster", or NULL (default) for all
#'   provinces.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{county}{County name}
#'     \item{pitch_count}{Number of pitches in that county}
#'     \item{province}{Province name (if available)}
#'   }
#'   Sorted alphabetically by county name.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Get pitch counts for all counties
#' knitr::kable(
#'   county_summary(),
#'   caption = "GAA Pitches by County"
#' )
#'
#' # Get pitch counts for Connacht only
#' knitr::kable(
#'   county_summary(province = "Connacht"),
#'   caption = "GAA Pitches in Connacht"
#' )
#' }
#'
county_summary <- function(province = NULL) {
  # Input validation
  if (!is.null(province)) {
    if (!is.character(province) || length(province) != 1) {
      stop("province must be a single character string or NULL")
    }
    
    valid_provinces <- c("Connacht", "Leinster", "Munster", "Ulster")
    if (!province %in% valid_provinces) {
      stop(paste("province must be one of:", paste(valid_provinces, collapse = ", ")))
    }
  }
  
  # Load the dataset if not already loaded
  if (!exists("gaa_pitches")) {
    data("gaa_pitches", envir = environment())
  } else {
    gaa_pitches <- get("gaa_pitches", envir = .GlobalEnv)
  }
  
  # Filter by province if specified
  if (!is.null(province)) {
    gaa_pitches <- gaa_pitches[gaa_pitches$province == province & !is.na(gaa_pitches$province), ]
  }
  
  # Group by county and count
  summary_df <- gaa_pitches %>%
    sf::st_drop_geometry() %>%
    dplyr::group_by(county, province) %>%
    dplyr::summarise(pitch_count = dplyr::n(), .groups = "drop") %>%
    dplyr::arrange(county)
  
  return(as.data.frame(summary_df))
}
