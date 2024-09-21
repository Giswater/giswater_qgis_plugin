/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_state_connec AS 
WITH 
p AS (SELECT connec_id, psector_id, state, arc_id FROM plan_psector_x_connec WHERE active), 
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
c as (SELECT connec_id, state, arc_id FROM connec)
SELECT c.connec_id::varchar(30), c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.connec_id::varchar(30), p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text 
AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT ON (p.connec_id) p.connec_id::varchar(30), p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text 
AND p.state = 1 AND cf.value is TRUE;



CREATE OR REPLACE VIEW v_state_gully AS 
WITH 
p AS (SELECT gully_id, psector_id, state, arc_id FROM plan_psector_x_gully WHERE active), 
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
s AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
c as (SELECT gully_id, state, arc_id FROM gully)
SELECT c.gully_id, c.arc_id FROM selector_state,c WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.gully_id, p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text 
AND p.state = 0 AND cf.value is TRUE
	UNION ALL
SELECT DISTINCT ON (p.gully_id) p.gully_id, p.arc_id FROM s, p, cf WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text 
AND p.state = 1 AND cf.value is TRUE;



CREATE OR REPLACE VIEW v_state_link_connec AS 
WITH 
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) 
AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;


CREATE OR REPLACE VIEW v_state_link_gully AS 
WITH 
p AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) 
AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT p.link_id FROM sp, se, cf, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;


CREATE OR REPLACE VIEW v_state_link AS
WITH 
c AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
cf AS (SELECT value::boolean FROM config_param_user WHERE parameter = 'utils_psector_strategy' AND cur_user = current_user),
g AS (SELECT gully_id, psector_id, state, link_id FROM plan_psector_x_gully WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) 
AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT c.link_id FROM sp, se, cf, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 0 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	EXCEPT ALL
SELECT g.link_id FROM sp, se, cf, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 0 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT c.link_id FROM sp, se, cf, c JOIN l USING (link_id) WHERE c.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND c.state = 1 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE
	UNION ALL
SELECT g.link_id FROM sp, se, cf, g JOIN l USING (link_id) WHERE g.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND g.state = 1 
AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value is TRUE;