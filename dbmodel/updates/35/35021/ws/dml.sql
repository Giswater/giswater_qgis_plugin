/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (432, 'Check node ''T candidate'' with wrong topology','ws', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/12/30
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'checkData', 'NONE'::text) WHERE parameter = 'utils_grafanalytics_status';

--2021/12/31
UPDATE config_function SET style = 
'{"style": {"point": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
"line": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]}}}'
WHERE id = 2710; 