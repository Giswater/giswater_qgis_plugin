/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
UPDATE sys_feature_cat SET man_table = f.man_table FROM cat_feature_gully f WHERE sys_feature_cat.id=f.type;

ALTER TABLE cat_feature_gully DROP COLUMN man_table;


ALTER TABLE cat_feature_node DROP COLUMN epa_table;
ALTER TABLE cat_feature_arc DROP COLUMN epa_table;

DROP TABLE IF EXISTS inp_node_type;
DROP TABLE IF EXISTS inp_arc_type;

ALTER TABLE IF EXISTS inp_flwreg_type RENAME TO _inp_flwreg_type_;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"cat_node", "column":"value"}}$$);

-- 2021/04/24
ALTER TABLE inp_controls_importinp RENAME TO _inp_controls_importinp_;









