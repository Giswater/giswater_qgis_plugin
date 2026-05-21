/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE value_result_type AS t SET idval = v.idval FROM (
	VALUES
	('GLOBAL', 'GLOBAL'),
    ('SELECTION', 'SELECCIÓ')
) AS v(id, idval)
WHERE t.id = v.id;

UPDATE value_status AS t SET idval = v.idval FROM (
	VALUES
	('CANCELED', 'CANCELAT'),
    ('FINISHED', 'ACABAT'),
    ('ON PLANNING', 'SOBRE LA PLANIFICACIÓ')
) AS v(id, idval)
WHERE t.id = v.id;

