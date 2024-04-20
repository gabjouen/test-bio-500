# BIO 500 - Atelier 1
# Main script pour le jeu de donnee de benthos
# Fait appel aux fonctions 


# 1. chemin vers les donn?es
Chem <- "combined_data.csv"

# Lecture de la table 1 - Espece
source ("table_1.R")
table <- espece(data1)
table

# Lecture de la table 2 - Date et heure de l'échantillonnage
source ("table_2.R")
tabl <- date(data2)
tabl

# Lecture de la table 3 - Caracteristiques physiques des stations d'echantillonnage 
source ("table_3.R")
tab <- site(data3)
tab

# Lecture de la table 4 - identification de l'échantillon
source ("table_4.R")
ta <- identification(data4)
ta

#On ne retrouve pas l'ensemble des variables de notre base de donnees car nous estimons qu'elles ne seront pas utilisables dans le futur (trop de NA's)

#classer les variables transparance en ordre 
source("fonction_nettoyage.R")
trans_data<-convert_transparence_eau(data_transpa)
trans_data

#suppression des colonnes ayant des valeurs NULL
source("") 

