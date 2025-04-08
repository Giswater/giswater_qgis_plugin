/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE arc alter column muni_id set NOT NULL;
ALTER TABLE node alter column muni_id set NOT NULL;
ALTER TABLE connec alter column muni_id set NOT NULL;
ALTER TABLE link alter column muni_id set NOT NULL;

ALTER TABLE arc alter column muni_id set default 0;
ALTER TABLE node alter column muni_id set default 0;
ALTER TABLE connec alter column muni_id set default 0;
ALTER TABLE link alter column muni_id set default 0;
