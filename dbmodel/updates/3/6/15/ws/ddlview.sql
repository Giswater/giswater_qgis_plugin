/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_state_link AS 
WITH 
p AS (SELECT connec_id, psector_id, state, link_id FROM plan_psector_x_connec WHERE active), 
sp AS (SELECT * FROM selector_psector WHERE cur_user = current_user), 
se AS (SELECT * FROM selector_expl WHERE cur_user = current_user), 
l AS (SELECT link_id, state, expl_id, expl_id2 FROM link)
SELECT l.link_id  FROM selector_state, se, l WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id2 = se.expl_id) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
	EXCEPT ALL
SELECT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text
	UNION ALL
SELECT DISTINCT p.link_id FROM sp, se, p JOIN l USING (link_id) WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text;

