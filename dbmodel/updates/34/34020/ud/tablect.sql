/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

      
ALTER TABLE temp_csv DROP CONSTRAINT IF EXISTS temp_csv2pg_csv2pgcat_id_fkey2;

ALTER TABLE element_x_gully DROP CONSTRAINT IF EXISTS element_x_gully_unique;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_unique UNIQUE(element_id, gully_id);