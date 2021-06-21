#### get_c14data ####

#' @title Download radiocarbon source databases and convert them to a \strong{c14_date_list}
#'
#' @description \code{get_c14data()} allows to download source databases and adjust their variables to conform to the
#' definition in the
#' \href{https://github.com/ropensci/c14bazAAR/blob/master/data-raw/variable_reference.csv}{variable_reference}
#' table. That includes renaming and arranging the variables (with \code{c14bazAAR::order_variables()})
#' as well as type conversion (with \code{c14bazAAR::enforce_types()}) -- so all the steps undertaken by
#' \code{as.c14_date_list()}. \cr
#' All databases require different downloading and data wrangling steps. Therefore
#' there's a custom getter function for each of them (see \code{?get_all_dates}). \cr
#'
#' \code{get_c14data()} is a wrapper to download all dates from multiple databases and
#' \code{c14bazAAR::fuse()} the results.
#'
#' @param databases Character vector. Names of databases to be downloaded. "all" causes the download of all databases. \code{get_c14data()} prints a list of the currently available databases
#'
#' @rdname db_getter
#'
#' @examples
#'
#' \dontrun{
##'  get_c14data(databases = c("adrac", "palmisano"))
#'   get_all_dates()}
#'
#' @export
get_c14data <- function(databases = c()) {

  # transfrom all input to lower
  databases <- tolower(databases)

  # message if no database is selected
  names_of_available_parsers <- names(get_all_parser_functions())
  if (length(databases) == 0) {
    message("The following databases are available: ", paste0(names_of_available_parsers, collapse = ", "))
    message("Learn more here: https://github.com/ropensci/c14bazAAR")
    return()
  }

  # start processing
  message("Trying to download all dates from the requested databases...")

  # check if all requested databases are available (e.g. spelling errors)
  database_availability_check <- databases %in% c("all", names_of_available_parsers)
  if (any(!database_availability_check)) {
    stop(
      "The following databases are not in the list of available databases (spelling?): ",
      paste0(databases[!database_availability_check], collapse = ", ")
    )
  }
  available_databases <- databases[database_availability_check]

  # setup progress bar
  pb <- utils::txtProgressBar(
    max = 100,
    style = 3,
    width = 50,
    char = "+"
  )

  # define list of parser functions
  parser_functions <- get_parser_functions(available_databases)

  # loop to call all parser functions
  date_lists <- list()
  for (i in 1:length(parser_functions)) {
    # call parser function
    date_lists[[i]] <- tryCatch(
      parser_functions[[i]](),
      error = function(e, name = names(parser_functions)[i]) { list(e = e, name = name) }
    )
    # increment progress bar
    utils::setTxtProgressBar(pb, 99 * i/length(parser_functions))
  }

  error_ind <- sapply(date_lists, function(x) !('c14_date_list' %in% class(x)))
  errors <- date_lists[error_ind]
  date_lists <- date_lists[!error_ind]

  if (any(error_ind)) {
    warning(
      paste(
        "There were errors:\n\n",
        paste(sapply(errors, function(x) { paste0(x$name, " --> ", x$e$message) }), collapse = "\n"),
        "\n\nNot all data might have been downloaded accurately!",
        sep = ""
      )
    )
  }

  # check if any database could be downloaded
  if (all(error_ind)) {
    stop("\n\nDownload failed for all databases.\n\n")
  }

  # fuse radiocarbon lists
  all_dates <- do.call(c14bazAAR::fuse, date_lists)

  # close progress bar
  utils::setTxtProgressBar(pb, 100)
  close(pb)

  return(all_dates)
}

#' get_parser_functions
#'
#' @return vector with all parser functions in c14bazAAR
#'
#' @keywords internal
#' @noRd
get_parser_functions <- function(databases) {
  pfs <- get_all_parser_functions()
  if ("all" %in% databases) {
    return(pfs)
  } else {
    return(pfs[names(pfs) %in% tolower(databases)])
  }
}

#' get_all_parser_functions
#'
#' @return vector with all parser functions in c14bazAAR
#'
#' @keywords internal
#' @noRd
get_all_parser_functions <- function() {
  return(c(
    "14sea" = c14bazAAR::get_14sea,
    "adrac" = c14bazAAR::get_adrac,
    "agrichange" = c14bazAAR::get_agrichange,
    "austarch" =  c14bazAAR::get_austarch,
    "calpal" = c14bazAAR::get_calpal,
    "caribbean" = c14bazAAR::get_caribbean,
    "context" = c14bazAAR::get_context,
    "emedyd" = c14bazAAR::get_emedyd,
    "eubar" = c14bazAAR::get_eubar,
    "euroevol" = c14bazAAR::get_euroevol,
    "radon" = c14bazAAR::get_radon,
    "radonb" = c14bazAAR::get_radonb,
    "kiteeastafrica" = c14bazAAR::get_kiteeastafrica,
    "palmisano" = c14bazAAR::get_palmisano,
    "irdd" = c14bazAAR::get_irdd,
    "pacea" = c14bazAAR::get_pacea,
    "14cpalaeolithic" = c14bazAAR::get_14cpalaeolithic,
    "medafricarbon" = c14bazAAR::get_medafricarbon,
    "jomon" = c14bazAAR::get_jomon,
    "mesorad" = c14bazAAR::get_mesorad,
    "katsianis" = c14bazAAR::get_katsianis,
    "nerd" = c14bazAAR::get_nerd,
    "bda" = c14bazAAR::get_bda,
    "rxpand" = c14bazAAR::get_rxpand
  ))
}

#' @title Backend functions for data download
#'
#' @description Backend functions to download data. See \code{?\link{get_c14data}}
#' for a more simple interface and further information.
#'
#' @param db_url Character. URL that points to the c14 archive file. \code{c14bazAAR::get_db_url()}
#' fetches the URL from a reference list on github
#'
#' @rdname db_getter_backend
#' @export
get_all_dates <- function() {
  get_c14data(names(get_all_parser_functions()))
}
