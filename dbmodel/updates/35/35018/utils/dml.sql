/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/08 
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (417, 'Links without connec on startpoint','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (419, 'Duplicated hydrometer related to more than one connec','utils', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/10
UPDATE sys_function SET descript ='Check topology assistant. Helps user to identify nodes connected with more/less arcs compared to num_arcs field of cat_feature_node table' WHERE id IN (2212, 2302);

--2021/11/13
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (421, 'Check category_type values exists on man_ table','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (422, 'Check function_type values exists on man_ table','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (423, 'Check fluid_type values exists on man_ table','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (424, 'Check location_type values exists on man_ table','utils', null, null) ON CONFLICT (fid) DO NOTHING;

UPDATE sys_param_user SET vdefault = gw_fct_json_object_set_key(value, 'step', '0'::integer) WHERE id = 'inp_options_debug';
UPDATE sys_param_user SET vdefault = gw_fct_json_object_delete_keys(value, 'onlyExport', 'checkData', 'checkNetwork') WHERE id = 'inp_options_debug';

UPDATE config_param_user SET value = gw_fct_json_object_set_key(value, 'step', '0'::integer) WHERE parameter = 'inp_options_debug';
UPDATE config_param_user SET value = gw_fct_json_object_delete_keys(value, 'onlyExport', 'checkData', 'checkNetwork') WHERE parameter = 'inp_options_debug';
