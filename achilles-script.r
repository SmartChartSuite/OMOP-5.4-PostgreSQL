install.packages("Achilles")

library(Achilles)
library(DatabaseConnector)

connectionDetails <- createConnectionDetails(dbms="postgresql",
            server="auh_cdm/omop54",port="5432",user="postgres",
            password="password")
# conn <- connect(connectionDetails)
# querySql(conn,"SELECT * FROM auh_cdm.person LIMIT 10")
# disconnect(conn)

cdmDatabaseSchema <- "auh_cdm"
resultsDatabaseSchema <- "results"
scratchDatabaseSchema <- "scratch"

# https://github.com/OHDSI/Achilles/blob/5ecc5b11c2b880bf62634c7303075f447fb85baa/extras/iterativeAchillesProcessing.r#L26
analysisDetails <- Achilles::getAnalysisDetails()
generalOnly <- analysisDetails[analysisDetails$CATEGORY == "General",]$ANALYSIS_ID

achilles(
      connectionDetails,
      cdmDatabaseSchema,
      resultsDatabaseSchema,
      scratchDatabaseSchema,
      vocabDatabaseSchema = cdmDatabaseSchema,
      tempEmulationSchema = resultsDatabaseSchema,
      smallCellCount = 0,
      cdmVersion = "5",
      sqlOnly = FALSE,
      outputFolder = "output",
      sourceName = "EUHA test",      
      analysisIds = generalOnly,
      createTable = TRUE,
      updateGivenAnalysesOnly = FALSE
)



# achilles(
#       connectionDetails,
#       cdmDatabaseSchema,
#       resultsDatabaseSchema,
#       scratchDatabaseSchema,
#       vocabDatabaseSchema = cdmDatabaseSchema,
#       tempEmulationSchema = resultsDatabaseSchema,
#       sourceName = "",
#       analysisIds = personOnly,
#       createTable = TRUE,
#       smallCellCount = 5,
#       cdmVersion = "5",
#       createIndices = TRUE,
#       numThreads = 1,
#       tempAchillesPrefix = "tmpach",
#       dropScratchTables = TRUE,
#       sqlOnly = FALSE,
#       outputFolder = "output",
#       verboseMode = TRUE,
#       optimizeAtlasCache = FALSE,
#       defaultAnalysesOnly = TRUE,
#       updateGivenAnalysesOnly = FALSE,
#     #   excludeAnalysisIds,
#       sqlDialect = NULL
# )

personOnly <- analysisDetails[analysisDetails$CATEGORY == "Person",]$ANALYSIS_ID
achilles(
      connectionDetails,
      cdmDatabaseSchema,
      resultsDatabaseSchema,
      scratchDatabaseSchema,
      vocabDatabaseSchema = cdmDatabaseSchema,
      tempEmulationSchema = resultsDatabaseSchema,
      smallCellCount = 0,
      cdmVersion = "5",
      sqlOnly = FALSE,
      outputFolder = "output",
      sourceName = "EUHA test",      
      analysisIds = personOnly,
      createTable = FALSE,
      updateGivenAnalysesOnly = TRUE
)

opOnly <- analysisDetails[analysisDetails$CATEGORY == "Observation Period",]$ANALYSIS_ID
achilles(
      connectionDetails,
      cdmDatabaseSchema,
      resultsDatabaseSchema,
      scratchDatabaseSchema,
      vocabDatabaseSchema = cdmDatabaseSchema,
      tempEmulationSchema = resultsDatabaseSchema,
      smallCellCount = 0,
      cdmVersion = "5",
      sqlOnly = FALSE,
      outputFolder = "output",
      sourceName = "EUHA test",      
      analysisIds = opOnly,
      createTable = FALSE,
      updateGivenAnalysesOnly = TRUE
)

deathOnly <- analysisDetails[analysisDetails$CATEGORY == "Death",]$ANALYSIS_ID
achilles(
      connectionDetails,
      cdmDatabaseSchema,
      resultsDatabaseSchema,
      scratchDatabaseSchema,
      vocabDatabaseSchema = cdmDatabaseSchema,
      tempEmulationSchema = resultsDatabaseSchema,
      smallCellCount = 0,
      cdmVersion = "5",
      sqlOnly = FALSE,
      outputFolder = "output",
      sourceName = "EUHA test",      
      analysisIds = deathOnly,
      createTable = FALSE,
      updateGivenAnalysesOnly = TRUE
)



# This is needed to create achilles_result_concept_count
# reads VOCAB, so takes LOOOOONG time! (2.6 min in Rosetta2-container)
optimizeAtlasCache(connectionDetails, 'results', 'auh_cdm')