---
documentclass: "tp"
lang: true
babel-lang: "french"
geometry:
  - left=1.5cm
  - right=1.5cm
  - top=1.5cm
  - bottom=2cm
title: "Prédiction de la gravité des accidents corporels routiers"
date: "24 janvier 2022"
abstract: "Dans ce compte-rendu, vous trouverez une étude sur les accidents corporels routiers de 2019 en France.\n Nous avons réaliser une étude descriptive des usagers impliqués dans ces accidents ainsi que la création d'un modèle de prédiction de la gravité de ces accidents."
anac: "2021 - 2022"
diplome: "Master Statistique pour l'Évaluation et la Prévision, 2\\up{ème} année"
moduleref: "SEP0932 - SEP0953 "
modulenom: "Amor KEZIOU - Morgan COUSIN"
enseig: 
  - "Hugo CARLIN"
  - "Valentine CROIBIEN"
  - "Emilie PIERQUIN"
  - "Adrien SAGRAFENA"
output: 
  bookdown::pdf_book:
    template: template.tex
    fig_caption: yes
    keep_tex: yes
    toc: no
bibliography: biblio_tp-urca.bib
biblio-style: plain
link-citations: yes
toc : true
toc_depth : 3
---









\newpage
# Introduction  

|           Enjeux majeurs des décisions politiques, les problèmes liés à la sécurité routière sont au cœur de tous les débats depuis maintenant quatre décennies.
Grâce aux innovations dans la conception et l’utilisation des voitures[^1], couplées à de nombreuses mesures de sécurité[^2], d’incontestables résultats ont été obtenus pour limiter le nombre et l’impact des accidents routiers dans notre vie quotidienne. Ainsi, par exemple, le nombre de tués sur la route est passé de 12510 en 1980 à 3480 en 2019[^3]. Toutefois, ces mesures montrent leur limite en termes d’efficacité : le nombre de tués se stabilise par exemple autour de 3400/3500.  

