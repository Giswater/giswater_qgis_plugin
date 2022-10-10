/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/29
INSERT INTO sys_table(id, descript, sys_role, source)
VALUES ('temp_lid_usage', 'Table used during pg2epa export for lid usage configuration', 'role_epa','core') ON CONFLICT (id) DO NOTHING;
 
UPDATE config_param_system set value = 
json_build_object('activated', value,'updateField','top_elev')::text WHERE parameter='admin_raster_dem';