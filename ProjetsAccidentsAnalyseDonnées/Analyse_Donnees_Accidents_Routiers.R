# effacer les objets de l'environnement
rm(list = ls())


# bibliotheques
library("tidyverse")
library('stringr')
library('kableExtra')
library("lubridate")
library("ggplot2")
library("questionr")
library("FactoMineR")
library("factoextra")

########## MISE EN PLACE DE LA BASE

### Chargement de l'emplacement
# pour Valentine: 
setwd("~/Documents/M2_SEP/SEMESTRE_1/Analyse_Donnees/ProjetFinal/data")
# pour Adrien :
setwd("~/AnalyseDonnees")


### Import des données et choix des variables
carac <- read.csv2(file="caracteristiques-2019.csv")
var_carac <- c("Num_Acc","jour","mois","hrmn","lum","dep","com","agg","int","atm","col")
carac <- carac[,var_carac]
str(carac)

usagers <- read.csv2(file="usagers-2019.csv")
var_usagers <- c("Num_Acc","id_vehicule","catu","place", "grav","sexe","an_nais","trajet")
usagers <- usagers[,var_usagers]
str(usagers)


## Jointure des jeux de données
victime <- inner_join(carac, usagers, by ="Num_Acc")

victime$date <- paste(victime$jour, victime$mois,"2019", sep = "/")
victime$date <- as.Date(victime$date,format="%d/%m/%Y")
victime <- victime[,-c(2,3)]
victime <- relocate(victime, "date", .after = "Num_Acc")

str(victime)

# Changement du type des variables + Ajout label
victime$Num_Acc <- as.character(victime$Num_Acc)

victime$lum <- factor(victime$lum, labels = c("Plein jour", "Crépuscule ou aube",
                                              "Nuit sans éclairage public",
                                              "Nuit avec éclairage public non allumé",
                                              "Nuit avec éclairage public allumé"))

victime$agg <- factor(victime$agg, labels = c("Hors agglomération", "En agglomération"))


victime$int <- factor(victime$int, labels = c("Hors intersection",  
                                              "Intersection en X", 
                                              "Intersection en T",  
                                              "Intersection en Y",  
                                              "Intersection à plus de 4 branches",  
                                              "Giratoire",  
                                              "Place",
                                              "Passage à niveau", 
                                              "Autre intersection"))


victime$atm <- factor(victime$atm, labels = c("Non renseigné" , 
                                              "Normale" , 
                                              "Pluie légère",  
                                              "Pluie forte",  
                                              "Neige - Grêle",  
                                              "Brouillard - Fumée",  
                                              "Vent fort - Tempête",  
                                              "Temps éblouissant",  
                                              "Temps couvert",  
                                              "Autre"))
v <- which(victime$atm == "Non renseigné")
victime <- victime[-v,]

victime$col <- factor(victime$col, labels = c("Non renseigné",
                                              "Deux véhicules - frontale",  
                                              "Deux véhicules - par l'arrière",  
                                              "Deux véhicules - par le côté",
                                              "Trois véhicules et plus - en chaîne",
                                              "Trois véhicules et plus - collisions multiples",
                                              "Autre collision",
                                              "Sans collision"))
v <- which(victime$col == "Non renseigné")
victime <- victime[-v,]

victime$catu <- factor(victime$catu, labels = c("Conducteur",  
                                                "Passager",
                                                "Piéton"))

victime$grav <- factor(victime$grav, labels = c("Indemne",  
                                                "Tué",  
                                                "Blessé hospitalisé",  
                                                "Blessé léger" ))

victime$sexe <- factor(victime$sexe, labels = c("Masculin",  
                                                "Féminin" ))

victime$trajet <- factor(victime$trajet, labels = c("Autre",   
                                                    "Autre",  
                                                    "Domicile – travail",  
                                                    "Domicile – école", 
                                                    "Courses – achats",  
                                                    "Utilisation professionnelle",  
                                                    "Promenade – loisirs",  
                                                    "Autre" ))

victime$place <- factor(victime$place, labels = c("Conducteur",
                                                  "Passager Avant",
                                                  "Passager",
                                                  "Passager",
                                                  "Passager",
                                                  "Passager Avant",
                                                  "Passager",
                                                  "Passager",
                                                  "Passager",
                                                  "Piéton"))

