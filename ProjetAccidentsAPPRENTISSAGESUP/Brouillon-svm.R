# effacer les objets de l'environnement
rm(list = ls())

# bibliotheques
library('dplyr')
library('stringr')
library('kableExtra')
library('e1071') #Pour SVM

########## MISE EN PLACE DE LA BASE

### Chargement de l'emplacement
setwd("C:/Users/lilid/OneDrive/Bureau/MASTER 2 SEP/S1/Conférences, Business Intelligence, SAS et VBA (Coeff 4)/M COUSIN/Suivi projet Apprentissage stat")

### Import des données
carac <- read.csv2(file="caracteristiques-2019.csv")
lieux <- read.csv2(file="lieux-2019.csv")
usagers <- read.csv2(file="usagers-2019.csv")
vehic <- read.csv2(file="vehicules-2019.csv")

# On garde les variables utiles
var_carac <- c("Num_Acc","jour","mois","hrmn","lum","com","agg","int","atm","col")
carac <- carac[,var_carac]

var_lieux <- c("Num_Acc","catr","circ","nbv","vosp","prof",
               "plan","surf","infra","situ","vma")
lieux <- lieux[,var_lieux]

var_vehic <- c("Num_Acc", "id_vehicule","catv","obs","obsm","manv","motor")
vehic <- vehic[,var_vehic]

var_usagers <- c("Num_Acc","id_vehicule", "catu","grav",
                 "sexe","an_nais","trajet")
usagers <- usagers[,var_usagers]



### Formatage des données

## Base caracteristiques
# numero accident
carac$Num_Acc <- as.factor(carac$Num_Acc)
lieux$Num_Acc <- as.factor(lieux$Num_Acc)
vehic$Num_Acc <- as.factor(vehic$Num_Acc)
usagers$Num_Acc <- as.factor(usagers$Num_Acc)
# date
carac$date <- paste(carac$jour,carac$mois,"2019",sep="/")
carac$date <- as.Date(carac$date,format="%d/%m/%Y")
carac <- carac[,-c(2,3)]
carac <- relocate(carac,"date",.after="Num_Acc")
# heure 
carac$hrmn <- as.factor(carac$hrmn)
# lumiere
carac$lum <- as.factor(carac$lum)
levels(carac$lum) <- c("Plein Jour","Crépuscule ou aube","Nuit sans éclairage public"," Nuit avec éclairage public non allumé ","Nuit avec éclairage public allumé")

# commune
carac$com <- as.factor(carac$com)
# agglomeration
carac$agg <- as.factor(carac$agg)
levels(carac$agg) <- c("Hors agglomération","En agglomération")

# intersection
carac$int <- as.factor(carac$int)
levels(carac$int) <- c("Hors intersection","Intersection en X","Intersection en T",
                       " Intersection en Y ","Intersection à plus de 4 branches ","Giratoire ",
                       " Place ","Passage à niveau"," Autre intersection ")

# météo
carac$atm <- as.factor(carac$atm)
levels(carac$atm) <- c("Non renseigné","Normale","Pluie légère","Pluie forte","Neige-grêle","Brouillard-fumée",
                       "Vent fort-tempête", "Temps éblouissant", "Temps couvert", "Autre")

# type de collision
carac$col <- as.factor(carac$col)
levels(carac$col) <- c("Non renseigné", "Deux véhicules-frontale","Deux véhicules-par l'arrière","Deux véhicules-par le côté",
                       "Trois véhicules et plus-en chaîne", "Trois véhicules et plus-collisions multiples","Autre collision","Sans collision")

## Base lieux
# categorie de route
lieux$catr <- as.factor(lieux$catr)
levels(lieux$catr) <- c("Autoroute","Route nationale","Route départementale","Voie communale","Hors réseau public","Parc de stationnement ouvert à la circulation publique",
                        "Routes de métropole urbaine","autre")

# regime de circulation
lieux$circ <- as.factor(lieux$circ)
levels(lieux$circ) <- c("Non renseigné","A sens unique","Bidirectionnelle","A chaussées séparées","Avec voies d'affectation variable")

# voie reservée
lieux$vosp <- as.factor(lieux$vosp)
levels(lieux$vosp) <- c("Non renseigné","Sans objet","Piste cyclable","Bande cyclable","Voie réservée")

# déclivité
lieux$prof <- as.factor(lieux$prof)
levels(lieux$prof) <- c("Non renseigné","Plat", "Pente","Sommet de côte","Bas de côte")

# virage
lieux$plan <- as.factor(lieux$plan)
levels(lieux$plan) <- c("Non renseigné","Partie rectiligne","En courbe à gauche","En courbe à droite","En S")

# etat de la surface
lieux$surf <- as.factor(lieux$surf)
levels(lieux$surf) <- c("Non renseigné","Normale","Mouillée","Flaques","Inondée","Enneigée","Boue","Verglacée","Corps gras-huile",
                        "Autre")

# infrastructures
lieux$infra <- as.factor(lieux$infra)
levels(lieux$infra) <- c("Non renseigné","Aucun","Souterrain-tunnel","Pont-autopont","Bretelle d'échangeur ou de raccordement","Voie ferrée","Carrefour amménagé",
                         "Zone piétonne", "Zone de péage", "Chantier","Autres")

