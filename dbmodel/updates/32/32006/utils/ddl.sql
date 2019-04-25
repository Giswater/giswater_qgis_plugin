/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE audit_cat_table ADD COLUMN sys_roleselect_id varchar (16);

-- 2019/04/19
ALTER TABLE sys_csv2pg_cat ADD COLUMN formname varchar (50);
ALTER TABLE sys_csv2pg_cat ADD COLUMN functionname varchar (50);
ALTER TABLE sys_csv2pg_cat ADD COLUMN isdeprecated boolean;


ALTER TABLE audit_cat_param_user RENAME COLUMN layout_name to layoutname;


