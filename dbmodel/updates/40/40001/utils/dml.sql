/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM sys_table WHERE id IN ('vp_basic_arc', 'vp_basic_node', 'vp_basic_connec', 'vp_basic_gully');

UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_node';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_connec';
UPDATE config_info_layer SET is_parent=false, tableparent_id=NULL WHERE layer_id='v_edit_arc';

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('SERVCONNECTION', 'LINK', 'UNDEFINED', 'man_servconnection');

INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('FLWREG', 'ELEMENT', 'UNDEFINED', 'man_flwreg');
INSERT INTO sys_feature_class (id, "type", epa_default, man_table) VALUES('GENELEMENT', 'ELEMENT', 'UNDEFINED', 'man_genelement');


DELETE FROM cat_feature WHERE id = 'LINK';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source") VALUES(3286, 'arc_id column cannot be modified when state = 0 on plan_psector %psector_id%.', '', 2, true, 'utils', 'core');

INSERT INTO sys_feature_epa_type (id, feature_type, epa_table, descript, active) VALUES('PUMP', 'ELEMENT', 'inp_flwreg_pump', NULL, true);

INSERT INTO config_typevalue (typevalue, id, camelstyle, idval, addparam) VALUES('sys_table_context', '{"level_1":"INVENTORY","level_2":"NETWORK","level_3":"ELEMENT"}', NULL, NULL, '{"orderBy":89}'::json);


INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer, active) VALUES ('FRPUMP', 'FLWREG', 'ELEMENT', 'v_edit_element', 've_elem_frpump', true) ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature (id, feature_class, feature_type, parent_layer, child_layer) SELECT upper(REPLACE(id, ' ', '_')), 'GENELEMENT', 'ELEMENT', 'v_edit_element', concat('ve_elem_', lower(REPLACE(id, ' ', '_'))) FROM element_type ON CONFLICT (id) DO NOTHING;
