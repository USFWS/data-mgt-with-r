#Load packages
if (!requireNamespace('esri2sf', quietly = TRUE)) remotes::install_github('yonghah/esri2sf')
library(dplyr)

url <- "https://services.arcgis.com/QVENGdaPbd4LUkLV/arcgis/rest/services/survey123_42f420578a9f49f0b819879c827af940_fieldworker/FeatureServer/0"
token <- "6xWYFUWS0gyYapsR2WzF1osG7gCXvBl_V2swxzfZlTg9QvoJqK4ldzknYCwHnPUmzrv-zU6iRWNU7BpMKfVD-z6xcLCRP1r0qFz-0tHvSw7tlE4Yxy6gOBGVPvYyTZH2rs5_TNf-rd_O7JRUqKr-sTxV7FfH2J6hzJn3asBLnLuqxy6bTeqQNCBv-qIv5jJ2mST850sdzaKmv3dye9KaZ5OojvVDI3R8-LqOz7LUxbusdjyUzRkaGpnZ4qO74Lfu"
outFields <- "*"
where = "1=1"

layerInfo <- jsonlite::fromJSON(httr::content(httr::POST(url,
                                                         query = list(f = "json", token = token), encode = "form",
                                                         config = httr::config(ssl_verifypeer = FALSE)), as = "text"))
geomType <- layerInfo$geometryType
queryUrl <- paste(url, "query", sep = "/")
esriFeatures <- esri2sf:::getEsriFeatures(queryUrl, outFields, where, token)

getPointGeometry <- function(feature) {
  return(sf::st_point(unlist(feature$geometry)))
}

geometry <- sf::st_sfc(lapply(esriFeatures, getPointGeometry))

atts <- lapply(esriFeatures, "[[", 1)
atts <- lapply(atts, function(att) {
  lapply(att, function(x) return(ifelse(is.null(x), NA, x)))
})

af <- bind_rows(lapply(atts, as.data.frame.list, stringsAsFactors = FALSE))
out_sf <- sf::st_sf(af, geometry, crs = "+init=epsg:4326") %>%
  mutate_at(vars(matches("date", ignore.case = TRUE)), ~ lubridate::as_datetime(./1000, tz = "America/New_York"))
out_sf

