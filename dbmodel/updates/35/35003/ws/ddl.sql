/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27


ALTER TABLE inp_rules_controls_importinp RENAME TO _inp_rules_controls_importinp_ ;

ALTER TABLE cat_feature_node DROP COLUMN epa_table;
ALTER TABLE cat_feature_arc DROP COLUMN epa_table;

DROP TABLE IF EXISTS inp_node_type;
DROP TABLE IF EXISTS inp_arc_type;


