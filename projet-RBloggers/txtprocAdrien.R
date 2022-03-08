# By Adrien
# sur le fichier df_text.csv : recherche du nombre d'occurrence d'un mot
# par mois et par an
# occurrence d'un mot par auteur

library("readr")
library("purrr")
library("lubridate")
library("tidyverse")
library("stringr")
library("data.table")
source("~/projet-rss/date.R", encoding = 'UTF-8')


# mot par auteur: autre solution ici
# ou prendre le programme que j'ai déjà fait avec countwordV1 ou V1b
# en novembre, ça marche aussi


## TRANSFORMATION DU DATAFRAME: GESTION DES DATES de data_txt

prev<- Sys.getlocale("LC_TIME") # pour éviter des ennuis de conversion pénibles   
Sys.setlocale("LC_TIME", "C")   # on passe de "French_France.1252" à "C"

data_text$date=strptime(data_text$date,format ="%B %d, %Y")

Sys.setlocale("LC_TIME", prev)  # retour système local

# j'ajoute les colonnes sans supprimer celle de la date formatée: les dataframes
# sont un peu plus lourds mais ça passe!

data_text%>%
  mutate(
    jour=wday(date,label = TRUE,abbr = FALSE ,week_start = "1",locale = Sys.getlocale("LC_TIME")),
    mois=month(date,label=TRUE,abbr=FALSE,locale = Sys.getlocale("LC_TIME")),
    annee=year(date)
  )->data_text



text_an<-function(mot){

data_text%>%
  select(annee,text)%>%
  group_by(annee)%>%
  mutate(comptage=str_count(text,regex(mot,ignore_case = TRUE)))%>%
  summarise(total=sum(comptage,na.rm=TRUE))->occur_mot_annee

  return(occur_mot_annee)

}

text_mois<-function(a,mot){
  
  data_text%>%
    select(annee,mois,text)%>%
    filter(annee==a)%>%
    group_by(mois)%>%
    mutate(comptage=str_count(text,regex(mot,ignore_case = TRUE)))%>%
    summarise(total=sum(comptage,na.rm=TRUE))->occur_mot_mois
  
  return(occur_mot_mois)
  
}

text_author<-function(auteur,mot){
  
  data_text%>%
    select(annee,author,text)%>%
    filter(author==regex(auteur,ignore_case=TRUE))%>%
    group_by(annee)%>%
    mutate(comptage=str_count(text,regex(mot,ignore_case = TRUE)))%>%
    summarise(total=sum(comptage,na.rm=TRUE))->occur_mot_auteur
  
  return(occur_mot_auteur)
  
}







