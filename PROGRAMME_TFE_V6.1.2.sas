/* ----------------------------------------------INITIALISATION---------------------------------------------- */
/* CHEMIN REEL DES DOSSIERS */
%let CHEMIN =  D:/TFE/TFE/;
%let MAJ = &CHEMIN.Fichier MAJ.xlsx;
/* ------------------------------------------------LIBRAIRIE------------------------------------------------ */
libname TFE_PROJ "&CHEMIN.";

/* ---------------------------------------------MACRO COMMANDES--------------------------------------------- */

%macro programme(REP);
	/* DECRYPTEUR */ 
	data TFE_PROJ.REP_LIST(keep = nom_de_fichier);
	   rc=filename("mydir","&REP.");
	   did=dopen("mydir");
	   if did > 0 then
	    do i = 1 to dnum(did);
	         nom_de_fichier = dread(did, i);
	         output;
	   	end;
		rc=dclose(did);
	run;

	/* IMPORTATION DU FICHIER MAJ */
	proc import datafile = "&MAJ."
		out		= TFE_PROJ.MAJ
		dbms	= xlsx replace;
	run;
	
	/* COMPTEUR ET INITIALISATION DES PARAMETRES */
	data _null_;
	   set TFE_PROJ.MAJ end = fin ;
		call symputx(CATS("CC", _N_), Code_produit);
		call symputx(CATS("NFICHE", _N_), Num_ro_fiche_EBX);   
		IF fin THEN call symputx("OBS", _N_);
	run;
	%do i = 1 %to &OBS.;
	
		data _null_;
			
			/* CREATION DE LA MACRO VARIABLE FICHIER */
 			data _null_;
				set TFE_PROJ.REP_LIST;
				if substr(nom_de_fichier, 1, 3) = &&CC&i.. then do;
					call symputx("FICHIER", nom_de_fichier);
				end;
			run;
 			
 			/* CONCATENATION DES MACROS CHEMIN ET FICHIER EN MACRO NOTE */
 			%let NOTE = &REP.&FICHIER.;
 			%let NOTENOM = NOTE&&CC&i..;
 			
 			/* VERIFICATION DE L'EXISTENCE DES FICHIERS */
 			%if %sysfunc(exist("TFE_PROJ.NOTENOM")) %then %do;
 				%put "It's there!";
 			%end;
   			%else %do;
	   			/* IMPORTATION DE LA I EME NOTE RECAPITULATIVE */
	 			proc import datafile = "&NOTE."
					out		= TFE_PROJ.&NOTENOM.
					dbms	= xlsx replace;
				run;
	 			/* SUPPRESSION */
	 			proc sql;
					create table &NOTENOM. as select F as NUM_FICHE, K as PROD_TECH
					from TFE_PROJ.&NOTENOM.
					where monotonic() > 4;
				quit;
   			%end;
   			
			/* EXTRACTION */
			data _null_;
				set WORK.&NOTENOM.;
				if NUM_FICHE = &&NFICHE&i.. then do;
					call symputx("CODE", PROD_TECH);
				end;
			run;
			
			/* INSERTION */
 			data TFE_PROJ.MAJ;
				set TFE_PROJ.MAJ;
				if Num_ro_fiche_EBX = &&NFICHE&i.. then Prod_Tech = "&CODE.";
			run;
 		run;
	%end;
%mend programme;

/* -------------------------------------------PROGRAMME PRINCIPAL------------------------------------------- */

%programme(D:/TFE/COMPTA/); /* CHEMIN DE LA COMPTA EN PARAMETRE */
