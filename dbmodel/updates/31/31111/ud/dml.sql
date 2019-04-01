/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- 2019/04/01
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype, tooltip) 
VALUES ('inp_subc_seq_id_prefix', 'C', 'text', 'epa', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

