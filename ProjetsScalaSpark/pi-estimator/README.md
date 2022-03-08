# pi-estimator

But : estimer la valeur de Pi

Pour exécuter l'artefact pi-estimor.jar (dans un terminal windows par exemple comme ci-dessous) : 

spark-submit --master local --class Main yourpathtotheproject\pi-estimator\out\artifacts\pi_estimator_jar\pi-estimator.jar



![](captures\wincmd1.JPG)  

![](captures\wincmd2.JPG)  


## 1. La fonction is_point_inside_the circle

Cette fonction sert à déterminer si un point de coordonnées (x;y), avec x et y compris entre 0 et 1, est situé à 
l'intérieur du quart de disque supérieur droit de centre O et de rayon 1.

## 2. La fonction pi_estimator_spark et

Cette fonction fabrique n points de coordonnées (x,y) aléatoires où x et y
suivent la loi uniforme sur [0;1], puis détermine pour chacun s'il est ou non dans le quart de cercle susmentionné et
stocke le résultat dans les éléments d'un RDD de taille n : 0 si le point n'est pas dans le quart de disque, 1 sinon.

La somme des valeurs du RDD donne le nombre de points situés dans le quart de disque. 
Nous calculons la fréquence de ces points sur le nombre total de points.

## 3. Lien avec l'approximation de Pi et résultats obtenus

Cette fréquence tend vers Pi/4 quand n tend vers + l'infini: c'est une
application directe de la loi des grands nombres (appliquée ici pour faire un calcul d'intégrale, méthode connue
sous le nom de "Hit or Miss" ou de méthode de "Monte Carlo").

En multipliant cette fréquence par 4 et en prenant n assez grand, on obtient une valeur approchée de Pi. Ci-dessous, 
quelques essais, dont les captures d'écran sont dans le répertoire captures:

|valeur de n|valeur approchée de Pi| écart avec Pi en valeur absolue|temps d'exécution| fichier |
|-----------|----------------------|--------------------------------|-----------------|---------|
|100        |3.2800000000000002    |0.138407346                     |555 ms           |C1.jpeg  |
|10000      |3.1251999999999982    |0.016392653                     |556 ms           |C2.jpeg  |
|1000000    |3,1405839999999988    |0.001008653                     |611 ms           |C3.jpeg  |


On répond ainsi à la dernière question:
7) pour n=1 000 000, on trouve une erreur (différence entre la valeur approchée de pi et sa valeur exacte, appelée écart
ici) vaut environ 0.0001 . Ceci est tout à fait logique car la convergence évoquée ci-dessus est en O(1/racine(n)),
d'après le théorème central Limit. 
Racine(1000000)=1000 donc l'erreur est environ de l'ordre du millième, ce que confirme 
la dernière ligne du tableau.

## Captures d'écran

![](captures\C3.JPG)  

![](captures\C2.JPG)  

![](captures\C1.JPG)  