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


-- 26/04/2024
INSERT INTO sys_style (id, idval, styletype, stylevalue, active) VALUES(210, 'Flow trace arc', 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.6-Prizren" styleCategories="Symbology">
  <renderer-v2 attr="context" referencescale="-1" forceraster="0" type="categorizedSymbol" symbollevels="0" enableorderby="0">
    <categories>
      <category symbol="0" value="Flow trace" type="string" uuid="1" label="Flow trace" render="true"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" frame_rate="10" type="line" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" pass="0" locked="0" id="{71286e21-da1f-4068-9672-604504b48ba7}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="235,167,48,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.86" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" frame_rate="10" type="line" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" pass="0" locked="0" id="{c8ae6149-c275-4fc2-938b-df916d63e1ba}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="184,30,179,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.26" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" force_rhr="0" frame_rate="10" type="line" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" pass="0" locked="0" id="{c6a9d2d2-3251-47b3-8ef0-cdd3d57b8448}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="35,35,35,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.26" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
', true);
INSERT INTO sys_style (id, idval, styletype, stylevalue, active) VALUES(211, 'Flow trace node', 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.6-Prizren" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" forceraster="0" type="RuleRenderer" symbollevels="0" enableorderby="0">
    <rules key="{e4d87f5e-3fd2-4d97-8962-998d1cba9adf}">
      <rule symbol="0" key="{c86240b2-11c2-4458-94b4-2bb0fd07bacd}" filter="&quot;context&quot; = ''Flow trace'' AND &quot;feature_type&quot; = ''CONNEC''" label="Connec"/>
      <rule symbol="1" key="{c70ca34c-0a81-4ecf-ba72-d91f6855b943}" filter="&quot;context&quot; = ''Flow trace'' AND &quot;feature_type&quot; = ''GULLY''" label="Gully"/>
      <rule symbol="2" key="{3b2aac74-0aaa-4513-92fa-c7d8c8e17c11}" filter="&quot;context&quot; = ''Flow trace'' AND &quot;feature_type&quot; NOT IN (''CONNEC'', ''GULLY'')" label="Node"/>
    </rules>
    <symbols>
      <symbol name="0" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}">
          <Option type="Map">
            <Option value="45" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="216,199,98,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="cross_fill" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="159,104,9,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}">
          <Option type="Map">
            <Option value="45" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="216,199,98,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="cross_fill" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="159,104,9,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="2" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{a140be8b-78e2-4623-a992-e827e24bf17b}">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="235,167,48,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{7ed4929a-7cce-4761-af88-aa2a8b1c9a42}">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
