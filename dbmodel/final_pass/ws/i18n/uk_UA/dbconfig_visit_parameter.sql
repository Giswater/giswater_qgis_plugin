/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_visit_parameter AS t SET descript = v.descript FROM (
	VALUES
	('clean_node', 'Очищення вузла'),
    ('defect_node', 'Дефекти вузла'),
    ('incident_comment', 'коментар_інциденту'),
    ('incident_type', 'тип інциденту'),
    ('insp_observ', 'Зауваження інспекції'),
    ('photo', 'Фотографія'),
    ('sediments_node', 'Відкладення у вузлі'),
    ('leak_arc', 'невелика теча на дузі'),
    ('leak_connec', 'невелика теча на з''єднанні'),
    ('leak_link', 'невелика теча на лінії')
) AS v(id, descript)
WHERE t.id = v.id;

