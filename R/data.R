#' GAA Pitch Locations Dataset
#'
#' A dataset containing location information for GAA (Gaelic Athletic Association)
#' pitches in Ireland and around the world. The data includes coordinates, club
#' information, geographic metadata, and additional attributes like elevation and
#' rainfall.
#'
#' @format An sf object with EPSG:4326 (WGS84) coordinate system containing:
#' \describe{
#'   \item{club}{Name of the GAA club}
#'   \item{pitch}{Name of the pitch or ground}
#'   \item{county}{County, division, state, or local grouping}
#'   \item{province}{Irish province (Connacht, Leinster, Munster, Ulster) where applicable}
#'   \item{country}{Country}
#'   \item{latitude}{Latitude in decimal degrees (WGS84)}
#'   \item{longitude}{Longitude in decimal degrees (WGS84)}
#'   \item{elevation}{Elevation in meters}
#'   \item{annual_rainfall}{Annual rainfall in millimeters}
#'   \item{rain_days}{Number of days with precipitation per year}
#'   \item{directions}{Google Maps directions URL}
#'   \item{twitter}{Club Twitter/X URL where available}
#'   \item{wikipedia}{Club Wikipedia URL where available}
#'   \item{geometry}{sf geometry column (POINT)}
#' }
#'
#' @source GAA Pitch Finder project by Ryan McGuinness
#'   \url{https://gaapitchfinder.com}
#'
#'   The dataset is licensed under Creative Commons Attribution 4.0 International
#'   License (CC BY 4.0). If you use this data, please credit GAA Pitch Finder
#'   by Ryan McGuinness and link to \url{https://gaapitchfinder.com}.
#'
#' @examples
#' \dontrun{
#' data(gaa_pitches)
#'
#' # View as a formatted table
#' knitr::kable(
#'   head(sf::st_drop_geometry(gaa_pitches)[, c("club", "pitch", "county", "province", "country")]),
#'   caption = "GAA Pitches Dataset (first 6 rows)"
#' )
#'
#' # Count pitches by province
#' knitr::kable(
#'   as.data.frame(table(Province = gaa_pitches$province)),
#'   caption = "Pitches by Province"
#' )
#' }
#'
"gaa_pitches"
