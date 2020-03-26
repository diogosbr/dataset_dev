rm(list = ls())
gc()
require(devtools)
#require(tictoc)
load_all()

#sink("/dados/pessoal/diogo/dataset_dev/config_for_dev_10.log", split = TRUE, append = TRUE)
sink("/dados/pessoal/diogo/dataset_dev/config_for_dev_10.log", split = TRUE, append = TRUE)
cat("Tempo inicial: \n")
(ini <- Sys.time())
sink()

#tic()
cfg <- "/dados/pessoal/diogo/dataset_dev/config_for_dev.json"
plangea(cfg)
#toc()

sink("/dados/pessoal/diogo/dataset_dev/config_for_dev_10.log", append = TRUE)
cat("\n Tempo final: \n")
(fim <- Sys.time())
fim - ini
sink()
