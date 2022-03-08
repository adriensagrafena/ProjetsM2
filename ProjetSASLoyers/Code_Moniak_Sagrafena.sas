/* dir= repertoire de travail etabl=catégorie d'établissements 
typ=type d'établissements 
autre=autres types de data 
p=library de copie des tables SAS */

%LET dir=/home/u49781956/M2_SEP/projet/BDD/;
%LET etabl=etablissements_scolaires_;
%LET typ=maternelles/ecoles_elementaires/colleges;
%LET autre=commerces/logement;
%LET p=projet;

/* renommer les fichiers avec des _ au lieu de - sinon gros soucis, n'arrive pas à  retrouver le nom du fichier, - a un statut trop particulier
pour SAS pour étre géré sympathiquement

Ne pas oublier le / dans le dir sinon idem


on peut mettre '/' dans scan cela ne change rien

chemins de fichier entre "" impérativement

countw non opÃ©rant avec des macros variables ou dans une "grande" macro...il faut forcer son exécution macro avec %sysfunc()

Attention i est une macro variable donc &i sinon erreur dans %scan: le 2ème argu n'est pas un nombre;

%scan : dans un cadre macro variable: extrait le mot n° &i dans &typ , chaque mot étant séparé de l'autre par le délimiteur /

ne pas oublier les .. dans les out sinon on se retrouve avec des tables work.projet... au lieu de projet.maternelles etc etc...

 */

%LET m=%sysfunc(countw(&typ,/));			
%LET n=%sysfunc(countw(&autre,/));

options validvarname = v7 ;

%macro import;

	%DO i=1 %to &m;
	PROC IMPORT DATAFILE="&dir.&etabl.%scan(&typ,&i,/).csv" 
			dbms=dlm 
			out=&p..%scan(&typ,&i,/)
		replace;
		delimiter=";" ;
		GETNAMES=YES;
		DATAROW=2;
	run;
	
	%end;
	
	%DO i=1 %to &n;

	PROC IMPORT DATAFILE="&dir.%scan(&autre,&i,/).csv" 
			dbms=dlm 
			out=&p..%scan(&autre,&i,/)
		replace;
		delimiter=";" ;
		GETNAMES=YES;
		DATAROW=2;
	run;
	
	%end;
	
run;
%MEND;
%import;

/*Préparation des bases pour les jointures
	- On extrait les arrondissements pour faire les jointures
	- On fait des group by pour savoir le nombre d'écoles par arrondissement

/* Base maternelle */

proc sql ;
	create table maternelle_1 as 
	select	substr(put(VAR5,5.),4,2) as arrondissements, 
			count(*) as nb_maternelle
	from projet.maternelles 
	group by arrondissements;
quit;

/* Base Ã©cole Ã©lÃ©mentaire*/

proc sql ;
	create table elementaire_1 as 
	select substr(put(VAR5,5.),4,2) as arrondissements,
			count(*) as nb_elementaire
	from projet.ecoles_elementaires
	group by arrondissements;
quit;


/* Base école élémentaire*/

proc sql ;
	create table college_1 as 
	select substr(put(VAR5,5.),4,2) as arrondissements,
			count(*) as nb_college
	from projet.colleges 
	group by arrondissements;
quit;

/* Base commerces*/

proc sql ;
	create table commerces_1 as 
	select	*, substr(put(departement_commune,5.),4,2) as arrondissements
	from projet.commerces
	where departement = 75 ;
quit;

/* Base logement */
proc sql ;
	create table logement_1 as 
	select	*, substr(put(code_grand_quartier,7.),4,2) as arrondissements
	from projet.logement;
quit;

proc sql ;
	create table logement_2 as 
	select	arrondissements, round(mean(ref),0.01) as moyenne_ref
	from logement_1
	group by arrondissements;
quit;

/*jointure */

