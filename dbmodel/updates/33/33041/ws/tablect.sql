/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE anl_mincut_selector_valve DROP CONSTRAINT anl_mincut_selector_valve_id_fkey;

ALTER TABLE anl_mincut_selector_valve ADD CONSTRAINT anl_mincut_selector_valve_id_fkey FOREIGN KEY (id)
REFERENCES node_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
