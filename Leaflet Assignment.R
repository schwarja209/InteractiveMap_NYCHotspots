library(jsonlite)
library(dplyr)
library(leaflet)

download.file("https://data.cityofnewyork.us/api/views/7agf-bcsq/rows.csv?accessType=DOWNLOAD","NYC_Wi-Fi_Hotspot_Locations_Map.csv")
hotspots<-read.csv("NYC_Wi-Fi_Hotspot_Locations_Map.csv")
hotspots<-rename(hotspots,lat=Latitude,lng=Longitude)

info<-paste("<b>Access Type: </b>",hotspots$Type,"<br>",
            "<b>Provider: </b>",hotspots$Provider,"<br>",
            "<b>Location Type: </b>",hotspots$Location_T,sep = "")
pal<-colorFactor(c("blue","darkgreen","red"),hotspots$Type)

hotspots_map<-hotspots%>%leaflet()%>%addTiles()%>%
    addCircleMarkers(clusterOptions=markerClusterOptions(),
               popup=info,color=pal(hotspots$Type))%>%
    addLegend(labels=c("Free - Unlimited","Free - Limited","Partner"),colors=c("blue","darkgreen","red"))
hotspots_map


hotspots2<-fromJSON("https://data.cityofnewyork.us/resource/7agf-bcsq.json", flatten = TRUE)
hotspots2<-rename(hotspots2,lng=long_)%>%mutate(lat=as.numeric(lat),lng=as.numeric(lng))

info2<-paste("<b>Access Type: </b>",hotspots2$type,"<br>",
             "<b>Provider: </b>",hotspots2$provider,"<br>",
             "<b>Location Type: </b>",hotspots2$location_t,sep = "")
pal2<-colorFactor(c("blue","darkgreen","red"),hotspots2$type)

hotspots2_map<-hotspots2%>%leaflet()%>%addTiles()%>%
    addCircleMarkers(clusterOptions=markerClusterOptions(),
                     popup=info2,color=pal2(hotspots$type))%>%
    addLegend(labels=c("Free - Unlimited","Free - Limited","Partner"),colors=c("blue","darkgreen","red"))
hotspots2_map