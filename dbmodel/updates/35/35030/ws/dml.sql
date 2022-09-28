/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/26
INSERT INTO config_function( id, function_name, style, layermanager, actions)
SELECT 2928, 'gw_fct_getstylemapzones', value::json, null, null
FROM config_param_system
WHERE parameter='utils_graphanalytics_dynamic_symbology' ON CONFLICT (id) DO NOTHING;

DELETE FROM config_param_system WHERE parameter='utils_graphanalytics_dynamic_symbology';