/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/09/16

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (267, 'Cat_feature_node without grafdelimiter definition', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (268, 'Sectors without grafconfig', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (269, 'DMA without grafconfig', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (270, 'DQA without grafconfig', 'ws') ON CONFLICT (fid) DO NOTHING;	

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (271, 'Presszone without grafconfig', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (272, 'Missing data on inp tables', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (273, 'Null values on valv_type table', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (274, 'Null values on valve status', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (275, 'Null values on valve pressure', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (276, 'Null values on GPV valve config', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (277, 'Null values on TCV valve config', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (278, 'Null values on FCV valve config', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (279, 'Null values on pump type', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (280, 'Null values on pump curve_id ', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (281, 'Null values on additional pump curve_id ', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (282, 'Null values on roughness catalog ', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (283, 'Null values on arc catalog - dint', 'ws') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (284, 'Arcs without elevation', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (285, 'Null values on raingage', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (286, 'Null values on raingage timeseries', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (287, 'Null values on raingage file', 'ud') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess (fid, fprocess_name, project_type)
VALUES (288, 'Store psector values for specific user', 'utils') ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (289, 'Store exploitation values for especific user', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess VALUES (290, 'Duplicated node on temp_table', 'utils')
ON CONFLICT (fid) DO NOTHING;

-- 2020/17/09

UPDATE sys_param_user SET dv_querytext = 'SELECT UNNEST(ARRAY (select (text_column::json->>''list_tables_name'')::text[] 
 from temp_table where fid = 163 and cur_user = current_user)) as id, 
 UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] FROM temp_table 
 WHERE fid = 163 and cur_user = current_user)) as idval' WHERE id = 'edit_cadtools_baselayer_vdefault';


UPDATE sys_table SET sys_role = 'role_edit' WHERE id ilike 've_pol%';

--2020/09/21
UPDATE config_param_system SET parameter = 'utils_grafanalytics_lrs_feature' WHERE parameter = 'grafanalytics_lrs_feature';
UPDATE config_param_system SET parameter = 'utils_grafanalytics_lrs_graf' WHERE parameter = 'grafanalytics_lrs_graf';

--2020/09/22
UPDATE config_form_tabs SET orderby=1 WHERE formname='selector_basic' AND tabname='tab_exploitation' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby=2 WHERE formname='selector_basic' AND tabname='tab_network_state' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby=3 WHERE formname='selector_basic' AND tabname='tab_hydro_state' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby=4 WHERE formname='selector_basic' AND tabname='tab_psector' AND orderby IS NULL;
UPDATE config_form_tabs SET orderby=5 WHERE formname='selector_basic' AND tabname='tab_sector' AND orderby IS NULL;


UPDATE sys_table SET notify_action ='[{"channel":"user","name":"set_layer_index", "enabled":"true", "trg_fields":"the_geom","featureType":["connec", "v_edit_link"]}]' WHERE id = 'connec';

INSERT INTO config_param_system (parameter, value, descript, isenabled, project_type, datatype) VALUES ('plan_psector_execute_action', '{"mode":"disabled"}',
'Define which mode psector trigger would use. Modes: "disabled", "onService"(transform all features afected by psector to its planified state and makes a
 copy of psector), "obsolete"(set all features afected to obsolete but manage their state_type)', FALSE, 'utils', 'json');
 
 INSERT INTO sys_message VALUES (3134, 'There''s no default value for Obsolete state_type', 'You need to define one default value for Obsolete state_type', 2, TRUE, 'utils');
 INSERT INTO sys_message VALUES (3136, 'There''s no default value for On Service state_type', 'You need to define one default value for On Service state_type', 2, TRUE, 'utils');

 UPDATE config_param_system SET value='{"table":"plan_psector", "selector":"selector_psector", "table_id":"psector_id",  "selector_id":"psector_id",  "label":"psector_id, '' - '', name", "orderBy":"psector_id",
"manageAll":true, "query_filter":" AND expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user = current_user)",
"layermanager":{"active":"v_edit_psector", "visible":["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully"], "addToc":["v_edit_psector"]},
"typeaheadFilter":" AND lower(concat(expl_id, '' - '', name))"}' WHERE parameter='basic_selector_tab_psector';

UPDATE config_param_system SET value='{"table":"sector", "selector":"selector_sector", "table_id":"sector_id",  "selector_id":"sector_id",  "label":"sector_id, '' - '', name", "orderBy":"sector_id",
"manageAll":true, "query_filter":" AND sector_id > 0"}' WHERE parameter='basic_selector_tab_sector';

 INSERT INTO sys_message VALUES (3138, 'Before use connec on planified mode you need to create a related link', NULL, 2, TRUE, 'utils');
 
UPDATE config_typevalue SET camelstyle='gwGetVisit' WHERE id='get_visit' AND typevalue='widgetfunction_typevalue';
UPDATE config_typevalue SET camelstyle='gwSetVisit' WHERE id='set_visit' AND typevalue='widgetfunction_typevalue';
UPDATE config_typevalue SET camelstyle='gwSetPrint' WHERE id='set_print' AND typevalue='widgetfunction_typevalue';
UPDATE config_typevalue SET camelstyle='backButtonClicked' WHERE id='set_previous_form_back' AND typevalue='widgetfunction_typevalue';

DELETE FROM config_form_fields WHERE formname IN ('lot', 'om_visit', 'om_visit_lot', 'visit_manager');
UPDATE config_form_fields SET widgetfunction = NULL WHERE widgetfunction='get_visit_manager' AND formname like 'v_ui_om_visitman%';

DELETE FROM config_typevalue WHERE id='get_lot' AND typevalue='widgetfunction_typevalue';
DELETE FROM config_typevalue WHERE id='get_visit_manager' AND typevalue='widgetfunction_typevalue';
DELETE FROM config_typevalue WHERE id='set_visit_manager' AND typevalue='widgetfunction_typevalue';
 

UPDATE config_param_system SET value=
'{"SECTOR":{"mode":"Disable", "column":"sector_id"}, "DMA":{"mode":"Stylesheet", "column":"name"}, "PRESSZONE":{"mode":"Random", "column":"presszone_id"}, "DQA":{"mode":"Random", "column":"dqa_id"}, "MINSECTOR":{"mode":"Disable", "column":"minsector_id"}}'
WHERE parameter  = 'utils_grafanalytics_dynamic_symbology';

DELETE FROM config_param_user WHERE parameter='qgis_toggledition_forceopen';
DELETE FROM sys_param_user WHERE id='qgis_toggledition_forceopen';

DELETE FROM config_param_user WHERE parameter='edit_connect_downgrade_link';
DELETE FROM sys_param_user WHERE id='edit_connect_downgrade_link';

--2020/10/14
UPDATE exploitation SET active = TRUE WHERE active IS NULL;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type)
VALUES (3144, 'Exploitation of the feature is different than the one of the related arc. Arc_id: ',
'Both features should have the same exploitation.', 2, TRUE, 'utils') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (291, 'Connec or gully with different expl_id than arc', 'utils') ON CONFLICT (fid) DO NOTHING;
