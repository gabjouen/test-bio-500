# Definition de la fonction pour creer le dataframe
identification <- function(tab4){
  data4 = data.frame(combined_data$date,combined_data$site,combined_data$ID_observation)
  return(data4)
}