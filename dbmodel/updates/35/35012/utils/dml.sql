/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/19
INSERT INTO config_function VALUES (2160, 'gw_fct_setfields', NULL, NULL, '[{"funcName": "refresh_canvas", "params": {}}]')
ON CONFLICT (id) DO NOTHING;

--2021/08/20
INSERT INTO sys_fprocess VALUES (395, 'Check to_arc missed values for pumps', 'ws')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function VALUES (3070, 'gw_fct_pg2epa_vnodetrimarcs', 'ud', 'function', 'text', 'json', 'Function to trim arcs using gullies', 'role_epa')
ON CONFLICT (id) DO NOTHING;