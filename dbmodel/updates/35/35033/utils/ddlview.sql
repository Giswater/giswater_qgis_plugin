/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2023/02/13

CREATE OR REPLACE VIEW v_state_arc
 AS
(
         SELECT arc.arc_id
           FROM selector_state,
            arc
          WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text 
        EXCEPT
         SELECT plan_psector_x_arc.arc_id
           FROM selector_psector,
            plan_psector_x_arc
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
          WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_arc.state = 0
) UNION
 SELECT plan_psector_x_arc.arc_id
   FROM selector_psector,
    plan_psector_x_arc
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_arc.state = 1;


CREATE OR REPLACE VIEW v_expl_arc
 AS
 SELECT arc.arc_id
   FROM selector_expl,
    arc
  WHERE selector_expl.cur_user = "current_user"()::text AND arc.expl_id = selector_expl.expl_id
UNION
 SELECT arc_border_expl.arc_id
   FROM selector_expl,
    arc_border_expl
  WHERE selector_expl.cur_user = "current_user"()::text AND arc_border_expl.expl_id = selector_expl.expl_id;