# Ajout d'une variable correspondant au nombre de véhicules impliqués dans 
# l'accident
victime %>%
  group_by(Num_Acc)%>%
  summarize(nb_veh=n_distinct(id_vehicule)) -> data
  
victime <- inner_join(victime, data, by = "Num_Acc")

# Ajout d'une variable correspondant au nombre de personnes impliquées dans 
# l'accident
data <- as.data.frame(table(victime$Num_Acc))
colnames(data) <- c("Num_Acc", "nb_ind")

victime <- inner_join(victime, data, by = "Num_Acc")


# Ajout d'une variable correspondant à l'âge des individus
victime$age <- 2019 - victime$an_nais
# Suppression de la variable an_nais
victime$an_nais <- NULL

str(victime)
summary(victime)

## Valeurs manquantes et aberrantes
# On cherche les valeurs manquantes
sapply(victime, function(x) sum(is.na(x)))
# Aucune valeur manquante

# On cherche les valeurs aberrantes
table(victime$age, victime$catu)
# On remarque un problème au niveau de l'âge des conducteurs  
# + bcp trop de personnes de plus de 100ans

# On "autorise" des conducteurs de plus de 16 ans et les personnes de moins de 100 ans
cond_min <- which((victime$age < 16) & (victime$catu == "Conducteur"))
length(cond_min)

vieux <- which((victime$age > 100))
length(vieux)

victime <- victime[-c(cond_min,vieux),]
table(victime$age, victime$catu)

str(victime)

# calendrier avec gradient de couleurs: on dégage tout ce qui est inutile, on garde date et nombre d'accidents distincts par date
# ensuite on travaille les dates avec Lubridate, puis ggplot bien entendu

victime %>%
  group_by(date)%>%
  summarize(nb_accidents=n_distinct(Num_Acc))%>%
  mutate(nom_jour=wday(date,label=TRUE,week_start=1,abbr=FALSE,locale=Sys.getlocale("LC_TIME")),
         num_jour_mois=day(date),
         nom_mois=month(date,label=TRUE,abbr=FALSE,locale=Sys.getlocale("LC_TIME")),
         num_semaine_an=isoweek(date))%>%
  group_by(nom_mois)%>%
  mutate(num_semaine_mois=case_when(nom_mois=="décembre" & num_semaine_an==1~6,
                                    nom_mois=="décembre" & num_semaine_an!=1~num_semaine_an-48+1, # parce que les 2 derniers jours de décembre posent souci
                                    TRUE~num_semaine_an-min(num_semaine_an)+1)
                                    
         )->calend

    
ggplot(calend,mapping=aes(x=num_semaine_mois,y=fct_rev(nom_jour),fill = nb_accidents))+
  geom_tile()+
  facet_wrap(facets="nom_mois",ncol=3,scales = "free")+
  scale_fill_gradient(low="green",high="red")+
  geom_text(mapping = aes(label = num_jour_mois))+
  labs(x="",y="")+
  theme_bw()


# statistiques par jour
calend%>%
  group_by(nom_jour)%>%
  summarize(total=sum(nb_accidents))%>%
  arrange(total)->tot_jour

# Moyenne du nombre d'accidents par jour
mean(tot_jour$total)

# Barplot non ordonné
ggplot(tot_jour, aes(x = nom_jour, y = total)) + 
  geom_bar(stat = "identity", color = "#0072B2", fill = "#0072B2") +
  ylab("Effectif") +
  scale_x_discrete("Jour") +
  geom_text(aes(label=total), vjust = 1.5, size=4, color = "white" ) +
  ggtitle("Nombre total d'accidents par jour en 2019")

# Barplot ordonné
ggplot(tot_jour, aes(x = reorder(nom_jour, total), y = total)) + 
  geom_bar(stat = "identity", color = "#0072B2", fill = "#0072B2") +
  ylab("Effectif") +
  scale_x_discrete("Jour") +
  geom_text(aes(label=total), vjust = 1.5, size=4, color = "white" ) +
  ggtitle("Nombre total d'accidents par jour en 2019")

#confirmation pour le vendredi et le dimanche....as expected

