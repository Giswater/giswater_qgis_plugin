/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW v_expl_arc
 AS
 SELECT arc.arc_id
   FROM selector_expl,
    arc
  WHERE selector_expl.cur_user = "current_user"()::text AND (arc.expl_id = selector_expl.expl_id OR arc.expl_id2 = selector_expl.expl_id);


CREATE OR REPLACE VIEW v_expl_node
 AS
 SELECT node.node_id
   FROM selector_expl,
    node
  WHERE selector_expl.cur_user = "current_user"()::text AND (node.expl_id = selector_expl.expl_id OR node.expl_id2 = selector_expl.expl_id);

