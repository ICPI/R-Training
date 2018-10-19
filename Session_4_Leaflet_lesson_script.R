## --- 1. Install & Load Packages ----
#Create a list of packages you need for this session
list_of_packages <- c("tidyverse","leaflet","readr","rgdal","sp", 'rgeos', 'RColorBrewer')

#check if packages are installed, if not install missing packages
lapply(list_of_packages, 
       function(x) if(!require(x,character.only = TRUE)) install.packages(x))

library(tidyverse)
library(leaflet)
library(readr)
library(rgdal)
library(sp)
library(rgeos)
library(RColorBrewer)

##---- 2. Load Files ----
df_msd <- read_tsv('RawData_leaflet/ICPI_MER_Structured_TRAINING_Dataset_PSNU_IM_FY17_18_20181012_v1_1.txt')

# read in facilities coordinates
fac_xy <- read_tsv('RawData_leaflet/ICPI_TRAINING_GoT_site_lat_long_MER_20181017.txt')

# read shape files as Spatial Polygon data for PSNU & OU
got.psnu <- readOGR(dsn='RawData_leaflet/GoT_PSNUs', layer = 'GoT_PSNUs')
 
got.regions <- readOGR(dsn= 'RawData_leaflet/GoT_Regions', layer= 'GoT_Regions')

## ---- 3. Examine Spatial Polygon DF ----
# lets see what the spatial polygon dataframes look like
summary(got.psnu)
summary(got.regions)

#check if the shape files are right ones 
# quick way to plot a Spatial Polygon dataframe, to see if the shape file look as expected
plot(got.psnu)

## --- 4. Introduce Leaflet ----
# Now we will just plot a location on a OpenStreet Map with leaflet 
# Create a map with just lat-long

leaflet() %>%
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

# Let's add a base map layer to see where this location is on the planet!

leaflet() %>%
  addTiles() %>%  # Adds default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")


# Change background map
leaflet() %>% 
  addProviderTiles(providers$CartoDB) %>% 
   addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

# Leaflet has 110 options for base layer maps, you can check the list of providers by running:
names(providers)

# change the type of marker
leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R", radius = 10)


## ---Exercise 1: Create a map with Marker (any type) on Latitude: 38.898 Longitude: -77.0425 ----



###---5. Let's work with GoT MSD data----

#Plot GoT PSNU shape file with Leaflet
# Just like a data frame or functions you can store a leaflet map in an object
m1 <- leaflet(got.psnu) %>% 
  addTiles() %>%
  addPolygons(color='black', weight=2, opacity=.8, fillOpacity = 0)# Call the map to display it in the viewer

m1 # Despite addTiles  argument in the code above, the background is blank
   # This is due to mismatch between CRS projection of GoT shape files and Openstreet Maps

## --- 6. CRS Projections ----

# Check CRS projection of GoT shape files
proj4string(got.psnu)
proj4string(got.regions)

# Set CRS to standard WGS84 
# You can check WGS 
proj4string(got.psnu)<- CRS("+proj=longlat +datum=WGS84 +no_defs")
proj4string(got.regions)<- CRS("+proj=longlat +datum=WGS84 +no_defs")


leaflet(got.psnu) %>% 
  addProviderTiles(providers$Thunderforest) %>%
  addPolygons(color='black', weight=2, opacity=.8, fillOpacity = 0)


# Add multiple layers of polygon- PSNU & Regions in the same map
# this useful when you want to display Region and PSNU boundaries distinctly in the same map
m2 <- leaflet() %>% 
  addTiles() %>%
  addPolygons(data=got.psnu, color='black', weight=2, opacity=.8, fillOpacity = 0) %>% 
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0)
m2

# -- 7. Choropleths ----

# First, create a color palette
col_pal <- colorFactor(palette = 'Set3', domain = got.psnu@data$PSNU ) # this creates a function that 
# has colors assigned based on PSNU names

#check all the color palettes available in RColorBrewer library
display.brewer.all()

leaflet() %>% 
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu, color='black', weight=2, opacity=.8, 
              fillColor = ~col_pal(PSNU), fillOpacity = 1, label = ~PSNU)

# -- 8. Merge MSD df with Spatial Polygon df ----

# Create Choropleth based on MSD data
# But the spatial DF doesn't have MSD data in it!
# So, merge MSD data with spatial DF

