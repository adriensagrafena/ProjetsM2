# RSS_article, travail sur la colonne item description: split et décompte
# du nombre de mots; vectorialisation du text de chaque post sur notre petit
# échantillon; on découvre le text mining!


setwd("~/projet-rss/data")

library("readr")
library("tokenizers")
library("purrr")
library("dplyr")
library("data.table")

rss_article <- read_csv("rss_article.csv")
View(rss_article)

# les fonctions du type tokenize_foo permettent de faire ce qu'on veut!
# j'essaie de me débarrasser des sujets et auxiliaires et autres négations
# de façon à alléger le travail avec un vecteut de stopword..il y en a des
# prédéfinis dans les packages R... à voir si cela nous aide davantage

# Suite à notre dernière discussion, j'essaie de mettre les mots captés dans chaque post à la suite des informations importantes (sujet, item description, etc.)
# j'ai enlevé quelques colonnes pour que ce soit lisible et tout mis dans un dataframe.
# Travail un peu pénible sur les listes...

stpw<-c("via","here's","is","n't","in","here's","your","we","a","have","the","are","be","to","and","on","of",
        "from","what","they","we","that","how","don't","this","if","you","with","it","so","you'll","but","you'd","you'll")

l<-tokenize_words(rss_article$item_description,stopwords=stpw,strip_punct = TRUE)

# Jusque là, aucun changement! on récupère dans une liste de liste la liste des mots conservés dans chaque post.
# de façon à faire afficher ce qui concerne chaque post en vecteur, on transpose (attention avec transpose et pas t)
# la liste et on met tout dans un dataframe, on renomme les colonnes sous la forme "mot+numéro" 
# Attention chaque post n'a pas le même nombre de mots donc valeurs manquantes inévitables quand on construit

m<-max(flatten_int(lapply(l,length))) # je récupère le max de la taille de chaque liste de mots

x<-data.frame(transpose(sapply(l,c)))    # on utilise transpose de dplyr sinon souci!
colnames(x)<-paste("mot",1:m,sep="")    # et renommage des colonnes à partir de "item guide"

motsRSS<-bind_cols(rss_article[,-c(1:5,15)],x)       # suppression des variables inutiles (valeurs sont identiques) et recollement dataframes


# euh voilà..du coup tout se récupère sous forme de lignes, colonnes, vecteurs... On a vectorialisé le texte de chaque post
# est-ce conforme à notre dernière discussion en interne? cela vous plaît or not?
#sinon il y a cette façon de faire où la liste de mots du post i est enfermée de force dans la cellule ligne i colonne item_description
# du dataframe... mais c'est moins manipulable que de travailler avec des listes ou des vecteurs seulement :
#rss_article%>%
# mutate(item_description=tokenize_words(item_description,stopwords=stpw,strip_punct = TRUE))->motsRSS

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
  
# RSS_article, travail sur la colonne item description: split et décompte
# du nombre de mots, vectorisation
# version 1bis Adrien Sagrafena
  
  setwd("~/projet-rss/data")

library("readr")
library("tokenizers")
library("purrr")
library("dplyr")
library("data.table")

rss_article <- read_csv("rss_article.csv")
View(rss_article)

stpw<-c("via","here's","is","n't","in","here's","your","we","a","have","the","are","be","to","and","on","of",
        "from","what","they","we","that","how","don't","this","if","you","with","it","so","you'll","but","you'd","you'll")
tokn<-tokenize_words(rss_article$item_description,stopwords=stpw,strip_punct = TRUE,simplify=TRUE)

#on obtient un token avec les mots clés (vecteur stepword à modifier...j'ai du en zapper)
# par contre certains mots sont encore liés (pas d'espace ou autre donc collés)
# ou sont des noms de fonctions...il ne faut donc les gérer....tout n'est pas
# encore parfait

# on peut faire le compte global du nombre de mots ainsi restant par post
# puis une petite moyenne.... attention! on a des lists de lists..faut purrr tout
# ça parce que sinon c'est pénible au superlatif!

tokn%>%
  flatten_dfc()%>%
  transpose()%>%
  rename(mot=V1)%>%
  group_by(mot)%>%
  count()->motscount

view(motscount)

# nombre de mots au total sur tous nos posts
# et stats sur notre petit échantillon...en passant!

summary(motscount)

# on peut faire aussi avec lapply(token,fun=table) pour obtenir une liste de
# tables de mots par post pour rentrer ds le détail et des stats avec
# nombremots<-flatten_int(lapply(tokn,length))
# summary(nombremots)

