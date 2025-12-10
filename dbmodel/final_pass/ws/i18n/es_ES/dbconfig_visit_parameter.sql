/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_visit_parameter AS t SET descript = v.descript FROM (
	VALUES
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

