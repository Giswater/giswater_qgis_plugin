/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE sys_label AS t SET idval = v.idval FROM (
	VALUES
	(1001, 'INFO'),
    (1002, 'WARNUNG'),
    (1003, 'ERROR'),
    (1004, 'KRITISCHE FEHLER'),
    (1005, 'HINT'),
    (1006, 'WARNUNG-403'),
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
    (3002, 'WARNUNGEN'),
    (3003, 'FEHLER'),
    (3006, 'ARC DIVIDE = TRUE'),
    (3008, 'ARC DIVIDE = FALSE'),
    (3009, 'RESUME'),
    (3010, 'SYSTEM PRÜFEN'),
    (3011, 'CHECK DB DATA'),
    (3012, 'DETAILS'),
    (3013, 'Um CRITICAL ERRORS oder WARNINGS zu prüfen, führen Sie eine Abfrage FROM anl_table WHERE fid=error number AND current_user aus. Zum Beispiel:  SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;  Nur die Fehler mit anl_table neben der Nummer können auf diese Weise überprüft werden. Mit der Giswater Toolbox ist es auch möglich, diese Fehler zu überprüfen.')
) AS v(id, idval)
WHERE t.id = v.id;

