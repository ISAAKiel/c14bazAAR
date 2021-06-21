#' @rdname db_getter_backend
#' @export
get_caribbean <- function(db_url = get_db_url("caribbean")) {

  check_connection_to_url(db_url)

  # read data
  caribbean <- db_url %>%
    data.table::fread(
      drop = c(
        "UniqID",
        "Island",
        "Subregion",
        "calCurves",
        "Material"
      ),
      colClasses = c(
        "LabNo" = "character",
        "Age" = "character",
        "Error" = "character",
        "d13C" = "character",
        "Type" = "character",
        "SiteName" = "character",
        "Country.Territory" = "character",
        "Provenience" = "character",
        "Lat" = "character",
        "Lon" = "character",
        "Region" = "character",
        "Reference" = "character"
      ),
      encoding = "UTF-8",
      na.strings = c("", "\u2014"),
      showProgress = FALSE
    ) %>%
    dplyr::transmute(
      labnr = .data[["LabNo"]],
      c14age = .data[["Age"]],
      c14std = .data[["Error"]],
      c13val = .data[["d13C"]],
      material = .data[["Type"]],
      site = .data[["SiteName"]],
      country = .data[["Country.Territory"]],
      region = .data[["Region"]],
      feature = .data[["Provenience"]],
      lat = .data[["Lat"]],
      lon = .data[["Lon"]],
      shortref = .data[["Reference"]]
    ) %>%
    dplyr::mutate(
      sourcedb = "caribbean",
      sourcedb_version = get_db_version("caribbean")
    ) %>%
    as.c14_date_list()

  return(caribbean)
}
