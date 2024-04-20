#package nécessaire pour la fonction
install.packages("dplyr")
library(dplyr)

# fonction permettant de compiler les données et de sortir une database combinée 
combine_csv_files <- function(folder_path) {
  
  # Obtentir la liste des fichiers CSV dans le repertoire
  csv_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  
  # Verifier s'il y a des fichiers CSV dans le repertoire
  if (length(csv_files) == 0) {
    print("Aucun fichier CSV trouvé dans le répertoire.")
    return(NULL)
  } else {
    # Lire et combiner tous les fichiers CSV en une seule base de données
    combined_data <- bind_rows(lapply(csv_files, read.csv))
    
    # Retourner la base de données combinée
    return(combined_data)
  }
}

# Repertoire contenant les fichiers CSV
folder_path <- "C:/Users/gabin/OneDrive/Documents/School/session hiver 2024/Ecologie computionelle/benthos/benthos"
combined_data <- combine_csv_files(folder_path)
