# Definition de la fonction pour creer le dataframe
espece <- function(tab1){
  data1 = data.frame(combined_data$ID_observation,combined_data$nom_sci,combined_data$abondance,combined_data$fraction)
  return(data1)
}
