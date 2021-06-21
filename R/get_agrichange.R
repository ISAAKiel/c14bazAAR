#' @rdname db_getter_backend
#' @export
get_agrichange <- function(db_url = get_db_url("agrichange")) {

  check_if_packages_are_available("readxl")
  check_connection_to_url(db_url)

  # download data
  temp <- tempfile(fileext = ".xlsx")
  utils::download.file(db_url, temp, mode = "wb", quiet = TRUE)

  # read data
  db_raw <- temp %>%
    readxl::read_excel(
      sheet = 1,
      col_names =  TRUE,
      col_types = "text",
      na = c("<<notfound>>", "nd", "--", "---"),
      trim_ws = TRUE
    )

  # delete temporary file
  unlink(temp)

  # final data preparation
  agrichange <- db_raw %>%
    dplyr::transmute(
      labnr = .data[["LabCode"]],
      c14age = .data[["BP"]],
      c14std = .data[["SD"]],
      method = .data[["Method"]],
      c13val = .[["\u03B413"]],
      material = .data[["Sample"]],
      species = .data[["Genus / specie"]],
      site = .data[["Site"]],
      country = .data[["Country"]],
      sitetype = .data[["TypeSite"]],
      lat = .data[["Lat"]],
      lon = .data[["Lon"]],
      region = .data[["Georegion"]],
      period = .data[["ChronoPhase"]],
      culture = paste_ignore_na(
        .data[["CultI"]], .data[["CultII"]],
        sep = ";"
      ),
      shortref = .data[["Date_reference"]],
      comment = .data[["Observations"]]
    ) %>%
    dplyr::mutate(
      sourcedb = "agrichange",
      sourcedb_version = get_db_version("agrichange")
    ) %>%
    as.c14_date_list()

  return(agrichange)

}
