



## ------------- ##
## Load packages ##
## ------------- ##




library(raster)
library(unmarked)




## --------- ##
## Load data ##
## --------- ##




year <- 2018
load(paste0("../data/final/species_occurrence_data_", year, ".gzip"))
years <- unlist(lapply(data.list, function(x)x$year))
nyears <- length(years)
habcov.raster <- raster("../resources/data/geodata/habcov.asc")
sitecovs <- data.frame(habcov = values(habcov.raster))
nsites <- length(habcov.raster)




## -------------------- ##
## Model fit and        ##
## parameter estimation ##
## -------------------- ##




## specify candidate model set
models <- c(Null = as.formula("~ 1 ~ 1"), DetCov = as.formula("~ viscov ~ 1"),
            OccuCov = as.formula("~ 1 ~ habcov"), Global = as.formula("~ viscov ~ habcov"))
nmods <- length(models)
modnames <- c("Null","DetCov","OccuCov","Global")
## fit all candidate models to each year of data
allfits <- lapply(data.list, function(data)fitList(fits = lapply(models,function(x,data)occu(x,data),
                                                                 data = data$unmarked.data)))
save(allfits, file = paste0("../output/raw_analysis/all_model_fits_", year, ".gzip"))




## --------------- ##
## Process results ##
## --------------- ##




modseltables <- lapply(allfits, function(x)as(modSel(x), "data.frame"))
modranks <- as.data.frame(lapply(modseltables, function(x)match(modnames, x$model)),
                          row.names = modnames, col.names = paste0("Y", years))
newdata1 <- data.frame(habcov = seq(-3,3,0.1) )
Epsi <- lapply(allfits, predict, type = "state", newdata = newdata1, appendData = TRUE)
newdata2 <- data.frame(viscov = factor(c("good","poor")))
Ep <- lapply(allfits, predict, type = "det", newdata = newdata2, appendData = TRUE)


source("./functions/get_topmod.R")
(topmods <- mapply(get.topmod, allfits, modranks))

source("./functions/get_betas.R")
(betas <- lapply(topmods, get.betas))

source("./functions/plot_betas.R")
plot.betas(betas, years, modranks)
