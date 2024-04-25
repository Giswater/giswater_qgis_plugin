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
  "polygon": {"style": "categorized","field": "mapzone_id",  "transparency": 0.5}}}'::json, actions='[{"funcName": "set_style_mapzones", "params": {}}, {"funcName": "get_graph_config", "params": {}}]'::json WHERE function_name='gw_fct_graphanalytics_mapzones';


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

UPDATE config_form_tabs SET sys_role = 'role_basic' WHERE formname ='selector_basic' and tabname = 'tab_macroexploitation';
UPDATE config_form_tabs SET orderby = 2 WHERE formname ='selector_basic' and tabname = 'tab_macrosector';
UPDATE config_form_tabs SET orderby = 3 WHERE formname ='selector_basic' and tabname = 'tab_sector';
UPDATE config_form_tabs SET orderby = 4 WHERE formname ='selector_basic' and tabname = 'tab_network_state';
UPDATE config_form_tabs SET orderby = 5 WHERE formname ='selector_basic' and tabname = 'tab_hydro_state';

-- 15/04/2024
UPDATE sys_table SET id = '_man_addfields_value_' WHERE id='man_addfields_value';

UPDATE sys_table SET id = 'archived_rpt_arc' WHERE id = 'rpt_arc';
UPDATE sys_table SET id = 'archived_rpt_energy_usage' WHERE id = 'rpt_energy_usage';
UPDATE sys_table SET id = 'archived_rpt_hydraulic_status' WHERE id = 'rpt_hydraulic_status';
UPDATE sys_table SET id = 'archived_rpt_node' WHERE id = 'rpt_node';

