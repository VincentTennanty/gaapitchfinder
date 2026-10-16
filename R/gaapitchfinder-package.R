#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom dplyr filter group_by summarise arrange n
#' @importFrom sf st_as_sf st_crs st_distance st_drop_geometry st_point st_sfc
#' @importFrom ggplot2 ggplot geom_sf aes theme_minimal labs
#' @importFrom utils data
## usethis namespace: end
NULL

# Suppress R CMD CHECK notes for dplyr non-standard evaluation variables
utils::globalVariables(c("county", "province"))
