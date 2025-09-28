# Required packages: httr, jsonlite, png
# You can check or install as needed:
.ensure_packages <- function(pkgs) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing)) {
    stop("Missing packages: ", paste(missing, collapse = ", "), ". Install them with install.packages().")
  }
}
