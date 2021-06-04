/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/06/04
UPDATE sys_feature_cat SET epa_default = 'CONDUIT' WHERE id = 'SIPHON';
DELETE FROM sys_feature_cat  WHERE id = 'ELEMENT';

UPDATE sys_table SET notify_actions  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "cat_arc"]}]'
WHERE id  = 'cat_feature_arc';
UPDATE sys_table SET notify_actions  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["connec", "cat_connec"]}]'
WHERE id  = 'cat_feature_connec';
UPDATE sys_table SET notify_actions  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["gully", "cat_grate"]}]'
WHERE id  = 'cat_feature_grate';
UPDATE sys_table SET notify_actions  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node", "cat_node"]}]'
WHERE id  = 'cat_feature_node';

UPDATE sys_table SET notify_actions  ='[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"pattern_id","featureType":["v_edit_inp_dwf", "inp_aquifer", "inp_inflows", "inp_inflows_pol_x_node",  "inp_dwf_pol_x_node"]}]'
WHERE id  = 'cat_feature_node';