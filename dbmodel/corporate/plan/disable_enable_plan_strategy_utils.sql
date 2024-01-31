/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

set search_path  = SCHEMA_NAME;


/*
Other strategies not implemented yet

- When disabled, use the layers plan_psector_x_* to show planned infraestructure (not allowed to show deprecated objects (0 state) on psector)
- Add hydbrid strategy by using:
	- ve_* layers for inventory
	- v_edit_* layers for plan
*/


--DISABLE PLAN STRATEGY-- 
------------------------
UPDATE config_form_tabs SET formname = 'selector_basic_' where tabname = 'tab_psector' and formname = 'selector_basic';

CREATE OR REPLACE VIEW v_state_arc AS 
  SELECT arc.arc_id FROM selector_state, arc
  WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_state_connec AS 
  SELECT connec.connec_id, connec.arc_id,state AS flag
  FROM selector_state, selector_expl, connec
  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id)
  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;

 
CREATE OR REPLACE VIEW v_state_link AS 
  SELECT link.link_id
  FROM selector_state, selector_expl, link
  WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
  AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_state_link_connec AS 
 SELECT link.link_id
 FROM selector_state,selector_expl, link
 WHERE link.state = selector_state.state_id AND (link.expl_id = selector_expl.expl_id OR link.expl_id2 = selector_expl.expl_id) 
 AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text AND link.feature_type::text = 'CONNEC'::text;
  
          
CREATE OR REPLACE VIEW v_state_node AS 
  SELECT node.node_id FROM selector_state, node
  WHERE node.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text;


--ENABLE PLAN STRATEGY-- 
------------------------
UPDATE config_form_tabs SET formname = 'selector_basic' where tabname = 'tab_psector' and formname = 'selector_basic_';


CREATE OR REPLACE VIEW v_sector_node AS 
 SELECT node.node_id
   FROM selector_sector,
    node
  WHERE selector_sector.cur_user = "current_user"()::text AND node.sector_id = selector_sector.sector_id
UNION
 SELECT node_border_sector.node_id
   FROM selector_sector,
    node_border_sector
  WHERE selector_sector.cur_user = "current_user"()::text AND node_border_sector.sector_id = selector_sector.sector_id;

CREATE OR REPLACE VIEW v_state_arc AS 
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


CREATE OR REPLACE VIEW v_state_connec AS 
 SELECT DISTINCT ON (a.connec_id) a.connec_id, a.arc_id, flag::smallint
   FROM ((
                 SELECT connec.connec_id,
                    connec.arc_id,
                    1 AS flag
                   FROM selector_state,
                    selector_expl,
                    connec
                  WHERE connec.state = selector_state.state_id AND (connec.expl_id = selector_expl.expl_id OR connec.expl_id2 = selector_expl.expl_id) AND selector_state.cur_user = "current_user"()::text AND selector_expl.cur_user = "current_user"()::text
                EXCEPT
                 SELECT plan_psector_x_connec.connec_id,
                    plan_psector_x_connec.arc_id,
                    1 AS flag
                   FROM selector_psector,
                    selector_expl,
                    plan_psector_x_connec
                     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
                  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 0 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
        ) UNION
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.arc_id,
            2 AS flag
           FROM selector_psector,
            selector_expl,
            plan_psector_x_connec
             JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_connec.psector_id
          WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text AND plan_psector_x_connec.state = 1 AND plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
  ORDER BY 1, 3 DESC) a;



CREATE OR REPLACE VIEW v_state_link_connec AS 
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