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


UPDATE sys_param_user SET layoutorder=2, layoutname = 'lyt_connec_gully_vdef' WHERE id='feat_fountain_vdefault';
UPDATE sys_param_user SET layoutorder=3, layoutname = 'lyt_connec_gully_vdef' WHERE id='feat_greentap_vdefault';
UPDATE sys_param_user SET layoutorder=4, layoutname = 'lyt_connec_gully_vdef' WHERE id='feat_tap_vdefault';
UPDATE sys_param_user SET layoutorder=5, layoutname = 'lyt_connec_gully_vdef' WHERE id='feat_vconnec_vdefault';
UPDATE sys_param_user SET layoutorder=6, layoutname = 'lyt_connec_gully_vdef' WHERE id='feat_wjoin_vdefault';
