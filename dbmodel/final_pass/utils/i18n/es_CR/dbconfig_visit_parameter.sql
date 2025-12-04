/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_visit_parameter AS t SET descript = v.descript FROM (
	VALUES
	('clean_arc', 'Limpio de arco'),
    ('clean_connec', 'Limpieza de conec'),
    ('clean_gully', 'Limpieza de barranco'),
    ('clean_link', 'Limpieza de enlace'),
    ('defect_arc', 'Defectos de arco'),
    ('defect_connec', 'Defectos de conec'),
    ('defect_gully', 'Defectos de barranco'),
    ('defect_link', 'Defectos de enlace'),
    ('sediments_arc', 'Sedimentos en arco'),
    ('sediments_connec', 'Sedimentos en connec'),
    ('sediments_gully', 'Sedimentos en el barranco'),
    ('sediments_link', 'Sedimentos en enlace'),
    ('smells_gully', 'Huele a barranco'),
    ('clean_node', 'Limpieza de nodo'),
    ('defect_node', 'Defectos del nodo'),
    ('incident_comment', 'comentario_incidente'),
    ('incident_type', 'tipo de incidente'),
    ('insp_observ', 'Observaciones de la inspección'),
    ('photo', 'Fotografía'),
    ('sediments_node', 'Sedimentos en el nodo'),
    ('leak_arc', 'pequeña fuga en el arco'),
    ('leak_connec', 'pequeña fuga en la conexión'),
    ('leak_link', 'pequeña fuga en el enlace')
) AS v(id, descript)
WHERE t.id = v.id;

