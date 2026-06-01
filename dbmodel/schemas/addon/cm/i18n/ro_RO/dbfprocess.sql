/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_fprocess AS t SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name FROM (
	VALUES
	(100, 'valoare nulă pe coloana %check_column% din %table_name%.', '%check_column% de pe %table_name% au valori corecte.', 'Verificarea consistenței nulităților'),
    (200, 'Există unii utilizatori cărora nu li s-a atribuit nicio echipă.', 'Toți utilizatorii au atribuită o echipă.', 'Verificarea consistenței utilizatorilor'),
    (201, 'echipe fără utilizatori atribuiți.', 'Toate echipele au utilizatori atribuiți.', 'Verificarea consistenței echipelor'),
    (202, 'Există câteva noduri orfane.', 'Nu există noduri orfane.', 'Verificarea nodurilor orfane'),
    (203, 'noduri dublate cu starea 1.', 'Nu există noduri duplicate cu starea 1', 'Verificarea nodurilor duplicate')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