', true);
INSERT INTO sys_style (id, idval, styletype, stylevalue, active) VALUES(212, 'Flow exit arc', 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.6-Prizren" styleCategories="Symbology">
  <renderer-v2 attr="context" referencescale="-1" forceraster="0" type="categorizedSymbol" symbollevels="0" enableorderby="0">
    <categories>
      <category symbol="0" value="Flow exit" type="string" uuid="0" label="Flow exit" render="true"/>
    </categories>
    <symbols>
      <symbol name="0" force_rhr="0" frame_rate="10" type="line" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" pass="0" locked="0" id="{69bf594d-8b1b-4f29-be92-de6f3e39fd52}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="235,74,117,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.86" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol name="0" force_rhr="0" frame_rate="10" type="line" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" pass="0" locked="0" id="{606db9a4-f11f-4d4f-ab44-db52cc28779e}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="184,30,179,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.26" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </source-symbol>
    <rotation/>
    <sizescale/>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" force_rhr="0" frame_rate="10" type="line" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleLine" enabled="1" pass="0" locked="0" id="{50b9a837-2d81-443d-bd5e-f67b68309369}">
          <Option type="Map">
            <Option value="0" name="align_dash_pattern" type="QString"/>
            <Option value="square" name="capstyle" type="QString"/>
            <Option value="5;2" name="customdash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="customdash_map_unit_scale" type="QString"/>
            <Option value="MM" name="customdash_unit" type="QString"/>
            <Option value="0" name="dash_pattern_offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="dash_pattern_offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="dash_pattern_offset_unit" type="QString"/>
            <Option value="0" name="draw_inside_polygon" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="35,35,35,255" name="line_color" type="QString"/>
            <Option value="solid" name="line_style" type="QString"/>
            <Option value="0.26" name="line_width" type="QString"/>
            <Option value="MM" name="line_width_unit" type="QString"/>
            <Option value="0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0" name="ring_filter" type="QString"/>
            <Option value="0" name="trim_distance_end" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_end_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_end_unit" type="QString"/>
            <Option value="0" name="trim_distance_start" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="trim_distance_start_map_unit_scale" type="QString"/>
            <Option value="MM" name="trim_distance_start_unit" type="QString"/>
            <Option value="0" name="tweak_dash_pattern_on_corners" type="QString"/>
            <Option value="0" name="use_custom_dash" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="width_map_unit_scale" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>1</layerGeometryType>
</qgis>
', true);
INSERT INTO sys_style (id, idval, styletype, stylevalue, active) VALUES(213, 'Flow exit node', 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.34.6-Prizren" styleCategories="Symbology">
  <renderer-v2 referencescale="-1" forceraster="0" type="RuleRenderer" symbollevels="0" enableorderby="0">
    <rules key="{e4d87f5e-3fd2-4d97-8962-998d1cba9adf}">
      <rule symbol="0" key="{9c94b1b8-8153-4cce-b198-b2bda93a93d6}" filter="&quot;context&quot; = ''Flow exit'' AND &quot;feature_type&quot; = ''CONNEC''" label="Connec"/>
      <rule symbol="1" key="{26d1f6d6-de4e-4ac7-abf0-4ff486cf8e79}" filter="&quot;context&quot; = ''Flow exit'' AND &quot;feature_type&quot; = ''GULLY''" label="Gully"/>
      <rule symbol="2" key="{9970676d-c3b3-4d57-9c37-57fb7f3cce61}" filter="&quot;context&quot; = ''Flow exit'' AND &quot;feature_type&quot; NOT IN (''CONNEC'', ''GULLY'')" label="Node"/>
    </rules>
    <symbols>
      <symbol name="0" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}">
          <Option type="Map">
            <Option value="45" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="235,74,117,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="cross_fill" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="144,0,40,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="1" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{b59dc6ec-7c58-4c2a-9fc3-28518bed91a3}">
          <Option type="Map">
            <Option value="45" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="235,74,117,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="cross_fill" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="144,0,40,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.6" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol name="2" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{a140be8b-78e2-4623-a992-e827e24bf17b}">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="235,74,117,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="0,0,0,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol name="" force_rhr="0" frame_rate="10" type="marker" alpha="1" is_animated="0" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer class="SimpleMarker" enabled="1" pass="0" locked="0" id="{7ed4929a-7cce-4761-af88-aa2a8b1c9a42}">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>
', true);

UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml","id":"213"},"line":{"style":"qml","id":"212"}}}'::json, layermanager=NULL
	WHERE id=2214;
UPDATE config_function
	SET "style"='{"style":{"point":{"style":"qml","id":"211"},"line":{"style":"qml","id":"210"}}}'::json, layermanager=NULL
	WHERE id=2218;
    
INSERT INTO sys_message
(id, error_message, hint_message, log_level, show_user, project_type, "source")
VALUES(3260, 'No arc exists with a smaller diameter than the maximum configuered on edit_link_check_arcdnom:',
'Please check the configured value', 2, true, 'utils', 'core');

-- 01/05/2024
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'sectorFromExpl','true'::text) WHERE parameter = 'basic_selector_tab_exploitation';
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'explFromSector','true'::text) WHERE parameter = 'basic_selector_tab_sector';
UPDATE config_param_system SET value = gw_fct_json_object_delete_keys (value::json,'explFromMacrosector') WHERE parameter = 'basic_selector_tab_macrosector';

DELETE FROM config_form_fields WHERE columnname = '_pol_id_';
DELETE FROM sys_message where id = 2024;


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source") 
VALUES(3304, 'gw_fct_admin_manage_planmode', 'utils', 'function', 'json', 'json', 'Function to toggle planmode (for big projects). ', 'role_admin', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

DELETE FROM sys_table where id IN ('v_expl_node', 'v_expl_arc');

INSERT INTO edit_typevalue
(typevalue, id, idval, descript, addparam)
VALUES('value_verified', '2', 'IGNORE CHECK', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

-- 06/05/2024
-- deprecate function gw_fct_import_addfields
DELETE FROM sys_function WHERE id = 2516;
DELETE FROM config_csv WHERE fid=236;
DROP FUNCTION IF EXISTS gw_fct_import_addfields;;


UPDATE sys_fprocess SET fprocess_name='Orphan rows on addfields values (DEPRECATED)' WHERE fid=256;