# Both are PSNU level files, so how do we find which variable to use as key?
# use interset() to see which column names match between got.psnu@data & df_msd

intersect(names(got.psnu@data), names(df_msd))

# First, we need to modify MSD to make it rowwise unique by PSNU
# aggregate data to PSNU level, so we have just one row per PSNU
# this makes it easier display it on the map
df_msd_agg <- df_msd %>% 
  gather(period, val, FY2018_TARGETS, FY2018Q1, FY2018Q2) %>% 
  mutate(ind_period=paste(indicator, period, sep = '_')) %>% 
  filter(indicator %in% c('TX_CURR', 'TX_NEW')) %>% 
  group_by(OperatingUnit, PSNU, PSNUuid, SNUPrioritization, disaggregate, ind_period) %>% 
  summarise(val=sum(val,na.rm = T)) %>% 
  ungroup() %>% 
  spread(ind_period, val)

# now merge the new wide df with spatial df
got.psnu.msd <- merge(got.psnu, df_msd_agg, by.x='PSNU', by.y='PSNU')

#check if the data was merged
head(got.psnu.msd@data,5)

# Create a choropleth on TX_CURR FY2018Q1 values by PSNU

# first create a color scale based on TX_CURR values; use colorBin 
col_txcurr <- colorBin(palette = 'YlOrRd', domain = got.psnu.msd@data$TX_CURR_FY2018Q2)

leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, label = ~PSNU)

## -- 9. Labels ----

# Now show TX_CURR_FY2018Q2 values in label with labels argument inside addPolygons

leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = ~paste(PSNU, 'TX_CURR:',TX_CURR_FY2018Q2,sep="\n"))


# or Create labels separately, using HTML toots

labels <- sprintf(
  "<strong>%s</strong><br/>TX_CURR: %g </sup>",
  got.psnu.msd@data$PSNU, got.psnu.msd@data$TX_CURR_FY2018Q2
) %>% lapply(htmltools::HTML)

# Then add the labels to the leaflet map
leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = labels)


# -- 10. Lengend - add legend to the map ----

map_txcurr <- leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = labels) %>% 
  addLegend('bottomright', pal = col_txcurr, values = got.psnu.msd@data$TX_CURR_FY2018Q2, title = 'TX_CURR FY2018Q2')

map_txcurr

## --- Exercise 2: ----
# Use TX_NEW FY2018Q2 to create a choropleth


## --- 11. Point Data ----

# Add Facility markers in each PSNU
map_txcurr %>% 
  addMarkers(data = fac_xy, lat = ~lat, lng = ~long, popup = ~PSNU) # you can use a non saptial df here, just need to point to lat/long variables in the df

# Change Markers
map_txcurr %>% 
  addCircleMarkers(data = fac_xy, lat = ~lat, lng = ~long, popup = ~sitename, radius = 0.7)

# Display Facilities in the North PSNU
map_txcurr %>% 
  addCircleMarkers(data = fac_xy %>% filter(PSNU=='The North'), lat = ~lat, lng = ~long, popup = ~sitename, radius = 1)


# Change the radius of facility markers based on their HTS_TST_POS values 

map_txcurr %>% 
  addCircleMarkers(data = fac_xy %>% filter(PSNU== c('The North', 'Riverlands')), lat = ~lat, lng = ~long, 
                   popup = ~sitename, radius = ~(hts_tst_pos)/50, fillOpacity = .8)


## -- Exercise 3: ----
# Display facilities in the southern part of the country i.e. latitude < 0




## -- 13. Awesome Markers ----
 # let's have some fun with Markers
# create icons based on facility
# checkout the list of options here: https://github.com/lvoogdt/Leaflet.awesome-markers 

icons <- awesomeIcons(
  icon = ifelse(fac_xy$f_c=="facility",'hospital-o', 'ambulance'),
  library = 'fa',
  markerColor = "white"
)

map_txcurr %>% 
  addAwesomeMarkers(data = fac_xy %>% filter(PSNU== c('The North', 'Riverlands')), lat = ~lat, lng = ~long, 
                   popup = ~sitename, icon = icons)


## -- 12. Saving Leaflet Maps ----
# Leaflet maps can be saved as PDF, JPEG or interactive HTML files
# HTML files are stored as web pages that can be opened in any browser

htmlwidgets::saveWidget(map_txcurr, 'map_txcurr.html') # you can do the same by clicking on Export in the Viewer window
