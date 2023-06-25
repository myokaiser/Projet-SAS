/* MACRO D'EXPORTATION DES FICHIERS */
%macro exportation;
	%put "PAS DE DOUBLONS DETECTES, CREATION DU FICHIER &&TABLE&i.._&datenow._&timenow..%scan(&&TYPE&i.., 1)";
	proc export data = WORK.&&TABLE&i..
		outfile 	= "&CHEMIN_FICHIER.&&TABLE&i.._&datenow._&timenow..%scan(&&TYPE&i.., 1)"
		dbms 		= %scan(&&TYPE&i.., 2) replace;
		delimiter 	= &&DEL&i..;
	run;
%mend exportation;