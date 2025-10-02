/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

WITH numbered AS (
    SELECT id,
        typevalue,
        (ROW_NUMBER() OVER (ORDER BY id)) - 1 AS new_id
    FROM config_typevalue
    WHERE typevalue = 'sys_table_context'
)
UPDATE config_typevalue c
SET idval = c.id, id = n.new_id
FROM numbered n
WHERE c.id = n.id AND c.typevalue = n.typevalue AND c.typevalue = 'sys_table_context';

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle, addparam) VALUES('widgettype_typevalue', 'valuerelation', 'valuerelation', 'valuerelation', NULL);
