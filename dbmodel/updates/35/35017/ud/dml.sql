/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ws_sample, public, pg_catalog;

--2021/11/01
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (416, 'Gully without pjoint_id or pjoint_type','ud', null, null) ON CONFLICT (fid) DO NOTHING;



