library(tibble)

# Listar arquivos com as espécies já recortadas para o Brasil
files <- list.files("/dados/pessoal/diogo/dataset_dev/rawdata", pattern = "tif$", recursive = TRUE, full.names = TRUE)
files_sp_brazil <- grep("species", files, invert = FALSE, value = TRUE)

# Lower -------------------------------------------------------------------
tb_lower <- read.csv("/dados/pessoal/diogo/dataset_dev/rawdata/variables/TB_LowerElevation_MAB_May2018.csv", sep = ";", stringsAsFactors = FALSE)
tb_lower_tibble <- as_tibble(tb_lower)


tb_lower_brazil <- tibble()

for (i in 1:length(files_sp_brazil)) {
  if (!is.null(tb_lower_tibble[tb_lower_tibble$taxonid == tools::file_path_sans_ext(basename(files_sp_brazil[i])), ])) {
    tb_lower_brazil <- rbind(tb_lower_brazil, tb_lower_tibble[tb_lower_tibble$taxonid == tools::file_path_sans_ext(basename(files_sp_brazil[i])), ])
  }
}

write.csv(tb_lower_brazil, "/dados/pessoal/diogo/dataset_dev/rawdata/variables/TB_LowerElevation_MAB_May2018_Brazil.csv")



# Upper -------------------------------------------------------------------
tb_upper <- read.csv("/dados/pessoal/diogo/dataset_dev/rawdata/variables/TB_UpperElevation_MAB_May2018.csv", sep = ";", stringsAsFactors = FALSE)
tb_upper_tibble <- as_tibble(tb_upper)

tb_upper_brazil <- tibble()

for (i in 1:length(files_sp_brazil)) {
  if (!is.null(tb_upper_tibble[tb_upper_tibble$taxonid == tools::file_path_sans_ext(basename(files_sp_brazil[i])), ])) {
    tb_upper_brazil <- rbind(tb_upper_brazil, tb_upper_tibble[tb_upper_tibble$taxonid == tools::file_path_sans_ext(basename(files_sp_brazil[i])), ])
  }
}

write.csv(tb_upper_brazil, "/dados/pessoal/diogo/dataset_dev/rawdata/variables/TB_UpperElevation_MAB_May2018_Brazil.csv")



# Habitats_marginal_excluded Processing -----------------------------------
habs <- as_tibble(Habitats_marginal_excluded_habitats_selected)

habs_brazil <- tibble()

for (i in 1:length(files_sp_brazil)) {
  if (!is.null(habs[habs$taxonid == tools::file_path_sans_ext(basename(files_sp_brazil[i])), ])) {
    habs_brazil <- rbind(habs_brazil, habs[habs$taxonid == tools::file_path_sans_ext(basename(files_sp_brazil[i])), ])
  }
}

write.csv(habs_brazil, "/dados/pessoal/diogo/dataset_dev/rawdata/species/Habitats_marginal_excluded_habitats_selected_Brazil.csv")