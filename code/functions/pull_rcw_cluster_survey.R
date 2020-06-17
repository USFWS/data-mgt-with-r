pull_rcw_cluster_survey <- function() {
  #Load packages
  if (!requireNamespace('esri2sf', quietly = TRUE)) remotes::install_github('yonghah/esri2sf')
  library(dplyr)
  
  url <- "https://services.arcgis.com/QVENGdaPbd4LUkLV/arcgis/rest/services/survey123_5f4f33ac440c41e29ef5044612257a85_stakeholder/FeatureServer/0"
  token <- "TSL--oz7gjjp_vbW2s_L4PwtDo4lZv1ZqY2yryWJZtAY14_-2590nHQTF3SDXGwfLrqlQxNeXigDTiAxnfoq8hl3TktkHe6h1cRQxrcbn-LyptsoownIvH-QR8rg0oCLwqgP0T9lPhqG9As10JwXHiDlW2CAUiYP7R9oeMxs5ZULgrI-pag_dCTf6rvBjrh2Jn3n3Iv_mH6FlOdqCL-zInMLTDsHezM4Q3N-ikTDJI7W8n13PPr-Td_p4b7zQPt6"
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
  return(out_sf)
}
  
  