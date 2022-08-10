/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/26

INSERT INTO sys_param_user VALUES('edit_noderotation_update_dsbl', 'config', 'If true, the automatic rotation calculation on the nodes is disabled. Used for an absolute manual update of rotation field', 'role_edit', NULL, 'Disable node rotation on update:', NULL, NULL, true, 3, 'utils', false, NULL, NULL, NULL, false, 'boolean', 'check', true, NULL, 'TRUE', 'lyt_other', true, NULL, NULL, NULL, NULL, 'core') ON CONFLICT (id) DO NOTHING;

-- 2022/08/10
UPDATE sys_param_user SET descript = 'Default value for enable /disable gully. Two options are available (Sink, To_network). In case of Sink water is lossed.', vdefault = 'To_network' WHERE id = 'epa_gully_outlet_type_vdefault';
UPDATE inp_typevalue SET id = 'To_network', idval = 'To_network' WHERE typevalue = 'typevalue_gully_outlet_type' AND id = 'To network'

