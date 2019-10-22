/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_param_system(parameter, value, data_type, context, descript, label, project_type, isdeprecated)
VALUES ('plan_statetype_planned', '3', 'integer', 'plan', 'State type for planned elements', 'State type for planned elements', 'utils', false) 
-- in case existing
ON CONFLICT (parameter) DO NOTHING;

--in case existing
UPDATE  config_param_system WHERE SET label='State type for planned elements', project_type='utils', isdeprecated=FALSE WHERE parameter='plan_statetype_planned';

UPDATE value_state_type SET isoperative=false WHERE state=0;
