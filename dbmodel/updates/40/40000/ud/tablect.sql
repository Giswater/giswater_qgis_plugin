/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Recreate the constraints that were previously deleted
ALTER TABLE arc ADD CONSTRAINT arc_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT node_nodecat_id_fkey FOREIGN KEY (nodecat_id) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_conneccat_id_fkey FOREIGN KEY (conneccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_private_conneccat_id_fkey FOREIGN KEY (private_conneccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_connec_arccat_id_fkey FOREIGN KEY (connec_arccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_conneccat_id_fkey FOREIGN KEY (conneccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_gullycat2_id_fkey FOREIGN KEY (gullycat2_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_gullycat_id_fkey FOREIGN KEY (gullycat_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gullycat2_id_fkey FOREIGN KEY (gullycat2_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gullycat_id_fkey FOREIGN KEY (gullycat_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- 04/12/2024
ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;

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

--28/01/2025
--Altering the inp tables for the flowregulators for constraints.
--ORIFICE
ALTER TABLE inp_flwreg_orifice ADD CONSTRAINT inp_flwreg_orifice_pkey PRIMARY KEY (flwreg_id);
ALTER TABLE inp_flwreg_orifice ADD CONSTRAINT inp_flwreg_orifice_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE;

--OUTLET
ALTER TABLE inp_flwreg_outlet ADD CONSTRAINT inp_flwreg_outlet_pkey PRIMARY KEY (flwreg_id);
ALTER TABLE inp_flwreg_outlet ADD CONSTRAINT inp_flwreg_outlet_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE;

--WEIR
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_pkey PRIMARY KEY (flwreg_id);
ALTER TABLE inp_flwreg_weir ADD CONSTRAINT inp_flwreg_weir_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE;

--PUMP 
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_pkey PRIMARY KEY (flwreg_id);
ALTER TABLE inp_flwreg_pump ADD CONSTRAINT inp_flwreg_pump_flwreg_id_fkey FOREIGN KEY (flwreg_id) REFERENCES flwreg(flwreg_id) ON DELETE CASCADE ON UPDATE CASCADE;