# situation de l'accident
lieux$situ <- as.factor(lieux$situ)
levels(lieux$situ) <- c("Non renseigné","Aucun","Sur chaussée","Sur bande d'arrêt d'urgence","Sur accotement","Sur trottoir","Sur piste cyclable","Sur autre voie spéciale","Autres")

## Base véhicules
# id vehicule
vehic$id_vehicule <- as.factor(vehic$id_vehicule)
# catégorie du véhicule
vehic$catv <- as.factor(vehic$catv)
levels(vehic$catv) <- c("Indéterminable","Bicyclette","Cyclomoteur<50cm3","Voiturette",
                        "VL Seul",
                        "VU seul 1,5T <= PTAC <= 3,5T avec ou sans remorque",
                        "PL seul 3,5T <PTCA <= 7,5T"," PL seul > 7,5T",
                        " PL > 3,5T + remorque",
                        "Tracteur routier seul","Tracteur routier + semi-remorque ",
                        "Engin spécial","Tracteur agricole",
                        "Scooter < 50 cm3 ","- Motocyclette > 50 cm3 et <= 125 cm3",
                        " Scooter > 50 cm3 et <= 125 cm3 ","Motocyclette > 125 cm3 ",
                        "Scooter > 125 cm3 ",
                        " Quad léger <= 50 cm3 ","- Quad lourd > 50 cm3","Autobus",
                        "Autocar","Train","Tramway","3RM <= 50 cm3 ","3RM > 50 cm3 <= 125 cm3",
                        " 3RM > 125 cm3 ","EDP à moteur","EDP sans moteur",
                        "VAE","Autre véhicule")
# obstacle fixe heurté
vehic$obs <- as.factor(vehic$obs)
levels(vehic$obs) <- c("Non renseigné","Sans objet","Véhicule en stationnement","Arbre","Glissière métallique","Glissière béton",
                       "Autre glissière","Bâtiment, mur, pile de pont"," Support de signalisation verticale ou poste d'appel d'urgence",
                       "Poteau","Mobilier urbain","Parapet","Ilot,refuge,borne haute","Bordure de trottoir","Fossé, talus, paroi rocheuse"," Autre obstacle fixe sur chaussée",
                       " Autre obstacle fixe sur trottoir ou accotement","Sortie de chaussée sans obstacle","Buse-tête d'aqueduc")

# obstacle mobile heurté
vehic$obsm <- as.factor(vehic$obsm)
levels(vehic$obsm) <- c("Non renseigné","Aucun","Piéton","Véhicule","Véhicule sur rail","Animal domestique","Animal sauvage","Autre")

# manoeuvre avant l'accident
vehic$manv <- as.factor(vehic$manv)
levels(vehic$manv) <- c("Non renseigné","Inconnue","Sans changement de direction","Même sens, même file","Entre 2 files","En marche arrière","A contresens","En franchissant le terre-plein central",
                        "Dans le couloir bus,dans le même sens ","Dans le couloir bus, dans le sens inverse","En s'insérant","En faisant demi-tour sur la chaussée","Changeant de file à gauche","Changeant de file à droite","Déporté à gauche","Déporté à droite",
                        "Tournant à gauche","Tournant à droite","Dépassant à gauche","Dépassant à droite","Traversant la chaussée","Manoeuvre de stationnement","Manoeuvre d'évitement",
                        "Ouverture de porte","Arrêté(hors stationnement","En stationnement avec occupants","Circulant sur le trottoir","Autres manoeuvres")

# motorisation
vehic$motor <- as.factor(vehic$motor)
levels(vehic$motor) <- c("Non renseigné","Inconnue","Hydrocarbures","Hybride électrique","Electrique","Hydrogène","Humaine","Autre")


## Base usagers
# catégorie de l'usager
usagers$catu <- as.factor(usagers$catu)
levels(usagers$catu) <- c("Conducteur","Passager","Piéton")
# gravité de l'accident
usagers$grav <- as.factor(usagers$grav)
levels(usagers$grav) <- c("Indemne","Tué","Blessé hospitalisé","Blessé léger")

# sexe
usagers$sexe <- as.factor(usagers$sexe)
levels(usagers$sexe) <- c("Masculin","Féminin")
# type de trajet
usagers$trajet <- as.factor(usagers$trajet)
levels(usagers$trajet) <- c("Non renseigné","Non renseigné","Domicile-travail","Domicile-école","Courses-achats","Utilisation professionnelle","Promenade-loisirs","Autre")


### Valeurs manquantes et abérrantes

## Base caracteristiques
va <- which(carac$atm=="Non renseigné")
va2 <- which(carac$col=="Non renseigné")
va3 <-which(is.nan(carac$adr) | carac$adr=="-")
carac<-carac[-c(va, va2, va3),]

## Base lieux
lieux$surf <- str_replace_all(lieux$surf, pattern = "Non renseigné", 
                              replacement = "Autre")



