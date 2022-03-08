# SparksqlDSL
Traitement des données en sql et DSL.

On traite ici la base de données walmart_stock.csv  à la fois en Spark DSL et en Spark SQL. On prendra conscience
que les données sont au format str et non int ou float et qu'il faut convertir.

On procède comme suit: 

1. Création du projet.
2. Import du fichier sous la forme d'un dataframe.
3. Aperçu du dataframe.
4. Schéma du dataframe.
5. Ajout de la colonne HV Ratio et conversion des variables.
6. Affichage de la date correspondant à la plus grande valeur "High".
7. Moyenne de la variable "Close".
8. Détermination du minimum et du maximum de la variable "Volume".
9. Nombre de jours avec la variable "Close" inférieure à 60.
10. Proportion du nombre de jours où la variable "High" est supérieure à 80 sur la totalité des relevés.
11. Maximum de la variable "High" par an.
12. Moyenne de la variable "Close" par mois.
13. Sauvegarde du résultat de la question précédente dans un fichier au format Parquet.

Le répertoire captures montre les sorties obtenues.