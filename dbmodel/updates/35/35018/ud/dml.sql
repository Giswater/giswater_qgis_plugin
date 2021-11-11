/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/08
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (418, 'Links without gully on startpoint','ud', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/11/11
INSERT INTO config_function(id, function_name) VALUES (3104, 'gw_fct_import_istram');
