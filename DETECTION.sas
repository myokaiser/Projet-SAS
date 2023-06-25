/* MACRO DE DETECTION */
%macro detecteur(nomvar = , nomtable = );
	proc sql;
		select count(*) 
		into :double /* VARIABLE CONTENANT LE NB DE LIGNES DE LA TABLE DOUBLE_XXX_YYY */
		from WORK.DOUBLE_&nomtable._&&TABLE&i..;
	quit;
	%global &nomvar.; /* CREATION D'UNE VARIABLE GLOBALE POUR EXTRAIRE LA VALEUR DE LA VARIABLE LOCALE */
	%let  &nomvar. = &double.;
%mend detecteur;