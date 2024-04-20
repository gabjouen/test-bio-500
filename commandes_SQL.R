#COMMANDES SQL!!!

# OUVRIR LA CONNECTION
#install.packages("RSQLite")
library(RSQLite)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), dbname="reseau_data")

################# CREER LES TABLES

tbl_identification <- "
CREATE TABLE identification (
  id_date           REAL,
  site              VARCHAR(40),
  ID_observation    REAL, 
  PRIMARY KEY (ID_observation, id_date)
);"

tbl_date <- "
CREATE TABLE date (
  date       DATE,
  heure_obs  CHAR,
  id_date    REAL,
  FOREIGN KEY (id_date) REFERENCES identification(id_date)
);"

tbl_site <- "
CREATE TABLE site (
  site               VARCHAR(40),
  largeur_riviere    REAL,
  profondeur_riviere REAL,
  vitesse_courant    REAL,
  transparence_eau   VARCHAR(40),
  temperature_eau_c  REAL,
  id_date            REAL,
  FOREIGN KEY (id_date) REFERENCES identification(id_date)
);"

tbl_espece <- "
CREATE TABLE espece (
  nom_sci          VARCHAR(50),
  abondance_totale REAL,
  famille          CHAR,
  ID_observation   REAL,
  FOREIGN KEY (ID_observation) REFERENCES identification(ID_observation)
);"

dbSendQuery(con, tbl_identification)
dbSendQuery(con, tbl_site)
dbSendQuery(con, tbl_date)
dbSendQuery(con, tbl_espece)


############# LECTURE DES FICHIERS CSV

bd_ident<- combined_data[, c('id_date','site','ID_observation')]
bd_esp<- combined_data[, c('nom_sci','abondance_totale','ID_observation','famille')]
bd_sites<- combined_data[, c('site','largeur_riviere','profondeur_riviere','vitesse_courant','transparence_eau','temperature_eau_c','id_date')]
bd_dates<- combined_data[, c('date', 'heure_obs','id_date')]


############### Seulement pour voir quelles variables sont des clés primaires ou secondaires

bd_sites <-bd_sites[!duplicated(bd_sites),]
bd_dates <-bd_dates[!duplicated(bd_dates),]


############ INJECTION DES DONNÉES

dbWriteTable(con, append = TRUE, name = "identification", value = bd_ident, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "espece", value = bd_esp, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = bd_dates, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "site", value = bd_sites, row.names = FALSE)

dbListTables(con)


################### REQUETES

req1 <- dbGetQuery(con, 'SELECT * FROM site LIMIT 10')
req1
req2 <- dbGetQuery(con, 'SELECT * FROM date LIMIT 10')
req2
req3 <- dbGetQuery(con, 'SELECT * FROM espece LIMIT 10')
req3
req4 <- dbGetQuery(con, 'SELECT * FROM identification LIMIT 10')
req4


#Juste pour faire les changement dans les tables
dbRemoveTable(con, "date")
dbRemoveTable(con, "site")
dbRemoveTable(con, "identification")
dbRemoveTable(con, "espece")

##########

# extraction des donnees necessaires pour nos 3 figures
requete1 <- "
SELECT espece.nom_sci, espece.abondance, site.largeur_riviere, site.profondeur_riviere, site.vitesse_courant
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
"
donnees1 <- dbGetQuery(con, requete1)

############

requete2 <- "
SELECT SUM(espece.abondance) AS abondance_totale, site.largeur_riviere
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.largeur_riviere
"
donnees2 <- dbGetQuery(con, requete2)

##########

requete3 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.profondeur_riviere
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.profondeur_riviere
"
donnees3 <- dbGetQuery(con, requete3)

############

requete4 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.vitesse_courant
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.vitesse_courant
"
donnees4 <- dbGetQuery(con, requete4)

###########

requete5 <- "
SELECT 
    e.famille,
    s.temperature_eau_c,
    e.abondance_totale
FROM
    espece e
JOIN
    identification i ON e.ID_observation = i.ID_observation
JOIN
    site s ON i.id_date = s.id_date
"
donnees5 <- dbGetQuery(con, requete5)

###########

requete6 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.temperature_eau_c
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.temperature_eau_c
"
donnees6 <- dbGetQuery(con, requete6)

############

requete7 <- "
SELECT s.largeur_riviere, s.profondeur_riviere, s.vitesse_courant, s.temperature_eau_c, e.abondance_totale
FROM site s
JOIN identification i ON s.id_date = i.id_date
JOIN espece e ON i.ID_observation = e.ID_observation
"

# Récupérer les données
donnees7 <- dbGetQuery(con, requete7)

############

requete8 <- "
SELECT 
    e.famille,
    s.vitesse_courant,
    s.temperature_eau_c
FROM 
    espece e
INNER JOIN 
    identification i ON e.ID_observation = i.ID_observation
INNER JOIN 
    site s ON i.id_date = s.id_date
"

# Exécuter la requête et stocker les résultats
donnees8 <- dbGetQuery(con, requete8)




dbDisconnect(con)

