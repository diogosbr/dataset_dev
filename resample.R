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


# Resample rasters from rawdata -------------------------------------------

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


# Creating subregions -----------------------------------------------------

# States
states <- rgdal::readOGR("/dados/pessoal/diogo/dataset_dev/GIS/estados_2010.shp")
states <- spTransform(states, crs(raster("/dados/rawdata/land-use/crop_class11_2015_4.9km_Moll.tif")))

states_ras <- rasterize(states, raster(files_vars[1]), field = "id")
plot(states_ras)

writeRaster(states_ras, "rawdata/subregions/states-code.tif")

# Creating csv
states_tab <- data.frame(states)
states_tab <- states_tab[ , c("id", "sigla")]
names(states_tab) <- c("CODE", "NAME")
head(states_tab)
write.csv(states_tab, "rawdata/subregions/states-code.csv")

set.seed(42)
states_tab_const <- states_tab
states_tab_const$total <- rnorm(nrow(states), 1000, 100)
write.csv(states_tab_const, "rawdata/subregions/restoration-constraints-per-states.csv")


# Biomes
biomes <- rgdal::readOGR("/dados/pessoal/diogo/dataset_dev/GIS/bioma.shp", stringsAsFactors = FALSE)
#crs(biomes) <- crs(raster("/dados/rawdata/land-use/crop_class11_2015_4.9km_Moll.tif"))
biomes <- spTransform(biomes, crs(raster("/dados/rawdata/land-use/crop_class11_2015_4.9km_Moll.tif")))

biomes_ras <- rasterize(biomes, raster(files_vars[1]))
plot(biomes_ras)
writeRaster(biomes_ras, "rawdata/land-use/ecoregions/biomes-code.tif")


# Creating csv
biomes_tab <- data.frame(biomes)
biomes_tab$id <- 1:6
biomes_tab <- biomes_tab[ , c("id", "NOME")]
names(biomes_tab) <- c("CODE", "NAME")

head(biomes_tab)
write.csv(biomes_tab, "rawdata/land-use/ecoregions/er_classes.csv")

set.seed(42)
biomes_tab_const <- biomes_tab
biomes_tab_const$total <- rnorm(nrow(biomes), 1000, 100)
write.csv(biomes_tab_const, "rawdata/land-use/ecoregions/restoration-constraints-per-biomes.csv")
