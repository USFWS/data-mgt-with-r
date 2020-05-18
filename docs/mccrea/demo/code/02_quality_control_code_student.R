


## ------------- ##
## Load packages ##
## ------------- ##




library(unmarked)
library(raster)




## ------------------- ##
## Load processed data ##
## ------------------- ##



year <- 2018
load(file = paste0("../data/final/species_occurrence_data_", year, ".gzip"))
str(data.list, max.level=1)
str(data.list, max.level=2)



## ------------------------------- ##
## Data quality checks with        ##
## functions from unmarked package ##
## ------------------------------- ##




str(data.list[[1]]$unmarked.data)

summary(data.list[[1]]$unmarked.data)

plot(data.list[[1]]$unmarked.data)

numSites(data.list[[1]]$unmarked.data)

numY(data.list[[1]]$unmarked.data)

obsNum(data.list[[1]]$unmarked.data)

show(data.list[[1]]$unmarked.data)

obsCovs(data.list[[1]]$unmarked.data)

siteCovs(data.list[[1]]$unmarked.data)





## ------------------------------ ##
## Additional data quality checks ##
## ------------------------------ ##




## create years data object
years <- sapply(data.list, function(x)x$year)


## calculate naive site occupancy status for sampled sites
apply(slot(data.list[[1]]$unmarked.data, "y"), 1, max)


## use custom function and more apply functions
naive.occu <- function(x){apply(slot(x$unmarked.data, "y"), 1, max)}
naiveoccu <- lapply(data.list, naive.occu)
str(naiveoccu)

## calculate annual naive occupancy probability for samples sites
naiveoccu.byyear <- sapply(naiveoccu, mean)
names(naiveoccu.byyear) <- years
naiveoccu.byyear

## create and save figure for annual naive occupancy probabilities
plot(years, naiveoccu.byyear, ylim = c(0,1), type = "b", pch = 16, frame.plot = FALSE, axes  =  FALSE,
     ylab = "Naive proportion of sites occupied", xlab = "Year")
axis(2)
axis(1, at = years)


## tabulate number of surveys conducted by each observer for each site
table(data.list[[1]]$occdf[,c("id","observer")])

annual.tables <- function(x,year){write.csv(table(x$occdf[,c("id","observer")]),
                                            paste0("../output/tables/observer_table_", year, ".csv"))}
mapply(annual.tables, x = data.list, year = years)


## plot map of naive occupancy
habcov.raster <- raster("../resources/data/geodata/habcov.asc")
sitecovs <- data.frame(habcov = values(habcov.raster))
nsites <- length(habcov.raster)
rasterpts <- data.frame(rasterToPoints(habcov.raster))
ss <- as.numeric(names(naiveoccu[[1]]))

plot(habcov.raster, xlab = "X", ylab = "Y", asp = 1)
points(rasterpts$x[ss], rasterpts$y[ss], pch = c(21,16)[naiveoccu[[1]] + 1],
       col = "blue", bg = c(NA,"blue")[naiveoccu[[1]] + 1], cex = 2)

plot.annual.naiveoccu <- function(habcov.raster,naiveoccu,year){
    png(paste0("../output/figures/naiveoccu_map_",year,".png"), width = 6.5, height = 6.5, units = "in", res = 96)
    rasterpts <- data.frame(rasterToPoints(habcov.raster))
    ss <- as.numeric(names(naiveoccu))
    plot(habcov.raster, xlab = "X", ylab = "Y", asp = 1)
    points(rasterpts$x[ss], rasterpts$y[ss], pch = c(21,16)[naiveoccu + 1],
           col = "blue", bg = c(NA,"blue")[naiveoccu + 1], cex = 2)
    dev.off()
}

mapply(plot.annual.naiveoccu, naiveoccu = naiveoccu, year = years, MoreArgs = list(habcov.raster = habcov.raster))



## Check sample distribution of habitat covaraite values

hist(data.list[[1]]$sitedf$habcov, breaks = seq(-3,3,0.2), ylim = c(0,10),
     main = "", xlab = "Habitat covariate")



## Excercise: create a function similar to plot.annual.naiveoccu and use it to create & save a histogram for each year


plot.sample.habcov.hist <- function(){}





## ---------------------------------- ##
## Check for same years in occurrence ##
## and site data file names           ##
## ---------------------------------- ##



## updated custom function
extract.years <- function(filename){
    if(grepl("occurrence", filename)) ind = gregexpr("_", filename)[[1]][2]
    if(grepl("sample_site", filename)) ind = gregexpr("_", filename)[[1]][3]
    substr(filename, ind + 1, ind + 4)
}

## read file names, extract years for each data type, and compare years
o.files <- list.files("../data/raw", pattern = "occurrence", full.names = TRUE)
s.files <- list.files("../data/raw", pattern = "sample_site", full.names = TRUE)
(o.years <- as.numeric(sapply(o.files, extract.years)))
(s.years <- as.numeric(sapply(s.files, extract.years)))
(miss.o <- !(s.years %in% o.years))
(miss.s <- !(o.years %in% s.years))

## find common years and
(years <- intersect(o.years, s.years))
nyears <- length(years)
occ.files <- o.files[o.years %in% years]
site.files <- s.files[s.years %in% years]














