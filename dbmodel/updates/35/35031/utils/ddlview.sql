/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_macrosector AS 
 SELECT macrosector.macrosector_id,
    macrosector.name,
    macrosector.descript,
    macrosector.the_geom,
    macrosector.undelete,
    macrosector.active
   FROM macrosector WHERE active is true;

CREATE OR REPLACE VIEW v_state_node
AS ( SELECT node.node_id
           FROM selector_state, node
          WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT
         SELECT plan_psector_x_node.node_id
           FROM selector_psector, plan_psector_x_node
          WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
          AND plan_psector_x_node.state = 0
) UNION
 SELECT plan_psector_x_node.node_id
   FROM selector_psector, plan_psector_x_node
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text 
  AND plan_psector_x_node.state = 1;

CREATE OR REPLACE VIEW v_expl_node
AS  SELECT node.node_id
           FROM selector_expl, node
          WHERE selector_expl.cur_user = "current_user"()::text AND (node.expl_id = selector_expl.expl_id)
          union
     SELECT node_id
           FROM selector_expl, node_border_expl
          WHERE selector_expl.cur_user = "current_user"()::text AND (node_border_expl.expl_id = selector_expl.expl_id);