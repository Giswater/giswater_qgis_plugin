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
UPDATE sys_param_user SET dv_querytext ='$$SELECT UNNEST(ARRAY (select (text_column::json->>''list_tables_name'')::text[]
 from temp_table where fid =163 and cur_user = current_user)) as id, 
UNNEST(ARRAY (select (text_column::json->>''list_layers_name'')::text[] FROM temp_table
WHERE fid = 163 and cur_user = current_user)) as idval $$' WHERE id = 'edit_cadtools_baselayer_vdefault';


UPDATE sys_table SET sys_role = 'role_edit' WHERE id ilike 've_pol%';