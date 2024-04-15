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
 

 CREATE OR REPLACE VIEW v_state_connec AS 
 SELECT DISTINCT ON (a.connec_id) a.connec_id,
    a.arc_id
   FROM (( SELECT connec.connec_id,
                    connec.arc_id,
                    1 AS flag
                   FROM selector_state,  connec
                  WHERE connec.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
                EXCEPT
                 SELECT plan_psector_x_connec.connec_id,
                    plan_psector_x_connec.arc_id,
                    1 AS flag
                   FROM selector_psector,  plan_psector_x_connec
                     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
                  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 
        ) UNION
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.arc_id,
            2 AS flag
           FROM selector_psector, plan_psector_x_connec
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
          WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1
  ORDER BY 1, 3 DESC) a;