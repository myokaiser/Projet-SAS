/* MACRO DE REPERAGE DES NOMS DES DOUBLONS */
%macro identification_doublon(critere = );
	%let double1=; %let double2=; /* A CHAQUE APPEL DE LA MACRO, DOUBLE EST NETTOYEE */
	%do indice = 1 %to &critere.;
		proc sql;
			select %scan(&&VAR&i.., &indice.)
			into :double&indice. separated by ", " /* IDENTIFICATION DES DOUBLONS DE PROD */
			from WORK.&&TABLE&i..
			group by %scan(&&VAR&i.., &indice.)
			having count(%scan(&&VAR&i.., &indice.)) >= 2;
		quit;
	%end;
	
	%if &critere. = 1 %then %do;
		%put "ATTENTION, DETECTION DE DOUBLONS POUR LES VALEURS SUIVANTES :";
		%put "&&VAR&i..: &double1.";
		%put "ARRET DE L'EXPORTATION DE &&TABLE&i.._&datenow._&timenow..%scan(&&TYPE&i.., 1)";
	%end;
	%else %do;
		%put "ATTENTION, DETECTION DE DOUBLONS POUR LES VALEURS SUIVANTES :";
		%put "%scan(&&VAR&i.., 1): &double1.";
		%put "%scan(&&VAR&i.., 2): &double2.";
		%put "ARRET DE L'EXPORTATION DE &&TABLE&i.._&datenow._&timenow..%scan(&&TYPE&i.., 1)";
	%end;
%mend identification_doublon;