/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/04
UPDATE sys_feature_cat SET epa_default = 'CONDUIT' WHERE id = 'SIPHON';

UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "cat_arc"]}]'
WHERE id  = 'cat_feature_arc';
UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["connec", "cat_connec"]}]'
WHERE id  = 'cat_feature_connec';
UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["gully", "cat_grate"]}]'
WHERE id  = 'cat_feature_grate';
UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node", "cat_node"]}]'
WHERE id  = 'cat_feature_node';

UPDATE sys_table SET notify_action  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"pattern_id","featureType":["v_edit_inp_dwf", "inp_aquifer", "inp_inflows", "inp_inflows_pol_x_node",  "inp_dwf_pol_x_node"]}]'
WHERE id  = 'inp_pattern';

UPDATE inp_typevalue SET idval = 'BIO-RETENTION CELL' WHERE id = 'BC';
UPDATE inp_typevalue SET idval = 'GREEN ROOF (5.1)' WHERE id = 'GR';
UPDATE inp_typevalue SET idval = 'INFILTRATION TRENCH' WHERE id = 'IT';
UPDATE inp_typevalue SET idval = 'PERMEABLE PAVEMENT' WHERE id = 'PP';
UPDATE inp_typevalue SET idval = 'RAIN BARREL' WHERE id = 'RB';
UPDATE inp_typevalue SET idval = 'VEGETATIVE SWALE' WHERE id = 'VS';

INSERT INTO inp_typevalue values ('inp_value_lidcontrol', 'RG', 'RAIN GARDEN (5.1)');
INSERT INTO inp_typevalue values ('inp_value_lidcontrol', 'RD', 'ROOFTOP DISCONNECTION (5.1)');

INSERT INTO sys_fprocess VALUES (383,'Check missed values for cat_mat.arc n used on real arcs', 'ud');