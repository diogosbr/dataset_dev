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

# ----------------------------------------------------------------------------------------------------- #


library(raster)

mask <- raster("~/storage/projetos_andamento/PPBio/delta_agbgC_tonha_v4.4.tif")

mask <- projectRaster(mask, raster("/home/diogo/storage/rawdata/land-use/crop_class11_2015_4.9km_Moll.tif"))

#dirs <- list.dirs("/dados/rawdata")
dirs <- list.dirs("~/storage//pessoal/diogo/testes/rawdata", recursive = FALSE)
dirs

# /land-use
sub_dir1 <- list.dirs(dirs[1], recursive = FALSE)

lista_land_use <- list.files(dirs[1], "tif$", full.names = TRUE)

for(i in 1:length(lista_land_use)){
  ras_temp <- raster::raster(lista_land_use[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_land_use[i], overwrite = TRUE)
}


# /ecoregions
lista_eco <- list.files(sub_dir1[1], "tif$", full.names = TRUE)

for(i in 1:length(lista_eco)){
  ras_temp <- raster::raster(lista_eco[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_eco[i], overwrite = TRUE)
}


# /past
lista_past <- list.files(sub_dir1[2], "tif$", full.names = TRUE)

for(i in 1:length(lista_past)){
  ras_temp <- raster::raster(lista_past[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_past[i], overwrite = TRUE)
}



# /especies
sub_dir2 <- list.dirs(dirs[2])[6:8]


# amph
lista_amph <- list.files(sub_dir2[1], "tif$", full.names = T)

for (i in 1:length(lista_amph)) {
  ras_temp <- raster::raster(lista_amph[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_amph[i], overwrite = TRUE)
}

# birds
lista_birds <- list.files(sub_dir2[2], "tif$", full.names = T)

for (i in 1:length(lista_birds)) {
  ras_temp <- raster::raster(lista_birds[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_birds[i], overwrite = TRUE)
}


# mammals
lista_mammals <- list.files(sub_dir2[3], "tif$", full.names = TRUE)

for (i in 1:length(lista_mammals)) {
  ras_temp <- raster::raster(lista_mammals[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_mammals[i], overwrite = TRUE)
}

# /subregions
sub_dir3 <- list.dirs(dirs[3])

lista_subregions <- list.files(sub_dir3, "tif$", full.names = TRUE)

for (i in 1:length(lista_subregions)) {
  ras_temp <- raster::raster(lista_subregions[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_subregions[i], overwrite = TRUE)
}


# /variables
lista_variables <- list.files(dirs[4], "tif$", full.names = TRUE)

for (i in 1:length(lista_variables)) {
  ras_temp <- raster::raster(lista_variables[i])
  masked <- mask(crop(ras_temp, mask), mask)
  writeRaster(masked, filename = lista_variables[i], overwrite = TRUE)
}