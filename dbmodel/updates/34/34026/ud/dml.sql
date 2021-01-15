/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
INSERT INTO sys_table VALUES ('v_plan_psector_gully', 'View to show gullys related to psectors. Useful to show gullys which will be obsolete in psectors', 'role_basic', 0, 'role_master', 2, 'Cannot view related gullys to psectors') ON CONFLICT (id) DO NOTHING;

-- 2020/12/16
UPDATE config_param_system SET value='FALSE' WHERE parameter='admin_config_control_trigger';
UPDATE config_form_fields SET formname='inp_timeseries_value' WHERE formname='inp_timeseries';
UPDATE config_form_fields SET formname='inp_transects_value' WHERE formname='inp_transects';

UPDATE sys_table SET id='inp_timeseries_value' WHERE id='inp_timeseries';
UPDATE sys_table SET id='inp_timeseries' WHERE id='inp_timser_id';
UPDATE sys_table SET id='inp_transects_value' WHERE id='inp_transects';
UPDATE sys_table SET id='inp_transects' WHERE id='inp_transects_id';

UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'inp_transects_id', 'inp_transects') WHERE dv_querytext LIKE '%inp_transects%';
UPDATE config_form_fields SET dv_querytext=replace(dv_querytext, 'inp_timser_id', 'inp_timeseries') WHERE dv_querytext LIKE '%inp_timser%';
UPDATE config_param_system SET value='TRUE' WHERE parameter='admin_config_control_trigger';

UPDATE sys_foreignkey SET target_table = 'inp_timeseries' WHERE target_table = 'inp_timser_id';

UPDATE config_form_tabs SET tabactions = '[{"disabled": false, "actionName": "actionEdit", "actionTooltip": "Edit"}, 
{"disabled": false, "actionName": "actionZoom", "actionTooltip": "Zoom In"}, 
{"disabled": false, "actionName": "actionCentered", "actionTooltip": "Center"}, 
{"disabled": false, "actionName": "actionZoomOut", "actionTooltip": "Zoom Out"}, 
{"disabled": false, "actionName": "actionCatalog", "actionTooltip": "Change Catalog"}, 
{"disabled": false, "actionName": "actionWorkcat", "actionTooltip": "Add Workcat"}, 
{"disabled": false, "actionName": "actionCopyPaste", "actionTooltip": "Copy Paste"}, 
{"disabled": false, "actionName": "actionLink", "actionTooltip": "Open Link"},
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"disabled": false, "actionName": "actionHelp", "actionTooltip": "Help"}]' WHERE formname ='v_edit_node';

INSERT INTO sys_param_user VALUES('inp_options_rule_step','epaoptions', 'Rule step control', 'role_epa', 'RULE_STEP', 'Rule step', null,null, true, 36, 
'ud', false, null, null, null, false, 'text', 'linetext', true, null, '00:00:00', 'lyt_hydraulics_1', true, null, null, null, null, false, 
'{"from":"5.1.000", "to":null,"language":"english"}')
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user VALUES('inp_options_threads','epaoptions', 'Threads control', 'role_epa', 'THREADS', 'Threads', null,null, true, 33, 
'ud', false, null, null, null, false, 'integer', 'linetext', true, null, '1', 'lyt_hydraulics_2', true, null, null, null, null, false, 
'{"from":"5.1.000", "to":null,"language":"english"}')
ON CONFLICT (id) DO NOTHING;

UPDATE sys_param_user SET layoutname = 'lyt_hydraulics_2' WHERE id = 'inp_options_sys_flow_tol';

INSERT INTO sys_param_user VALUES('inp_options_epaversion','hidden', 'EPA version', 'role_epa', null, 'EPA version', null,null, true, 37, 
'ud', false, null, null, null, false, 'text', 'linetext', true, null, '5.0.022', 'lyt_hydraulics_1', true, null, null, null, null, false, 
'{"from":"5.0.022", "to":null,"language":"english"}')
ON CONFLICT (id) DO NOTHING;

UPDATE config_param_system SET value  = $${"arc":"SELECT arc_id AS arc_id, concat(v_edit_arc.matcat_id,'-Ø',(c.geom1*100)::integer) as catalog, (case when slope is not null then concat((100*slope)::numeric(12,2),' / ',gis_length::numeric(12,2),'m') else concat('None / ',gis_length::numeric(12,2),'m') end) as dimensions , arc_id as code FROM v_edit_arc JOIN cat_arc c ON id = arccat_id"}$$ 
WHERE parameter = 'om_profile_guitartext';