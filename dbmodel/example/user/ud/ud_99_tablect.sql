/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


ALTER TABLE gully ALTER COLUMN inventory SET NOT NULL;
ALTER TABLE gully ALTER COLUMN state_type SET NOT NULL;
ALTER TABLE gully ALTER COLUMN workcat_id SET NOT NULL;
--ALTER TABLE gully ALTER COLUMN builtdate SET NOT NULL;
ALTER TABLE gully ALTER COLUMN verified SET NOT NULL;
ALTER TABLE gully ALTER COLUMN code SET NOT NULL;
ALTER TABLE gully ALTER COLUMN the_geom SET NOT NULL;
