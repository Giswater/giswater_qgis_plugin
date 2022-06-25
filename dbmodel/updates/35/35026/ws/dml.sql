/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
update config_toolbox
set inputparams='[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""},
{"widgetname":"descript", "label":"Descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5,"value":""}]' 
WHERE id=3108;

UPDATE om_mincut_node SET node_type=nodetype_id FROM node JOIN cat_node cn ON cn.id=nodecat_id WHERE node.node_id=om_mincut_node.node_id;
UPDATE om_mincut_connec SET customer_code=a.customer_code FROM connec a WHERE a.connec_id=om_mincut_connec.connec_id;

INSERT INTO config_param_system(parameter, value, descript, label,
isenabled, layoutorder, project_type, dv_isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable, layoutname)
SELECT 'om_mincut_config',json_build_object('version', p1.value, 'usePgrouting', p2.value::boolean) as value,
'Mincut system config. version - Mincut version; usePgrouting - Different ways to use mincut.If true, mincut is done with pgrouting, an extension of Postgis.',
'Mincut system config', TRUE, 1,'ws', false, false,'json', 'linetext', true,true,'lyt_admin_om'
FROM config_param_system p1 ,config_param_system p2
WHERE p1.parameter='om_mincut_version' and p2.parameter='om_mincut_use_pgrouting' ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system(parameter, value, descript, label,
isenabled, layoutorder, project_type, dv_isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable, layoutname)
SELECT 'om_mincut_debug',json_build_object('status', value::boolean) as value,concat(descript), 'Mincut debug',
isenabled, layoutorder, project_type, dv_isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable, layoutname
FROM config_param_system
WHERE parameter='admin_debug' ON CONFLICT (parameter) DO NOTHING;

INSERT INTO config_param_system(parameter, value, descript, label,
isenabled, layoutorder, project_type, dv_isparent, isautoupdate, datatype, widgettype, ismandatory, iseditable, layoutname)
SELECT 'om_mincut_settings',json_build_object('valveStatusUnaccess', p1.value::boolean,'redoOnStart',json_build_object('status',false,'days',0)) as value,
'Mincut settings. valveStatus - Variable to enable/disable the possibility to use valve unaccess button to open valves with closed status ; redoOnStart - If true, on starting the mincut the process will be recalculated if the indicated number of days since receving the mincut has passed.',
'Mincut settings', TRUE, 4,'ws', false, false,'json', 'linetext', true,true,'lyt_admin_om'
FROM config_param_system p1
WHERE p1.parameter='om_mincut_valvestatus_unaccess' ON CONFLICT (parameter) DO NOTHING;

DELETE FROM config_param_system WHERE parameter='om_mincut_version' or parameter='om_mincut_use_pgrouting' or parameter='om_mincut_valve2tank_traceability' or 
parameter='om_mincut_disable_check_temporary_overlap' or parameter='om_mincut_valvestatus_unaccess' OR parameter='admin_debug';


update config_toolbox
set inputparams='
[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}, 
{"widgetname":"period", "label":"Source CRM period:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":6, "dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "selectedId":""},
{"widgetname":"pattern", "label":"Feature pattern:","widgettype":"combo","tooltip":"This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.", "datatype":"text","layoutname":"grl_option_parameters","layoutorder":7,"comboIds":[1,2,3,4,5,6], "comboNames":["NONE", "SECTOR-DEFAULT", "DMA-DEFAULT", "DMA-PERIOD","HYDROMETER-PERIOD","HYDROMETER-CATEGORY"], "selectedId":""}, 
{"widgetname":"demandUnits", "label":"Demand units:","tooltip": "Choose units to insert volume data on demand column. <br> This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8 ,"comboIds":["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"], "comboNames":["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"], "selectedId":""}]'
WHERE id=3110;

--2022/06/14
UPDATE sys_table
	SET orderby=10,context='{"level_1":"EPA","level_2":"DSCENARIO"}',alias='Connec Dscenario'
	WHERE id='v_edit_inp_dscenario_connec';
UPDATE sys_table
	SET orderby=11,context='{"level_1":"EPA","level_2":"DSCENARIO"}',alias='Junction Dscenario'
	WHERE id='v_edit_inp_dscenario_junction';
UPDATE sys_table
	SET orderby=12,context='{"level_1":"EPA","level_2":"DSCENARIO"}',alias='Inlet Dscenario'
	WHERE id='v_edit_inp_dscenario_inlet';
UPDATE sys_table
	SET orderby=5
	WHERE id='v_edit_inp_dscenario_reservoir';
UPDATE sys_table
	SET orderby=6
	WHERE id='v_edit_inp_dscenario_shortpipe';
UPDATE sys_table
	SET orderby=7
	WHERE id='v_edit_inp_dscenario_tank';
UPDATE sys_table
	SET orderby=8
	WHERE id='v_edit_inp_dscenario_valve';
UPDATE sys_table
	SET orderby=9,context='{"level_1":"EPA","level_2":"DSCENARIO"}',alias='Virtual Valve Dscenario'
	WHERE id='v_edit_inp_dscenario_virtualvalve';
UPDATE sys_table
	SET orderby=4,context='{"level_1":"EPA","level_2":"DSCENARIO"}',alias='Pump Additional Dscenario'
	WHERE id='v_edit_inp_dscenario_pump_additional';


UPDATE config_csv SET descript='The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active' WHERE fid=444;

UPDATE config_csv SET descript='The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, isarcdivide, isprofilesurface, choose_hemisphere, code_autofill, double_geom, num_arcs, graf_delimiter, shortcut_key, link_path, descript, active'
WHERE fid=445;

UPDATE config_csv SET descript='The csv file must contain the following columns in the exact same order: 
id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active' WHERE fid=446;

UPDATE config_csv SET descript='The csv file must contain the following columns in the exact same order: 
id, nodetype_id, matcat_id, pnom, dnom, dint, dext, shape, descript, link, brand, model, svg, estimated_depth, cost_unit, cost, active, label, ischange, acoeff'
WHERE fid=448;

UPDATE config_csv SET descript='The csv file must contain the following columns in the exact same order: 
id, connectype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, active, label' 
WHERE fid=449;

UPDATE config_csv SET descript='The csv file must contain the following columns in the exact same order: 
id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, shape, acoeff, connect_cost' 
WHERE fid=450;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(460, 'Check zones without numeric id', 'ws', NULL, 'core', true, 'Check graf-data', NULL) 
ON CONFLICT (fid) DO NOTHING;

DELETE FROM config_param_user where cur_user=current_user AND parameter ='inp_options_valve_mode';
DELETE FROM sys_param_user where id ='inp_options_valve_mode';

DELETE FROM config_param_user where cur_user=current_user AND parameter ='inp_options_valve_mode_mincut_result';
DELETE FROM sys_param_user where id ='inp_options_valve_mode_mincut_result';

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3158,'gw_fct_create_dscenario_from_mincut','ws','function','json','json','Function to create valve dscenario from mincut','role_epa','core');

INSERT INTO config_toolbox VALUES
(3158,'Create valve dscenario from mincut','{"featureType":[]}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"mincutId", "label":"Mincut:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, "dvQueryText":"SELECT id as id, id as idval FROM om_mincut", "selectedId":"$userMincut"}]', '',TRUE);

INSERT INTO inp_typevalue VALUES ('inp_typevalue_dscenario', 'SHORTPIPE', 'SHORTPIPE');
INSERT INTO inp_typevalue VALUES ('inp_options_dscenario_priority', '0', 'REMOVE ALL BASE DEMANDS & PATT.');
UPDATE inp_typevalue SET idval ='OVERWRITE BASE DEMANDS & PATT.' WHERE typevalue ='inp_options_dscenario_priority' and id='1';
UPDATE inp_typevalue SET idval ='JOIN DEMANDS & PATTERNS' WHERE typevalue ='inp_options_dscenario_priority' and id='2';


UPDATE sys_table SET addparam = null where id = 'v_edit_inp_dscenario_demand';