require(dplyr)
require(readxl)
require(writexl)
data<-readxl::read_excel('event_data_formato.xlsx', sheet="Sheet1")


data$conteo<-as.numeric(data$conteo)
data$Vol_concentrado<-as.numeric(data$Vol_concentrado)
data$Vol_alicuota<-as.numeric(data$Vol_alicuota)
data$Num_alicuotas<-as.numeric(data$Num_alicuotas)
data$Vol_filtrado<-as.numeric(data$Vol_filtrado)


data<-data%>%
  mutate('quantity [inv.m-3]' = ((conteo*Vol_concentrado)/(Vol_alicuota*Num_alicuotas*Vol_filtrado))*2)
data<-data%>%
  mutate('quantity [inv.1000m-3]' = `quantity [inv.m-3]` * 1000)

writexl::write_xlsx(data, "data_zooplancton_2023_conteo.xlsx") 