INSERT INTO sys_table VALUES('archived_rpt_inp_pattern_value', 'id', 'role_epa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'core', NULL, NULL);

UPDATE sys_function SET input_params='character varying, boolean, boolean' WHERE function_name = 'gw_fct_pg2epa_nod2arc' and project_type = 'ws';
UPDATE sys_function SET input_params='character varying' WHERE function_name = 'gw_fct_pg2epa_nod2arc' and project_type = 'ud';
update sys_function set input_params = null where function_name = 'gw_fct_setvalurn';
update sys_function set input_params = null where function_name = 'gw_fct_admin_schema_utils_fk';
update sys_function set input_params = null where function_name = 'gw_fct_admin_role_permissions';
update sys_function set input_params = null where function_name = 'gw_fct_refresh_mat_view';
update sys_function set input_params = null where function_name IN ('gw_fct_fill_om_tables', 'gw_fct_fill_doc_tables');
update sys_function set input_params = null where function_name = 'gw_fct_admin_test_ci';
update sys_function set input_params = null where function_name = 'gw_fct_vnode_repair';
update sys_function set input_params = null where function_name = 'gw_fct_arc_repair';
update sys_function set input_params = null where function_name = 'gw_trg_edit_anl_hydrant';
update sys_function set input_params = 'text, json' where function_name = 'gw_fct_rpt2pg_log';
UPDATE sys_function SET input_params = 'in json, variadic _text' where function_name='gw_fct_json_object_delete_keys';
update sys_function set input_params = 'varchar' where function_name = 'gw_fct_pg2epa_breakpipes';
update sys_function set input_params = 'json' where function_name = 'gw_fct_pg2epa_autorepair_epatype';
update sys_function set input_params = 'json, int4, json, json, json' where function_name = 'gw_fct_json_create_return';
update sys_function set input_params = 'json' where function_name = 'gw_fct_linkexitgenerator';
update sys_function set input_params = 'json' where function_name = 'gw_fct_getprofile';
update sys_function set input_params = 'json' where function_name = 'gw_fct_linktonetwork';
update sys_function set input_params = 'json' where function_name = 'gw_fct_infofromid';
update sys_function set input_params = 'json' where function_name = 'gw_fct_getdmabalance';
update sys_function set input_params = 'json' where function_name = 'gw_fct_setclosestaddress';
update sys_function set input_params = 'json' where function_name = 'gw_fct_setinitproject';
update sys_function set input_params = 'json' where function_name = 'gw_fct_getvisit_manager';
update sys_function set input_params = 'json' where function_name = 'gw_fct_waterbalance';
update sys_function set input_params = 'json' where function_name = 'gw_fct_setprofile';
update sys_function set input_params = 'character varying, character varying, integer, bool' where function_name = 'gw_fct_mincut';
update sys_function set input_params = 'int4, int8, int8' where function_name = 'gw_fct_link_repair';
update sys_function set input_params = 'int4' where function_name = 'gw_fct_linkexitgenerator';
update sys_function set input_params = 'int4' where function_name = 'gw_fct_mincut_inverted_flowtrace';
update sys_function set project_type = 'ud' where function_name = 'gw_fct_anl_node_elev';
update sys_function set project_type = 'ud' where function_name = 'gw_fct_anl_arc_elev';
DELETE FROM sys_function WHERE id=2900; -- function_name = 'gw_fct_getprojectvisitforms';
update sys_function set input_params = 'json' where function_name = 'gw_fct_create_dwf_scenario_empty';
update sys_function set input_params = 'json' where function_name = 'gw_fct_create_dwf_scenario_empty';
update sys_function set input_params = 'json' where function_name = 'gw_fct_epa_setoptimumoutlet';
update sys_function set input_params = 'json' where function_name = 'gw_fct_duplicate_hydrology_scenario';
update sys_function set input_params = 'json' where function_name = 'gw_fct_duplicate_dwf_scenario';
update sys_function set input_params = 'json' where function_name = 'gw_fct_create_hydrology_scenario_empty';

-- 16/04/2024
drop view if exists v_ui_event_x_arc;

CREATE OR REPLACE VIEW v_ui_event_x_arc
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id as visit_class,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_arc.arc_id;

drop view if exists v_ui_event_x_node;

CREATE OR REPLACE VIEW v_ui_event_x_node
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id AS visit_class,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_node.node_id;

drop view if exists v_ui_event_x_connec;

CREATE OR REPLACE VIEW v_ui_event_x_connec
AS SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    om_visit.class_id AS visit_class,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
     JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_connec.connec_id;

UPDATE config_form_list SET listname='tbl_event_x_arc' WHERE listname='tbl_visit_x_arc' AND device=4;
UPDATE config_form_list SET listname='tbl_event_x_node' WHERE listname='tbl_visit_x_node' AND device=4;
UPDATE config_form_list SET listname='tbl_event_x_connec' WHERE listname='tbl_visit_x_connec' AND device=4;

UPDATE config_form_fields SET linkedobject='tbl_event_x_arc' WHERE formname='arc' AND formtype='form_feature' AND tabname='tab_event' AND linkedobject = 'tbl_visit_x_arc';
UPDATE config_form_fields SET linkedobject='tbl_event_x_connec' WHERE formname='connec' AND formtype='form_feature' AND tabname='tab_event' AND linkedobject = 'tbl_visit_x_connec';
UPDATE config_form_fields SET linkedobject='tbl_event_x_node' WHERE formname='node' AND formtype='form_feature' AND tabname='tab_event' AND linkedobject = 'tbl_visit_x_node';

INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_visit_arc_leak', 'SELECT * FROM v_ui_visit_arc_leak WHERE visit_id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_visit_connec_leak', 'SELECT * FROM v_ui_visit_connec_leak WHERE visit_id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_visit_node_insp', 'SELECT * FROM v_ui_visit_node_insp WHERE visit_id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);
INSERT INTO config_form_list (listname, query_text, device, listtype, listclass, vdefault, addparam) VALUES('v_ui_visit_incid_node', 'SELECT * FROM v_ui_visit_incid_node WHERE visit_id IS NOT NULL', 4, 'tab', 'list', '{"orderBy":"1", "orderType": "ASC"}'::json, NULL);

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM config_visit_class WHERE feature_type IN (''ARC'',''ALL'') ', isfilter=false, dv_isnullvalue=false, widgetfunction='{"functionName": "manage_visit_class","parameters": {}}'::json WHERE formname='arc' AND formtype='form_feature' AND columnname='visit_class' AND tabname='tab_visit';
UPDATE config_form_fields SET linkedobject=NULL WHERE formname='arc' AND formtype='form_feature' AND columnname='tbl_visits' AND tabname='tab_visit';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM config_visit_class WHERE feature_type IN (''CONNEC'',''ALL'')  ', isfilter=false, dv_isnullvalue=false, widgetfunction='{"functionName": "manage_visit_class","parameters": {}}'::json WHERE formname='connec' AND formtype='form_feature' AND columnname='visit_class' AND tabname='tab_visit';
UPDATE config_form_fields SET linkedobject=NULL WHERE formname='connec' AND formtype='form_feature' AND columnname='tbl_visits' AND tabname='tab_visit';

UPDATE config_form_fields SET dv_querytext='SELECT id, idval FROM config_visit_class WHERE feature_type IN (''NODE'',''ALL'') ', isfilter=false, dv_isnullvalue=false, widgetfunction='{"functionName": "manage_visit_class","parameters": {}}'::json WHERE formname='node' AND formtype='form_feature' AND columnname='visit_class' AND tabname='tab_visit';
UPDATE config_form_fields SET linkedobject=NULL WHERE formname='node' AND formtype='form_feature' AND columnname='tbl_visits' AND tabname='tab_visit';


-- 25/04/2024
DELETE FROM sys_foreignkey WHERE id = 75;
DELETE FROM sys_foreignkey WHERE id = 78;
