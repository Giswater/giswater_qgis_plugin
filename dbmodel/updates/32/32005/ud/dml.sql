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

INSERT INTO audit_cat_param_user VALUES ('connecarccat_vdefault', 'config', 'Default value for connec_arccat_id', 'role_edit', NULL, NULL, 'Connec arccat:','SELECT cat_connec.id AS id, cat_connec.id as idval FROM cat_connec WHERE id IS NOT NULL', NULL, true, 12, 1, 'ud', false, NULL, 'connec_arccat_id', NULL, false, 'string', 'combo', false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false);
