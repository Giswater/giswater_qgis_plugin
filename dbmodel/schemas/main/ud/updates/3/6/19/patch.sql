/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

update gully set muni_id = 0 where muni_id is null;
ALTER TABLE gully alter column muni_id set NOT NULL;
ALTER TABLE gully alter column muni_id set default 0;
