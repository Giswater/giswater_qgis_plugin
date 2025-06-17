/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = cm, public, pg_catalog;


INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(101, 'Check users consistence', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'There are some users with no team assigned.', NULL, NULL, 'SELECT * FROM cat_user WHERE team_id IS NULL', 'All users have a team assigned.', '[]', true)
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
INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(102, 'Check teams consistence', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'There are some teams with no users assigned.', NULL, NULL, 'SELECT * FROM cat_team ct WHERE NOT EXISTS (SELECT 1 FROM cat_user cu WHERE ct.team_id = cu.team_id)', 'All teams have users assigned.', '[]', true)
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

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(103, 'Check orphan nodes', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'There are some orphan nodes', 'cm_node', NULL, 'SELECT a.node_id, a.nodecat_id, a.expl_id, a.the_geom FROM PARENT_SCHEMA.v_edit_node a JOIN PARENT_SCHEMA.cat_node nc ON nodecat_id=id JOIN PARENT_SCHEMA.cat_feature_node nt ON nt.id=nc.node_type JOIN PARENT_SCHEMA.node ON node.node_id = a.node_id WHERE a.state > 0 AND isarcdivide = ''false'' AND node.arc_id IS null', 'All teams have users assigned.', '[]', true)
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

INSERT INTO sys_fprocess (fid, fprocess_name, project_type, parameters, "source", isaudit, fprocess_type, addparam, except_level, except_msg, except_table, except_table_msg, query_text, info_msg, function_name, active)
VALUES(104, 'Check duplicated nodes', 'cm', NULL, 'core', true, 'Check cm', NULL, 3, 'nodes duplicated with state 1.', 'cm_node', NULL, 'SELECT * FROM  (SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state AS state1, t2.node_id AS node_2, t2.nodecat_id AS nodecat_2, t2.state as state2, t1.expl_id, 106, t1.the_geom FROM PARENT_SCHEMA.node AS t1 JOIN PARENT_SCHEMA.node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom, 0.01) WHERE t1.node_id != t2.node_id ORDER BY t1.node_id ) a where a.state1 = 1 AND a.state2 = 1', 'There are no nodes duplicated with state 1', '[]', true)
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
