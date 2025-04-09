/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Insert into sys_feature_epa_type
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('PUMP', 'FLWREG', 'inp_flwreg_pump', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('WEIR', 'FLWREG', 'inp_flwreg_weir', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('ORIFICE', 'FLWREG', 'inp_flwreg_orifice', NULL, true);
INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('OUTLET', 'FLWREG', 'inp_flwreg_outlet', NULL, true);

-- Adding flowregulator objects on cat_feature [Modified from first version]
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, active) VALUES ('FRORIFICE', 'ORIFICE', 'FLWREG', 'v_edit_flwreg', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, active) VALUES ('FROUTLET', 'VFLWREG', 'FLWREG', 'v_edit_flwreg', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, active) VALUES ('FRWEIR', 'WEIR', 'FLWREG', 'v_edit_flwreg', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, active) VALUES ('FRPUMP', 'PUMP', 'FLWREG', 'v_edit_flwreg', true) ON CONFLICT (id) DO NOTHING;
-- Adding objects on config_info_layer and config_info_layer_x_type (this both tables controls the button info)
INSERT INTO config_info_layer VALUES ('v_edit_flwreg', TRUE, 'flwreg', TRUE, 'info_generic', 'Flow regulator', 4);

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_gully';
