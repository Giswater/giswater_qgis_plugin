/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/21
ALTER TABLE config_graf_valve DROP CONSTRAINT config_mincut_valve_id_fkey;

ALTER TABLE config_graf_valve ADD CONSTRAINT config_mincut_valve_id_fkey FOREIGN KEY (id)
REFERENCES cat_feature_node (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