# statistiques par mois
calend%>%
  group_by(nom_mois)%>%
  summarize(total=sum(nb_accidents))%>%
  arrange(total)->tot_mois

# Moyenne du nombre d'accident par mois
mean(tot_mois$total)

# Barplot non ordonné
ggplot(tot_mois, aes(x = nom_mois, y = total)) + 
  geom_bar(stat = "identity", color = "#0072B2", fill = "#0072B2") +
  ylab("Effectif") +
  scale_x_discrete("Mois") +
  geom_text(aes(label=total), vjust = 1.5, size=4, color = "white" ) +
  ggtitle("Nombre total d'accidents par mois en 2019")

# Barplot ordonné
ggplot(tot_mois, aes(x = reorder(nom_mois, total), y = total)) + 
  geom_bar(stat = "identity", color = "#0072B2", fill = "#0072B2") +
  ylab("Effectif") +
  scale_x_discrete("Mois") +
  geom_text(aes(label=total), vjust = 1.5, size=4, color = "white" ) +
  ggtitle("Nombre total d'accidents par mois en 2019")



### Quelques statistiques descriptives
# Gravité de l'accident
tab_grav <- table(victime$grav)
tab_grav

# Place de l'usager
tab_place <- table(victime$place)
tab_place
# La place 10 correspond aux piétons, 1 aux conducteurs et 2 à la "place du mort"

tab_grav_place <- table(victime$place, victime$grav)
tab_grav_place