|           Notre étude porte sur les facteurs influençant la gravité des accidents corporels routiers. Nous allons essayer d'élaborer un modèle permettant de prédire la gravité d'un accident. 
Pour cela, nous avons choisi un ensemble de base de données issues du site [DataGouv](https://www.data.gouv.fr/fr/datasets/bases-de-donnees-annuelles-des-accidents-corporels-de-la-circulation-routiere-annees-de-2005-a-2019/) sur les accidents corporels de la circulation routière de 2019. Les données utilisées sont présentées en annexe \@ref(jeux-donnees).  

|           Dans un premier temps, nous allons donc vous présenter une étude statistique des accidents corporels routiers en 2019, puis nous tenterons de mettre en place un modèle de prédiction de notre variable gravité.  

[^1]: On citera la ceinture de sécurité, les airbags, les renforts latéraux parmi tant d’autres.
[^2]: On citera l’abaissement drastique du taux d’alcoolémie, l’instauration du permis à points, l’alourdissement du régime des contraventions, la politique de généralisations des radars et l’abaissement de la vitesse de 90 à 80km/h sur le réseau secondaire.
[^3]: [Statistiques de la sécurité routière](http://www.securite-routiere.org/Fiches/statistiques/statfr.htm)


# Études des accidents corporels routiers de 2019 en France  
|           Dans un premier temps, nous avons étudié la répartition des usagers impliqués dans un accident selon la gravité. Cette répartition est illustrée dans la table \@ref(tab:tablegrav).  

Ensuite, nous avons étudié la répartition des usagers selon la gravité croisée avec d'autres variables telles que la catégorie de l'usager, le type de trajet effectué, l'état de la surface, les conditions atmosphériques, etc.  

La répartition des individus selon la gravité et leur catégorie est disponible dans la figure \@ref(fig:barplot1).  



# Prédiction de la gravité des accidents corporels routiers  

\newpage
# Conclusion


\newpage
# (APPENDIX) Annexes {-}
# Annexes
## Jeux de données utilisés {#jeux-donnees}
Les jeux de données utilisés sont disponibles sur [DataGouv](https://www.data.gouv.fr/fr/datasets/bases-de-donnees-annuelles-des-accidents-corporels-de-la-circulation-routiere-annees-de-2005-a-2019/). Ces jeux de données décrivent les accidents corporels routiers ayant eu lieu en 2019.  

Nous disposons de quatre bases de données :  

* Base caractéristiques : correspondant aux caractéristiques générales de l'accident
* Base lieux : correspondant aux caractéristiques du lieu de l'accident
* Base véhicule : correspondant aux caractéristiques du véhicule prenant part à l'accident
* Base usagers : correspondant aux caractéristiques des usagers faisant partie de l'accident

## Préparation des données 
### Jointure des 4 bases  

Nous réalisons des jointures entre les différentes bases sur l'identifiant de l'accident mais également sur l'identifiant des véhicules impliqués. Nous n'avons finalement plus qu'un jeu de données à étudier dans lequel chaque ligne correspond à un usager impliqué dans un accident corporel routier en France en 2019.  

### Choix des variables  

Cependant, en réalisant notre jointure, nous obtenons une base de données avec une soixantaine de variables.  
Nous choisissons donc de réaliser un premier tri sur ces variables et de garder les variables suivantes :  

* L'identifiant de l'accident,
* La date,
* L'heure et minute,
* La luminosité,
* Le département, 
* La commune,
* Si l'accident a eu lieu en agglomération ou non,
* Le type d'intersection,
* Les conditions atmosphériques,
* Le type de collision,
* La catégorie de la route,
* Le régime de circulation,
* Le nombre de voies,
* La présence d'une voie particulière,
* Le profil de la route,
* Le plan de la route,
* L'état de la surface,
* Les infrastructures mises en place,
* La situation de l'accident,
* La vitesse maximale autorisée,
* L'identifiant du véhicule,
* La gravité,
* La catégorie de l'usager,
* Le sexe de l'usager,
* Le type de trajet effectué,
* La catégorie du véhicule,
* L'obstacle fixe rencontré,
* L'obstacle mobile rencontré,
* Le type de manoeuvre effectué,
* Le moteur du véhicule.

## Statistiques descriptives sur les usagers  

### Statistiques globales  
(ref:captablesummary) Sommaire des variables disponibles  
\begin{table}[H]

\caption{(\#tab:tablesummary)(ref:captablesummary)}
\centering
\begin{tabular}[t]{lllllllllllllllllllllllllllllll}
\toprule
\textbf{ } & \textbf{        Num\_Acc} & \textbf{     date} & \textbf{     hrmn} & \textbf{lum} & \textbf{    dep} & \textbf{     com} & \textbf{agg} & \textbf{     int} & \textbf{     atm} & \textbf{     col} & \textbf{     catr} & \textbf{circ} & \textbf{     nbv} & \textbf{vosp} & \textbf{prof} & \textbf{plan} & \textbf{    surf} & \textbf{    infra} & \textbf{     situ} & \textbf{     vma} & \textbf{id\_vehicule} & \textbf{grav} & \textbf{catu} & \textbf{sexe} & \textbf{    trajet} & \textbf{     catv} & \textbf{     obs} & \textbf{     obsm} & \textbf{     manv} & \textbf{    motor}\\
\midrule
\cellcolor{gray!6}{} & \cellcolor{gray!6}{201900049689:    33} & \cellcolor{gray!6}{Min.   :2019-01-01} & \cellcolor{gray!6}{18:00  :  1870} & \cellcolor{gray!6}{1:88619} & \cellcolor{gray!6}{Length:132975} & \cellcolor{gray!6}{75116  :  1418} & \cellcolor{gray!6}{1:50186} & \cellcolor{gray!6}{1      :87067} & \cellcolor{gray!6}{1      :105339} & \cellcolor{gray!6}{3      :40350} & \cellcolor{gray!6}{4      :55157} & \cellcolor{gray!6}{-1: 6726} & \cellcolor{gray!6}{Min.   :-1.000} & \cellcolor{gray!6}{-1:  1428} & \cellcolor{gray!6}{-1:    30} & \cellcolor{gray!6}{-1:    15} & \cellcolor{gray!6}{Length:132975} & \cellcolor{gray!6}{0      :110523} & \cellcolor{gray!6}{1      :117931} & \cellcolor{gray!6}{Min.   : -1.00} & \cellcolor{gray!6}{Length:132975} & \cellcolor{gray!6}{1:55314} & \cellcolor{gray!6}{1:97355} & \cellcolor{gray!6}{1:90382} & \cellcolor{gray!6}{5      :52020} & \cellcolor{gray!6}{7      :85253} & \cellcolor{gray!6}{0      :111797} & \cellcolor{gray!6}{2      :84950} & \cellcolor{gray!6}{1      :55866} & \cellcolor{gray!6}{1      :109235}\\
 & 201900029632:    30 & 1st Qu.:2019-04-11 & 17:30  :  1646 & 2: 8281 & Class :character & 75112  :   976 & 2:82789 & 2      :16547 & 2      : 14749 & 6      :34838 & 3      :47060 & 1 :23094 & 1st Qu.: 2.000 & 0 :121681 & 1 :107389 & 1 :109072 & Class :character & 5      :  7878 & 3      :  7529 & 1st Qu.: 50.00 & Class :character & 2: 3496 & 2:24356 & 2:42593 & 0      :34376 & 33     : 9256 & 1      :  3068 & 0      :25195 & 2      :14801 & 0      : 13538\\
\cellcolor{gray!6}{} & \cellcolor{gray!6}{201900027084:    25} & \cellcolor{gray!6}{Median :2019-07-07} & \cellcolor{gray!6}{18:30  :  1628} & \cellcolor{gray!6}{3:13674} & \cellcolor{gray!6}{Mode  :character} & \cellcolor{gray!6}{31555  :   952} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{3      :13769} & \cellcolor{gray!6}{8      :  4944} & \cellcolor{gray!6}{2      :17977} & \cellcolor{gray!6}{1      :15915} & \cellcolor{gray!6}{2 :80816} & \cellcolor{gray!6}{Median : 2.000} & \cellcolor{gray!6}{1 :  4085} & \cellcolor{gray!6}{2 : 21131} & \cellcolor{gray!6}{2 : 11207} & \cellcolor{gray!6}{Mode  :character} & \cellcolor{gray!6}{9      :  4946} & \cellcolor{gray!6}{8      :  2067} & \cellcolor{gray!6}{Median : 50.00} & \cellcolor{gray!6}{Mode  :character} & \cellcolor{gray!6}{3:20858} & \cellcolor{gray!6}{3:11264} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{1      :17677} & \cellcolor{gray!6}{10     : 8790} & \cellcolor{gray!6}{13     :  2770} & \cellcolor{gray!6}{1      :20757} & \cellcolor{gray!6}{15     :10468} & \cellcolor{gray!6}{5      :  4707}\\
 & 201900049861:    24 & Mean   :2019-07-07 & 17:00  :  1503 & 4: 1204 & NA & 75117  :   915 & NA & 9      : 5916 & 3      :  3244 & 1      :13956 & 2      : 9595 & 3 :21502 & Mean   : 2.479 & 2 :  1890 & 3 :  2328 & 3 : 11064 & NA & 2      :  2676 & 2      :  2033 & Mean   : 61.55 & NA & 4:53307 & NA & NA & 4      :12506 & 1      : 5265 & 2      :  2287 & 9      : 1003 & 0      : 7140 & 6      :  2041\\
\cellcolor{gray!6}{} & \cellcolor{gray!6}{201900052213:    24} & \cellcolor{gray!6}{3rd Qu.:2019-10-04} & \cellcolor{gray!6}{16:00  :  1420} & \cellcolor{gray!6}{5:21197} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{34172  :   882} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{6      : 4504} & \cellcolor{gray!6}{7      :  2336} & \cellcolor{gray!6}{4      : 9292} & \cellcolor{gray!6}{7      : 2928} & \cellcolor{gray!6}{4 :  837} & \cellcolor{gray!6}{3rd Qu.: 3.000} & \cellcolor{gray!6}{3 :  3891} & \cellcolor{gray!6}{4 :  2097} & \cellcolor{gray!6}{4 :  1617} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{3      :  2079} & \cellcolor{gray!6}{4      :  1180} & \cellcolor{gray!6}{3rd Qu.: 80.00} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{9      : 9461} & \cellcolor{gray!6}{2      : 4268} & \cellcolor{gray!6}{3      :  2158} & \cellcolor{gray!6}{6      :  809} & \cellcolor{gray!6}{13     : 5871} & \cellcolor{gray!6}{3      :  1922}\\
\addlinespace
 & 201900054644:    24 & Max.   :2019-12-31 & 19:00  :  1409 & NA & NA & 75119  :   855 & NA & 4      : 2859 & 5      :   723 & 7      : 8663 & 9      : 1228 & NA & Max.   :12.000 & NA & NA & NA & NA & 1      :  1803 & 5      :  1033 & Max.   :800.00 & NA & NA & NA & NA & 3      : 3557 & 30     : 3614 & 4      :  2016 & 4      :   99 & 26     : 4900 & 2      :  1076\\
\cellcolor{gray!6}{} & \cellcolor{gray!6}{(Other)     :132815} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{(Other):123499} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{(Other):126977} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{(Other): 2313} & \cellcolor{gray!6}{(Other):  1640} & \cellcolor{gray!6}{(Other): 7899} & \cellcolor{gray!6}{(Other): 1092} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{(Other):  3070} & \cellcolor{gray!6}{(Other):  1202} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{NA} & \cellcolor{gray!6}{(Other): 3378} & \cellcolor{gray!6}{(Other):16529} & \cellcolor{gray!6}{(Other):  8879} & \cellcolor{gray!6}{(Other):  162} & \cellcolor{gray!6}{(Other):33929} & \cellcolor{gray!6}{(Other):   456}\\
\bottomrule
\end{tabular}
\end{table}

#### Répartition des usagers par gravité  
(ref:captablegrav) Effectifs des usagers par gravité
\begin{table}[H]

\caption{(\#tab:tablegrav)(ref:captablegrav)}
\centering
\begin{tabular}[t]{lr}
\toprule
\textbf{Var1} & \textbf{Freq}\\
\midrule
\cellcolor{gray!6}{Indemne} & \cellcolor{gray!6}{55314}\\
Tué & 3496\\
\cellcolor{gray!6}{Blessé hospitalisé} & \cellcolor{gray!6}{20858}\\
Blessé léger & 53307\\
\bottomrule
\end{tabular}
\end{table}

### Croisement de la gravité avec d'autres variables

#### Répartition des usagers selon leur catégorie et la gravité  

(ref:barplotcatu) Graphiques à bâtons sur les profils lignes, regroupement par catégorie d'usagers  
__Source des données :__ Par les auteurs selon les données de 2019 du ministère de l’Intérieur.  
__Cohorte :__ 132975 usagers.  
__Lecture :__ 64% des piétons sont des blessés légers.  


\begin{figure}[ht!]

{\centering \includegraphics{Prediction_Gravite_files/figure-latex/barplotcatu-1} 

}

\caption{(ref:barplotcatu)}(\#fig:barplotcatu)
\end{figure}

\newpage
#### Répartition des usagers selon leur trajet et la gravité  

(ref:barplottrajet) Graphiques à bâtons sur les profils lignes, regroupement par type de trajet  
__Source des données :__ Par les auteurs selon les données de 2019 du ministère de l’Intérieur.  
__Cohorte :__ 132975 usagers.  
__Lecture :__ 65% des usagers ayant un eu un accident lors d’un trajet d’utilisation professionnelle en ressortent indemnes.  


\begin{figure}[ht!]

{\centering \includegraphics{Prediction_Gravite_files/figure-latex/barplottrajet-1} 

}

\caption{(ref:barplottrajet)}(\#fig:barplottrajet)
\end{figure}
\newpage
#### Répartition des usagers selon la condition atmosphérique et la gravité  

(ref:barplotatm) Graphiques à bâtons sur les profils lignes, regroupement par type de trajet  
__Source des données :__ Par les auteurs selon les données de 2019 du ministère de l’Intérieur.  
__Cohorte :__ 132975 usagers.  
__Lecture :__ 42% des usagers ayant un eu un accident alors que la condition atmosphérique était normale en ressortent indemnes.   


\begin{figure}[ht!]

{\centering \includegraphics{Prediction_Gravite_files/figure-latex/barplotatm-1} 

}

\caption{(ref:barplotatm)}(\#fig:barplotatm)
\end{figure}

#### Répartition des usagers selon la catégorie de route et la gravité  

(ref:barplotroute) Graphiques à bâtons sur les profils lignes, regroupement par type de trajet  
__Source des données :__ Par les auteurs selon les données de 2019 du ministère de l’Intérieur.  
__Cohorte :__ 132975 usagers.  
__Lecture :__ 42% des usagers ayant un eu un accident alors que la condition atmosphérique était normale en ressortent indemnes.   


\begin{figure}[ht!]

{\centering \includegraphics{Prediction_Gravite_files/figure-latex/barplotroute-1} 

}

\caption{(ref:barplotroute)}(\#fig:barplotroute)
\end{figure}

#### Répartition des usagers selon la surface et la gravité  

(ref:barplotsurface) Graphiques à bâtons sur les profils lignes, regroupement par type de trajet  
__Source des données :__ Par les auteurs selon les données de 2019 du ministère de l’Intérieur.  
__Cohorte :__ 132975 usagers.  
__Lecture :__ 42% des usagers ayant un eu un accident alors que la condition atmosphérique était normale en ressortent indemnes.   


\begin{figure}[ht!]

{\centering \includegraphics{Prediction_Gravite_files/figure-latex/barplotsurface-1} 

}

\caption{(ref:barplotsurface)}(\#fig:barplotsurface)
\end{figure}
  

## Classification des individus
### Choix du nombre de variables explicatives  
### Méthode de régression logistique
### Méthode XGBoost
### Méthode Random Forest  

\newpage
## Dictionnaire des variables  
* __Base caractéristiques__ :  
  * Num_acc : Numéro d'identifiant de l'accident  
  
  * Jour mois : Jour et mois de l'accident  
  
  * Hrmn : Heures et minutes de l'accident  
  
  * Lum : Conditions d’éclairage dans lesquelles l'accident s'est produit   
    1 – Plein jour  
    2 – Crépuscule ou aube  
    3 – Nuit sans éclairage public  
    4 – Nuit avec éclairage public non allumé   
    5 – Nuit avec éclairage public allumé  
    
  * Com :  Le numéro de commune est un code donné par l‘INSEE. Le code est composé du code INSEE du département suivi par 3 chiffres  
  
  * Agg : Localisation de l'accident   
    1 – Hors agglomération   
    2 – En agglomération  
    
  * Int : Le type d'intersection où l'accident s'est déroulé   
    1 – Hors intersection  
    2 – Intersection en X  
    3 – Intersection en T  
    4 – Intersection en Y  
    5 – Intersection à plus de 4 branches  
    6 – Giratoire  
    7 – Place  
    8 – Passage à niveau  
    9 – Autre intersection  
    
  * Atm : Le type de condition atmosphérique   
    -1 – Non renseigné  
    1 – Normale  
    2 – Pluie légère  
    3 – Pluie forte  
    4 – Neige - Grêle  
    5 – Brouillard - Fumée  
    6 – Vent fort - Tempête  
    7 – Temps éblouissant  
    8 – Temps couvert  
    9 – Couvert  
    
  * Col : Le type de collision   
    -1 – Non renseigné
    1 – Deux véhicules - frontale  
    2 – Deux véhicules - par l'arrière  
    3 – Deux véhicules - par le côté  
    4 – Trois véhicules et plus - en chaîne  
    5 – Trois véhicules et plus - collisions multiples  
    6 – Autre collision  
    7 – Sans collision  

* __Base lieux__ :  
  * Catr : Catégorie de route   
    1 – Autoroute  
    2 – Route nationale  
    3 – Route départementale  
    4 – Voie communale  
    5 – Hors réseau public  
    6 – Parc de stationnement ouvert à la circulation publique  
    7 – Routes de métropole urbaine  
    9 – Autre  
    
  * Voie : Numéro de la route 
  
  * Circ : Régime de circulation  
    -1 – Non renseigné  
    1 – À sens unique  
    2 – Bidirectionnelle  
    3 – À chaussées séparées  
    4 – Avec voies d'affectation variable  
    
  * Nbv : Nombre total de voies de circulation  
  
  * Vosp : Signale l'existence d'une voie réservée, indépendamment du fait que l'accident ait lieu ou non sur cette voie  
    -1 – Non renseigné  
    0 – Sans objet  
    1 – Piste cyclable  
    2 – Bande cyclable  
    3 – Voie réservée  
    
  * Prof : Profil en long décrit la déclivité de la route à l'endroit de l'accident   
    -1 – Non renseigné  
    1 – Plat  
    2 – Pente  
    3 – Sommet de côte  
    4 – Bas de côte  
    
  * Plan : Tracé en plan   
    -1 – Non renseigné  
    1 – Partie rectiligne  
    2 – En courbe à gauche  
    3 – En courbe à droite  
    4 – En "s"  
    
  * Larrout : Largeur de la chaussée affectée à la circulation des véhicules, ne sont pas compris les bandes d'arrêts d'urgences, les TPC et les places de stationnement (en m)  
  
  * Surf : État de la surface   
     -1 – Non renseigné  
     1 – Normale  
     2 – Mouillée  
     3 – Flaques  
     4 – Inondée  
     5 – Enneigée  
     6 – Boue  
     7 – Verglacée  
     8 – Corps gras - huile  
     9 – Autre  
     
  * Infra : Aménagement, infrastructure  
    -1 – Non renseigné  
    0 – Aucun  
    1 – Souterrain - tunnel  
    2 – Pont - autopont  
    3 – Bretelle d'échangeru ou de raccordement  
    4 – Voie ferrée  
    5 – Carrefour aménagé  
    6 – Zone piétonne  
    7 – Zone de péage  
    8 – Chantier  
    9 – Autres  
    
  * Situ : Situation de l'accident  
    -1 – Non renseigné  
    0 – Aucun  
    1 – Sur chaussée  
    2 – Sur bandes d'arrêt d'urgence  
    3 – Sur accotement  
    4 – Sur trottoir  
    5 – Sur piste cyclable  
    6 – Sur autre voie spéciale  
    8 – Autres  
    
  * VMA : Vitesse maximale autorisée sur le lieu et au moment de l'accident  
  
* __Base véhicule__ :  
  * Id_vehicule : Identifiant unique du véhicule repris pour chacun des usagers occupant ce véhicule (y compris les piétons qui sont rattachés aux véhicules qui les ont heurtés) – Code numérique  
  
  * Catv : Catégorie du véhicule :
    00 – Indéterminable  
    01 – Bicyclette  
    02 – Cyclomoteur <50cm3  
    03 – Voiturette (Quadricycle à moteur carrossé) (anciennement "voiturette ou tricycle à moteur")  
  04 – Référence inutilisée depuis 2006 (scooter immatriculé)  
    05 – Référence inutilisée depuis 2006 (motocyclette)  
    06 – Référence inutilisée depuis 2006 (side-car)  
    07 – VL seul  
    08 – Référence inutilisée depuis 2006 (VL + caravane)       
    09 – Référence inutilisée depuis 2006 (VL + remorque)       
    10 – VU seul 1,5T <= PTAC <= 3,5T avec ou sans remorque (anciennement VU seul 1,5T <= PTAC
<= 3,5T)  
    11 – Référence inutilisée depuis 2006 (VU (10) + caravane)  
    12 – Référence inutilisée depuis 2006 (VU (10) + remorque)  
    13 – PL seul 3,5T <PTCA <= 7,5T  
    14 – PL seul > 7,5T  
    15 – PL > 3,5T + remorque  
    16 – Tracteur routier seul  
    17 – Tracteur routier + semi-remorque  
    18 – Référence inutilisée depuis 2006 (transport en commun)  
    19 – Référence inutilisée depuis 2006 (tramway)  
    20 – Engin spécial  
    21 – Tracteur agricole  
    30 – Scooter < 50 cm3  
    31 – Motocyclette > 50 cm3 et <= 125 cm3  
    32 – Scooter > 50 cm3 et <= 125 cm3  
    33 – Motocyclette > 125 cm3  
    34 – Scooter > 125 cm3  
    35 – Quad léger <= 50 cm3 (Quadricycle à moteur non carrossé)  
    36 – Quad lourd > 50 cm3 (Quadricycle à moteur non carrossé)  
    37 – Autobus  
    38 – Autocar  
    39 – Train  
    40 – Tramway  
    41 – 3RM <= 50 cm3  
    42 – 3RM > 50 cm3 <= 125 cm3  
    43 – 3RM > 125 cm3  
    50 – EDP à moteur  
    60 – EDP sans moteur 80 – VAE  
    99 – Autre véhicule  
    
  * Obs : Obstacle fixe heurté  
    -1 – Non renseigné  
    0 – Sans objet  
    1 – Véhicule en stationnement  
    2 – Arbre  
    3 – Glissière métallique  
    4 – Glissière béton  
    5 – Autre glissière  
    6 – Bâtiment, mur, pile de pont  
    7 – Support de signalisation verticale ou poste d’appel d’urgence  
    8 – Poteau  
    9 – Mobilier urbain  
    10 – Parapet  
    11 – Ilot, refuge, borne haute  
    12 – Bordure de trottoir  
    13 – Fossé, talus, paroi rocheuse  
    14 – Autre obstacle fixe sur chaussée  
    15 – Autre obstacle fixe sur trottoir ou accotement  
    16 – Sortie de chaussée sans obstacle  
    17 – Buse – tête d’aqueduc  
    
  * Obsm : Obstacle mobile heurté  
    -1 – Non renseigné  
    0 – Aucun  
    1 – Piéton  
    2 – Véhicule  
    4 – Véhicule sur rail  
    5 – Animal domestique  
    6 – Animal sauvage  
    9 – Autre  

  * Manv : Manoeuvre principale avant l’accident  
    -1 – Non renseigné  
    0 – Inconnue  
    1 – Sans changement de direction  
    2 – Même sens, même file  
    3 – Entre 2 files  
    4 – En marche arrière  
    5 – A contresens  
    6 – En franchissant le terre-plein central  
    7 – Dans le couloir bus, dans le même sens  
    8 – Dans le couloir bus, dans le sens inverse  
    9 – En s’insérant
    10 – En faisant demi-tour sur la chaussée  
    **Changeant de file**  
    11 – A gauche  
    12 – A droite  
    **Déporté**  
    13 – A gauche  
    14 – A droite  
    **Tournant**  
    15 – A gauche  
    16 – A droite  
    **Dépassant**  
    17 – A gauche  
    18 – A droite  
    **Divers**  
    19 – Traversant la chaussée  
    20 – Manœuvre de stationnement  
    21 – Manœuvre d’évitement  
    22 – Ouverture de porte  
    23 – Arrêté (hors stationnement)  
    24 – En stationnement (avec occupants)  
    25 – Circulant sur trottoir  
    26 – Autres manœuvres  
    
  * Motor : Type de motorisation du véhicule  
    -1 – Non renseigné  
    0 – Inconnue  
    1 – Hydrocarbures  
    2 – Hybride électrique  
    3 – Electrique  
    4 – Hydrogène  
    5 – Humaine  
    6 – Autre   
    
* __Base usagers__ :  
  * Catu : Catégorie d'usager  
    1 – Conducteur  
    2 – Passager  
    3 – Piéton  
    
  * Grav: Gravité de blessure de l'usager, les usagers accidentés sont classés en trois catégories de victimes plus les indemnes  
    1 – Indemne  
    2 – Tué  
    3 – Blessé hospitalisé  
    4 – Blessé léger  
    
  * Sexe : Sexe de l'usager  
    1 – Masculin  
    2 – Féminin  
    
  * An_nais : Année de naissance de l'usager  
  
  * Trajet : Motif du déplacement au moment de l’accident  
    -1 – Non renseigné   
    0 – Non renseigné  
    1 – Domicile – travail  
    2 – Domicile – école  
    3 – Courses – achats  
    4 – Utilisation professionnelle  
    5 – Promenade – loisirs  
    9 – Autre  
    
  * Secu1 : 
Le renseignement du caractère indique la présence et l’utilisation de l’équipement de sécurité  
    -1 – Non renseigné  
    0 – Aucun équipement  
    1 – Ceinture  
    2 – Casque  
    3 – Dispositif enfants  
    4 – Gilet réfléchissant  
    5 – Airbag (2RM/3RM)  
    6 – Gants (2RM/3RM)  
    7 – Gants + Airbag (2RM/3RM)  
    8 – Non déterminable  
    9 – Autre  
    
  * Secu2 : Le renseignement du caractère indique la présence et l’utilisation de l’équipement de sécurité  
    -1 – Non renseigné  
    0 – Aucun équipement  
    1 – Ceinture  
    2 – Casque  
    3 – Dispositif enfants  
    4 – Gilet réfléchissant  
    5 – Airbag (2RM/3RM)  
    6 – Gants (2RM/3RM)  
    7 – Gants + Airbag (2RM/3RM)  
    8 – Non déterminable  
    9 – Autre  
    
  * Secu3 : Le renseignement du caractère indique la présence et l’utilisation de l’équipement de sécurité  
    -1 – Non renseigné  
    0 – Aucun équipement  
    1 – Ceinture  
    2 – Casque  
    3 – Dispositif enfants  
    4 – Gilet réfléchissant  
    5 – Airbag (2RM/3RM)  
    6 – Gants (2RM/3RM)  
    7 – Gants + Airbag (2RM/3RM)  
    8 – Non déterminable  
    9 – Autre  
    
  * Locp : Localisation du piéton  
    -1 – Non renseigné   
    0 – Sans objet  
    **Sur chaussée :**  
    1 – A + 50 m du passage piéton  
    2 – A – 50 m du passage piéton  
    **Sur passage piéton :**  
    3 – Sans signalisation lumineuse    
    4 – Avec signalisation lumineuse  
    **Divers :**  
    5 – Sur trottoir  
    6 – Sur accotement  
    7 – Sur refuge ou BAU  
    8 – Sur contre allée  
    9 – Inconnue  
    
  * Actp : Action du piéton  
    -1 – Non renseigné  
    **Se déplaçant**  
    0 – Non renseigné ou sans objet   
    1 – Sens véhicule heurtant  
    2 – Sens inverse du véhicule  
    **Divers**  
    3 – Traversant  
    4 – Masqué  
    5 – Jouant – courant  
    6 – Avec animal  
    9 – Autre  
    A – Monte/descend du véhicule  
    B – Inconnue  
    
  * Etatp : Cette variable permet de préciser si le piéton accidenté était seul ou non  
    -1 – Non renseigné  
    1 – Seul  
    2 – Accompagné  
    3 – En groupe

