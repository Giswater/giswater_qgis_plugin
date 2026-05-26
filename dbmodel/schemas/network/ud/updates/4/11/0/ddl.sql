/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 21/05/2026
ALTER TABLE node ADD COLUMN has_access BOOLEAN DEFAULT TRUE;
ALTER TABLE omunit DROP COLUMN is_way_in;
ALTER TABLE omunit DROP COLUMN is_way_out;
ALTER TABLE macroomunit DROP COLUMN is_way_in;
ALTER TABLE macroomunit DROP COLUMN is_way_out;
