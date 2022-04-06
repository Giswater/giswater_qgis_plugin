/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/04/06
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source, isaudit, fprocess_type)
VALUES ('440', 'Check outlet_id assigned to subcatchments','ud',null, 'core', true, 'Check epa-config')
ON CONFLICT (fid) DO NOTHING;

UPDATE config_param_system SET parameter='admin_debug' WHERE parameter = 'om_mincut_debug';
