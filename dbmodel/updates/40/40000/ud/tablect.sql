/*
This file is part of Giswater
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

-- 10/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"node", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"connec", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"gully", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"element", "column":"buildercat_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_gully_traceability", "column":"buildercat_id"}}$$);

DROP TABLE cat_builder;


--18/03/2025
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_manhole ADD CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_wwtp ADD CONSTRAINT man_wwtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_event ADD CONSTRAINT om_visit_event_position_id_fkey FOREIGN KEY (position_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_netgully ADD CONSTRAINT inp_netgully_gully_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_chamber ADD CONSTRAINT man_chamber_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE node_border_sector ADD CONSTRAINT arc_border_expl_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netelement ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_groundwater ADD CONSTRAINT inp_groundwater_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_wjump ADD CONSTRAINT man_wjump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_storage ADD CONSTRAINT man_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netinit ADD CONSTRAINT man_netinit_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_junction ADD CONSTRAINT man_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_storage ADD CONSTRAINT inp_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_rdii ADD CONSTRAINT inp_rdii_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_outfall ADD CONSTRAINT man_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_inflows ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE flwreg ADD CONSTRAINT flwreg_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_treatment ADD CONSTRAINT inp_treatment_node_x_pol_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE RULE undelete_node AS
    ON DELETE TO node
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


ALTER TABLE connec ADD CONSTRAINT connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE flwreg ADD CONSTRAINT flwreg_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_conduit ADD CONSTRAINT inp_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_orifice ADD CONSTRAINT inp_orifice_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_outlet ADD CONSTRAINT inp_outlet_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_weir ADD CONSTRAINT inp_weir_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_conduit ADD CONSTRAINT man_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_siphon ADD CONSTRAINT man_siphon_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_varc ADD CONSTRAINT man_varc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_waccel ADD CONSTRAINT man_waccel_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_arc_x_pavement ADD CONSTRAINT plan_arc_x_pavement_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;


CREATE RULE undelete_arc AS
    ON DELETE TO arc
   WHERE (old.undelete = true) DO INSTEAD NOTHING;



ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE RULE undelete_connec AS
    ON DELETE TO connec
   WHERE (old.undelete = true) DO INSTEAD NOTHING;




ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_gully ADD CONSTRAINT inp_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_gully ADD CONSTRAINT om_visit_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE RULE undelete_gully AS
    ON DELETE TO gully
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit_x_link ADD CONSTRAINT om_visit_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_link ADD CONSTRAINT doc_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;
