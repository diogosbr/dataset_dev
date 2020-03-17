# Loading packages --------------------------------------------------------

library(raster)
library(doParallel)
library(foreach)


# Mask to resample global dataset -----------------------------------------

# Mask from Brazil
mask <- raster("/dados/projetos_andamento/PPBio/delta_agbgC_tonha_v4.4.tif")

# Reprojecting the mask
mask <- projectRaster(mask, raster("/dados/rawdata/land-use/crop_class11_2015_4.9km_Moll.tif"))

# Removing outer rows and columns that all have NA
mask <- trim(mask)

# list raster file to mask
files <- list.files("/dados/pessoal/diogo/dataset_dev/rawdata", pattern = "tif$", recursive = TRUE, full.names = TRUE)
length(files)

# select files without species
files_vars <- grep("species", files, invert = TRUE, value = TRUE)

# select files with species
files_sp <- grep("species", files, invert = FALSE, value = TRUE)


# Regiter cores to use ----------------------------------------------------

cl = parallel::makeCluster(50, outfile = "")
registerDoParallel(cl)


# Loop to mask variables --------------------------------------------------

foreach(i = 1:length(files_vars), .packages = "raster") %dopar% {
  ras_temp <- raster::raster(files_vars[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = files_vars[i], overwrite = TRUE)
}


# Loop to mask species ----------------------------------------------------

foreach(i = 1:length(files_sp), .packages = "raster") %dopar% {
  ras_temp <- raster::raster(files_sp[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = files_sp[i], overwrite = TRUE)
}


# Removing species without occurrence in Brazil ---------------------------

foreach(i = 1:length(files_sp), .packages = "raster") %dopar% {
  ras_temp <- raster::raster(files_sp[i])
  if (sum(values(ras_temp), na.rm = TRUE) == 0) {
    unlink(files_sp[i], force = TRUE)
  }
}

# Removing variables without data in Brazil ---------------------------

foreach(i = 1:length(files_vars), .packages = "raster") %dopar% {
  ras_temp <- raster::raster(files_vars[i])
  if (sum(values(ras_temp), na.rm = TRUE) == 0) {
    unlink(files_vars[i], force = TRUE)
  }
}

parallel::stopCluster(cl)
