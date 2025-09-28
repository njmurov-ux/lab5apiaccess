#' Download a raster tile (z/x/y) as raw PNG
#' @param z zoom level (integer)
#' @param x tile X (integer)
#' @param y tile Y (integer)
#' @param style map style; Stadia supports 'outdoors'/'alidade_smooth' etc. Default 'outdoors'
#' @param file (optional) file path to save the tile image to
#' @return raw vector (PNG) invisibly or writes file if path provided
#' @export
#' @importFrom httr GET content status_code
stadia_get_tile <- function(z, x, y, style = "outdoors", file = NULL) {
  .ensure_packages(c("httr", "png"))
  api_key <- get_stadia_api_key()
  base <- stadia_base_url()
  # Example tile endpoint: /tiles/{style}/{z}/{x}/{y}.png?api_key=...
  url <- sprintf("%s/tiles/%s/%d/%d/%d.png", base, style, as.integer(z), as.integer(x), as.integer(y))
  resp <- GET(url, query = list(api_key = api_key))
  if (status_code(resp) != 200) {
    stop("Failed to fetch tile: ", status_code(resp), " ", content(resp, "text", encoding = "UTF-8"))
  }
  raw <- content(resp, "raw")
  if (!is.null(file)) {
    writeBin(raw, file)
    invisible(file)
  } else {
    invisible(png::readPNG(raw))
  }
}
