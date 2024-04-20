#################### nettoyage de la base de donnees

install.packages("tidyverse")
library(tidyverse) # nous utilisons ce package car cela permet d'avoir une syntaxe coherente, une facilite d'utilisation et des puissantes capacites de manipulation de donnees


# Ici je veux que la variable de transparence de l'eau soit pris en compte comme un facteur et non un simple charactere (parce que ici il y a des niveaux!)
# On voulait classr la varibale transparence de l'eau puisque il s'agit d'une variable categorique et nous voulions que R comprenne la différence entre elever, moyen et faible 
unique(combined_data$transparence_eau)
combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
class(combined_data$transparence_eau) #pour vérifier si la transparence est bien de type facteur 
levels(combined_data$transparence_eau)



################ Fonction qui place la les valeurs (elever, moyenne et faible) en ordre de niveau

convert_transparence_eau <- function(transparence) {
  combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
  # Modification de la colonne transparence_eau
  data_transpa <- factor(combined_data$transparence_eau, levels = c("élevée", "moyenne", "faible"))
  # Retourner la base de données modifiée
  levels(combined_data$transparence_eau)
  
  return(data_transpa)
}
convert_transparence_eau(transparence)


####################### Donnees retenues et ajouts de colonnes (ID_observation et id_date)


