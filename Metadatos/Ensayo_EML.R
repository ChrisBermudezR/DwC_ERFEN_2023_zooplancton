if(!require(EML)){install.packages("EML")}


# para dudas, consulta este link: https://ipt.gbif.org/manual/en/ipt/latest/gbif-metadata-profile#metadata-elements

#Dataset####





# Creadores

source("dataset.R")
source("colaboradoresCCCP.R")
source("project.R")
source("methods.R")
source("coverage.R")

# Lengua






my_eml <- list(
  lang="spa",
  '@context'=list(
    
  ),
  '@type'="EML",
  dataset = list(
    #Data Resource
    title = titulo,
    creator = list(Fredy, Christian),
    contact=list(Christian),
    associatedParty=list(),
    metadataProvider=list(Christian),
    abstract=abstract,
    keywordSet=keywordSet,
    intellectualRights=intellectualRights,
    coverage=coverage,
    maintenance=maintenance,
    language=language,
    methods=methods,
    project=project,
    alternateIdentifier="intellectualRights",
    
    
  )

)

EML::write_eml(my_eml, "Prueba_EML.xml")
#> NULL
eml_validate("Prueba_EML.xml")
#> [1] TRUE
#> attr(,"errors")
#> character(0)
