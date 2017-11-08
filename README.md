# Interactive Map: NYC Hotspots
Jacob Schwartz  
September 15, 2017  

## Purpose

This page is the result of a project from the Developing Data Products course in the Data Science Specialization on Coursera (offered by Johns Hopkins University). The purpose of the project was to create a web page using `R Markdown` that features a map created with `Leaflet`.

For my version of the project, I used data from [Open Data NYC](https://opendata.cityofnewyork.us/) on public wifi hotspots throughout New York City. I felt that, in addition to being a good application of the skills from the course, this would be a useful resource to have online in map form.

*Note: The resulting map was approached in two different ways, yeilding slightly different results. The reasons for this are explained below, however, both maps are accurate and useable.*


## Setup

When I looked at the hotspot location from Open Data NYC, there were many different options for ways to download the data. Initially, I simply downloaded a .csv file, since this is easily manipulatable in R. However, after some thought, I came to the conclusion that it would actually be more useful to have a dynamic JSON link instead. Unfortunately, for some reason the City does not have all of the wifi hotspot data in their JSON link yet. So a JSON map alone was missing a lot of locations. Therefore, I opted to use both the .csv and JSON methods, to cover my bases. Over time, though, I assume that the JSON method will end up being more useful.

In any case, this is why, in addition to the `leaflet` library, the `jsonlite` library is included below. The `dplyr` library is also included for a bit of data frame manipulation that I needed to perform.


```r
library(jsonlite)
library(dplyr)
library(leaflet)
```


#### Method 1

As mentioned above, the first method I used to capture the hotspot data from Open Data NYC was downloading the .csv file, and importing it into R. The one issue with this is that it requires a file download, which can both be slow and require storage.


```r
download.file("https://data.cityofnewyork.us/api/views/7agf-bcsq/rows.csv?accessType=DOWNLOAD","NYC_Wi-Fi_Hotspot_Locations_Map.csv")
hotspots<-read.csv("NYC_Wi-Fi_Hotspot_Locations_Map.csv")
hotspots<-rename(hotspots,lat=Latitude,lng=Longitude)
```

Once the data was downloaded, I used some of the additional data to create informative popups and a color scheme.


```r
info<-paste("<b>Access Type: </b>",hotspots$Type,"<br>",
            "<b>Provider: </b>",hotspots$Provider,"<br>",
            "<b>Location Type: </b>",hotspots$Location_T,sep = "")

pal<-colorFactor(c("blue","darkgreen","red"),hotspots$Type)
```


#### Method 2

The second method used, as mentioned above, was an import from a JSON link. This should theoretically be more dynamic and auto-updating. However, there is less than half the amount of data available as with the .csv file. So for now this method is a bit limited.


```r
hotspots2<-fromJSON("https://data.cityofnewyork.us/resource/7agf-bcsq.json", flatten = TRUE)
hotspots2<-rename(hotspots2,lng=long_)%>%mutate(lat=as.numeric(lat),lng=as.numeric(lng))

info2<-paste("<b>Access Type: </b>",hotspots2$type,"<br>",
             "<b>Provider: </b>",hotspots2$provider,"<br>",
             "<b>Location Type: </b>",hotspots2$location_t,sep = "")

pal2<-colorFactor(c("blue","darkgreen","red"),hotspots2$type)
```


## Maps

The maps for each method can be found [here](http://rpubs.com/schwarja209/NYC_hotspots). Both cluster hotspot points and both are color coded based on the type of wifi access available, for somewhat easier navigation.

Please explore and enjoy, and feel free to reach out with any feedback or suggestions!


## Appendix

These maps were created on a computer with the following system running:

```
R version 3.4.1 (2017-06-30)
Platform: x86_64-w64-mingw32/x64 (64-bit)
Running under: Windows 10 x64 (build 15063)

Matrix products: default

locale:
[1] LC_COLLATE=English_United States.1252 
[2] LC_CTYPE=English_United States.1252   
[3] LC_MONETARY=English_United States.1252
[4] LC_NUMERIC=C                          
[5] LC_TIME=English_United States.1252    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] leaflet_1.1.0 dplyr_0.7.3   jsonlite_1.5 

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.12     knitr_1.17       bindr_0.1        magrittr_1.5    
 [5] xtable_1.8-2     R6_2.2.2         rlang_0.1.2      stringr_1.2.0   
 [9] tools_3.4.1      htmltools_0.3.6  crosstalk_1.0.0  yaml_2.1.14     
[13] rprojroot_1.2    digest_0.6.12    assertthat_0.2.0 tibble_1.3.4    
[17] bindrcpp_0.2     shiny_1.0.5      htmlwidgets_0.9  glue_1.1.1      
[21] evaluate_0.10.1  mime_0.5         rmarkdown_1.6    stringi_1.1.5   
[25] compiler_3.4.1   backports_1.1.0  httpuv_1.3.5     pkgconfig_2.0.1 
```
