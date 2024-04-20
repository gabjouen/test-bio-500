install.packages("targets")
library(targets)
# ===========================================
# _targets.R file
# ===========================================
# Dépendances
tar_option_set(packages = c("RSQLite", "DBI","dplyr","tidyverse"))
library(targets)

# Scripts R
source("commandes_SQL.R")
source("fonction_combiner.R")
source("fonction_heure.R")
source("fonction_nettoyage.R")
source("script_principal.R")
source("table_1.R")
source("table_2.R")
source("table_3.R")
source("table_4.R")

# Pipeline
list(
  # Target pour le chemin du fichier de données
  tar_target(
    name = chemin,
    command = ".", # Remplacez par le chemin réel de votre fichier de données
    format = "file"
  ),
  # Target pour les commandes SQL
  tar_target(
    name = commandes_sql,
    command = script_commandes_sql() # Fonction à définir dans commandes_SQL.R
  ),
  
  # Target pour la combinaison des données
  tar_target(
    name = donnees_combinees,
    command = combiner_donnees(commandes_sql) # Fonction à définir dans fonction_combiner.R
  ),
  
  # Target pour le traitement des heures
  tar_target(
    name = donnees_heure,
    command = traiter_heure(donnees_combinees) # Fonction à définir dans fonction_heure.R
  ),
  
  # Target pour le nettoyage des données
  tar_target(
    name = donnees_nettoyees,
    command = nettoyer_donnees(donnees_heure) # Fonction à définir dans fonction_nettoyage.R
  ),
  
  # Target pour l'exécution du script principal
  tar_target(
    name = resultat_final,
    command = script_principal(donnees_nettoyees) # Fonction à définir dans script principal.R
  ),
  
  # Targets pour les différentes tables
  tar_target(
    name = table1,
    command = generer_table_1(donnees_nettoyees) # Fonction à définir dans table_1.R
  ),
  
  tar_target(
    name = table2,
    command = generer_table_2(donnees_nettoyees) # Fonction à définir dans table_2.R
  ),
  
  tar_target(
    name = table3,
    command = generer_table_3(donnees_nettoyees) # Fonction à définir dans table_3.R
  ),
  
  tar_target(
    name = table4,
    command = generer_table_4(donnees_nettoyees) # Fonction à définir dans table_4.R
  )
)
