/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 04/12/2024
ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_workcat ADD CONSTRAINT doc_x_workcat_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_visit ADD CONSTRAINT doc_x_visit_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;

DROP RULE insert_plan_psector_x_arc ON arc;
DROP RULE insert_plan_psector_x_node ON node;

CREATE RULE insert_plan_psector_x_arc AS
    ON INSERT TO arc
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
  VALUES (new.arc_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_current'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);

CREATE RULE insert_plan_psector_x_node AS
    ON INSERT TO node
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
  VALUES (new.node_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_current'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);