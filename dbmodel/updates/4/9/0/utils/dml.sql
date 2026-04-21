/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/03/2026
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'PATTERN', 'PATTERN', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_function (id, function_name, "style", layermanager, actions) VALUES(3536, 'gw_fct_getmincutminsector', '{
  "style": {
    "Valves": {
      "style": "categorized",
      "field": "closed",
      "width": 2,
      "transparency": 0.5
    },
    "Arcs": {
      "style": "categorized",
      "field": "minsector_id",
      "width": 2,
      "transparency": 0.5
    },
    "Connecs": {
      "style": "categorized",
      "field": "minsector_id",
      "width": 2,
      "transparency": 0.5
    }
  }
}'::json, NULL, NULL);

-- 24/03/2026
UPDATE sys_function SET function_alias = 'MACROMAPZONES DYNAMIC SECTORITZATION' WHERE id = 3482;


INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_municipality', 'View of town cities and villages', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_streetaxis', 'View of streetaxis', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_address', 'View of entrance numbers', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_plot', 'View of urban properties', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_raster_dem', 'View to store raster DEM', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_district', 'View of districts', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_region', 'View of regions', 'role_edit', 'core');

INSERT INTO sys_table (id, descript, sys_role, "source")
VALUES('v_province', 'View of provinces', 'role_edit', 'core');

-- 26/03/2026
INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'CALIBRATION', 'CALIBRATION', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;


UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM cat_element WHERE active IS true'
WHERE formname = 've_element' AND columnname = 'elementcat_id';

UPDATE config_form_tabs SET tooltip='State' WHERE formname='selector_basic' AND tabname='tab_network_state';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4610, 'Mincut has overlapping conflicts', NULL, 1, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4612, 'Mincut to cancel not found', NULL, 1, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4614, 'Mincut to delete not found', NULL, 1, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4616, 'Mincut deleted', NULL, 0, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4618, 'Node not operative not found', NULL, 2, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4620, 'You MUST execute the minsector analysis before executing the mincut analysis with 6.1 version.', NULL, 3, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;

UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type AS id, function_type AS idval FROM man_type_function WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT category_type AS id, category_type AS idval FROM man_type_category WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';

UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''ARC''=ANY(feature_type))' WHERE formname='ve_arc' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''CONNEC''=ANY(feature_type))' WHERE formname='ve_connec' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''ELEMENT''=ANY(feature_type))' WHERE formname='ve_element' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type AS id, location_type AS idval FROM man_type_location WHERE active AND (featurecat_id IS NULL AND ''NODE''=ANY(feature_type))' WHERE formname='ve_node' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';

-- 30/03/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4622, 'You MUST select “current_psector” to perform this action', NULL, 2, true, 'utils', 'core', 'UI') ON CONFLICT DO NOTHING;

INSERT INTO sys_message
(id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4624, 'There are values not allowed in the field ''%alias%'' (%column%) of the table ''%table%''', NULL, 0, true, 'utils', 'core', 'AUDIT');

-- 31/03/2026
DELETE FROM config_form_tabs WHERE formname='selector_basic' AND tabname='tab_hydro_state';
DELETE FROM config_typevalue WHERE typevalue='tabname_typevalue' AND id='tab_hydro_state';
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('connec', 'form_feature', 'tab_hydrometer', 'cmb_hydrometer_state', 'lyt_hydrometer_1', 2, 'string', 'combo', 'State:', 'State:', NULL, false, false, true, false, true, 'SELECT name as id, name as idval FROM ext_rtc_hydrometer_state WHERE id IS NOT NULL', NULL, true, NULL, NULL, NULL, '{"saveValue": false, "filterSign":"="}'::json, '{
  "functionName": "filter_table",
  "parameters": {
    "columnfind": "state",
    "field_id": "feature_id"
  }
}'::json, 'v_ui_hydrometer', false, 2);


UPDATE sys_table SET id='ve_municipality' WHERE id='v_ext_municipality';
UPDATE sys_table SET id='ve_streetaxis' WHERE id='v_ext_streetaxis';
UPDATE sys_table SET id='ve_address' WHERE id='v_ext_address';
UPDATE sys_table SET id='ve_plot' WHERE id='v_ext_plot';
UPDATE sys_table SET id='ve_raster_dem' WHERE id='v_ext_raster_dem';
INSERT INTO sys_table (id, descript, sys_role, source) VALUES('ve_district', 'Filtered view of districts', 'role_edit', 'core');

