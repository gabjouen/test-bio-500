# Definition de la fonction pour creer le dataframe
date <- function(tab2){
  data2 = data.frame(combined_data$date,combined_data$heure_obs,combined_data$id_date)
  return(data2)
}