*avec les commerces;
proc sql ; 
	create table j1 as
	select t1.arrondissements, t1.moyenne_ref, t2.hypermarche, t2.supermarche,
			t2.grande_surface_de_bricolage, t2.superette, t2.epicerie, 
			t2.boulangerie, t2.boucherie_charcuterie, t2.produits_surgeles, 
			t2.poissonnerie, t2.librairie_papeterie_journaux, t2.magasin_de_vetements,
			t2.magasin_d_equipements_du_foyer, t2.magasin_de_chaussures, t2.magasin_d_electromenager_et_de_m,
			t2.magasin_de_meubles, t2.magasin_d_articles_de_sports_et_, t2.magasin_de_revetements_murs_et_s,
			t2.droguerie_quincaillerie_bricolag, t2.parfumerie, t2.horlogerie_bijouterie, t2.fleuriste, 
			t2.magasin_d_optique, t2.station_service
	from logement_2 t1 left join commerces_1 t2 on t1.arrondissements = t2.arrondissements
;quit;

*avec les établissements scolaires;
proc sql ; 
	create table j2 as
	select t1.*, t2.nb_maternelle
	from j1 as t1 left join maternelle_1 as t2 on t1.arrondissements = t2.arrondissements
;quit;

proc sql ; 
	create table j3 as
	select t1.*, t2.nb_elementaire
	from j2 as t1 left join elementaire_1 as t2 on t1.arrondissements = t2.arrondissements
;quit;

proc sql ; 
	create table BDD as
	select t1.*, t2.nb_college
	from j3 as t1 left join college_1 as t2 on t1.arrondissements = t2.arrondissements
;quit;


/* ----- analyse ----- */

/*Meublé avec le prix*/
proc sql ;
	select	meuble_txt,round(mean(ref),0.01) as moyenne_ref
	from logement_1
	group by meuble_txt;
quit;

*vérification de la significativité des résultats;
proc ANOVA data = logement_1 plots(maxpoints = 7680);
	class  meuble_txt   ;
	model  ref =  meuble_txt ;
run;

/*Nombre_piece et le prix*/
proc sql ;
	select	piece,round(mean(ref),0.01) as moyenne_ref
	from logement_1
	group by piece;
quit;

*vérification de la significativité des résultats;
proc ANOVA data = logement_1 plots(maxpoints = 7680);
	class  piece   ;
	model  ref =  piece ;
run;

/*epoque et prix*/
proc sql ;
	select epoque ,round(mean(ref),0.01) as moyenne_ref
	from logement_1
	group by epoque;
quit;

*vérification de la significativité des résultats;
proc ANOVA data = logement_1 plots(maxpoints = 7680);
	class epoque  ;
	model  ref =  epoque ;
run;

/*Prix moyen par arrondissements*/
proc sql; 
select arrondissements, moyenne_ref
	from BDD;
quit;

/*prix moyen par types de commerces et d'établissements scolaires */
proc sql ;
	create table BDD_corr as
	select  moyenne_ref, sum(hypermarche, supermarche) as grande_surface,
			sum(superette, epicerie, boulangerie, boucherie_charcuterie, produits_surgeles, poissonnerie) as alimentaire_proxi ,
			sum(droguerie_quincaillerie_bricolag, grande_surface_de_bricolage, magasin_d_equipements_du_foyer , 
				magasin_d_electromenager_et_de_m, magasin_de_meubles, magasin_de_revetements_murs_et_s) as brico_maison,
			sum(magasin_de_vetements , magasin_de_chaussures) as chaussure_vetement,
			sum(magasin_d_articles_de_sports_et_, librairie_papeterie_journaux) as sport_loisir,
			sum(fleuriste,station_service, magasin_d_optique, horlogerie_bijouterie , parfumerie) as autre,
			nb_maternelle, nb_elementaire, nb_college
	from BDD;
quit;

/*Corrélation entre les variables*/
proc corr data = BDD_corr;
	var _ALL_;
run;

/*Corrélations significatives entre les variables*/
proc corr data = BDD_corr;
	var moyenne_ref grande_surface alimentaire_proxi  
	nb_maternelle nb_elementaire nb_college chaussure_vetement;
run;
	