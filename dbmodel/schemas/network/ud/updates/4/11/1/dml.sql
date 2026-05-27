/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 27/05/2026
DELETE FROM config_function WHERE id = 3424;
DELETE FROM config_function WHERE id = 3066;

UPDATE config_function c SET id = s.id
FROM sys_function s
WHERE c.function_name = s.function_name
AND c.id <> s.id;
