/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system
SET descript='If true, connec''s label and symbol will be rotated using the angle of link. 
Label must be configured with "CASE WHEN label_x = ''R'' THEN ''    '' ||  "connec_id" ELSE  "connec_id"  || ''    ''  END" as ''Expression'', label_x as ''Position priotiry'' and label_rotation as ''Rotation'''
WHERE "parameter"='edit_link_update_connecrotation';

UPDATE config_param_system SET "label"='Default value for EPA TCV valves:' WHERE "parameter"='epa_valve_vdefault_tcv';
UPDATE config_param_system SET "label"='Default value for EPA PRV valves:' WHERE "parameter"='epa_valve_vdefault_prv';
UPDATE config_param_system SET "label"='Minimum length to export arcs:' WHERE "parameter"='epa_arc_minlength';
UPDATE config_param_system SET "label"='Admin hydrometer state:' WHERE "parameter"='admin_hydrometer_state';
UPDATE config_param_system SET "label"='Default value for EPA shortpipes:' WHERE "parameter"='epa_shortpipe_vdefault';
UPDATE config_param_system SET "label"='Admin message debug:' WHERE "parameter"='admin_message_debug';
UPDATE config_param_system SET "label"='Updated fields when calculating lrs:' WHERE "parameter"='utils_graphanalytics_lrs_feature';
UPDATE config_param_system SET "label"='Default values for geometry of mapzones algorithm:' WHERE "parameter"='utils_graphanalytics_vdefault';
UPDATE config_param_system SET "label"='Config of headers for calculating lrs:' WHERE "parameter"='utils_graphanalytics_lrs_graph';
UPDATE config_param_system SET "label"='Production Schema:' WHERE "parameter"='admin_isproduction';
UPDATE config_param_system SET "label"='Show final nodes'' code on arc''s form:' WHERE "parameter"='admin_node_code_on_arc';
UPDATE config_param_system SET "label"='Skip audit:' WHERE "parameter"='admin_skip_audit';
UPDATE config_param_system SET "label"='Force downgrading connecs:' WHERE "parameter"='edit_connec_downgrade_force';
UPDATE config_param_system SET "label"='Custom config for admin check project:' WHERE "parameter"='admin_checkproject';
UPDATE config_param_system SET "label"='Check conflict mapzones:' WHERE "parameter"='edit_arc_check_conflictmapzones';
UPDATE config_param_system SET "label"='Tab for period:' WHERE "parameter"='basic_selector_tab_period';
UPDATE config_param_system SET project_type = 'utils' WHERE parameter = 'utils_graphanalytics_lrs_graph';
UPDATE config_param_system SET project_type = 'utils' WHERE parameter = 'utils_graphanalytics_vdefault';
UPDATE config_param_system SET project_type = 'utils' WHERE parameter = 'utils_graphanalytics_lrs_feature';
UPDATE config_param_system SET project_type = 'utils' WHERE parameter = 'admin_checkproject';
UPDATE config_param_system SET project_type = 'utils' WHERE parameter = 'qgis_form_selector_stylesheet';
UPDATE config_param_system SET project_type = 'ws' WHERE parameter = 'admin_hydrometer_state';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'edit_mapzones_automatic_insert';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'epa_valve_vdefault_tcv';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'epa_valve_vdefault_prv';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'admin_hydrometer_state';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'epa_shortpipe_vdefault';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'utils_graphanalytics_vdefault';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'qgis_form_selector_stylesheet';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'basic_selector_tab_period';
UPDATE config_param_system SET datatype = 'json', widgettype = 'text' WHERE parameter = 'admin_checkproject';
UPDATE config_param_system SET datatype = 'boolean', widgettype = 'check' WHERE parameter = 'edit_mapzones_set_lastupdate';
UPDATE config_param_system SET datatype = 'boolean', widgettype = 'check' WHERE parameter = 'admin_message_debug';
UPDATE config_param_system SET datatype = 'double' WHERE parameter = 'epa_arc_minlength';
update config_param_system set widgettype = 'check' where datatype = 'boolean';
update config_param_system set widgettype = 'text' where widgettype is null and datatype in ('string', 'json', 'integer', 'text', 'double');
update config_param_system set isenabled = false where isenabled is null;
update config_param_system set layoutname = null where layoutname = 'false';

update sys_function set function_type = 'trigger' where function_type ilike '%trigger%';
update sys_function set function_type = 'function' where function_type ilike '%function%';
delete from sys_function where function_name = 'gw_fct_getunexpected';
delete from sys_function where function_name = 'gw_fct_getvisit_main';

update sys_message set source = 'core' where source is null;




