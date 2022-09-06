/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/06

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam) -- old duplicated fid 462
VALUES(467, 'Planified EPANET pumps with more than two acs', 'ws', NULL, 'core', true, 'Check plan-data', NULL) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)  -- old duplicated fid 465
VALUES (468, 'Graph analysis for hydrants - hydrant proposal', 'ws',null, 'core', false, 'Function process',null) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (469, 'Import scada_x_data values', 'utils',null, 'core', false, 'Function process',null) 
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function (id,function_name,project_type,function_type,input_params,return_type,descript,sys_role,"source")
VALUES (3166,'gw_fct_import_scada_x_data','utils','function','json','json','Function to import scada_x_data values','role_om','core')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (469, 'Import scada_x_data', 'Import scada_x_data', 'gw_fct_import_scada_x_data', true,16, null) 
ON CONFLICT (fid) DO NOTHING;


-- profilactic delete to avoid conflicts with sequences
DELETE FROM audit_check_project;
DELETE FROM audit_check_data;