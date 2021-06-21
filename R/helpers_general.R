#' check_if_packages_are_available
#'
#' @param packages_ch packages that should be available
#'
#' @return NULL - called for side effect stop()
#'
#' @keywords internal
#' @noRd
check_if_packages_are_available <- function(packages_ch) {
  if (
    packages_ch %>%
    sapply(function(x) {requireNamespace(x, quietly = TRUE)}) %>%
    all %>% `!`
  ) {
    stop(
      paste0(
        "R packages ",
        paste(packages_ch, collapse = ", "),
        " needed for this function to work. Please install with ",
        "install.packages(c('", paste(packages_ch, collapse = "', '"), "'))"
      ),
      call. = FALSE
    )
  }
}

#' add_or_replace_column_in_df
#'
#' @param x data.frame
#' @param column_name_s name of new column
#' @param column_content_mi content of new column
#' @param ... passed to tibble::add_column()
#'
#' @return data.frame with new column
#'
#' @keywords internal
#' @noRd
add_or_replace_column_in_df <- function(x, column_name_s, column_content_mi, ...) {
  if (column_name_s %in% colnames(x) %>% all) {
    x[[column_name_s]] <- column_content_mi
  } else {
    x <- x %>%
      tibble::add_column(
        !!(column_name_s) := column_content_mi,
        ...
      )
  }
  return(x)
}

#' check_if_columns_are_present
#'
#' @param x c14_date_list
#' @param columns name of columns column
#'
#' @return NULL - called for side effect stop()
#'
#' @keywords internal
#' @noRd
check_if_columns_are_present <- function(x, columns) {
  if(columns %in% colnames(x) %>% all %>% `!`) {
    stop(
      paste0(
        "Columns ",
        paste(columns, collapse = ", "),
        " needed in your c14_date_list for this function to work."
      ),
      call. = FALSE
    )
  }
}

#' clean dataset
#'
#' @description Apply some data cleaning steps to a c14_date_list
#'
#' @param x an object of class c14_date_list
#'
#' @return an object of class c14_date_list
#'
#' @rdname cleaning
#' @keywords internal
#' @noRd
clean_latlon <- function(x) {

  if(all(c("lat", "lon") %in% colnames(x))) {

    # lat&lon not available but zero
    x[which(x[["lon"]] == 0 & x[["lat"]] == 0), c("lon", "lat")] <- NA

    # lat&long not on this earth
    x[which(x[["lon"]] > 180 | x[["lon"]] < -180 | x[["lat"]] > 90 | x[["lat"]] < -90), c("lon", "lat")] <- NA

  }

  return(x)
}

#' @rdname cleaning
#' @keywords internal
#' @noRd
clean_labnr <- function(x) {

  if ("labnr" %in% colnames(x)) {

    # Testcode
    # EUROEVOL -> x
    # x$labnr[x$labnr %>% grepl("[-]", .) %>% `!`]

    # case 1: simple labnr but no hyphen and no space z.B. Gd4438
    without_space <- x[["labnr"]] %>%
      grep("^[A-Z,a-z]+[0-9]+[A-Za-z]?$", .)
    x[["labnr"]][without_space] <- x[["labnr"]][without_space] %>%
      gsub("^([A-Za-z]+)([0-9]+)([A-Za-z]?)$", "\\1-\\2\\3", .)

    # case 2: simple labnr but space instead of hyphen
    without_hyphen <- x[["labnr"]] %>%
      grep("^[A-Z,a-z]+\\s[0-9]+[A-Za-z]?$", .)
    x[["labnr"]][without_hyphen] <- x[["labnr"]][without_hyphen] %>%
      gsub("^([A-Za-z]+)(\\s)([0-9]+)([A-Za-z]?)$", "\\1-\\3\\4", .)

    # case 3: simple labnr but double hyphens
    double_hyphen <- x[["labnr"]] %>%
      grep("^[A-Z,a-z]+--[0-9]+[A-Za-z]?$", .)
    x[["labnr"]][double_hyphen] <- x[["labnr"]][double_hyphen] %>%
      gsub("^([A-Za-z]+)(--)([0-9]+)([A-Za-z]?)$", "\\1-\\3\\4", .)

  }

  return(x)
}

#' check_connection_to_url
#'
#' @param db_url url string
#'
#' @return logical
#'
#' @keywords internal
#' @noRd
check_connection_to_url <- function(db_url) {
  if (httr::http_error(db_url)) {stop(paste(db_url, "is not available. No internet connection?"))}
}

#' paste_ignore_na
#'
#' https://stackoverflow.com/questions/13673894/suppress-nas-in-paste
#'
#' @param ... character vectors
#' @param sep character
#'
#' @return character vector
#'
#' @keywords internal
#' @noRd
paste_ignore_na <- function(..., sep = ";") {
  L <- list(...)
  L <- lapply(
    L,
    function(x) {
      x[is.na(x)] <- ""
      x
    }
  )
  ret <- gsub(
    paste0("(^", sep, "|", sep, "$)") ,
    "",
    gsub(
      paste0(sep, sep),
      sep,
      do.call(paste, c(L, list(sep = sep)))
    )
  )
  is.na(ret) <- ret == ""
  ret
}
