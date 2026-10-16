options(pkgType = "binary", install.packages.compile.from.source = "never")

for (pkg in c("hexSticker", "showtext", "sysfonts", "maps")) {
  if (!requireNamespace(pkg, quietly = TRUE))
    install.packages(pkg, type = "binary", repos = "https://cloud.r-project.org/")
}

library(ggplot2)
library(hexSticker)
library(showtext)
library(maps)

font_add_google("Oswald", "oswald")
showtext_auto()

# ── load real pitch coordinates ───────────────────────────────────────────────
pkg_path <- "."
data_file <- file.path(pkg_path, "data", "gaa_pitches.rda")
load(data_file)
pitches_df <- sf::st_drop_geometry(gaa_pitches)
pitches_df <- pitches_df[!is.na(pitches_df$longitude) & !is.na(pitches_df$latitude), ]

# ── world map ─────────────────────────────────────────────────────────────────
world <- map_data("world")

map_plot <- ggplot() +

  # ocean background
  theme(panel.background = element_rect(fill = "#1a3a5c", color = NA)) +

  # land masses
  geom_polygon(data = world,
               aes(x = long, y = lat, group = group),
               fill = "#2d6e2d", color = "#1a4a1a", linewidth = 0.1) +

  # Ireland highlighted
  geom_polygon(data = map_data("world", region = "Ireland"),
               aes(x = long, y = lat, group = group),
               fill = "#4caf50", color = "#a5d6a7", linewidth = 0.2) +

  # UK highlighted (Northern Ireland is part of UK map)
  geom_polygon(data = map_data("world", region = "UK"),
               aes(x = long, y = lat, group = group),
               fill = "#388e3c", color = "#81c784", linewidth = 0.15) +

  # all GAA pitch locations
  geom_point(data = pitches_df,
             aes(x = longitude, y = latitude),
             color = "#ffeb3b", size = 0.18, alpha = 0.85, shape = 16) +

  # Ireland pitches on top, slightly larger
  geom_point(data = pitches_df[pitches_df$country == "Ireland" |
                                 pitches_df$country == "Northern Ireland", ],
             aes(x = longitude, y = latitude),
             color = "#ffeb3b", size = 0.35, alpha = 1, shape = 16) +

  coord_fixed(ratio = 1, xlim = c(-160, 160), ylim = c(-55, 75)) +
  theme_void() +
  theme(
    panel.background = element_rect(fill = "#1a3a5c", color = NA),
    plot.background  = element_rect(fill = "#1a3a5c", color = NA)
  )

# ── hex sticker ───────────────────────────────────────────────────────────────
if (!dir.exists("man/figures")) dir.create("man/figures", recursive = TRUE)

sticker(
  map_plot,
  package    = "gaapitchfinder",
  p_size     = 18,
  p_color    = "#ffeb3b",
  p_family   = "oswald",
  p_y        = 0.55,
  s_x        = 1.0,
  s_y        = 1.12,
  s_width    = 1.9,
  s_height   = 1.1,
  h_fill     = "#1a3a5c",
  h_color    = "#4caf50",
  h_size     = 1.4,
  filename   = "man/figures/logo.png",
  dpi        = 300
)

cat("Hex sticker saved to man/figures/logo.png\n")
