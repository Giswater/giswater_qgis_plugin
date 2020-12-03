/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table set sys_role_id='role_basic' WHERE id='config_param_user';

UPDATE audit_cat_param_user SET layout_id=5,layout_order=1 where id='elementcat_vdefault';
UPDATE audit_cat_param_user SET layout_id=12,layout_order=1 where id='connecat_vdefault';
UPDATE audit_cat_param_user SET layout_order=2 where id='connecarccat_vdefault';
UPDATE audit_cat_param_user SET layout_id=12,layout_order=3 where id='gullycat_vdefault';
UPDATE audit_cat_param_user SET layout_id=12,layout_order=4 where id='gratecat_vdefault';