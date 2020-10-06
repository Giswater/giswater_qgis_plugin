/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/09/18
ALTER TABLE inp_demand DROP CONSTRAINT inp_demand_node_id_fkey;
ALTER TABLE inp_demand RENAME node_id TO feature_id;
ALTER TABLE inp_demand RENAME deman_type TO demand_type;
ALTER TABLE inp_demand ADD COLUMN feature_type varchar(16);