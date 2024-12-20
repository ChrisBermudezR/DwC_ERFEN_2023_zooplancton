if(!require(worrms)){install.packages("worrms")}
if(!require(dplyr)){install.packages("dplyr")}
if(!require(tidyr)){install.packages("tidyr")}
if(!require(writexl)){install.packages("writexl")}

#Consultar: https://rs.gbif.org/core/dwc_occurrence_2024-02-23.xml


MatrizConteo_total<-readxl::read_excel("Formato_transitorio_V4.xlsx", sheet = "Sheet1")

grupos_interes<-MatrizConteo_total%>%
  filter(Clase == "Teleostei" | Clase == "Thaliacea" | Orden == "Siphonophorae" | Phylllum =="Mollusca")

grupos_completos <- dplyr::anti_join(MatrizConteo_total, grupos_interes, by = colnames(MatrizConteo_total))


grupos_interes_completos<-grupos_interes%>%
  select(
         fieldNumber,
         verbatimIdentification,
         Vol_filtrado,
         conteo
         )%>%
  mutate(organismQuantity = (conteo/Vol_filtrado)*1000)%>%
  select(
    fieldNumber,
    verbatimIdentification,
        conteo,
    organismQuantity
  )
colnames(grupos_interes_completos)<-c("fieldNumber",
                                      "verbatimIdentification", 
                                      "individualCount", 
                                      "organismQuantity"
)






matriz_grupos_completos<-grupos_completos%>%
  select(
    fieldNumber,
    verbatimIdentification,
    Vol_concentrado,
    Vol_filtrado,
    Vol_alicuota,
    Num_alicuotas,
    conteo
  )%>%
  mutate('organismQuantity' = (1000*(conteo*Vol_concentrado)/(Vol_alicuota*Num_alicuotas*Vol_filtrado))*2)%>%
  select(
    fieldNumber,
    verbatimIdentification,
    conteo,
    organismQuantity
  )

colnames(matriz_grupos_completos)<-c("fieldNumber",
                                     "verbatimIdentification", 
                                     "individualCount", 
                                     "organismQuantity"
)



Matriz_total<-rbind(matriz_grupos_completos,grupos_interes_completos )
Matriz_total$verbatimIdentification<-as.factor(Matriz_total$verbatimIdentification)

Matriz_total_conteo<-Matriz_total%>%
  select("fieldNumber",
         "verbatimIdentification", 
         "individualCount")
Matriz_total_cantidad<-Matriz_total%>%
  select("fieldNumber",
         "verbatimIdentification", 
         "organismQuantity")

options(scipen=9999999)

Matriz_total_conteo_wide<-Matriz_total_conteo%>%
  tidyr::pivot_wider(names_from = "fieldNumber",
                     values_from ="individualCount",
                     values_fn = sum,
                     values_fill = 0)
Matriz_total_cantidad_wide<-Matriz_total_cantidad%>%
  tidyr::pivot_wider(names_from = "fieldNumber",
                     values_from ="organismQuantity",
                     values_fn = sum,
                     values_fill = 0)

Matriz_total_conteo_long<-Matriz_total_conteo_wide%>%
  tidyr::pivot_longer(cols = 2:63,
                      names_to =  "fieldNumber",
                     values_to = "individualCount")
Matriz_total_cantidad_long<-Matriz_total_cantidad_wide%>%
  tidyr::pivot_longer(cols = 2:63,
                      names_to =  "fieldNumber",
                      values_to = "organismQuantity")

matriz_total_long<-base::merge(Matriz_total_conteo_long, Matriz_total_cantidad_long, by=c("fieldNumber", "verbatimIdentification"))


eventoTable<-utils::read.csv2("./DwC/event.csv", header = TRUE, sep=",")

tablaMerge<-base::merge(matriz_total_long, eventoTable, by="fieldNumber")

#Inicio del OCcurrence####


#occurrenceID####
occurrenceID_secuencia<-as.data.frame(seq(1:8742))
colnames(occurrenceID_secuencia)<-"occurrenceID_secuencia"

bindTabla<-cbind(occurrenceID_secuencia, tablaMerge$eventID)
bindTabla<-bindTabla%>% mutate(occurrenceID = paste0(bindTabla$`tablaMerge$eventID`,":",bindTabla$occurrenceID_secuencia))
occurrenceID<-as.data.frame(bindTabla[,3])
colnames(occurrenceID)<-"occurrenceID"

tablaMerge<-cbind(occurrenceID, tablaMerge)

#basisOfRecord####
basisOfRecord<-as.data.frame(rep("HumanObservation", time=8742))
colnames(basisOfRecord)="basisOfRecord"

