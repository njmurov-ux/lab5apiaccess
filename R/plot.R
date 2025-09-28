#' Read PNG bytes into R as a raster image for plotting
#' @param raw raw vector from stadia_get_tile or stadia_static_map
#' @return raster array (matrix-like) for plotting with rasterImage
#' @export
stadia_read_png <- function(raw) {
  .ensure_packages(c("png"))
  txt <- rawConnection(raw)
  on.exit(close(txt))
  img <- png::readPNG(txt)
  img
}

#' Plot a PNG image returned by stadia_read_png
#' @param img image to plot
#' @export
stadia_plot_png <- function(img) {
  old <- par(no.readonly = TRUE)
  on.exit(par(old))
  plot.new()
  plot.window(xlim = c(0,1), ylim = c(0,1), asp = NA)
  rasterImage(img, 0, 0, 1, 1)
}
