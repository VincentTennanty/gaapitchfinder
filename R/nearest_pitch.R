#' Find Nearest GAA Pitch to Coordinates
#'
#' Find the nearest GAA pitch(es) to a given latitude and longitude location.
#' Returns the pitch(es) with calculated distances in kilometers.
#'
#' @param lat Numeric latitude in decimal degrees (WGS84, EPSG:4326)
#' @param lon Numeric longitude in decimal degrees (WGS84, EPSG:4326)
#' @param n Integer number of nearest pitches to return. Default is 1.
#'
#' @return An sf object containing the nearest pitch(es) with all dataset columns
#'   plus a 'distance_km' column showing the distance in kilometers.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Find nearest pitch to Dublin city center
#' nearest <- nearest_pitch(lat = 53.3498, lon = -6.2603, n = 5)
#' knitr::kable(
#'   sf::st_drop_geometry(nearest)[, c("club", "pitch", "county", "distance_km")],
#'   caption = "5 Nearest Pitches to Dublin City Centre",
#'   digits = 2
#' )
#' }
#'
nearest_pitch <- function(lat, lon, n = 1) {
  # Input validation
  if (!is.numeric(lat) || length(lat) != 1) {
    stop("lat must be a single numeric value")
  }
  
  if (!is.numeric(lon) || length(lon) != 1) {
    stop("lon must be a single numeric value")
  }
  
  if (lat < -90 || lat > 90) {
    stop("lat must be between -90 and 90")
  }
  
  if (lon < -180 || lon > 180) {
    stop("lon must be between -180 and 180")
  }
  
  if (!is.numeric(n) || length(n) != 1 || n < 1) {
    stop("n must be a positive integer")
  }
  
  n <- as.integer(n)
  
  # Load the dataset if not already loaded
  if (!exists("gaa_pitches")) {
    data("gaa_pitches", envir = environment())
  } else {
    gaa_pitches <- get("gaa_pitches", envir = .GlobalEnv)
  }
  
  # Create point for the input location
  input_point <- sf::st_sfc(sf::st_point(c(lon, lat)), crs = 4326)
  
  # Calculate distances to all pitches
  distances <- sf::st_distance(input_point, gaa_pitches)
  
  # Convert distances to kilometers
  distances_km <- as.numeric(distances) / 1000
  
  # Add distances to the data
  gaa_pitches$distance_km <- distances_km
  
  # Sort by distance and return top n
  result <- gaa_pitches[order(distances_km), ][1:min(n, nrow(gaa_pitches)), ]
  
  return(result)
}
