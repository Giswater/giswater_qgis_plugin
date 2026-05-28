/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE sys_label AS t SET idval = v.idval FROM (
	VALUES
	(1001, 'INFO'),
    (1002, 'ADVERTENCIA'),
    (1003, 'ERROR'),
    (1004, 'ERRORES CRÍTICOS'),
    (1005, 'CONSEJO'),
    (1006, 'ADVERTENCIA-403'),
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
    (3002, 'ADVERTENCIAS'),
    (3003, 'ERRORES'),
    (3006, 'ARC DIVIDE = TRUE'),
    (3008, 'ARC DIVIDE = FALSE'),
    (3009, 'RESUMEN'),
    (3010, 'VERIFICACIÓN DE SISTEMA'),
    (3011, 'COMPROBAR DATOS DE BASE DE DATOS'),
    (3012, 'DETALLES'),
    (3013, 'Para comprobar ERRORES CRÍTICOS o ADVERTENCIAS, ejecute una consulta FROM anl_table WHERE fid=error de error AND usuario_actual. Por ejemplo:  SELECT * FROM anl_arc WHERE fid = 103 AND cur_user=current_user;  Sólo los errores con anl_table al lado del número se pueden comprobar de esta manera. Utilizando Giswater Toolbox también es posible comprobar estos errores.')
) AS v(id, idval)
WHERE t.id = v.id;

