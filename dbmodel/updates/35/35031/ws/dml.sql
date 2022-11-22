/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system set project_type='utils' WHERE parameter='utils_graphanalytics_status';

UPDATE sys_function SET function_name='gw_fct_massivemincut' where id=2712;

UPDATE config_toolbox SET alias = 'Mapzones analysis' WHERE id=2768;

UPDATE config_param_system SET value=value::jsonb || '{"node":"SELECT node_id AS node_id, code AS code FROM v_edit_node"}' WHERE parameter='om_profile_guitartext';
