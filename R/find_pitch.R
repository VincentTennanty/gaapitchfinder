#' Search for GAA Pitches by Name, Club, or County
#'
#' Search for GAA pitches using case-insensitive partial matching on pitch names,
#' club names, or county names. Returns all matching pitches as an sf object.
#'
#' @param search_term Character string to search for. Searches across pitch names,
#'   club names, and county names using case-insensitive partial matching.
#'
#' @return An sf object containing matching pitches with all dataset columns.
#'   Returns an empty sf object with the correct schema if no matches are found.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Search for Croke Park
#' croke <- find_pitch("Croke Park")
#' knitr::kable(
#'   sf::st_drop_geometry(croke)[, c("club", "pitch", "county", "latitude", "longitude")],
#'   caption = "Croke Park Results"
#' )
#'
#' # Search by county
#' cork_pitches <- find_pitch("Cork")
#' knitr::kable(
#'   head(sf::st_drop_geometry(cork_pitches)[, c("club", "pitch", "county")]),
#'   caption = "Cork Pitches (first 6)"
#' )
#' }
#'
find_pitch <- function(search_term) {
  # Input validation
  if (!is.character(search_term) || length(search_term) != 1) {
    stop("search_term must be a single character string")
  }
  
  if (nchar(search_term) == 0) {
    stop("search_term cannot be an empty string")
  }
  
  # Load the dataset if not already loaded
  if (!exists("gaa_pitches")) {
    data("gaa_pitches", envir = environment())
  } else {
    gaa_pitches <- get("gaa_pitches", envir = .GlobalEnv)
  }
  
  # Convert search term to lowercase for case-insensitive matching
  search_lower <- tolower(search_term)
  
  # Search across pitch, club, and county columns
  matches <- gaa_pitches[
    grepl(search_lower, tolower(gaa_pitches$pitch), fixed = FALSE) |
    grepl(search_lower, tolower(gaa_pitches$club), fixed = FALSE) |
    grepl(search_lower, tolower(gaa_pitches$county), fixed = FALSE),
  ]
  
  return(matches)
}
