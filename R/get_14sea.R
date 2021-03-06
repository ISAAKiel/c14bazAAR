#' @rdname db_getter_backend
#' @export
get_14sea <- function(db_url = get_db_url("14sea")) {

  check_if_packages_are_available("readxl")
  check_connection_to_url(db_url)

  # download data
  temp <- tempfile(fileext = ".xlsx")
  utils::download.file(db_url, temp, mode = "wb", quiet = TRUE)

  # read data
  db_raw <- temp %>%
    readxl::read_excel(
      sheet = 1,
      col_types = "text",
      na = c("Combination fails", "nd", "-"),
      trim_ws = TRUE
    )

  # delete temporary file
  unlink(temp)

  # final data preparation
  sea14 <- db_raw %>%
    dplyr::transmute(
      labnr = .[[5]],
      c14age = .[[6]],
      c14std = .[[7]],
      c13val = .[[8]],
      material = .[[11]],
      country = .[[4]],
      region = .[[2]],
      site = .[[1]],
      period = .[[15]],
      feature = .[[13]],
      shortref = {
        combined_ref <- paste0(
          ifelse(!is.na(.[[16]]), .[[16]], ""),
          ifelse(!is.na(.[[16]]) & !is.na(.[[17]]), ", ", ""),
          ifelse(!is.na(.[[17]]), .[[17]], ""),
          ifelse(!is.na(.[[17]]) & !is.na(.[[18]]), ", ", ""),
          ifelse(!is.na(.[[18]]), .[[18]], ""),
          ifelse(!is.na(.[[18]]) & !is.na(.[[19]]), ", ", ""),
          ifelse(!is.na(.[[19]]), .[[19]], "")
        )
        ifelse(nchar(combined_ref) == 0, NA, combined_ref)
      },
      comment = .[[14]]
    ) %>%
    dplyr::mutate(
      sourcedb = "14sea",
      sourcedb_version = get_db_version("14sea")
    ) %>%
    as.c14_date_list()

  return(sea14)
}
