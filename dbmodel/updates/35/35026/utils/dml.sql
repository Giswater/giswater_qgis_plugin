/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_workspace", "column":"active", "dataType":"boolean", "isUtils":"False"}}$$);

ALTER TABLE cat_workspace ALTER COLUMN active SET DEFAULT True;

UPDATE sys_fprocess SET fprocess_type='Function process' WHERE fprocess_type='"Function process"';

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES (453, 'Node planified duplicated', 'utils', null, 'core', true, 'Check plan-data', null) ON CONFLICT (fid) DO NOTHING;

--2022/06/09
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type, addparam)
VALUES(454, 'Check node_1 and node_2 on temp_table', 'utils', NULL, 'core', true, '"Function process"', NULL) 
ON CONFLICT (fid) DO NOTHING;