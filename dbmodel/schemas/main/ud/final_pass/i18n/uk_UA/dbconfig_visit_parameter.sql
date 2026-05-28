/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_visit_parameter AS t SET descript = v.descript FROM (
	VALUES
	('clean_arc', 'Очищення дуги'),
    ('clean_connec', 'Очищення з''єднання'),
    ('clean_gully', 'Очищення ливнеприймальника'),
    ('clean_link', 'Очищення лінії'),
    ('defect_arc', 'Дефекти дуги'),
    ('defect_connec', 'Дефекти з''єднання'),
    ('defect_gully', 'Дефекти ливнеприймальника'),
    ('defect_link', 'Дефекти лінії'),
    ('sediments_arc', 'Відкладення в дузі'),
    ('sediments_connec', 'Відкладення в з''єднанні'),
    ('sediments_gully', 'Відкладення в ливнеприймальнику'),
    ('sediments_link', 'Відкладення в лінії'),
    ('smells_gully', 'Неприємні запахи в ливнеприймальнику'),
    ('clean_node', 'Очищення вузла'),
    ('defect_node', 'Дефекти вузла'),
    ('incident_comment', 'коментар_інциденту'),
    ('incident_type', 'тип інциденту'),
    ('insp_observ', 'Зауваження інспекції'),
    ('photo', 'Фотографія'),
    ('sediments_node', 'Відкладення у вузлі')
) AS v(id, descript)
WHERE t.id = v.id;

