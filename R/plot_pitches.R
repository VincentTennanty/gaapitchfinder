#' Plot GAA Pitch Locations on an Interactive Map
#'
#' Create an interactive leaflet map of GAA pitch locations. Clicking a marker
#' shows the club name, pitch name, and county.
#'
#' @param pitches An sf object containing pitch data (typically from \code{gaa_pitches}
#'   or results from search/filter functions)
#' @param color Optional column name to color markers by (e.g., \code{"county"},
#'   \code{"province"}). When \code{NULL} (default) all markers are green.
#' @param radius Numeric circle marker radius in pixels. Default is 6.
#' @param alpha Numeric fill opacity between 0 and 1. Default is 0.7.
#'
#' @return A leaflet htmlwidget that renders interactively in RStudio, R Markdown,
#'   and Shiny.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Plot all pitches
#' plot_pitches(gaa_pitches)
#'
#' # Color by province
#' plot_pitches(gaa_pitches, color = "province")
#'
#' # Plot search results
#' cork <- find_pitch("Cork")
#' plot_pitches(cork, color = "county")
#' }
plot_pitches <- function(pitches, color = NULL, radius = 6, alpha = 0.7) {
  if (!inherits(pitches, "sf")) stop("pitches must be an sf object")
  if (!is.numeric(radius) || radius <= 0) stop("radius must be a positive number")
  if (!is.numeric(alpha) || alpha < 0 || alpha > 1) stop("alpha must be between 0 and 1")
  if (!is.null(color) && !color %in% names(pitches)) {
    stop(paste("color column", color, "not found in pitches data"))
  }

  esri_tiles <- leaflet::providers$Esri.WorldStreetMap

  if (nrow(pitches) == 0) {
    return(leaflet::leaflet() %>%
      leaflet::addProviderTiles(esri_tiles) %>%
      leaflet::setView(lng = -8.0, lat = 53.4, zoom = 6))
  }

  popup_text <- paste0(
    "<strong>", pitches$club, "</strong><br>",
    pitches$pitch, "<br>",
    "<em>", pitches$county, "</em>"
  )

  if (is.null(color)) {
    leaflet::leaflet(pitches) %>%
      leaflet::addProviderTiles(esri_tiles) %>%
      leaflet::addCircleMarkers(
        radius = radius,
        fillOpacity = alpha,
        opacity = alpha,
        color = "#1a7a1a",
        fillColor = "#2ecc40",
        popup = popup_text
      )
  } else {
    vals <- pitches[[color]]
    pal <- leaflet::colorFactor("Set1", domain = vals)
    leaflet::leaflet(pitches) %>%
      leaflet::addProviderTiles(esri_tiles) %>%
      leaflet::addCircleMarkers(
        radius = radius,
        fillOpacity = alpha,
        opacity = alpha,
        color = ~pal(vals),
        fillColor = ~pal(vals),
        popup = popup_text
      )
  }
}
