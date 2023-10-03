/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE IF EXISTS link ADD CONSTRAINT link_workcat_id_fkey FOREIGN KEY (workcat_id)
REFERENCES cat_work (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE IF EXISTS link ADD CONSTRAINT link_workcat_id_end_fkey FOREIGN KEY (workcat_id_end)
REFERENCES cat_work (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE IF EXISTS link ADD CONSTRAINT link_connecat_id_fkey FOREIGN KEY (connecat_id)
REFERENCES cat_connec (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
