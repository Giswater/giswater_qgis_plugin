/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE audit_cat_table SET sys_role_id='role_basic' WHERE id='config_param_user';
UPDATE audit_cat_table SET sys_role_id='role_basic' WHERE id='config_param_system';


--2019/02/11
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('epa_units_factor', 
'{"LPS":1, "LPM":60, "MLD":0.216, "CMH":3.6, "CMD":3.6, "CMD":86.4, "CFS":0, "GPM":0, "MGD":0, "IMGD":0, "AFD":0}', 'json', 'Epa', 'Conversion factors of CRM flows in function of EPA units choosed by user');

-- 2019/01/26
DELETE FROM config_client_forms WHERE table_id='v_ui_anl_mincut_result_cat' AND column_id='macroexpl_id' AND column_index=8;
UPDATE  config_client_forms SET status=false WHERE table_id='v_ui_anl_mincut_result_cat' AND column_index=2;

-- 2019/02/01
ALTER TABLE anl_mincut_cat_state DROP CONSTRAINT IF EXISTS anl_mincut_cat_state_check;
INSERT INTO anl_mincut_cat_state VALUES (3, 'Canceled');

INSERT INTO audit_cat_param_user VALUES ('manholecat_vdefault', 'config', 'Default value for manhole element parameter', 'role_edit', null, 'manholecat_vdefault:', 'id', 'SELECT cat_node.id FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''MANHOLE'' AND cat_node.id=', 'text');
INSERT INTO audit_cat_param_user VALUES ('waterwellcat_vdefault', 'config', 'Default value for waterwell element parameter', 'role_edit', null, 'waterwellcat_vdefault:', 'id', 'SELECT cat_node.id FROM cat_node JOIN node_type ON node_type.id=nodetype_id WHERE type=''WATERWELL'' AND cat_node.id=', 'text');


--2019/02/08
INSERT INTO audit_cat_param_user VALUES ('psector_type_vdefault', 'config', 'Default value for psector type parameter', 'role_master', NULL, 'psector_type_vdefault:');
INSERT INTO audit_cat_param_user VALUES ('owndercat_vdefault', 'config', 'Default value for owner parameter', 'role_edit', NULL, 'owndercat_vdefault:');
DELETE FROM config_param_user WHERE parameter='qgis_template_folder_path';

-- 2019/02/12
INSERT INTO config_param_system (parameter, value, data_type, context, descript) VALUES ('code_vd', 'No code', 'string', 'OM', 'UD');
UPDATE config_param_system SET descript='Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status (WS)' WHERE parameter='om_mincut_valvestat_using_valveunaccess';
UPDATE config_param_system SET descript='Variable to enable/disable the debug messages of mincut (WS)' WHERE parameter='om_mincut_debug';