UPDATE sys_style SET layername='ve_municipality' WHERE layername='v_ext_municipality';
UPDATE sys_style SET layername='ve_streetaxis' WHERE layername='v_ext_streetaxis';
UPDATE sys_style SET layername='ve_address' WHERE layername='v_ext_address';
UPDATE sys_style SET layername='ve_plot' WHERE layername='v_ext_plot';

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'v_ext_municipality', 've_municipality') WHERE dv_querytext LIKE '%v_ext_municipality%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'v_ext_streetaxis', 've_streetaxis') WHERE dv_querytext LIKE '%v_ext_streetaxis%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_municipality', 'v_municipality') WHERE dv_querytext LIKE '%ext_municipality%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_streetaxis', 'v_streetaxis') WHERE dv_querytext LIKE '%ext_streetaxis%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_address', 'v_address') WHERE dv_querytext LIKE '%ext_address%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_region', 'v_region') WHERE dv_querytext LIKE '%ext_region%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_province', 'v_province') WHERE dv_querytext LIKE '%ext_province%';
UPDATE config_form_fields SET dv_querytext = replace(dv_querytext, 'ext_district', 'v_district') WHERE dv_querytext LIKE '%ext_district%';

UPDATE config_param_system SET value = replace(value, 'v_ext_municipality', 've_municipality') WHERE value LIKE '%v_ext_municipality%';
UPDATE config_param_system SET value = replace(value, 'v_ext_streetaxis', 've_streetaxis') WHERE value LIKE '%v_ext_streetaxis%';
UPDATE config_param_system SET value = replace(value, 'ext_municipality', 'v_municipality') WHERE value LIKE '%ext_municipality%';
UPDATE config_param_system SET value = replace(value, 'ext_streetaxis', 'v_streetaxis') WHERE value LIKE '%ext_streetaxis%';
UPDATE config_param_system SET value = replace(value, 'v_ext_address', 've_address') WHERE value LIKE '%v_ext_address%';
UPDATE config_param_system SET value = replace(value, 'ext_region', 'v_region') WHERE value LIKE '%ext_region%';
UPDATE config_param_system SET value = replace(value, 'ext_province', 'v_province') WHERE value LIKE '%ext_province%';
UPDATE config_param_system SET value = replace(value, 'ext_district', 'v_district') WHERE value LIKE '%ext_district%';

UPDATE config_form_fields SET formname='ve_streetaxis' WHERE formname = 'v_ext_streetaxis';
DELETE FROM config_form_fields WHERE formname='ve_streetaxis' AND columnname='expl_id';

UPDATE config_form_fields SET formname='ve_municipality' WHERE formname in ('v_ext_municipality', 'ext_municipality');
DELETE FROM config_form_fields WHERE formname='ve_municipality' AND columnname in ('expl_id', 'sector_id');

UPDATE config_form_fields SET formname='ve_address' WHERE formname = 'v_ext_address';
DELETE FROM config_form_fields WHERE formname='ve_address' AND columnname = 'expl_id';

UPDATE config_form_fields SET formname='ve_plot' WHERE formname = 'v_ext_plot';
DELETE FROM config_form_fields WHERE formname='ve_plot' AND columnname = 'expl_id';
UPDATE config_form_fields SET columnname='code', label='Code:', tooltip='Code' WHERE formname = 've_plot' AND columnname = 'plot_code';
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

DELETE FROM config_param_user WHERE "parameter"='edit_arc_automatic_link2netowrk';

INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable,"source")
VALUES ('edit_arc_automatic_link2network','config','Automatic connection of closest connecs to the arc','role_edit','Automatic connection of closest connecs to the arc:',true,9,'utils',false,false,'json','text',true,'{"active":"false", "buffer":"10"}','lyt_other',true,'core');

INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('inp_family','Defines inp families contained in the network','role_edit','core');

INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('dma_graph','Table to manage graph for dma','role_edit','core');
INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('sector_graph','Table to manage graph for sector','role_edit','core');

INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('inp_dscenario_pattern','Table to manage dscenario for pattern','role_epa','core');
INSERT INTO sys_table (id,descript,sys_role,"source")
VALUES ('inp_dscenario_pattern_value','Table to manage dscenario for pattern value','role_epa','core');

-- 08/04/2026
UPDATE config_param_system SET isenabled = true WHERE "parameter" ILIKE 'basic_search_v2_tab_%';

UPDATE config_form_fields
SET dv_querytext='SELECT ''ALL'' as id, ''ALL'' as idval
UNION
SELECT id, id as idval
FROM sys_feature_type
WHERE classlevel = 1 OR classlevel = 2 OR classlevel = 4'
WHERE formname='config_visit_parameter' AND formtype='form_feature' AND columnname='feature_type' AND tabname='tab_none';

UPDATE config_form_fields SET widgettype='typeahead' WHERE formname='generic' AND formtype='psector' AND columnname='workcat_id_plan' AND tabname='tab_general';
UPDATE config_form_fields SET widgettype='typeahead' WHERE formname='generic' AND formtype='psector' AND columnname='workcat_id' AND tabname='tab_general';


INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('vf_node', 'Filtered nodes', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('vf_arc', 'Filtered arcs', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('vf_connec', 'Filtered connecs', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('vf_element', 'Filtered elements', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('vf_gully', 'Filtered gullys', 'role_basic', 'core') ON CONFLICT DO NOTHING;
INSERT INTO sys_table (id, descript, sys_role, "source") VALUES('vf_link', 'Filtered gullys', 'role_basic', 'core') ON CONFLICT DO NOTHING;


INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,layoutname,iseditable,"source",vdefault)
VALUES ('edit_insert_show_elevation_from_dem','config','If true, the elevation will be showed from the DEM raster when inserting a new feature','role_edit','Show elevation from DEM:',true,28,'utils',false,false,'boolean','check',true,'lyt_other',true,'core', 'TRUE') ON CONFLICT (id) DO NOTHING;

-- 10/04/2026
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4626, 'The following catalogs have invalid dnom: %invalid_dnom%', 'Check the catalogs and correct dnom values', 2, true, 'ws', 'core', 'UI') ON CONFLICT DO NOTHING;

-- 13/04/2026
DELETE FROM sys_table WHERE id='rtc_hydrometer';
DELETE FROM sys_table WHERE id='rtc_hydrometer_x_connec';
DELETE FROM sys_table WHERE id='rtc_hydrometer_x_node';

-- 14/04/2026
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) 
VALUES(712, 'Supply Zonification', 'ws', NULL, 'core', true, 'Function process', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, true) ON CONFLICT (fid) DO NOTHING;

-- 15/04/2026
UPDATE config_param_system
SET value = (
  COALESCE(value::jsonb, '{}'::jsonb)
  || jsonb_build_object(
    'SECTOR', true,
    'DMA', true,
    'DQA', true,
    'PRESSZONE', true,
    'DWFZONE', true,
    'SUPPLYZONE', true,
    'MACROSECTOR', true,
    'MACRODMA', true,
    'MACRODQA', true,
    'MACROOMZONE', true,
    'OMZONE', false,
    'DRAINZONE', false
  )
)::json
WHERE parameter = 'utils_graphanalytics_status';

-- 21/04/2026
UPDATE config_param_system SET parameter= 'basic_search_v2_tab_psector', value = '{"sys_display_name":"concat(name,'' ('',text2,'')'')","sys_tablename":"ve_plan_psector","sys_pk":"psector_id","sys_fct":"gw_fct_getinfofromid","sys_filter":"","sys_geom":"the_geom"}'
WHERE parameter = 'basic_search_v2_tab_psector ';

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname) 
VALUES('qgis_mapzone_inundation_from_arc', 'false', 'If true, graph inundation starts by selecting an arc', 'Inundation from arc:', NULL, NULL, true, 18, 'utils', NULL, NULL, 'boolean', 'check', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_other') ON CONFLICT DO NOTHING;


-- 21/04/2026
UPDATE config_function
	SET "style"='{
  "style": {
    "point": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5,
      "width": 2.5,
      "values": [
        {
          "id": "Disconnected",
          "color": [
            255,
            124,
            64
          ]
        },
        {
          "id": "Conflict",
          "color": [
            14,
            206,
            253
          ]
        }
      ]
    },
    "line": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5,
      "width": 2.5,
      "values": [
        {
          "id": "Disconnected",
          "color": [
            255,
            124,
            64
          ]
        },
        {
          "id": "Conflict",
          "color": [
            14,
            206,
            253
          ]
        }
      ]
    },
    "polygon": {
      "style": "categorized",
      "field": "descript",
      "transparency": 0.5
    },
    "Graphconfig": {
      "style": "qml",
      "id": "103"
    }
  }
}'::json
	WHERE id=3508;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4628, 'MAPZONES COULD NOT BE CALCULATED DUE TO ERRORS ON GRAPHCONFIG - CHECK ERRORS PARAGRAPH FOR MORE INFO', NULL, 0, true, 'ws', 'core', 'AUDIT');

