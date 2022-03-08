ReadMe du Projet Rbloggers

Lien du dashboard deployé :
---------------------------------------------- 

https://ettouilebouael.shinyapps.io/R-Bloggers-Dashboard/

Fichiers:
---------------------------------------------- 
Dashboard.rmd : Ficher rmarkdown du dashboard

Webscraper.ipynb : Notebook python du script du webscraping des articles de Rbloggers

Topic-modeling.ipynb : Notebook python de la partie apprentissage non supervisé


Contributions :
---------------------------------------------- 


* Contribution de Ouael ETTOUILEB : 

-> Gestion et cadrage du projet;
-> Préparation de l'environnement de développement;
-> Collecte et préparation des données;
-> Intégration des différentes parties du Dashboard;
-> Apprentissage non supervisé : Identification des thématiques d'intérêts à l'aide du clustering;
-> Déploiement du Dashboard;
-> Création de la partie Topics du dashboard;
-> Rédaction de la partie méthodologie du compte-rendu;

$
Contribution d'Adrien Sagrafena au travail du groupe:

-> Tentative de récupération des données sur Facebook avec FacebookR (avortée: package obsolète
avec les nouvelles conditions de sécurité facebook).
->Création de 2 fonctions (countword, non conservées en l'état) pour se familiariser avec les concepts du text mining, faire les premières essais sur les jeux de données.
(découpage des articles en phrases puis en mots, comptage du nombre de mot, stop words, expressions régulières, packages divers: tokenizers,etc)
-> Création de code pour permettre au groupe de traiter les dates dans les datafames
(extraction du jour, du mois en français)
-> Création du code R sur le filtrage puis le comptage des mots par an, par an et mois et par auteur
(utilisation tidyverse, dplyr et expressions régulières)
-> Création de la partie du dashboard sur les mots-clés (key-words) avec RShiny
-> Rédaction: commentaires des graphiques de la partie 5, discussion, conclusion; relecture du compte-rendu final.


Contribution Ayoub BRIDAOUI :

-> Première page du dashboard. Une mission qui consiste à faire un calendrier permettant de connaitre à quelle fréquence les articles sont publiés afin d’avoir une vision globale sur le dynamisme de Rbloggers sur toute la période à la fois par jour de la semaine, par mois et par année.


Contribution Oumaima Fariss: 

-> Deuxième page du Dashboard. La tâche consiste à déterminer la contribution, à savoir le nombre des articles publiés et leurs titres ainsi que les thèmes abordés par chacun des auteurs dans Rbloggers.


Contribution Salomé THIRIOT :

-> Récupération des données sur Twitter afin de regarder le trafic présent sur chaque tweet composé d’un article de Rbloggers;
-> Vectorisation des textes afin d’ordonner et des structurer les données;
-> Rédaction : Rédaction de la partie lntroduction et Problèmatique ainsi que l’interprétation des graphiques présents dans la partie 5;
-> Réaction de la partie 4 sur l’interprétation du Tableau représentant les mots les plus populaire par clusters.




