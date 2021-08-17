/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/17
ALTER TABLE om_mincut_valve DROP CONSTRAINT IF EXISTS anl_mincut_result_valve_unique_result_node;

ALTER TABLE om_mincut_valve DROP CONSTRAINT IF EXISTS om_mincut_valve_unique_result_node;

ALTER TABLE om_mincut_valve ADD CONSTRAINT om_mincut_valve_unique_result_node UNIQUE(result_id, node_id);
