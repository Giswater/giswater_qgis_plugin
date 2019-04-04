/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 2019/03/27
SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('sys_exploitation_x_user','false','boolean', 'basic', 'Parameters to identify if system has enabled restriction for users in function of exploitation');

INSERT INTO sys_fprocess_cat VALUES (39, 'Epa inlet flowtrace', 'Edit', 'Epa inlet flowtrace', 'ws');

UPDATE sys_feature_type SET parentlayer = 'v_edit_arc' WHERE id='ARC';
UPDATE sys_feature_type SET parentlayer = 'v_edit_node' WHERE id='NODE';
UPDATE sys_feature_type SET parentlayer = 'v_edit_connec' WHERE id='CONNEC';


INSERT INTO audit_cat_table VALUES ('anl_polygon', 'Analysis', 'Table with the results of the topology process of polygons', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, false);

