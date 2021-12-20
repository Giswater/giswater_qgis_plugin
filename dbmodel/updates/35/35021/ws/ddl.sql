/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/02
ALTER TABLE config_user_x_sector DROP CONSTRAINT config_user_x_sector_sector_id_fkey;
ALTER TABLE config_user_x_sector ADD CONSTRAINT config_user_x_sector_sector_id_fkey FOREIGN KEY (sector_id)
REFERENCES sector (sector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