donnee_retenue<-function(combined_data){
  combined_data <-  combined_data[, -c(13:30)]
  combined_data <-  combined_data[, -3]
  combined_data <-  combined_data[-c(1920:1947),]# nous avons enlever les observation d'un site car les valeurs étaient aberrantes comparer aux autres
  combined_data$ID_observation<- c(1:1978)
  
  combined_data<- combined_data %>%
    mutate(id_date=cumsum(date != lag(date, default = first(date))))
  
  combined_data$abondance_totale <- (combined_data$abondance*100/combined_data$fraction)# nous ajoutons cette colonne qui calcule l'abondance totale
  
  familles <- c(
    "Pericoma | Telmatoscopus"="Psychodidae",
    "Hydatophylax | Pycnopsyche"= "Limnephilidae",
    "Baetis" = "Ephemerellidae",
    "Ephemerella" = "Ephemerellidae",
    "Eurylophella" = "Ephemerellidae",
    "Epeorus" = "Heptageniidae",
    "Leucrocuta" = "Heptageniidae",
    "Leptophlebiidae" = "Leptophlebiidae",
    "Glossosoma" = "Glossosomatidae",
    "Hydropsychidae" = "Hydropsychidae",
    "Ceratopsyche" = "Hydropsychidae",
    "Hydropsyche" = "Hydropsychidae",
    "Lepidostoma" = "Lepidostomatidae",
    "Hydatophylax" = "Limnephilidae",
    "Pycnopsyche" = "Limnephilidae",
    "Dolophilodes" = "Philopotamidae",
    "Rhyacophila" = "Rhyacophilidae",
    "Paracapnia" = "Capniidae",
    "Sweltsa" = "Chloroperlidae",
    "Leuctra" = "Leuctridae",
    "Acroneuria" = "Perlidae",
    "Isoperla" = "Perlodidae",
    "Probezzia" = "Ceratopogonidae",
    "Ceratopogon" = "Ceratopogonidae",
    "Tanytarsini" = "Chironomidae",
    "Orthocladiinae" = "Chironomidae",
    "Pentaneurini" = "Chironomidae",
    "Hemerodromia" = "Empididae",
    "Simulium" = "Simuliidae",
    "Antocha" = "Limoniidae",
    "Dicranota" = "Pediciidae",
    "Hexatoma" = "Limoniidae",
    "Tipula" = "Tipulidae",
    "Promoresia" = "Empididae",
    "Boyeria" = "Aeshnidae",
    "Cordulegaster" = "Gomphidae",
    "Acari" = "Acari",
    "Pisidium" = "Sphaeriidae",
    "Maccaffertium" = "Heptageniidae",
    "Rhithrogena" = "Heptageniidae",
    "Cheumatopsyche" = "Hydropsychidae",
    "Ceraclea" = "Leptoceridae",
    "Limnephilidae" = "Limnephilidae",
    "Polycentropus" = "Polycentropodidae",
    "Taeniopteryx" = "Taeniopterygidae",
    "Atherix" = "Athericidae",
    "Chironomidae" = "Chironomidae",
    "Chironomini" = "Chironomidae",
    "Corduliidae" = "Corduliidae",
    "Gomphidae" = "Gomphidae",
    "Oligochaeta" = "Oligochaeta",
    "Isonychia" = "Isonychiidae",
    "Micrasema" = "Brachycentridae",
    "Goera" = "Goeridae",
    "Helicopsyche" = "Helicopsychidae",
    "Chimarra" = "Philopotamidae",
    "Paragnetina" = "Perlidae",
    "Optioservus" = "Elmidae",
    "Ophiogomphus" = "Gomphidae",
    "Sphaerium" = "Sphaeriidae",
    "Plauditus" = "Chironomidae",
    "Heptageniidae" = "Heptageniidae",
    "Neureclipsis" = "Polycentropodidae",
    "Alloperla" = "Chloroperlidae",
    "Neoplasta" = "Hydropsychidae",
    "Stenelmis" = "Elmidae",
    "Acerpenna" = "Baetidae",
    "Serratella" = "Ephemerellidae",
    "Hydroptila" = "Hydroptilidae",
    "Mystacides" = "Leptoceridae",
    "Pseudolimnophila" = "Limoniidae",
    "Trichoptera" = "Trichoptera",
    "Oecetis" = "Leptoceridae",
    "Pycnopsyche" = "Limnephilidae",
    "Neophylax" = "Uenoidae",
    "Strophopteryx" = "Limnephilidae",
    "Psephenus" = "Psephenidae",
    "Nigronia" = "Corydalidae",
    "Nemertea" = "Nemertea",
    "Tricorythodes" = "Leptohyphidae",
    "Oxyethira" = "Hydroptilidae",
    "Nectopsyche" = "Leptoceridae",
    "Setodes" = "Leptoceridae",
    "Ectopria" = "Elmidae",
    "Parapsyche" = "Hydropsychidae",
    "Prosimulium" = "Simuliidae",
    "Apatania" = "Apataniidae",
    "Paraleptophlebia" = "Leptophlebiidae",
    "Hydroptilidae" = "Hydroptilidae",
    "Leptoceridae" = "Leptoceridae",
    "Caenis" = "Caenidae",
    "Ephemera" = "Ephemeridae",
    "Protoptila" = "Glossosomatidae",
    "Stenacron" = "Heptageniidae",
    "Platyhelminthes" = "Platyhelminthes",
    "Helichus" = "Elmidae",
    "Stagnicola" = "Lymnaeidae",
    "Pericoma" = "Psychodidae",
    "Telmatoscopus" = "Psychodidae",
    "Gammarus" = "Gammaridae",
    "Mallochohelea" = "Ceratopogonidae",
    "Decapoda" = "Decapoda",
    "Leucotrichia" = "Hydroptilidae",
    "Diamesinae" = "Chironomidae",
    "Elmidae" = "Elmidae",
    "Ostracoda" = "Ostracoda",
    "Brachycentridae" = "Brachycentridae",
    "Perlodidae" = "Perlodidae",
    "Curculionidae" = "Curculionidae",
    "Hexagenia" = "Ephemeridae",
    "Chelifera" = "Empididae",
    "Lype" = "Psychomyiidae",
    "Procloeon" = "Baetidae",
    "Orconectes" = "Cambaridae",
    "Stenonema" = "Heptageniidae",
    "Neoperla" = "Perlidae",
    "Prodiamesinae" = "Chironomidae",
    "Chloroperlidae" = "Chloroperlidae",
    "Wiedemannia" = "Empididae",
    "Wormaldia" = "Hydropsychidae",
    "Ameletus" = "Ameletidae",
    "Aeshnidae" = "Aeshnidae",
    "Cloeon" = "Baetidae",
    "Limnophila" = "Limoniidae",
    "Drunella" = "Ephemerellidae",
    "Zapada" = "Heptageniidae",
    "Siphlonurus" = "Siphlonuridae",
    "Stactobiella" = "Elmidae",
    "Psychoglypha" = "Limnephilidae",
    "Simuliidae" = "Simuliidae",
    "Calopteryx" = "Calopterygidae",
    "Coenagrionidae" = "Coenagrionidae",
    "Argia" = "Coenagrionidae",
    "Brachycentrus" = "Brachycentridae",
    "Lanthus" = "Gomphidae",
    "Acentrella" = "Baetidae",
    "Hydatophylax" = "Limnephilidae",
    "Psychomyia" = "Psychomyiidae",
    "Bezzia | Palpomyia" = "Ceratopogonidae",
    "Hagenius" = "Gomphidae",
    "Crambidae" = "Crambidae",
    "Heterocloeon" = "Baetidae",
    "Agnetina" = "Perlidae",
    "Gomphus" = "Gomphidae",
    "Dentatella" = "Leptoceridae",
    "Macrostemum" = "Hydropsychidae",
    "Stylogomphus" = "Gomphidae",
    "Psilotreta" = "Odontoceridae",
    "Nematoda" = "Nematoda",
    "Chironominae" = "Chironomidae",
    "Baetisca" = "Baetiscidae",
    "Heptagenia" = "Heptageniidae",
    "Capniidae" = "Capniidae",
    "Perlidae" = "Perlidae",
    "Isogenoides" = "Perlidae",
    "Baetidae" = "Baetidae",
    "Polycentropodidae" = "Polycentropodidae",
    "Diplectrona" = "Hydropsychidae",
    "Nyctiophylax" = "Polycentropodidae",
    "Empididae" = "Empididae",
    "Haploperla" = "Chloroperlidae",
    "Veliidae" = "Veliidae",
    "Diphetor Hageni" = "Baetidae",
    "Ephemerellidae" = "Ephemerellidae",
    "Tanypodinae" = "Chironomidae",
    "Glossosomatidae" = "Glossosomatidae",
    "Roederiodes" = "Leptoceridae",
    "Physa" = "Physidae",
    "Caecidota" = "Caecidota",
    "Sialis" = "Sialidae",
    "Cambarus" = "Cambaridae",
    "Hirudinea" = "Hirudinida",
    "Philopotamidae" = "Philopotamidae",
    "Dubiraphia" = "Hydropsychidae",
    "Ferrissia" = "Planorbidae",
    "Agapetus" = "Glossosomatidae",
    "Pteronarcys" = "Pteronarcyidae",
    "Taeniopterygidae" = "Taeniopterygidae",
    "Blepharicera" = "Blephariceridae",
    "Oulimnius" = "Elmidae",
    "Arctopsyche" = "Hydropsychidae"
  )

  # Ajout d'une colonne 'Famille' au tableau, en utilisant le vecteur 'familles' pour la correspondance
  combined_data$famille <- familles[combined_data$nom_sci]
  
  
  return(combined_data)
}
combined_data<- donnee_retenue(combined_data)


################### ligne pour enlever les doublons

combined_data <-combined_data[!duplicated(combined_data),]



################### telechager la BD finale dans notre projet

telechargement <- function(combined_data){
  
  # Definition du chemin de fichier
  chemin_telechargement <- "C:/Users/gabin/OneDrive/Documents/School/session hiver 2024/Ecologie computionelle/projet/projet-gab-alex-just"

  # Nom du fichier CSV de sortie
  nom_fichier <- "combined_data.csv"

  # Chemin complet du fichier de sortie
  chemin_complet <- file.path(chemin_telechargement, nom_fichier)

  # Sauvegarde du tableau en tant que fichier CSV
  write.csv(combined_data, file = chemin_complet, row.names = FALSE)

  # Affichage d'un message indiquant que le fichier a pu etre enregistrer avec succes
  cat("Le fichier", nom_fichier, "a pu etre enregistrer sur votre projet.\n")

}

telechargement(combined_data)
