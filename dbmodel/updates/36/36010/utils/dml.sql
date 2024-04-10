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

DELETE FROM inp_typevalue WHERE typevalue = 'inp_typevalue_dscenario' AND id = 'UNDEFINED';

UPDATE config_function SET "style"='{"style": {"point": {"style": "categorized", "field": "mapzone_id", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
"line": {"style": "categorized", "field": "mapzone_id", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
  "polygon": {"style": "categorized","field": "mapzone_id",  "transparency": 0.5}}}'::json WHERE function_name='gw_fct_graphanalytics_mapzones';


UPDATE config_toolbox SET inputparams='[
  {
    "widgetname": "graphClass",
    "label": "Graph class:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Graphanalytics method used",
    "layoutname": "grl_option_parameters",
    "layoutorder": 1,
    "comboIds": [
      "DRAINZONE"
    ],
    "comboNames": [
      "Drainage area (DRAINZONE)"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "exploitation",
    "label": "Exploitation:",
    "widgettype": "combo",
    "datatype": "text",
    "tooltip": "Choose exploitation to work with",
    "layoutname": "grl_option_parameters",
    "layoutorder": 2,
     "comboIds": [
      "userSelectors"
    ],
    "comboNames": [
      "Users expl selection"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "floodOnlyMapzone",
    "label": "Flood only one mapzone: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Flood only identified mapzones. The purpose of this is update only network elements affected by this flooding keeping rest of network as is. Recommended to gain performance when mapzones ecosystem is under work",
    "placeholder": "1001",
    "layoutname": "grl_option_parameters",
    "layoutorder": 3,
    "value": ""
  },
  {
    "widgetname": "forceOpen",
    "label": "Force open nodes: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 5,
    "value": ""
  },
  {
    "widgetname": "forceClosed",
    "label": "Force closed nodes: (*)",
    "widgettype": "text",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Optative node id(s) to temporary close open node(s) to force algorithm to stop there",
    "placeholder": "1015,2231,3123",
    "layoutname": "grl_option_parameters",
    "layoutorder": 6,
    "value": ""
  },
  {
    "widgetname": "usePlanPsector",
    "label": "Use selected psectors:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, use selected psectors. If false ignore selected psectors and only works with on-service network",
    "layoutname": "grl_option_parameters",
    "layoutorder": 7,
    "value": ""
  },
  {
    "widgetname": "commitChanges",
    "label": "Commit changes:",
    "widgettype": "check",
    "datatype": "boolean",
    "tooltip": "If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables",
    "layoutname": "grl_option_parameters",
    "layoutorder": 8,
    "value": ""
  },
  {
    "widgetname": "valueForDisconnected",
    "label": "Value for disconn. and conflict: (*)",
    "widgettype": "linetext",
    "datatype": "text",
    "isMandatory": false,
    "tooltip": "Value to use for disconnected features. Usefull for work in progress with dynamic mpzonesnode",
    "placeholder": "",
    "layoutname": "grl_option_parameters",
    "layoutorder": 9,
    "value": ""
  },
  {
    "widgetname": "updateMapZone",
    "label": "Mapzone constructor method:",
    "widgettype": "combo",
    "datatype": "integer",
    "layoutname": "grl_option_parameters",
    "layoutorder": 10,
    "comboIds": [
      0,
      1,
      2,
      6
    ],
    "comboNames": [
      "NONE",
      "CONCAVE POLYGON",
      "PIPE BUFFER",
      "EPA SUBCATCH"
    ],
    "selectedId": ""
  },
  {
    "widgetname": "geomParamUpdate",
    "label": "Pipe buffer",
    "widgettype": "text",
    "datatype": "float",
    "tooltip": "Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.",
    "layoutname": "grl_option_parameters",
    "layoutorder": 11,
    "isMandatory": false,
    "placeholder": "5-30",
    "value": ""
  }
]'::json WHERE id=2768 AND alias='Mapzones analysis';

-- 26/03/2024
SELECT gw_fct_admin_transfer_addfields_values();

-- 10/04/2024
UPDATE config_param_system SET project_type='utils' WHERE "parameter"='edit_mapzones_set_lastupdate';