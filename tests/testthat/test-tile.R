mock_httr_GET <- function(url, query = list(), ...) {
  # Intercept the URL and query to customize the response
  if (grepl("404", url)) { # Simulate a 404 error
    structure(
      list(
        status_code = 404,
        content = function(as, encoding) "Not Found",
        headers = list('content-type' = 'text/plain'),
        request = list(url = url)  # Add a dummy request object
      ),
      class = "response"  # Set the class to "response"
    )
  } else if (grepl("invalid_api_key", query$api_key)) { # Simulate an invalid API key
    structure(
      list(
        status_code = 403,
        content = function(as, encoding) "Invalid API Key",
        headers = list('content-type' = 'text/plain'),
        request = list(url = url)
      ),
      class = "response"
    )
  } else if (grepl("corrupt", url)) { # simulate corrupt png
    structure(
      list(
        status_code = 200,
        content = function(as, encoding) charToRaw("Not a PNG"),
        headers = list('content-type' = 'image/png'),
        request = list(url = url)
      ),
      class = "response"
    )
  }
  else { # Simulate a successful response
    structure(
      list(
        status_code = 200,
        content = function(as, encoding) {
          if (as == "raw") {
            png::writePNG(matrix(0, nrow = 16, ncol = 16)) # Create a tiny dummy PNG
          } else if (as == "text") {
            "OK"
          } else {
            NULL
          }
        },
        headers = list('content-type' = 'image/png'),
        request = list(url = url)
      ),
      class = "response"
    )
  }
}

mock_httr_content <- function(response, as, encoding){
  response$content(as = as, encoding=encoding)
}

test_that("Success - Return image", {
  with_mocked_bindings(
    GET = mock_httr_GET,
    content = mock_httr_content,
    {
      set_stadia_api_key("test")
      tile <- stadia_get_tile(z = 1, x = 1, y = 1)
      expect_true(is.matrix(tile), "Should return a matrix (PNG image)")
      expect_equal(dim(tile), c(16, 16))
    }
  )
})

test_that("Success - Write to file", {
  with_mocked_bindings(
    GET = mock_httr_GET,
    content = mock_httr_content,
    {
      set_stadia_api_key("test")
      temp_file <- tempfile(fileext = ".png")
      result <- stadia_get_tile(z = 1, x = 1, y = 1, file = temp_file)
      expect_equal(result, temp_file)
      expect_true(file.exists(temp_file), "File should be created")
      file.remove(temp_file) # Clean up
    }
  )
})

test_that("Handle API error (404)", {
  with_mocked_bindings(
    GET = mock_httr_GET,
    content = mock_httr_content,
    {
      set_stadia_api_key("test")
      expect_error(stadia_get_tile(z = 404, x = 1, y = 1), "Failed to fetch tile: 404 Not Found", fixed = TRUE)
    }
  )
})

test_that("Handle invalid API key", {
  with_mocked_bindings(
    GET = mock_httr_GET,
    content = mock_httr_content,
    `get_stadia_api_key` = function() "invalid_api_key",
    {
      set_stadia_api_key("test")
      expect_error(stadia_get_tile(z = 1, x = 1, y = 1), "Failed to fetch tile: 403 Invalid API Key", fixed = TRUE)
    }
  )
})

test_that("Handle corrupt PNG data", {
  with_mocked_bindings(
    GET = mock_httr_GET,
    content = mock_httr_content,
    {
      set_stadia_api_key("test")
      expect_error(stadia_get_tile(z = 1, x = 1, y = 1, style = "corrupt"), "libpng error: Not a PNG file", fixed = FALSE)
    }
  )
})
