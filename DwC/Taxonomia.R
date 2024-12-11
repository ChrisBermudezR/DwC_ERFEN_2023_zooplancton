
#Paquetes Usados####
if(!require(worrms)){install.packages("worrms")}
if(!require(dplyr)){install.packages("dplyr")}
if(!require(purrr)){install.packages("purrr")}
if(!require(writexl)){install.packages("writexl")}
if(!require(algaeClassify)){install.packages("algaeClassify")}
if(!require(rgbif)){install.packages("rgbif")}
if(!require(inborutils)){remotes::install_github("inbo/inborutils")}


#Carga de la tabla inicial####
taxa_df<-readxl::read_excel("datos_ERFEN_2023_pseudolong.xlsx", sheet = "listadoTaxonomico")

#Selección de los datos

verbatimIdentification_df<-taxa_df$verbatimIdentification
scientificIdentification_df<-taxa_df$scientificName
AphiaID_df<-taxa_df$AphiaID



#Worms####

matchedTaxa1<-worrms::wm_records_taxamatch(scientificIdentification_df[1:50], 
                                           marine_only = TRUE, 
                                           kingdom = "chromista")
matchedTaxa2<-worrms::wm_records_taxamatch(scientificIdentification_df[51:100], 
                                           marine_only = TRUE, 
                                           kingdom = "chromista")
matchedTaxa3<-worrms::wm_records_taxamatch(scientificIdentification_df[101:150], 
                                           marine_only = TRUE, 
                                           kingdom = "chromista")
matchedTaxa4<-worrms::wm_records_taxamatch(scientificIdentification_df[151:200], 
                                           marine_only = TRUE, 
                                           kingdom = "chromista")
matchedTaxa5<-worrms::wm_records_taxamatch(scientificIdentification_df[201:249], 
                                           marine_only = TRUE, 
                                           kingdom = "chromista")




# Unir los dataframes en uno solo
df1 <- dplyr::bind_rows(matchedTaxa1)
df2 <- dplyr::bind_rows(matchedTaxa2)
df3 <- dplyr::bind_rows(matchedTaxa3)
df4 <- dplyr::bind_rows(matchedTaxa4)
df5 <- dplyr::bind_rows(matchedTaxa5)


df_final<-rbind(df1, df2, df3, df4, df5)




#Exporta la table a un .xlsx####
writexl::write_xlsx(df_final,
                    path = "matched_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)


writexl::write_xlsx(df1,
                    path = "df1_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)
writexl::write_xlsx(df2,
                    path = "df2_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)
writexl::write_xlsx(df3,
                    path = "df3_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)
writexl::write_xlsx(df4,
                    path = "df4_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)
writexl::write_xlsx(df5,
                    path = "df5_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)

#Corrección Final

matched_Aphia01 <- wm_record(AphiaID_df[1:50], 
                          marine_only = TRUE)
matched_Aphia02 <- wm_record(AphiaID_df[51:100], 
                             marine_only = TRUE)
matched_Aphia03 <- wm_record(AphiaID_df[101:150], 
                             marine_only = TRUE)
matched_Aphia04 <- wm_record(AphiaID_df[151:200], 
                             marine_only = TRUE)
matched_Aphia05 <- wm_record(AphiaID_df[201:249], 
                             marine_only = TRUE)




Aphia_final<-rbind(matched_Aphia01, matched_Aphia02, matched_Aphia03, matched_Aphia04, matched_Aphia05)

writexl::write_xlsx(Aphia_final,
                    path = "Aphia_matched_Total.xlsx",
                    col_names = TRUE,
                    format_headers = TRUE,
                    use_zip64 = FALSE
)




#gbif back bone####

gbif_back_bone<-inborutils::gbif_species_name_match(
  df =as.data.frame(AphiaID_df) ,
  name = "V1", strict=FALSE)





#Algaebase

scientificIdentification_df<-as.data.frame(scientificIdentification_df)
algaebase_search_df(scientificIdentification_df,
                    apikey = NULL,
                    higher=TRUE,
                    long=TRUE,
                    species.name = "scientificIdentification_df")

