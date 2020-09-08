/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/14
UPDATE config_param_system SET project_type = 'ws' WHERE parameter = 'om_mincut_enable_alerts';

--2020/08/04
INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2994, 'gw_fct_vnode_repair', 'utils', 'function')ON CONFLICT (id) DO NOTHING;


INSERT INTO config_toolbox VALUES (2496, 'Arc repair', TRUE, '{"featureType":["arc"]}', NULL, NULL, TRUE);

INSERT INTO sys_param_user(id, formname, descript, sys_role, label, isenabled, layoutorder, project_type, isparent, 
isautoupdate, datatype, widgettype, ismandatory, layoutname, iseditable, isdeprecated, vdefault)
VALUES ('edit_element_doublegeom', 'config', 'If value, overwrites trigger element value to create double geometry in case elementcat_id is defined with this attribute',
'role_edit', 'Doublegeometry value for element:', TRUE, 11, 'utils', FALSE, FALSE, 'boolean', 'check', FALSE, 'lyt_inventory',
TRUE, FALSE, 2) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type) 
VALUES (2996, 'gw_trg_edit_element_pol', 'utils', 'function')ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox VALUES (2522, 'Import epanet inp file', TRUE, '{"featureType":[]}', '[{"widgetname":"useNode2arc", "label":"Create node2arc:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"false"}]', null, TRUE);
INSERT INTO config_toolbox VALUES (2524, 'Import swmm inp file', TRUE, '{"featureType":[]}', '[{"widgetname":"createSubcGeom", "label":"Create subcatchments geometry:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"}]', null, TRUE);

INSERT INTO config_typevalue (typevalue, id, idval, camelstyle) VALUES ('datatype_typevalue', 'text', 'text', 'text')
ON CONFLICT (typevalue, id) DO NOTHING;

update sys_param_user SET id = concat(sys_param_user.id, 'edit_addfield_') 
FROM sys_addfields WHERE sys_param_user.id = concat(param_name,'_',lower(cat_feature_id),'_vdefault');
