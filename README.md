
# lab5apiaccess

<!-- badges: start -->
[![R-CMD-check](https://github.com/njmurov-ux/lab5apiaccess/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/njmurov-ux/lab5apiaccess/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of lab5apiaccess is to provide API access to Stadia Maps

## Installation

You can install the development version of lab5apiaccess like so:

``` r
# install.packages("pak")
pak::pak("njmurov-ux/lab5apiaccess")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(lab5apiaccess)
set_stadia_api_key("<your_key>")
image <- stadia_get_tile(12, 654, 1577, style = "outdoors", file = NULL)
# stadia_plot_png(image)
```

