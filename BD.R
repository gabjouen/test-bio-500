##################ASSEMBLAGE, NETTOYAGE ET VALIDATION DE LA BD


install.packages("dplyr")
library(dplyr)

# Repertoire contenant les fichiers CSV
folder_path <- "C:/Users/ALEXIS/OneDrive/Bureau/Éco computationnelle/Atelier 1/benthos/benthos"

# Obtention de la liste des fichiers CSV dans le repertoire
csv_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Verification s'il y a des fichiers CSV dans le repertoire
if (length(csv_files) == 0) {
  print("Aucun fichier CSV trouver dans le repertoire.")
} else {
  # Lire et combiner tous les fichiers CSV en une seule base de donnees
  combined_data <- bind_rows(lapply(csv_files, read.csv))
  
  # Affichage de la base de donnees combinee
  print(combined_data)
}



#################### nettoyage de la base de donnees


install.packages("tidyverse")
library(tidyverse) # nous utilisons ce package car cela permet d'avoir une syntaxe coherente, une facilite d'utilisation et des puissantes capacites de manipulation de donnees
summary.data.frame(combined_data)
unique(combined_data$transparence_eau)


# Ici je veux que la variable de transparence de l'eau soit pris en compte comme un facteur et non un simple charactere (parce que ici il y a des niveaux!)
# On voulait classr la varibale transparence de l'eau puisque il s'agit d'une variable categorique et nous voulions que R comprenne la différence entre elever, moyen et faible 
combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
class(combined_data$transparence_eau)
levels(combined_data$transparence_eau)


#Fonction qui place la les valeurs (elever, moyenne et faible) en ordre de niveau
combined_data$transparence_eau <- factor((combined_data$transparence_eau), levels=c("élevée","moyenne","faible"))
levels(combined_data$transparence_eau)


#Cette ligne demontre que nous avons aucune duplication dans notre base de donnees!
combined_data <-combined_data[!duplicated(combined_data),]



####################Boucles qui seront peut-etre garder ultimement


#exemple de fonction qui remplacerais les NA retrouver par un autre terme pour ne pas perdre de la donnee
combined_data %>% 
  select("date","site","date_obs","heure_obs","fraction","nom_sci","abondance","largeur_riviere","profondeur_riviere","vitesse_courant","transparence_eau","temperature_eau_c","ETIQSTATION") %>% 
  filter(!complete.cases(.)) %>% 
  mutate(ETIQSTATION=replace_na(ETIQSTATION,"TERME D?TERMIN? PLUS TARD"))

#On retrouve aussi des NA dans la temperature d'eau, vitesse du courant, profondeur riviere, largueur riviere? Problemes sur le terrain lors de l'echantillonnage Va-t-on les prendrent en compte dans l'analyse?
#exemple de fonction permettant d'enlever tous les NA dans la variable specifier si jamais nous d?cidons de ne pas les garder finalement...
combined_data %>% 
  select("date","site","date_obs","heure_obs","fraction","nom_sci","abondance","largeur_riviere","profondeur_riviere","vitesse_courant","transparence_eau","temperature_eau_c","ETIQSTATION") %>% 
  filter(!complete.cases(.)) %>% 
  drop_na("variable du tableau sp?cifi?e")



####################### Donnees retenues

summary.data.frame(combined_data) 
combined_data <- combined_data[,-(13:30)]
combined_data <- combined_data[,-(3)]
combined_data$ID_observation<- c(1:2006) #ajout d'une colonne pour avoir une valeur unique pour chaque observation

combined_data<- combined_data %>%
  mutate(id_date=cumsum(date != lag(date, default = first(date)))) #ajout colonne id_date pour chaque dates differentes
  


################ Uniformiser le format de la date

# Convertir la colonne "heure_obs" en format hh:mm:ss
# Fonction pour convertir le format xxhmm.ss en hh:mm:ss

convertir_heure <- function(heure) {
  # Extraire les heures, les minutes et les secondes
  
  heures <- substr(heure, 1, 2)
  minutes <- substr(heure, 4, 5)
  secondes <- sprintf("%.0f", as.numeric(substr(heure, 7, 9)) * 60)
  
  # Assembler les composantes en format hh:mm:ss
  heure_convertie <- paste(heures, minutes, secondes, sep = ":")
  
  return(heure_convertie)
  
}


# Appliquer la fonction de conversion à la colonne "heure_obs"
combined_data$heure_obs <- sapply(combined_data$heure_obs, convertir_heure)
# Afficher les premières lignes du tableau pour vérifier
head(combined_data)


###################### ENREGISTRER LA BD COMPLETE EN FORMAT CSV

# Definition du chemin de fichier
chemin_telechargement <- "C:/Users/ALEXIS/OneDrive/Bureau/Atelier2_ AlexisGabJust/projet-gab-alex-just"

# Nom du fichier CSV de sortie
nom_fichier <- "combined_data.csv"

# Chemin complet du fichier de sortie
chemin_complet <- file.path(chemin_telechargement, nom_fichier)

# Sauvegarde du tableau en tant que fichier CSV
write.csv(combined_data, file = chemin_complet, row.names = FALSE)

# Affichage d'un message indiquant que le fichier a pu etre enregistrer avec succes
cat("Le fichier", nom_fichier, "a pu etre enregistrer sur votre projet.\n")


