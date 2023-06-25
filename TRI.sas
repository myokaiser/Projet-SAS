/* MACRO DE TRI */
%macro tri(indice = , nom = );
	proc sort data=WORK.&&TABLE&i.. out=WORK.NEW_&nom._&&TABLE&i.. dupout=WORK.DOUBLE_&nom._&&TABLE&i.. nodupkey; 
		by %scan(&&VAR&i.., &indice.); /* TRI SUR LA PREMIERE VALEUR DE VAR */
	run;
%mend tri;