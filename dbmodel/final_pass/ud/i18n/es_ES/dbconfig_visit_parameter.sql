/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_visit_parameter AS t SET descript = v.descript FROM (
	VALUES
	('clean_arc', 'Limpieza de arco'),
    ('clean_connec', 'Limpieza de conexión'),
    ('clean_gully', 'Limpieza de cuneta'),
    ('clean_link', 'Limpieza de enlace'),
    ('defect_arc', 'Defectos de arco'),
    ('defect_connec', 'Defectos de conexión'),
    ('defect_gully', 'Defectos de cuneta'),
    ('defect_link', 'Defectos de enlace'),
    ('sediments_arc', 'Sedimentos en arco'),
    ('sediments_connec', 'Sedimentos en conexión'),
    ('sediments_gully', 'Sedimentos en cuneta'),
    ('sediments_link', 'Sedimentos en enlace'),
    ('smells_gully', 'Olores de cuneta'),
    ('clean_node', 'Limpieza de nodo'),
    ('defect_node', 'Defectos de nodo'),
    ('incident_comment', 'comentario_incidente'),
    ('incident_type', 'tipo de incidente'),
    ('insp_observ', 'Observaciones de inspección'),
    ('photo', 'Fotografía'),
    ('sediments_node', 'Sedimentos en nodo')
) AS v(id, descript)
WHERE t.id = v.id;

