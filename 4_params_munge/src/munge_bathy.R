
munge_bathy <- function(out_ind, bathy_list_ind){

  bathy_list <- readRDS(sc_retrieve('3_params_fetch/out/bathy_files.rds.ind'))

  bathy_dat <- NULL

  # Loop through files and bind together
  for (i in 1:nrow(bathy_list)){
    csv_name <- bathy_list$name[i]
    csv_id <- as_id(bathy_list$id[i])

    lake_dow <- unlist(strsplit(csv_name, ".csv"))
    lake_dow <- unlist(strsplit(lake_dow, "_"))
    lake_dow <- lake_dow[length(lake_dow)]


    # Create folder to save downloaded files
    dir.create("3_params_fetch/in/hypsos_m/", showWarnings = FALSE)
    # Download csv's

    if (!file.exists(paste0("3_params_fetch/in/hypsos_m/",csv_name))){
      drive_download(csv_id, path=paste0("3_params_fetch/in/hypsos_m/",csv_name), overwrite = TRUE)
      message(paste0("Downloading ", csv_name))
    }

    #gd_confirm_posted(as_ind_file(paste0("3_params_fetch/in/hypsos_m/",csv_name)))
    #gd_get(as_ind_file(paste0("3_params_fetch/in/hypsos_m/",csv_name)))


    # Read csv's
    message(paste0("Reading ", csv_name))

    lake_hypso <- read.csv(paste0("3_params_fetch/in/hypsos_m/",csv_name), header=T)
    # Add lake DOW
    lake_hypso$DOW <- lake_dow

    # Bind lakes together - there is a slicker way to do this
    bathy_dat <- rbind(bathy_dat, lake_hypso)

  }


  data_file <- scipiper::as_data_file(out_ind)
  saveRDS(bathy_dat, data_file)
  gd_put(out_ind, data_file)
}