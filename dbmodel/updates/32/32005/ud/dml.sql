/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- 3.1.111

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('inp_subc_seq_id_prefix', 'C', 'text', 'epa', NULL) ON CONFLICT (parameter) DO NOTHING;

--24/04/2019
UPDATE audit_cat_table SET sys_role_id='role_om' WHERE id='v_ui_om_visitman_x_gully';