#type####

type<-as.data.frame(rep("Event", time=8742))
colnames(type)="type"

#institutionCode####

institutionCode<-as.data.frame(tablaMerge$institutionCode)
colnames(institutionCode)="institutionCode"

#institutionID####

institutionID<-as.data.frame(tablaMerge$institutionID)
colnames(institutionID)="institutionID"

#datasetName####

datasetName<-as.data.frame(tablaMerge$datasetName)
colnames(datasetName)="datasetName"

#datasetID####

datasetID<-as.data.frame(tablaMerge$datasetID)
colnames(datasetID)="datasetID"

#language####

language<-as.data.frame(tablaMerge$language)
colnames(language)="language"

#rightsHolder####

rightsHolder<-as.data.frame(tablaMerge$rightsHolder)
colnames(rightsHolder)="rightsHolder"

#rightsHolder####

accessRights<-as.data.frame(rep("Sólo para uso no comercial", time=8742))
colnames(accessRights)="accessRights"

#references####

references<-as.data.frame(tablaMerge$references)
colnames(references)="references"

#ownerInstitutionCode####

ownerInstitutionCode<-as.data.frame(rep("Centro de Investigaciones Oceanográficas e Hidrográficas del Pacífico - Dirección General Marítima (DIMAR)", time=8742))
colnames(ownerInstitutionCode)="ownerInstitutionCode"


#recordNumber####
recordNumber<-as.data.frame(rep("Solicitud 31", time=8742))
colnames(recordNumber)="recordNumber"

#recordedBy####
recordedBy<-as.data.frame(rep("Fredy Albeiro Castrillón Valencia", time=8742))
colnames(recordedBy)="recordedBy"

#recordedByID####

recordedByID<-as.data.frame(rep("https://orcid.org/0000-0003-2815-6122", time=8742))
colnames(recordedByID)="recordedByID"

#individualCount####

individualCount<-as.data.frame(tablaMerge$individualCount)
colnames(individualCount)="individualCount"


#organismQuantity####

organismQuantity<-as.data.frame(as.integer(round(tablaMerge$organismQuantity)))
colnames(organismQuantity)="organismQuantity"

#organismQuantityType####

organismQuantityType<-as.data.frame(rep("1000 ind/m3", time=8742))
colnames(organismQuantityType)="organismQuantityType"

#occurrenceStatus####

occurrenceStatus<-as.data.frame(individualCount%>%mutate(occurrenceStatus= ifelse(individualCount > 0, "present", "absent")))
occurrenceStatus<-as.data.frame(occurrenceStatus[,2])
colnames(occurrenceStatus)="occurrenceStatus"

#parentEventID####
parentEventID<-as.data.frame(tablaMerge$parentEventID)
colnames(parentEventID)="parentEventID"

#eventID####
eventID<-as.data.frame(tablaMerge$eventID)
colnames(eventID)="eventID"

#samplingProtocol####
samplingProtocol<-as.data.frame(tablaMerge$samplingProtocol)
colnames(samplingProtocol)="samplingProtocol"


#sampleSizeValue####
sampleSizeValue<-as.data.frame(tablaMerge$sampleSizeValue)
colnames(sampleSizeValue)="sampleSizeValue"

#sampleSizeUnit####
sampleSizeUnit<-as.data.frame(tablaMerge$sampleSizeUnit)
colnames(sampleSizeUnit)="sampleSizeUnit"

#samplingEffort####
samplingEffort<-as.data.frame(tablaMerge$samplingEffort)
colnames(samplingEffort)="samplingEffort"

#eventDate####
eventDate<-as.data.frame(tablaMerge$eventDate)
colnames(eventDate)="eventDate"

#year####
year<-as.data.frame(tablaMerge$year)
colnames(year)="year"

#month####
month<-as.data.frame(tablaMerge$month)
colnames(month)="month"


#day####
day<-as.data.frame(tablaMerge$day)
colnames(day)="day"



#eventTime####
eventTime<-as.data.frame(tablaMerge$eventTime)
colnames(eventTime)="eventTime"

#habitat####
habitat<-as.data.frame(tablaMerge$habitat)
colnames(habitat)="habitat"

#fieldNumber####
fieldNumber<-as.data.frame(tablaMerge$fieldNumber)
colnames(fieldNumber)="fieldNumber"

#eventRemarks####
#eventRemarks<-as.data.frame(tablaMerge$eventRemarks)
#colnames(eventRemarks)="eventRemarks"

