/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/27
ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_epa_default_fkey;
ALTER TABLE cat_feature_arc DROP CONSTRAINT cat_feature_arc_epa_default_fkey;

ALTER TABLE cat_feature_arc ADD CONSTRAINT cat_feature_arc_inp_check 
CHECK (epa_default = ANY(ARRAY['CONDUIT', 'WEIR', 'ORIFICE', 'VIRTUAL', 'PUMP', 'OUTLET', 'NOT DEFINED', 'UNDEFINED']));
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_inp_check 
CHECK (epa_default = ANY(ARRAY['JUNCTION', 'STORAGE', 'DIVIDER', 'OUTFALL', 'NOT DEFINED', 'UNDEFINED']));

ALTER TABLE arc ADD CONSTRAINT arc_epa_type_check 
CHECK (epa_type = ANY(ARRAY['CONDUIT', 'WEIR', 'ORIFICE', 'VIRTUAL', 'PUMP', 'OUTLET', 'NOT DEFINED', 'UNDEFINED']));
ALTER TABLE node ADD CONSTRAINT node_epa_type_check 
CHECK (epa_type = ANY(ARRAY['JUNCTION', 'STORAGE', 'DIVIDER', 'OUTFALL', 'NOT DEFINED', 'UNDEFINED']));

ALTER TABLE node DROP CONSTRAINT node_epa_type_fkey ;
ALTER TABLE arc DROP CONSTRAINT arc_epa_type_fkey ;


ALTER TABLE cat_feature_arc DROP CONSTRAINT cat_feature_arc_inp_check;
ALTER TABLE cat_feature_arc ADD CONSTRAINT cat_feature_arc_inp_check 
CHECK (epa_default = ANY(ARRAY['CONDUIT', 'WEIR', 'ORIFICE', 'VIRTUAL', 'PUMP', 'OUTLET', 'UNDEFINED']));
ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_inp_check;
ALTER TABLE cat_feature_node ADD CONSTRAINT cat_feature_node_inp_check 
CHECK (epa_default = ANY(ARRAY['JUNCTION', 'STORAGE', 'DIVIDER', 'OUTFALL', 'UNDEFINED']));

ALTER TABLE arc DROP CONSTRAINT arc_epa_type_check;
ALTER TABLE arc ADD CONSTRAINT arc_epa_type_check 
CHECK (epa_type = ANY(ARRAY['CONDUIT', 'WEIR', 'ORIFICE', 'VIRTUAL', 'PUMP', 'OUTLET', 'UNDEFINED']));
ALTER TABLE node DROP CONSTRAINT node_epa_type_check;
ALTER TABLE node ADD CONSTRAINT node_epa_type_check 
CHECK (epa_type = ANY(ARRAY['JUNCTION', 'STORAGE', 'DIVIDER', 'OUTFALL', 'UNDEFINED']));
