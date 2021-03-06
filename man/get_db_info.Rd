% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_dbs.R
\name{get_db_url}
\alias{get_db_url}
\alias{get_db_version}
\title{Get information for c14 databases}
\usage{
get_db_url(..., db_info_table = c14bazAAR::db_info_table)

get_db_version(..., db_info_table = c14bazAAR::db_info_table)
}
\arguments{
\item{...}{names of the databases}

\item{db_info_table}{db info reference table}
}
\description{
Looks for information for the c14 source databases in \link{db_info_table}.
}
