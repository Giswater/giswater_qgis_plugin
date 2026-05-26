/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE sys_label AS t SET idval = v.idval FROM (
	VALUES
	(1001, 'INFO'),
    (1002, 'OSTRZEŻENIE'),
    (1003, 'BŁĄD'),
    (1004, 'BŁĘDY KRYTYCZNE'),
    (1005, 'WSKAZÓWKA'),
    (1006, 'WARNING-403'),
    (1007, 'ERROR-403'),
    (1008, 'ERROR-357'),
    (2000, ' '),
    (2007, '-------'),
    (2008, '--------'),
    (2009, '---------'),
    (2010, '----------'),
    (2011, '-----------'),
    (2014, '--------------'),
    (2022, '----------------------'),
    (2025, '-------------------------'),
    (2030, '------------------------------'),
    (2049, '-------------------------------------------------'),
    (3001, 'INFO'),
    (3002, 'OSTRZEŻENIA'),
    (3003, 'BŁĘDY'),
    (3006, 'ARC DIVIDE = TRUE'),
    (3008, 'ARC DIVIDE = FALSE'),
    (3009, 'CV'),
    (3010, 'SYSTEM KONTROLI'),
    (3011, 'SPRAWDŹ DANE DB'),
    (3012, 'SZCZEGÓŁY'),
    (3013, 'Aby sprawdzić KRYTYCZNE BŁĘDY lub OSTRZEŻENIA, wykonaj zapytanie FROM anl_table WHERE fid=numer błędu AND current_user. Na przykład:  SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;  W ten sposób można sprawdzić tylko błędy z anl_table obok numeru. Za pomocą Giswater Toolbox można również sprawdzić te błędy.')
) AS v(id, idval)
WHERE t.id = v.id;

