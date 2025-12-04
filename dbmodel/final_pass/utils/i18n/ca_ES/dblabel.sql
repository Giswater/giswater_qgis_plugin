/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE sys_label AS t SET idval = v.idval FROM (
	VALUES
	(1001, 'INFO'),
    (1002, 'ADVERTIMENT'),
    (1003, 'ERROR'),
    (1004, 'ERRORS CRÍTICS'),
    (1005, 'PISTA'),
    (1006, 'ADVERTIMENT-403'),
    (1007, 'ERROR-403'),
    (1008, 'ERROR-357'),
    (2000, ' '),
    (2007, '-------'),
    (2008, '--------'),
    (2009, '---------'),
    (2010, '----------'),
    (2011, '-----------'),
    (2014, '--------------'),
    (2022, '-----------------------'),
    (2025, '-------------------------'),
    (2030, '-------------------------------'),
    (2049, '-------------------------------------------------'),
    (3001, 'INFO'),
    (3002, 'ADVERTIMENTS'),
    (3003, 'ERRORS'),
    (3006, 'ARC DIVIDE = VERDADER'),
    (3008, 'ARC DIVIDE = FALS'),
    (3009, 'CURRÍCULA'),
    (3010, 'SISTEMA DE VERIFICACIÓ'),
    (3011, 'VERIFICAR LES DADES DE LA BD'),
    (3012, 'DETALLS'),
    (3013, 'Per comprovar ERRORS CRÍTICS o ADVERTIMENTS, executeu una consulta FROM anl_table WHERE fid=número d''error I usuari_actual.Per exemple:  SELECT * FROM MySchema.anl_arc WHERE fid = Myfid AND cur_user=current_user;  Només es poden comprovar d''aquesta manera els errors amb anl_table al costat del número.Amb Giswater Toolbox també és possible comprovar aquests errors.')
) AS v(id, idval)
WHERE t.id = v.id;

