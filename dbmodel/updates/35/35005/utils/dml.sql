/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/11
INSERT INTO config_param_system(parameter, value, descript, isenabled, project_type, datatype)
VALUES ('edit_arc_divide', '{"setArcObsolete":"false","setOldCode":"false"}', 
'Configuration of arc divide tool. If setArcObsolete true state of old arc would be set to 0, otherwise arc will be deleted. If setOldCode true, new arcs will have same code as old arc.',
FALSE, 'utils', 'json') ON CONFLICT (parameter) DO NOTHING;