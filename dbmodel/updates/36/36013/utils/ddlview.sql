/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_state_arc AS 
WITH 
p AS (SELECT arc_id, psector_id, state FROM plan_psector_x_arc WHERE active), 
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
a as (SELECT arc_id, state FROM arc)
SELECT arc.arc_id FROM selector_state,arc WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.arc_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
	UNION ALL
SELECT DISTINCT p.arc_id FROM s,p WHERE p.psector_id = s.psector_id AND p.state = 1;


CREATE OR REPLACE VIEW v_state_node AS 
WITH 
p AS (SELECT node_id, psector_id, state FROM plan_psector_x_node WHERE active), 
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
n AS (SELECT node_id, state FROM node)
SELECT n.node_id FROM selector_state,n WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.node_id FROM s, p WHERE p.psector_id = s.psector_id AND p.state = 0
	UNION ALL
SELECT DISTINCT p.node_id FROM s,p WHERE p.psector_id = s.psector_id AND p.state = 1;