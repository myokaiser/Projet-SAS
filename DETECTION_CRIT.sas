%macro bdd_detecteur_crit(sasnomvar =, bddnomvar = , nomtable = , critere = );
	%let crit1=; %let crit2=; /* A CHAQUE APPEL DE LA MACRO, CRIT EST NETTOYEE */
	%do i = 1 %to &critere.;
		proc sql;
			select '"' || %scan(&sasnomvar., &i.) || '"'
			into :chaine separated by ", "
			from WORK.&nomtable.;
	
			select %scan(&bddnomvar., &i.)
			into :crit&i. separated by ", "
			from TFE_PROJ.&nomtable.
			where %scan(&bddnomvar., &i.) IN (&chaine.);
		quit;
	%end;
	
	%if &crit1. = and &crit2. = %then %do; /* CONDITION D'AFFICHAGE DU MESSAGE */
		%put "INCLUSION POSSIBLE AVEC LA BASE DE DONNEES &nomtable.";
	%end;
	%else %do;
		%if &critere. = 1 %then %do;
			%put "INCLUSION IMPOSSIBLE AVEC LA BASE DE DONNEES &nomtable., DETECTION DE DOUBLONS";
			%put "%scan(&sasnomvar., 1): &crit1.";
		%end;
		%else %do;
			%put "INCLUSION IMPOSSIBLE AVEC LA BASE DE DONNEES &nomtable., DETECTION DE DOUBLONS";
			%put "%scan(&sasnomvar., 1): &crit1.";
			%put "%scan(&sasnomvar., 2): &crit2.";
		%end;
	%end;
%mend bdd_detecteur_crit;