# Effectifs des variables
ggplot(victime, aes(x = grav, fill = place)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") + 
  scale_x_discrete("Gravité") +  guides(fill = guide_legend(title = "Place de l'usager")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par gravité")

ggplot(victime, aes(x = place, fill = grav)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") +
  scale_x_discrete("Place de l'usager") +  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par place")


# Profils lignes, pour comparer les modalités de la gravité
profil_ligne_grav_place <- lprop(tab_grav_place, digits = 0, percent = TRUE)
profil_ligne_grav_place

ggplot(victime, aes(x = place, fill = grav))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..],
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Place de l'usager") +  
  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils lignes, regroupement par place")


# Profils colonnes, pour comparer les modalités de la catégorie d'usagers
profil_colonne_grav_place <- cprop(tab_grav_place, digits = 0, percent = TRUE)
profil_colonne_grav_place

ggplot(victime, aes(x = grav, fill = place))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..], 
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Gravité") +  
  guides(fill = guide_legend(title = "Place de l'usager")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils colonnes, regroupement par gravité")


# Trajet effectué
tab_trajet <- table(victime$trajet)
tab_trajet

# Tableau de contingence, Gravité de l'accident vs trajet effectué
tab_grav_trajet<- table(victime$trajet, victime$grav)
tab_grav_trajet

ggplot(victime, aes(x = grav, fill = trajet)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") + 
  scale_x_discrete("Gravité") +  guides(fill = guide_legend(title = "Trajet")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par gravité")

ggplot(victime, aes(x = trajet, fill = grav)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") +
  scale_x_discrete("Trajet") +  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par type de trajet")



# Profils lignes, pour comparer les modalités de la gravité
profil_ligne_grav_trajet <- lprop(tab_grav_trajet, digits = 0, percent = TRUE)
profil_ligne_grav_trajet

ggplot(victime, aes(x = trajet, fill = grav))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..],
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Type de trajet") +  
  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils lignes, regroupement par type de trajet")


# Profils colonnes, pour comparer les modalités du trajet
profil_colonne_grav_trajet <- cprop(tab_grav_trajet, digits = 0, percent = TRUE)
profil_colonne_grav_trajet

ggplot(victime, aes(x = grav, fill = trajet))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..], 
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Gravité") +  
  guides(fill = guide_legend(title = "Type de trajet")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils colonnes, regroupement par gravité")

# Conditions atmosphériques
tab_atm<-table(victime$atm)
tab_atm

tab_grav_atm <-table(victime$grav, victime$atm)
tab_grav_atm

# Effectifs des variables
ggplot(victime, aes(x = grav, fill = atm)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") + 
  scale_x_discrete("Gravité") +  guides(fill = guide_legend(title = "Conditions atmosphériques")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par gravité")

ggplot(victime, aes(x = atm, fill = grav)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") +
  scale_x_discrete("Conditions atmosphériques") +  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par type de condition atmosphérique")



# Profils lignes, pour comparer les modalités de la gravité
profil_ligne_grav_atm <- lprop(tab_grav_atm, digits = 0, percent = TRUE)
profil_ligne_grav_atm

ggplot(victime, aes(x = atm, fill = grav))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..],
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Condition atmosphérique") +  
  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils lignes, regroupement par condition atmosphérique")



# Profils colonnes, pour comparer les modalités de la condition atmosphérique
cond_meteo <- which(victime$atm %in%c("Neige - Grêle","Brouillard - Fumée","Vent fort - Tempête"))


profil_colonne_grav_atm <- cprop(tab_grav_atm, digits = 0, percent = TRUE)
profil_colonne_grav_atm

ggplot(victime[-cond_meteo,], aes(x = grav, fill = atm))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..], 
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Gravité") +  
  guides(fill = guide_legend(title = "Condition atmosphérique")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils colonnes, regroupement par gravité")


# Luminosité
tab_lum <-table(victime$lum)
tab_lum

tab_grav_lum <-table(victime$grav, victime$lum)
tab_grav_lum

# Effectifs des variables
ggplot(victime, aes(x = grav, fill = lum)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") + 
  scale_x_discrete("Gravité") +  guides(fill = guide_legend(title = "Luminosité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par gravité")

ggplot(victime, aes(x = lum, fill = grav)) + 
  geom_bar(stat="count", position = "dodge") + ylab("Effectif") +
  scale_x_discrete("Luminosité") +  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Effectifs des usagers, \nregroupement par type de luminosité")



# Profils lignes, pour comparer les modalités de la gravité
profil_ligne_grav_lum <- lprop(tab_grav_lum, digits = 0, percent = TRUE)
profil_ligne_grav_lum

ggplot(victime, aes(x = lum, fill = grav))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..],
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Luminosité") +  
  guides(fill = guide_legend(title = "Gravité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils lignes, regroupement par luminosité")



# Profils colonnes, pour comparer les modalités de la luminosité

profil_colonne_grav_lum <- cprop(tab_grav_lum, digits = 0, percent = TRUE)
profil_colonne_grav_lum

ggplot(victime, aes(x = grav, fill = lum))+
  geom_bar(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..]), position="dodge" ) +
  geom_text(aes( y=..count../tapply(..count.., ..x.. ,sum)[..x..], 
                 label=scales::percent(round(..count../tapply(..count.., ..x.. ,sum)[..x..], 2))),
            stat="count", position=position_dodge(0.9), vjust=-0.5, size = 3)+
  ylab('Pourcentage, %') +
  scale_y_continuous(labels = scales::percent) +
  scale_x_discrete("Gravité") +  
  guides(fill = guide_legend(title = "Luminosité")) + 
  theme(legend.position="right", plot.title = element_text(face = "bold")) +
  ggtitle("Graphiques à bâtons sur les profils colonnes, regroupement par gravité")

# ACM


dtf<-victime[,c(4,7:10,13:16)]  # on garde lum,agg,int,atm,col,place,grav,sexe,trajet
# on enleve catu qui fait doublon avec place en étant moins précis


res.acm<-MCA(dtf,graph=TRUE,quali.sup=7)  # on retrouve une structure de trèfle à 4 feuilles 
fviz_eig(res.acm)

fviz_mca_ind(res.acm,habillage=1,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=2,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=3,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=4,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=5,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=6,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=7,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=8,geom.ind=c("point"))
fviz_mca_ind(res.acm,habillage=9,geom.ind=c("point"))

fviz_mca_ind(res.acm,axes=c(2,3),habillage=1,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=2,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=3,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=4,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=5,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=6,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=7,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=8,geom.ind=c("point"))
fviz_mca_ind(res.acm,axes=c(2,3),habillage=9,geom.ind=c("point"))

round(res.acm$var$coord,digits=2)
round(res.acm$var$contrib,digits=2)
round(res.acm$var$eta2,digits=2)
round(res.acm$var$cos2,digits=2)


# on voit ce qui se passe sur l'axe 1 (les coloriages le montrent,les eta2 confirment et
# et si on regarde finement les modalités aussi): il est clairement déterminé par agg surtout
# et par lum et int...seul souci pour interpréter: lum et agg sont sans doute un peu liées
# l'axe 2 c'est surtout collision+Place
# gravité et atm influencent peu voire pas du tout sur les 3 premières dim....
# la météo la 5ème!! ce qui m'étonne bcp mais bref...on retrouve ce qu'on a pu dire à l'oral
# avec Morgan Cousin

# Après vérif, mettre la gravité en coloration n'apporte qu'une amélioration minime
# mais réelle (dans la forme du nuage de pts, l'inertie expliquée etc)
# faut voir si on reste tel quel ou si on couple à une deuxième variable supplémentaire
# genre atm et grav par exemple...et suivant notre choix, on commencera à raconter du concret
# à partir de nos coloriages du début, des tableaux et des graphes de variables que je mets ici
# (on peut faire avec les biplots mais bon peu lisible)

fviz_mca_biplot( axes = c(1, 2),geom.ind="point",geom.var = c("point", "text")

fviz_mca_biplot( axes = c(2, 3),geom.ind="point",geom.var = c("point", "text")

# N.B. je ne suis absolument pas chaud du tout pour faire une 2ème puis une 3ème ACM vu le nombre
# d'individus concernés. D'autant que la séparation en trèfle se voit bien, notamment quand
# on prend des qualis sup... ce serait ptêtre bien de s'arrêter là et d'interpréter uniquement
# dim1 dim2 dim3 en ne prenant que les variables et les modaltiés les plus fortes sur ces axes?

#write.csv(victime,"victime1.csv")

# library(openxlsx)
# write.xlsx(victime,"victime1.xlsx",overwrite=TRUE)
`%!in%' <- negate(`%in%`)

type2<-which(dtf$lum %in% c("Nuit sans éclairage public","Nuit avec éclairage public non allumé","Crépuscule ou aube") &
             dtf$agg=="Hors agglomération" &
             dtf$col %in% c("Autre collision","Sans collision")&(
             dtf$atm %in% c("Normale","Vent fort - Tempête","Pluie forte","Brouillard - Fumée","Neige - Grêle")|
             dtf$int %in% c("Aucune","Passage à niveau")|
             dtf$trajet  %!in% c("Utilisation professionnelle","Domicile – travail")) 
)
type4<-which(  dtf$agg=="Hors agglomération" &
                 dtf$lum %in% c("Plein jour","Nuit avec éclairage public allumé")&
                 dtf$int %in% c("Hors intersection")&
                 dtf$col %!in% c("Autre collision","Sans collision")
)


type3<-which(  dtf$agg=="En agglomération" &
               dtf$int %!in% c("Place","Giratoire","Autre")&
               dtf$lum %in% c("Plein jour","Nuit avec éclairage public allumé") &
               dtf$atm %in% c("Normale","Pluie légère","Temps couvert","Temps éblouissant")&
               dtf$place %in% c("conducteur","Passager","Passager Avant","Piéton")&
               dtf$grav %in% c("Indemne","Blessé léger")&
               dtf$trajet  %!in% c("Utilisation professionnelle","Domicile – travail")

)

type1<-which(  dtf$agg=="En agglomération" &
               dtf$int %in% c("Place","Giratoire")&
               dtf$col %in% c("Autre collision","Sans collision")&
               dtf$lum %in% c("Plein jour","Nuit avec éclairage public allumé") &
               dtf$atm %in% c("Normale","Pluie légère","Temps couvert","Temps éblouissant")&(
                   
               dtf$grav %in% c("Indemne","Blessé léger")|
               dtf$trajet  %!in% c("Utilisation professionnelle","Domicile – travail") 
               ))


round(100*(length(type1)+length(type2)+length(type3)+length(type4))/nrow(dtf),digits=2)

victime<-cbind(victime,rep("0",131727))
names(victime)[names(victime) == 'rep("0", 131727)'] <- 'type'

victime$type[type1]<-"1"
victime$type[type2]<-"2"
victime$type[type3]<-"3"
victime$type[type4]<-"4"

write.csv(victime,"victime1.csv")

