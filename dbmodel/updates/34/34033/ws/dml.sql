/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/04

INSERT INTO config_param_system (parameter, value,  project_type, datatype,isenabled, descript)
VALUES ('admin_addmapzone', '{"dma":{"idXExpl": "false", "setUpdate":null}, "presszone":{"idXExpl": "false", "setUpdate":null}}', 'ws', 'json', false, 
'Defines if mapzone id depends on expl and if it updates any more inventory fields')
ON CONFLICT (parameter) DO NOTHING;