#locationID####
locationID<-as.data.frame(tablaMerge$locationID)
colnames(locationID)="locationID"

#higherGeography####
higherGeography<-as.data.frame(tablaMerge$higherGeography)
colnames(higherGeography)="higherGeography"

#continent####
continent<-as.data.frame(tablaMerge$continent)
colnames(continent)="continent"

#waterBody####
waterBody<-as.data.frame(tablaMerge$waterBody)
colnames(waterBody)="waterBody"

#country####
country<-as.data.frame(tablaMerge$country)
colnames(country)="country"

#country####
countryCode<-as.data.frame(tablaMerge$countryCode)
colnames(countryCode)="countryCode"

#locality####
locality<-as.data.frame(tablaMerge$locality)
colnames(locality)="locality"


#minimumDepthInMeters####
minimumDepthInMeters<-as.data.frame(tablaMerge$minimumDepthInMeters)
colnames(minimumDepthInMeters)="minimumDepthInMeters"

#maximumDepthInMeters####
maximumDepthInMeters<-as.data.frame(tablaMerge$maximumDepthInMeters)
colnames(maximumDepthInMeters)="maximumDepthInMeters"

#decimalLatitude####
decimalLatitude<-as.data.frame(tablaMerge$decimalLatitude)
colnames(decimalLatitude)="decimalLatitude"

#decimalLongitude####
decimalLongitude<-as.data.frame(tablaMerge$decimalLongitude)
colnames(decimalLongitude)="decimalLongitude"

#geodeticDatum####
geodeticDatum<-as.data.frame(tablaMerge$geodeticDatum)
colnames(geodeticDatum)="geodeticDatum"

#georeferencedBy####
georeferencedBy<-as.data.frame(tablaMerge$georeferencedBy)
colnames(georeferencedBy)="georeferencedBy"


#identifiedBy####
identifiedBy<-as.data.frame(rep("Daniel Cardona-Recalde", time=8742))
colnames(identifiedBy)="identifiedBy"

#identifiedByID####


identifiedByID<-as.data.frame(rep("https://orcid.org/0000-0002-8603-2075", time=8742))
colnames(identifiedByID)="identifiedByID"


#dateIdentified####

dateIdentified<-as.data.frame(rep("2024-05-14/2024-10-21", time=8742))
colnames(dateIdentified)="dateIdentified"


#verbatimIdentification####
verbatimIdentification<-as.data.frame(tablaMerge$verbatimIdentification)
colnames(verbatimIdentification)="verbatimIdentification"




#Tabla Final####

TablaFinal<-cbind(occurrenceID,
              basisOfRecord,
              type,
              institutionCode,
              institutionID,
              datasetName,
              datasetID,
              language,
              rightsHolder,
              accessRights,
              references,
              ownerInstitutionCode,
              recordNumber,
              recordedBy,
              recordedByID,
              individualCount,
              organismQuantity,
              organismQuantityType,
              occurrenceStatus,
              parentEventID,
              eventID,
              samplingProtocol,
              sampleSizeValue,
              sampleSizeUnit,
              samplingEffort,
              eventDate,
              year,
              month,
              day,
              eventTime,
              habitat,
              fieldNumber,
              #eventRemarks,
              locationID,
              higherGeography,
              continent,
              waterBody,
              country,
              countryCode,
              locality,
              minimumDepthInMeters,
              maximumDepthInMeters,
              decimalLatitude,
              decimalLongitude,
              geodeticDatum,
              georeferencedBy,
              identifiedBy,
              identifiedByID,
              dateIdentified,
              verbatimIdentification
              )






#Taxonomía####
taxonomia<-readxl::read_excel("Formato_transitorio_V4.xlsx", sheet = "Listado_Final")
taxonomia<-taxonomia%>%select(verbatimIdentification,
                   scientificName, 
                   authority, 
                   url, 
                   lsid, 
                   status,
                   Kingdom,
                   Phylum,
                   Class,
                   Order,
                   Family,
                   Genus,
                   Species)

colnames(taxonomia)<-c("verbatimIdentification",
"scientificName",
"scientificNameAuthorship",
"taxonID",
"scientificNameID",
"taxonRank",
"kingdom",
"phylum",
"class",
"order",
"family",
"genus", 
"species")

DwC<-merge(TablaFinal,taxonomia, by= "verbatimIdentification")

DwC<-DwC%>%arrange(occurrenceID)
write.table(
  DwC, 
  file = "./DwC/Occurrence.csv", 
  col.names = TRUE, 
  row.names = FALSE, 
  sep = ",", 
  fileEncoding = "UTF-8",
  na = ""
)







