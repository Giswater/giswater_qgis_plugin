/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_expl_arc
 AS
 SELECT DISTINCT arc.arc_id
   FROM selector_expl,
    arc
  WHERE selector_expl.cur_user = "current_user"()::text AND (arc.expl_id = selector_expl.expl_id OR arc.expl_id2 = selector_expl.expl_id);


CREATE OR REPLACE VIEW v_expl_node
 AS
 SELECT DISTINCT node.node_id
   FROM selector_expl,
    node
  WHERE selector_expl.cur_user = "current_user"()::text AND (node.expl_id = selector_expl.expl_id OR node.expl_id2 = selector_expl.expl_id);


DROP TABLE IF EXISTS node_border_expl ;


CREATE OR REPLACE VIEW v_state_link_connec
 AS
(
         SELECT DISTINCT link.link_id
           FROM selector_state,
            selector_expl,
            link
          WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text
        EXCEPT ALL
         SELECT plan_psector_x_connec.link_id
           FROM selector_psector,
            selector_expl,
            plan_psector_x_connec
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
          WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE
) UNION ALL
 SELECT plan_psector_x_connec.link_id
   FROM selector_psector,
    selector_expl,
    plan_psector_x_connec
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = CURRENT_USER::text AND plan_psector_x_connec.active IS TRUE;

