############## ANALYSE DES DONNÉES ET CRÉATION DE GRAPHIQUES

library(ggplot2)

# Abondance en fonction de la largeur de la rivière (histogramme de points - visualisation mauvaise)

ggplot(donnees1, aes(x = largeur_riviere, y = abondance, color = nom_sci)) +
  geom_point() +
  labs(title = "Abondance du benthos en fonction de la largeur de la rivière",
       x = "Largeur de la rivière (m)",
       y = "Abondance") +
       theme_minimal() +
         theme(legend.position = "none")



# RÉGRESSION LINÉAIRE

# CRÉATION DE LA FIGURE - largeur

donnees2$largeur_riviere <- log(donnees2$largeur_riviere)
donnees2$abondance_totale <- log(donnees2$abondance_totale)
modele_log_larg <- lm(donnees2$largeur_riviere ~ donnees2$abondance_totale, data = donnees2)

#CALCUL R2

r2 <- summary(modele_log_larg)$r.squared

ggplot(donnees2, aes(x = donnees2$largeur_riviere, y = donnees2$abondance_totale)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Régression linéaire (log) entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Largeur de la rivière (m)",
       y = "Abondance totale en benthos") +
  theme_minimal()


# CRÉATION DE LA FIGURE - profondeur

abondance_totale_log <- log(donnees3$abondance_totale)

modele_log_prof <- lm(donnees3$profondeur_riviere ~ abondance_totale_log, data = donnees3)

r2_prof <- summary(modele_log_prof)$r.squared

ggplot(donnees3, aes(x = donnees3$profondeur_riviere, y = abondance_totale_log)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "orange") +
  labs(title = "Régression linéaire entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Profondeur de la rivière (m)",
       y = "Abondance totale en benthos (log)") +
  theme_minimal()


# CRÉATION DE LA FIGURE - vitesse du courant

abondance_totale_log <- log(donnees4$abondance_totale)

modele_log_vit <- lm(donnees4$vitesse_courant ~ abondance_totale_log, data = donnees4)

r2_vit <- summary(modele_log_vit)$r.squared

ggplot(donnees4, aes(x = donnees4$vitesse_courant, y = abondance_totale_log)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "green") +
  labs(title = "Régression linéaire entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Vitesse du courant (m/s)",
       y = "Abondance totale en benthos (log)") +
  theme_minimal()


###########

donnees5<- na.omit(donnees5)

# Créer le modèle de régression linéaire
model5 <- lm(famille ~ temperature_eau_c, data = donnees5)

# Résumé du modèle
summary(model5)

# Créer un graphique de la régression
ggplot(donnees5, aes(x = temperature_eau_c, y = famille)) +
  geom_point() +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Régression linéaire de la Famille en fonction de la Température de l'eau",
       x = "Température de l'eau (°C)",
       y = "Famille")





# CRÉATION DE LA FIGURE - temperature eau

modele_log_temp <- lm(donnees6$temperature_eau_c ~ donnees6$abondance_totale, data = donnees6)

#CALCUL R2

r2 <- summary(modele_log_temp)$r.squared

ggplot(donnees6, aes(x = donnees6$temperature_eau_c, y = donnees6$abondance_totale)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Régression linéaire (log) entre la température de l'eau et l'abondance totale en benthos",
       x = "Température de l'eau",
       y = "Abondance totale en benthos") +
  theme_minimal()


#########

install.packages("GGally")
library(GGally)

# S'assurer que les données sont numériques et qu'il n'y a pas de NA
donnees7 <- na.omit(donnees7)
donnees7$largeur_riviere <- as.numeric(donnees7$largeur_riviere)
donnees7$profondeur_riviere <- as.numeric(donnees7$profondeur_riviere)
donnees7$vitesse_courant <- as.numeric(donnees7$vitesse_courant)
donnees7$temperature_eau_c <- as.numeric(donnees7$temperature_eau_c)
donnees7$abondance_totale <- as.numeric(donnees7$abondance_totale)

# Créer la matrice de corrélation avec GGally

# Définir la fonction personnalisée pour ggpairs
custom_fn <- function(data, mapping, ...){
  ggplot(data = data, mapping = mapping) +
    geom_point(color = "blue", size = 1, ...) +
    geom_smooth(method = "lm", color = "red", ...)
}

# Créer la matrice de corrélation avec GGally, incluant des points et des lignes de tendance
ggpairs(donnees7, 
        upper = list(continuous = wrap("cor", size = 4)),
        lower = list(continuous = custom_fn),
        diag = list(continuous = wrap("densityDiag", size = 0.5))
)

###########

donnees8 <- na.omit(donnees8)

# Calculer les moyennes par famille
donnees8_agg <- donnees8 %>%
  group_by(famille) %>%
  summarise(vitesse_moyenne = mean(vitesse_courant, na.rm = TRUE),
            temp_moyenne = mean(temperature_eau_c, na.rm = TRUE))

# Réaliser la régression linéaire multiple
model8 <- lm(vitesse_moyenne ~ temp_moyenne, data = donnees8_agg)

# Afficher le résumé du modèle
summary(model8)

ggplot(donnees8_agg, aes(x = temp_moyenne, y = vitesse_moyenne, color = famille)) +
  geom_point() +  # Utiliser des points de couleur variable selon 'famille'
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Régression linéaire de la Vitesse Moyenne en fonction de la Température Moyenne",
       x = "Température Moyenne de l'Eau (°C)",
       y = "Vitesse Moyenne du Courant (m/s)",
       color = "Famille") +  # Modifier ici pour définir le titre de la légende
  scale_color_manual(values = rainbow(n = length(unique(donnees8_agg$famille)))) +  # Assigner une couleur unique par famille
  theme_minimal() +  # Utiliser un thème minimal pour une meilleure visualisation
  theme(legend.title = element_text(size = 12))  # Modifier la taille du texte de la légende
