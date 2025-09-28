#' Set Stadia Maps API key (environment variable)
#' @param key Your Stadia Maps API key (string)
#' @export
set_stadia_api_key <- function(key) {
  Sys.setenv(STADIA_MAPS_API_KEY = key)
  invisible(TRUE)
}

#' Read Stadia Maps API key from a config file and set environment variable
#' Supports either a single-line key or an INI-style line (stadia_api_key=KEY or api_key=KEY)
#' @param path path to config file (default: "~/.stadia_maps")
#' @param env_var name of environment variable to set (default: "STADIA_MAPS_API_KEY")
#' @return invisibly returns the key (invisibly)
#' @export
read_stadia_api_key_from_file <- function(path = "~/.stadia_maps", env_var = "STADIA_MAPS_API_KEY") {
  path <- path.expand(path)
  if (!file.exists(path)) stop("Config file not found: ", path)
  lines <- readLines(path, warn = FALSE)
  # remove empty lines and comments
  lines <- trimws(lines)
  lines <- lines[lines != "" & !grepl("^\\s*#", lines)]
  if (length(lines) == 0) stop("No usable lines found in config file: ", path)

  # try to find a key in INI-like format
  key_line_idx <- grep("stadia_api_key\\s*=|api_key\\s*=", lines, ignore.case = TRUE)
  if (length(key_line_idx) > 0) {
    # use first match
    kv <- lines[key_line_idx[1]]
    parts <- strsplit(kv, "=", fixed = TRUE)[[1]]
    if (length(parts) < 2) stop("Invalid key=value line in config file: ", kv)
    key <- trimws(paste(parts[-1], collapse = "="))
  } else {
    # fallback: treat first non-empty non-comment line as the key
    key <- lines[1]
  }

  if (key == "") stop("API key is empty in config file: ", path)
  Sys.setenv(STADIA_MAPS_API_KEY = key)  # sets environment variable
  invisible(key)
}

#' Get Stadia Maps API key from environment
#' @export
get_stadia_api_key <- function() {
  key <- Sys.getenv("STADIA_MAPS_API_KEY", unset = "")
  if (identical(key, "")) stop("Stadia Maps API key not set. Use set_stadia_api_key(key).")
  key
}

#' Base URL for Stadia Maps
#' @export
stadia_base_url <- function() {
  # default vector tile / static maps host
  "https://tiles.stadiamaps.com"
}
