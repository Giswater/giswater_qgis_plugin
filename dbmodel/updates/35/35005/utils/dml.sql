/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/11
INSERT INTO config_param_system(parameter, value, descript,  project_type, datatype, label, isenabled, dv_isparent, isautoupdate, widgettype,
ismandatory, iseditable, layoutname, layoutorder)
VALUES ('edit_arc_divide', '{"setArcObsolete":"true","setOldCode":"false"}', 
'Configuration of arc divide tool. If setArcObsolete true state of old arc would be set to 0, otherwise arc will be deleted. If setOldCode true, new arcs will have same code as old arc.',
'utils', 'json', 'Arc divide:', true, false, false, 'linetext', true, true, 'lyt_topology', 18 ) ON CONFLICT (parameter) DO NOTHING;

--2021/05/11
UPDATE man_type_location set featurecat_id=NULL WHERE featurecat_id in ('{NODE}','{CONNEC}','{ARC}','{GULLY}');
UPDATE man_type_category set featurecat_id=NULL WHERE featurecat_id in ('{NODE}','{CONNEC}','{ARC}','{GULLY}');
UPDATE man_type_function set featurecat_id=NULL WHERE featurecat_id in ('{NODE}','{CONNEC}','{ARC}','{GULLY}');
UPDATE man_type_fluid set featurecat_id=NULL WHERE featurecat_id in ('{NODE}','{CONNEC}','{ARC}','{GULLY}');


INSERT INTO sys_function (id, function_name, project_type, function_type, sys_role) VALUES (3034, 'gw_fct_pg2epa_autorepair_epatype', 'utils', 'function', 'role_epa');

UPDATE config_toolbox SET inputparams = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":"$userInpResult"}]'
WHERE id = 2680;

UPDATE config_toolbox SET inputparams = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":"$userInpResult"}]'
WHERE id = 2848;

--2021/05/18
UPDATE sys_table SET notify_action=
'[{"channel":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"expl_id, name","featureType":["arc", "node", "connec","v_edit_element", "v_edit_samplepoint","v_edit_pond", "v_edit_pool", "v_edit_dma", "v_edit_presszone", "v_ext_plot","v_ext_streetaxis", "v_ext_address"]}]'
WHERE id='exploitation';
