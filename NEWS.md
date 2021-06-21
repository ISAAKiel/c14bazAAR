# 2.4.0

- added getter function for agrichange database: `get_agrichange`
- added getter function for caribbean database: `get_caribbean`

# 2.3.0

- deprecated `get_emedyd`, because the emedyd database was superseded by the nerd database

# 2.2.0

- added getter function for rxpand database: `get_rxpand`

# 2.1.0

- added getter function for NERD database: `get_nerd`
- added getter function for BDA database: `get_bda`

# 2.0.0

- the default lookup tables are now stored in the package and not downloaded from Github any more (#128)
- some changes in the internal functioning of the lookup methods (#128)
- introduced `inspect_lookup_country` and `inspect_lookup_material` which replace the automatic printing in `fix_database_country_name` and `classify_material` (#128)

# 1.3.3

- modified variable reference table layout (#126) 

# 1.3.2

- added submission ToDo list to README (#124)
- defined version update schema in README (#124)

# 1.3.1

- filtered out TL dates from aDRAC in parser function (#123)

# 1.3.0

## general changes
- added a CITATION file (see citation("c14bazAAR"))
- deprecated `mark_duplicates` to get rid of this extra step. You can get the same result now with `remove_duplicates(mark_only = TRUE)` (#100)
- deprecated `coordinate_precision`. The functionality was not essential and the calculated precision values probably frequently misleading. Beyond that the name was confusing (#96) (#106)
- deprecated `finalize_country_name`. This wrapper function was rather confusing and the functionality can be very easily be reimplemented if necessary (#96) (#106)
- renamed `standardize_country_name` to `fix_database_country_name` to make more clear what it does (#96) (#106)
- switched from openxlsx to readxl & writexl for handling xlsx files (#105) (#111)
- allowed for different calibration curves in calibrate (#118)

## new getter functions
- added getter function for MesoRAD database: `get_mesorad` (#112)
- added getter function for Katsianis et al. database: `get_katsianis` (#103)
- added getter function for PACEA database: `get_pacea` (#90)
- added getter function for 14C-Palaeolithic database: `get_14cpalaeolithic` (#90)
- added getter function for MedAfriCarbon database: `get_medafricarbon` (#95)
- added getter function for Jōmon population dynamics database: `get_jomon` (#95)
- added getter function for emedyd database: `get_emedyd` (#102)

## database updates
- updated the CalPal database from version 2017_04_27 to 2020_08_20 (#108)

## bugfixes
- `lwgeom::st_make_valid` was replaced by `sf::st_make_valid` (#99)
- enabled UTF-8 characters in country thesaurus (#96) (#104)
- `plot.c14_date_list` does not choke any more on c14_date_lists without coordinate columns (#112)
- fixed some entries in the country thesaurus

# 1.2.0

## general changes
- unified database names in all functions, tables, variables and documentation (#86)
- new logo and some layout changes in the README (#81)

## new features
- added a basic plot function for c14_date_lists (#82)
- added a basic write function for c14_date_lists: `write_c14()` (#84)
- added a version column that documents from which database version a certain date is pulled (#85)

# 1.1.0

## general changes
- [ROpenSci review](https://github.com/ropensci/software-review/issues/333)
- moved main development repository to github/ropensci/c14bazAAR (e0e6827f0381be04c50380eec277c01cad44ac7d)
- created [c14bazAAR project](https://doi.org/10.17605/OSF.IO/3DS6A) on the OSF platform with a DOI
- more work on an article for the Journal of Open Source Software (paper.md + paper.bib)
- changed citation to JOSS article after its publication

## new features
- new download interface as suggested by Enrico Crema in the ROpenSci review: `get_c14data()` (#76)
- replaced hard coded URLs with arguments to get helper functions (caabcb7b)

## new getter functions
- added getter function for irdd database: `get_irdd` (#79)

# 1.0.3

## general changes
- reformatted authors in DESCRIPTION and added ORCIDs (#72)
- added a [citation](https://github.com/ropensci/c14bazAAR#citation) section to the README
- added a [checklist](https://github.com/ropensci/c14bazAAR#adding-database-getter-functions) to the README on how to add new getter functions
- work on an article for the Journal of Open Source Software (paper.md + paper.bib)
- added a vignette with some plotting workflows
- created a completely artificial example dataset that replaces the sampled version

## new getter functions
- added getter function for Palmisano et al. database: `get_palmisano` (#59)
- added getter function for eubar database: `get_eubar` (#64)

## new features
- added new options for the deduplication function (see `?duplicates`) (#63)
- added an internal function `clean_labnr` to the `as.c14_date_list` workflow to fix certain syntactically wrong representations of lab numbers in several input databases as part of the downloading process (#61)
- better implementation of the `c14_date_list` as a subclass of tibble for a better integration of the subclass into the tidyverse (#67)

## bugfixes
- small file path construction fix in context getter function
- replaced some deprecated functions by other packages (dplyr::funs & tibble::as.tibble)
- replaced `RCurl::url.exists` with `httr::http_error` in `check_connection_to_url` (#68)
- fixed `as.sf` error that occurred when date lists with dates without coordinates were transformed

## removed objects
- data objects `c14bazAAR::country_thesaurus`, `c14bazAAR::material_thesaurus`, `c14bazAAR::variable-reference` have been removed from the package -- they are queried from [here](https://github.com/ropensci/c14bazAAR/tree/master/data-raw) anyway and it's not necessary to put them into the package
- some helper functions have been made internal
- .Rd files for unexported, internal objects have been removed (@noRd)

# 1.0.2

Release version
