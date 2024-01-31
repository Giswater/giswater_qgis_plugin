/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

set search_path  = SCHEMA_NAME;


-- DISABLE PLAN STRATEGY
------------------------

CREATE OR REPLACE VIEW v_state_gully AS 
SELECT DISTINCT ON (gully_id) gully_id, arc_id 
FROM selector_state, selector_expl, gully
WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) 
AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;
              
CREATE OR REPLACE VIEW v_state_link_gully AS 
SELECT DISTINCT link.link_id FROM selector_state, selector_expl,link
WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id)
AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text;

  

-- ENABLE PLAN STRATEGY
-----------------------
CREATE OR REPLACE VIEW v_state_gully AS 
SELECT DISTINCT ON (a.gully_id) a.gully_id, a.arc_id
FROM ((
                 SELECT gully.gully_id,
                    gully.arc_id,
                    1 AS flag
                   FROM selector_state,
                    selector_expl,
                    gully
                  WHERE gully.state = selector_state.state_id AND (gully.expl_id = selector_expl.expl_id OR gully.expl_id2 = selector_expl.expl_id) AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
                EXCEPT
                 SELECT plan_psector_x_gully.gully_id,
                    plan_psector_x_gully.arc_id,
                    1 AS flag
                   FROM selector_psector,
                    selector_expl,
                    plan_psector_x_gully
                     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
                  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
        ) UNION
         SELECT plan_psector_x_gully.gully_id,
            plan_psector_x_gully.arc_id,
            2 AS flag
           FROM selector_psector,
            selector_expl,
            plan_psector_x_gully
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
          WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
  ORDER BY 1, 3 DESC) a;


CREATE OR REPLACE VIEW v_state_link_gully AS 
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'GULLY'::text
        EXCEPT ALL
         SELECT plan_psector_x_gully.link_id
           FROM selector_psector,
            selector_expl,
            plan_psector_x_gully
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
          WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_gully.active IS TRUE
) UNION ALL
 SELECT plan_psector_x_gully.link_id
   FROM selector_psector,
    selector_expl,
    plan_psector_x_gully
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_gully.psector_id
  WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_gully.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_gully.active IS TRUE;