### Jointures
carac_lieux <- inner_join(carac,lieux,by="Num_Acc")
lieux_usagers <- inner_join(lieux,usagers,by="Num_Acc")
usagers_vehic <- inner_join(usagers,vehic,by="id_vehicule")
colnames(usagers_vehic)[1] <- "Num_Acc"

var_usagers_vehic <- c("Num_Acc","id_vehicule","grav","catu","sexe","trajet","catv","obs","obsm","manv","motor")
usagers_vehic <- usagers_vehic[,var_usagers_vehic]

df <- inner_join(carac_lieux,usagers_vehic,by="Num_Acc")

str(df)
#MODELE SVM

View(df)
library('lubridate')
df$hrmn<-hour(strptime(df$hrmn,format="%H:%M"))
df$hrmn<- cut(df$hrmn, breaks =0:24, labels = NULL,
              include.lowest = TRUE, right = FALSE,
              ordered_result = TRUE)

df$date <-wday(df$date,label=TRUE,abbr=FALSE,week_start="1",locale = Sys.getlocale("LC_TIME"))


summary(df)

#Test sur toutes les données des 500 premières lignes
#on partage la base en deux parties : train.set et test.set
index <- 1:nrow(df[1:500,])
l <- 2 #(l-1)/l d'observations pour l'apprentissage et 1/l observations pour le test
test.set.index <- sample(x = index, size = trunc(length(index)/l), replace = FALSE)
test.set <- df[1:500,][test.set.index, ]
train.set <- df[1:500,][- test.set.index, ]

str(test.set)
str(train.set)
#avec kernel linéaire
tune.out <- tune(svm, grav ~ lum + agg + int + atm + col + catr + circ + nbv + vosp + 
                   prof + plan + surf + infra + situ + vma + catu + 
                   sexe + trajet + catv +obs + obsm +manv + motor, data = train.set, kernel = "linear",
                 scale = TRUE,
                 ranges = list(cost = c(2^(-2) ,2^(-1), 1, 2^2, 2^3)))
summary(tune.out)
str(tune.out)
table(true = test.set[, "grav"], 
      pred = predict(tune.out$best.model, newdata = test.set, 
                     scale = TRUE))
err1 <- mean(!(test.set[, "grav"] == 
                 predict(tune.out$best.model, newdata = test.set, 
                         scale = TRUE)))
err1

#avec kernel radial
tune.out <- tune(svm,grav ~ lum + agg + int + atm + col + catr + circ + nbv + vosp + 
                   prof + plan + surf + infra + situ + vma + catu + 
                   sexe + trajet + catv +obs + obsm +manv + motor, data = train.set,kernel = "radial",
                 scale = TRUE,
                 ranges = list(cost = c(2^(-2) ,2^(-1), 1, 2^2, 2^3), 
                               gamma = c(2^(-2), 2^(-1), 1, 2, 2^2, 2^3))
)
summary(tune.out)
table(true = test.set[, "grav"], 
      pred = predict(tune.out$best.model, newdata = test.set,
                     scale = TRUE))
err2 <- mean(!(test.set[, "grav"] == 
                 predict(tune.out$best.model, newdata = test.set,
                         scale = TRUE)))
err2

#Comparaison
err1
err2

#Test sur 70 % des données pour l'apprentissage

#on partage la base en deux parties : train.set et test.set
index <- nrow(df[1:500,])
set.seed(123)
test.set.index <- sample(1:index, size = 0.7*index, replace = FALSE)
test.set <- df[1:500,][test.set.index, ]
train.set <- df[1:500,][- test.set.index, ]

#avec kernel linéaire
tune.out <- tune(svm,grav ~lum + agg + int + atm + col + catr + circ + nbv + vosp + 
                   prof + plan + surf + infra + situ + vma + catu + 
                   sexe + trajet + catv +obs + obsm +manv + motor, data = train.set, kernel = "linear",
                 scale = TRUE,
                 ranges = list(cost = c(2^(-2) ,2^(-1), 1, 2^2, 2^3)))
summary(tune.out)
table(true = test.set[,"grav"], 
      pred = predict(tune.out$best.model, newdata = test.set, 
                     scale = TRUE))
err1 <- mean(!(test.set[, "grav"] == 
                 predict(tune.out$best.model, newdata = test.set, 
                         scale = TRUE)))
err1

#avec kernel radial
tune.out <- tune(svm,grav ~ lum + agg + int + atm + col + catr + circ + nbv + vosp + 
                   prof + plan + surf + infra + situ + vma + catu + 
                   sexe + trajet + catv +obs + obsm +manv + motor, data = train.set, kernel = "radial",
                 scale = TRUE,
                 ranges = list(cost = c(2^(-2) ,2^(-1), 1, 2^2, 2^3), 
                               gamma = c(2^(-2), 2^(-1), 1, 2, 2^2, 2^3))
)
summary(tune.out)
table(true = test.set[, "grav"], 
      pred = predict(tune.out$best.model, newdata = test.set,
                     scale = TRUE))
err2 <- mean(!(test.set[, "grav"] == 
                 predict(tune.out$best.model, newdata = test.set,
                         scale = TRUE)))
err2

#Comparaison
err1
err2         
