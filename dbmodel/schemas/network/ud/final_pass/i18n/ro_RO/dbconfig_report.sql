/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_report AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(100, 'Lungimea conductei în funcție de exploatare și catalog', NULL),
    (101, 'Conexiuni prin exploatare', NULL),
    (105, 'Noduri în funcție de exploatare și tip', NULL)
) AS v(id, alias, descript)
WHERE t.id = v.id;

