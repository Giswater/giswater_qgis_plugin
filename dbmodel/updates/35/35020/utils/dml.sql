/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/30
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (430, 'Check matcat null for arcs','utils', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (431, 'Check minimun length for arcs','ud', null, null) ON CONFLICT (fid) DO NOTHING;
