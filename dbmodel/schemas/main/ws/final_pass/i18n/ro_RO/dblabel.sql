/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE sys_label AS t SET idval = v.idval FROM (
	VALUES
	(1001, 'INFO'),
    (1002, 'AVERTISMENT'),
    (1003, 'ERROR'),
    (1004, 'ERORI CRITICE'),
    (1005, 'SFAT'),
    (1006, 'AVERTISMENT-403'),
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
    (3002, 'AVERTISMENTE'),
    (3003, 'ERORI'),
    (3006, 'ARC DIVIDE = TRUE'),
    (3008, 'ARC DIVIDE = FALS'),
    (3009, 'CV'),
    (3010, 'SISTEM DE VERIFICARE'),
    (3011, 'CHECK DB DATA'),
    (3012, 'DETALII'),
    (3013, 'Pentru a verifica ERORI CRITICE sau AVERTIZĂRI, executați o interogare FROM anl_table WHERE fid=numărul erorii AND current_user. De exemplu:  SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;  Numai erorile cu anl_table alături de număr pot fi verificate în acest fel. Folosind Giswater Toolbox este de asemenea posibil să verificați aceste erori.')
) AS v(id, idval)
WHERE t.id = v.id;

