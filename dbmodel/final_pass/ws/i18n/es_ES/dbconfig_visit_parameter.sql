/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_visit_parameter AS t SET descript = v.descript FROM (
	VALUES
	('clean_node', 'Limpieza de nodo'),
    ('defect_node', 'Defectos de nodo'),
    ('incident_comment', 'comentario_incidente'),
    ('incident_type', 'tipo de incidente'),
    ('insp_observ', 'Observaciones de inspección'),
    ('photo', 'Fotografía'),
    ('sediments_node', 'Sedimentos en nodo'),
    ('leak_arc', 'fuga menor en arco'),
    ('leak_connec', 'fuga menor en conexión'),
    ('leak_link', 'fuga menor en enlace')
) AS v(id, descript)
WHERE t.id = v.id;

