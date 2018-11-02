/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2018/10/05
ALTER TABLE anl_node ADD COLUMN arc_distance numeric(12,3);
ALTER TABLE anl_node ADD COLUMN arc_id varchar(16);


-- 2018/10/23
ALTER TABLE plan_psector_cat_type DROP CONSTRAINT IF EXISTS plan_psector_cat_type_check;
ALTER TABLE plan_psector_cat_type ADD CONSTRAINT plan_psector_cat_type_check CHECK (id = 1);