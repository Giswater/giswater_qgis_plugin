/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO sys_fprocess_cm (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(353, 'Check users consistence', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'There are some users with no team assigned.', NULL, NULL, 'SELECT * FROM cat_user WHERE team_id IS NULL', 'All users have a team assigned.', '[]', true)
ON CONFLICT (fid) DO UPDATE SET
fprocess_name = EXCLUDED.fprocess_name,
project_type = EXCLUDED.project_type,
parameters = EXCLUDED.parameters,
"source" = EXCLUDED.source,
isaudit = EXCLUDED.isaudit,
fprocess_type = EXCLUDED.fprocess_type,
addparam = EXCLUDED.addparam,
except_level = EXCLUDED.except_level,
except_msg = EXCLUDED.except_msg,
except_table = EXCLUDED.except_table,
except_table_msg = EXCLUDED.except_table_msg,
query_text = EXCLUDED.query_text,
info_msg = EXCLUDED.info_msg,
function_name = EXCLUDED.function_name,
active = EXCLUDED.active;

-- Check for teams without any assigned users.
INSERT INTO sys_fprocess_cm (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(354, 'Check teams consistence', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'There are some teams with no users assigned.', NULL, NULL, 'SELECT * FROM cat_team ct WHERE NOT EXISTS (SELECT 1 FROM cat_user cu WHERE ct.team_id = cu.team_id)', 'All teams have users assigned.', '[]', true)
ON CONFLICT (fid) DO UPDATE SET
fprocess_name = EXCLUDED.fprocess_name,
project_type = EXCLUDED.project_type,
parameters = EXCLUDED.parameters,
"source" = EXCLUDED.source,
isaudit = EXCLUDED.isaudit,
fprocess_type = EXCLUDED.fprocess_type,
addparam = EXCLUDED.addparam,
except_level = EXCLUDED.except_level,
except_msg = EXCLUDED.except_msg,
except_table = EXCLUDED.except_table,
except_table_msg = EXCLUDED.except_table_msg,
query_text = EXCLUDED.query_text,
info_msg = EXCLUDED.info_msg,
function_name = EXCLUDED.function_name,
active = EXCLUDED.active; 

INSERT INTO sys_fprocess_cm (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active) VALUES(355, 'Check orphan nodes', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'There are some orphan nodes', 'cm_node', NULL, 'SELECT a.node_id, a.nodecat_id, a.expl_id, a.the_geom FROM ws_40_lots.v_edit_node a JOIN ws_40_lots.cat_node nc ON nodecat_id=id JOIN ws_40_lots.cat_feature_node nt ON nt.id=nc.node_type JOIN ws_40_lots.node ON node.node_id = a.node_id WHERE a.state > 0 AND isarcdivide = ''false'' AND node.arc_id IS null', 'All teams have users assigned.', '[]', true)
ON CONFLICT (fid) DO UPDATE SET
fprocess_name = EXCLUDED.fprocess_name,
project_type = EXCLUDED.project_type,
parameters = EXCLUDED.parameters,
"source" = EXCLUDED.source,
isaudit = EXCLUDED.isaudit,
fprocess_type = EXCLUDED.fprocess_type,
addparam = EXCLUDED.addparam,
except_level = EXCLUDED.except_level,