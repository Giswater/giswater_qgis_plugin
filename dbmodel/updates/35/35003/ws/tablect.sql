/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27

ALTER TABLE cat_feature_arc DROP CONSTRAINT IF EXISTS cat_feature_arc_inp_check;
ALTER TABLE cat_feature_arc ADD CONSTRAINT cat_feature_arc_inp_check 
CHECK (epa_default = ANY(ARRAY['PIPE', 'UNDEFINED', 'PUMP-IMPORTINP', 'VALVE-IMPORTINP', 'VIRTUALVALVE']));
ALTER TABLE cat_feature_node DROP CONSTRAINT IF EXISTS cat_feature_node_inp_check;
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_inp_check 
CHECK (epa_default = ANY(ARRAY['JUNCTION', 'RESERVOIR', 'TANK', 'INLET', 'UNDEFINED', 'SHORTPIPE', 'VALVE', 'PUMP']));

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_epa_type_check;
ALTER TABLE arc ADD CONSTRAINT arc_epa_type_check 
CHECK (epa_type = ANY(ARRAY['PIPE', 'UNDEFINED', 'PUMP-IMPORTINP', 'VALVE-IMPORTINP', 'VIRTUALVALVE']));
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_epa_type_check;
ALTER TABLE node ADD CONSTRAINT node_epa_type_check 
CHECK (epa_type = ANY(ARRAY['JUNCTION', 'RESERVOIR', 'TANK', 'INLET', 'UNDEFINED', 'SHORTPIPE', 'VALVE', 'PUMP']));








