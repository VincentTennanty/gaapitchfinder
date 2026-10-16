#' Find GAA Pitches Within a Radius
#'
#' Find all GAA pitches within a specified distance from a given latitude and
#' longitude location. Returns pitches sorted by distance with calculated distances
#' in kilometers.
#'
#' @param lat Numeric latitude in decimal degrees (WGS84, EPSG:4326)
#' @param lon Numeric longitude in decimal degrees (WGS84, EPSG:4326)
#' @param radius Numeric distance in kilometers. All pitches within this distance
#'   will be returned.
#'
#' @return An sf object containing all pitches within the specified radius, with
#'   all dataset columns plus a 'distance_km' column showing the distance in
#'   kilometers. Returns an empty sf object with the correct schema if no pitches
#'   are found within the radius.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Find all pitches within 10km of Dublin city center
#' nearby <- pitches_within_radius(lat = 53.3498, lon = -6.2603, radius = 10)
#' knitr::kable(
#'   sf::st_drop_geometry(nearby)[, c("club", "pitch", "county", "distance_km")],
#'   caption = "Pitches within 10km of Dublin City Centre",
#'   digits = 2
#' )
#' }
#'
pitches_within_radius <- function(lat, lon, radius) {
  # Input validation
  if (!is.numeric(lat) || length(lat) != 1) {
    stop("lat must be a single numeric value")
  }
  
  if (!is.numeric(lon) || length(lon) != 1) {
    stop("lon must be a single numeric value")
  }
  
  if (!is.numeric(radius) || length(radius) != 1 || radius <= 0) {
    stop("radius must be a positive numeric value")
  }
  
  if (lat < -90 || lat > 90) {
    stop("lat must be between -90 and 90")
  }
  
  if (lon < -180 || lon > 180) {
    stop("lon must be between -180 and 180")
  }
  
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
  
  # Filter pitches within radius
  within_radius <- distances_km <= radius
  
  # Add distances to the filtered data
  result <- gaa_pitches[within_radius, ]
  result$distance_km <- distances_km[within_radius]
  
  # Sort by distance
  result <- result[order(result$distance_km), ]
  
  return(result)
}
