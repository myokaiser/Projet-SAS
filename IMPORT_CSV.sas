%macro import_csv(CHEMIN = , NOM = );
	proc import datafile = "&CHEMIN."
		out		= TFE_PROJ.&NOM.
		dbms	= csv replace;
		delimiter = ";";
	run;
%mend;