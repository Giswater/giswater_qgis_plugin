/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/11/20

UPDATE sys_message SET error_message='The inserted value is not present in a catalog.'
WHERE ID = 3022;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (357, 'Store hydrometer user selector values', 'utils') ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (358, 'Store state user selector values', 'utils') ON CONFLICT (fid) DO NOTHING ;
