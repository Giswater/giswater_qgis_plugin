/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_node AS 
 SELECT n.*
 FROM 
 (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) s, vu_node n
 JOIN v_state_node USING (node_id)
 WHERE (n.expl_id = s.expl_id OR n.expl_id2 = s.expl_id);
 
 
 CREATE OR REPLACE VIEW v_arc AS 
 SELECT a.*
 FROM 
 (SELECT expl_id FROM selector_expl WHERE selector_expl.cur_user = current_user) s, vu_arc a
 JOIN v_state_arc USING (arc_id)
 WHERE (a.expl_id = s.expl_id OR a.expl_id2 = s.expl_id);
 