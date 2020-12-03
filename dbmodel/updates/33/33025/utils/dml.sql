/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/01/10
UPDATE config_param_system SET isdeprecated = TRUE, isenabled = false where parameter = 'om_mincut_use_pgrouting';


INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, isenabled, layout_id, layout_order, project_type, datatype, widgettype, ismandatory, isdeprecated) 
VALUES ('om_mincut_version', '4', 'int2', 'system', 'Mincut version', 'Mincut version', TRUE, 17, 1, 'ws', 'string', 'linetext', true, false) ON CONFLICT (parameter) DO NOTHING;