-- 21/04/2026
UPDATE sys_fprocess SET except_table='anl_node' WHERE fprocess_type = 'Check epa-data' and except_msg is not null and isaudit = TRUE;
UPDATE sys_fprocess SET except_table=NULL WHERE fid IN (482, 272);
UPDATE sys_fprocess SET except_table='anl_arc' WHERE fid IN (169, 284);

UPDATE sys_fprocess SET except_table='anl_arc', query_text='SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_pump table'') AS epa_table, a.expl_id, a.the_geom FROM t_inp_pump JOIN arc a USING (arc_id) WHERE epa_type !=''PUMP''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_conduit table'') AS epa_table, a.expl_id, a.the_geom FROM t_inp_conduit JOIN arc a USING (arc_id) WHERE epa_type !=''CONDUIT''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_outlet table'') AS epa_table, a.expl_id, a.the_geom FROM t_inp_outlet JOIN arc a USING (arc_id) WHERE epa_type !=''OUTLET''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_orifice table'') AS epa_table, a.expl_id, a.the_geom FROM t_inp_orifice JOIN arc a USING (arc_id) WHERE epa_type !=''ORIFICE''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_weir table'') AS epa_table, a.expl_id, a.the_geom FROM t_inp_weir JOIN arc a USING (arc_id) WHERE epa_type !=''WEIR''
UNION
SELECT 295, a.arc_id, a.arccat_id, concat(epa_type, '' using inp_virtual table'') AS epa_table, a.expl_id, a.the_geom FROM t_inp_virtual JOIN arc a USING (arc_id) WHERE epa_type !=''VIRTUAL''' 
WHERE fid=295;

UPDATE sys_fprocess SET except_table='anl_arc', query_text='SELECT  a.arc_id,  b.arccat_id, b.expl_id, b.the_geom from t_inp_weir a
JOIN arc b USING (arc_id)
where weir_type is null or cd is null or geom1 is null or geom2 is null or offsetval is NULL'
WHERE fid=529;

UPDATE sys_fprocess SET except_table='anl_arc', query_text='SELECT a.arc_id, b.arccat_id, b.expl_id, b.the_geom from t_inp_orifice a
JOIN arc b USING (arc_id)
where ori_type is null or geom1 is null or offsetval is null'
WHERE fid=530;

UPDATE sys_fprocess SET except_table='anl_node', query_text='SELECT rg_id AS node_id, null as nodecat_id, expl_id, the_geom FROM t_raingage where (form_type is null) OR (intvl is null) OR (rgage_type is null) OR (scf is null)'
WHERE fid=285;

UPDATE sys_fprocess SET except_table='anl_node', query_text='SELECT rg_id as node_id, null as nodecat_id, expl_id, the_geom FROM t_raingage where rgage_type=''TIMESERIES'' AND timser_id IS NULL'
WHERE fid=286;

UPDATE sys_fprocess SET except_table='anl_node', query_text='SELECT rg_id as node_id, null as nodecat_id, expl_id, the_geom FROM t_raingage where rgage_type=''FILE'' AND (fname IS NULL or sta IS NULL or units IS NULL)'
WHERE fid=287;