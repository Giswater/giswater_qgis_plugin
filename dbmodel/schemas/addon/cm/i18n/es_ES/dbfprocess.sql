/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE sys_fprocess AS t SET except_msg = v.except_msg, info_msg = v.info_msg, fprocess_name = v.fprocess_name FROM (
	VALUES
	(100, 'valor nulo en la columna %check_column% de %table_name%.', 'Las %check_column% en %table_name% tienen valores correctos.', 'Comprobar la coherencia de los nulos'),
    (200, 'Hay algunos usuarios sin equipo asignado.', 'Todos los usuarios tienen un equipo asignado.', 'Comprobar la coherencia de los usuarios'),
    (201, 'equipos sin usuarios asignados.', 'Todos los equipos tienen usuarios asignados.', 'Comprobar la coherencia de los equipos'),
    (202, 'Hay algunos nodos huérfanos.', 'No hay nodos huérfanos.', 'Comprobar nodos huérfanos'),
    (203, 'nodos duplicados con el estado 1.', 'No existen nodos duplicados con el estado 1.', 'Comprobar nodos duplicados')
) AS v(fid, except_msg, info_msg, fprocess_name)
WHERE t.fid = v.fid;

