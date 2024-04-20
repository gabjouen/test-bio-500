################ Uniformiser le format de heure_obs

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













