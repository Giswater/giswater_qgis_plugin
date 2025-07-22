/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE link DROP constraint if exists  link_sector_id;

ALTER TABLE link DROP constraint if exists link_muni_id;

ALTER TABLE link ADD CONSTRAINT link_sector_id_fkey FOREIGN KEY (sector_id) 
REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;