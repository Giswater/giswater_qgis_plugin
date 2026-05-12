/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- Recreate the constraints that were previously deleted
ALTER TABLE arc ADD CONSTRAINT arc_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT node_nodecat_id_fkey FOREIGN KEY (nodecat_id) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_conneccat_id_fkey FOREIGN KEY (conneccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_connec_arccat_id_fkey FOREIGN KEY (_connec_arccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_gratecat2_id_fkey FOREIGN KEY (_gratecat2_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gully ADD CONSTRAINT gully_gullycat_id_fkey FOREIGN KEY (gullycat_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gullycat2_id_fkey FOREIGN KEY (gullycat2_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gullycat_id_fkey FOREIGN KEY (gullycat_id) REFERENCES cat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- 04/12/2024
ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;



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
ALTER TABLE inp_dwf_pol_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dwf_pol_x_node ADD CONSTRAINT inp_dwf_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_manhole ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_manhole ADD CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_wwtp ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_wwtp ADD CONSTRAINT man_wwtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_visit_event_update_xy ON om_visit_event;
ALTER TABLE om_visit_event ALTER COLUMN position_id TYPE integer USING position_id::integer;
ALTER TABLE om_visit_event ADD CONSTRAINT om_visit_event_position_id_fkey FOREIGN KEY (position_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_inflows_poll ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_inflows_poll ADD CONSTRAINT inp_inflows_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netgully ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_netgully ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_netgully ADD CONSTRAINT inp_netgully_gully_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_outfall DROP CONSTRAINT inp_dscenario_outfall_node_id_fkey;
ALTER TABLE inp_outfall ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_outfall ADD CONSTRAINT inp_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_outfall ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_outfall ADD CONSTRAINT inp_dscenario_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_outfall(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_chamber ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_chamber ADD CONSTRAINT man_chamber_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE node_border_sector ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE node_border_sector ADD CONSTRAINT arc_border_expl_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_divider ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netelement ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_netelement ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_groundwater ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_groundwater ADD CONSTRAINT inp_groundwater_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_wjump ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_wjump ADD CONSTRAINT man_wjump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_inflows_poll ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_inflows_poll ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_storage ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_storage ADD CONSTRAINT man_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_netinit ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_netinit ADD CONSTRAINT man_netinit_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_valve ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_junction ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_junction ADD CONSTRAINT man_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_inflows ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_inflows ADD CONSTRAINT inp_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_storage DROP CONSTRAINT inp_dscenario_storage_node_id_fkey;
ALTER TABLE inp_storage ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_storage ADD CONSTRAINT inp_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_storage ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_storage ADD CONSTRAINT inp_dscenario_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_storage(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_rdii ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_rdii ADD CONSTRAINT inp_rdii_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dwf ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dwf ADD CONSTRAINT inp_dwf_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_outfall ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE man_outfall ADD CONSTRAINT man_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_junction DROP CONSTRAINT inp_dscenario_junction_node_id_fkey;
ALTER TABLE inp_junction ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_junction ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_junction(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_inflows ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_inflows ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node ON plan_psector_x_node;
ALTER TABLE plan_psector_x_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_treatment DROP CONSTRAINT inp_treatment_node_id_fkey;
ALTER TABLE inp_treatment ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_treatment ADD CONSTRAINT inp_treatment_node_x_pol_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_treatment ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE inp_dscenario_treatment ADD CONSTRAINT inp_dscenario_treatment_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_treatment(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE connec ADD CONSTRAINT connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_conduit DROP CONSTRAINT inp_dscenario_conduit_arc_id_fkey;
ALTER TABLE inp_conduit ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_conduit ADD CONSTRAINT inp_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_dscenario_conduit ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_dscenario_conduit ADD CONSTRAINT inp_dscenario_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_conduit(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_divider ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_divider ADD CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_orifice ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_orifice ADD CONSTRAINT inp_orifice_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_outlet ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_outlet ADD CONSTRAINT inp_outlet_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_pump ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_weir ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_weir ADD CONSTRAINT inp_weir_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_conduit ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_conduit ADD CONSTRAINT man_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_siphon ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_siphon ADD CONSTRAINT man_siphon_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_varc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_varc ADD CONSTRAINT man_varc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_waccel ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE man_waccel ADD CONSTRAINT man_waccel_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_arc_x_pavement ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_arc_x_pavement ADD CONSTRAINT plan_arc_x_pavement_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc ON plan_psector_x_arc;
ALTER TABLE plan_psector_x_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_link ON plan_psector_x_connec;
ALTER TABLE plan_psector_x_connec ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_link ON plan_psector_x_gully;
ALTER TABLE plan_psector_x_gully ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_connec ON plan_psector_x_connec;
ALTER TABLE plan_psector_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE element_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE inp_gully ADD CONSTRAINT inp_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_gully ON plan_psector_x_gully;
ALTER TABLE plan_psector_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE om_visit_x_gully ADD CONSTRAINT om_visit_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE doc_x_gully ADD CONSTRAINT doc_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE element_x_gully ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_gully ADD CONSTRAINT element_x_gully_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE element_x_connec ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_node ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_link ALTER COLUMN element_id TYPE integer USING element_id::integer;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE plan_psector_x_gully ADD CONSTRAINT plan_psector_x_gully_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit_x_link ADD CONSTRAINT om_visit_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_link ADD CONSTRAINT doc_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;


CREATE RULE omzone_conflict AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = '-1'::integer) OR (old.omzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE omzone_del_conflict AS
    ON DELETE TO omzone
   WHERE (old.omzone_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE omzone_del_undefined AS
    ON DELETE TO omzone
   WHERE (old.omzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE omzone_undefined AS
    ON UPDATE TO omzone
   WHERE ((new.omzone_id = 0) OR (old.omzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE sector_conflict AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = '-1'::integer) OR (old.sector_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE sector_del_conflict AS
    ON DELETE TO sector
   WHERE (old.sector_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE sector_del_undefined AS
    ON DELETE TO sector
   WHERE (old.sector_id = 0) DO INSTEAD NOTHING;

CREATE RULE sector_undefined AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = 0) OR (old.sector_id = 0)) DO INSTEAD NOTHING;

CREATE RULE macroomzone_del_undefined AS
    ON DELETE TO macroomzone
   WHERE (old.macroomzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE macroomzone_undefined AS
    ON UPDATE TO macroomzone
   WHERE ((new.macroomzone_id = 0) OR (old.macroomzone_id = 0)) DO INSTEAD NOTHING;

CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;

CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;


CREATE RULE macrosector_del_undefined AS
    ON DELETE TO macrosector
   WHERE (old.macrosector_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrosector_undefined AS
    ON UPDATE TO macrosector
   WHERE ((new.macrosector_id = 0) OR (old.macrosector_id = 0)) DO INSTEAD NOTHING;

CREATE RULE exploitation_del_undefined AS
    ON DELETE TO exploitation
   WHERE (old.expl_id = 0) DO INSTEAD NOTHING;

CREATE RULE exploitation_undefined AS
    ON UPDATE TO exploitation
   WHERE ((new.expl_id = 0) OR (old.expl_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE cat_dwf ADD CONSTRAINT cat_dwf_scenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE cat_hydrology ADD CONSTRAINT cat_hydrology_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE dimensions ADD CONSTRAINT dimensions_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_curve ADD CONSTRAINT inp_curve_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_pattern ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_timeseries ADD CONSTRAINT inp_timeseries_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE raingage ADD CONSTRAINT raingage_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE selector_expl ADD CONSTRAINT selector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE link ADD CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_verified_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE node ADD CONSTRAINT node_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE node ADD CONSTRAINT node_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE inp_controls ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE selector_sector ADD CONSTRAINT inp_selector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE node_border_sector ADD CONSTRAINT node_border_expl_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_subcatchment ADD CONSTRAINT subcatchment_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE dimensions ADD CONSTRAINT dimensions_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE node ADD CONSTRAINT node_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE gully ADD CONSTRAINT gully_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "element" ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE link ADD CONSTRAINT link_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON DELETE RESTRICT ON UPDATE CASCADE;


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

ALTER TABLE polygon ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE plan_rec_result_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE plan_rec_result_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_rec_result_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE plan_rec_result_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;

ALTER TABLE anl_arc_x_node ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE archived_psector_arc_traceability ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE archived_psector_connec_traceability ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE archived_psector_gully_traceability ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE archived_psector_node_traceability ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE archived_rpt_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE archived_rpt_inp_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN arc_id1 TYPE integer USING arc_id1::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN arc_id2 TYPE integer USING arc_id2::integer;
ALTER TABLE ext_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE inp_virtual ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE plan_reh_result_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE review_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE review_audit_arc ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE temp_anlgraph ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE temp_arc_flowregulator ALTER COLUMN arc_id TYPE integer USING arc_id::integer;
ALTER TABLE temp_go2epa ALTER COLUMN arc_id TYPE integer USING arc_id::integer;



ALTER TABLE archived_psector_node_traceability ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE archived_rpt_inp_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE archived_rpt_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE audit_arc_traceability ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE ext_node ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE ext_rtc_scada_x_data ALTER COLUMN node_id TYPE integer USING node_id::integer;
ALTER TABLE plan_reh_result_node ALTER COLUMN node_id TYPE integer USING node_id::integer;

ALTER TABLE archived_psector_connec_traceability ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE review_audit_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE review_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;
ALTER TABLE rtc_hydrometer_x_connec ALTER COLUMN connec_id TYPE integer USING connec_id::integer;

ALTER TABLE archived_psector_gully_traceability ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE review_audit_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;
ALTER TABLE review_gully ALTER COLUMN gully_id TYPE integer USING gully_id::integer;

ALTER TABLE archived_psector_link_traceability ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE audit_log_data ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE dimensions ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE samplepoint ALTER COLUMN feature_id TYPE integer USING feature_id::integer;
ALTER TABLE temp_data ALTER COLUMN feature_id TYPE integer USING feature_id::integer;

ALTER TABLE archived_psector_connec_traceability ALTER COLUMN pjoint_id TYPE integer USING pjoint_id::integer;
ALTER TABLE archived_psector_gully_traceability ALTER COLUMN pjoint_id TYPE integer USING pjoint_id::integer;
ALTER TABLE archived_psector_link_traceability ALTER COLUMN exit_id TYPE integer USING exit_id::integer;



ALTER TABLE archived_psector_arc_traceability ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE archived_psector_arc_traceability ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE archived_rpt_inp_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE archived_rpt_inp_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE plan_reh_result_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE plan_reh_result_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE rpt_summary_arc ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE rpt_summary_arc ALTER COLUMN node_2 TYPE integer USING node_2::integer;
ALTER TABLE temp_anlgraph ALTER COLUMN node_1 TYPE integer USING node_1::integer;
ALTER TABLE temp_anlgraph ALTER COLUMN node_2 TYPE integer USING node_2::integer;

ALTER TABLE inp_virtual ALTER COLUMN fusion_node TYPE integer USING fusion_node::integer;

DO $$
DECLARE
    v_utils boolean;
BEGIN
     SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

     IF v_utils THEN
        ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES utils.district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES utils.streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;

    ELSE
        ALTER TABLE node ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE element ADD CONSTRAINT element_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE link ADD CONSTRAINT link_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE node ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE node ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE arc ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE connec ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id,streetaxis2_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;
        ALTER TABLE gully ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id,streetaxis_id) REFERENCES ext_streetaxis(muni_id,id) ON DELETE RESTRICT ON UPDATE CASCADE;

        ALTER TABLE ext_streetaxis ADD CONSTRAINT ext_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE ext_address ADD CONSTRAINT ext_address_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
        ALTER TABLE ext_plot ADD CONSTRAINT ext_plot_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    END IF;
END $$;

DO $$
DECLARE
    v_rec RECORD;
    v_table_name text;
    v_feature_name text;
BEGIN
    FOR v_rec IN
        SELECT DISTINCT cf.id, cf.feature_type
        FROM sys_addfields sa
        JOIN cat_feature cf ON cf.id = sa.cat_feature_id
    LOOP
        v_feature_name := lower(v_rec.feature_type) || '_id';
        v_table_name := 'man_' || lower(v_rec.feature_type) || '_' || lower(v_rec.id);

        EXECUTE 'ALTER TABLE ' || v_table_name || ' ALTER COLUMN ' || v_feature_name || ' TYPE int4 USING ' || v_feature_name || '::int4';
        EXECUTE 'ALTER TABLE ' || v_table_name || ' ADD CONSTRAINT ' || v_table_name || '_' || v_feature_name || '_fkey FOREIGN KEY (' || v_feature_name || ') REFERENCES ' || v_rec.feature_type || '(' || v_feature_name || ') ON DELETE CASCADE';
    END LOOP;
END $$;

-- Recreate foreign keys for muni_id
DO $$
DECLARE
    v_utils boolean;
BEGIN
    SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

    IF v_utils THEN

        -- Index
        CREATE INDEX idx_municipality_name ON utils.municipality USING btree (name);
        CREATE INDEX idx_municipality_the_geom ON utils.municipality USING gist(the_geom);
        
        -- utils.municipality
        ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id);

        ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES utils.municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id)
        REFERENCES utils.municipality(muni_id);

        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id)
        REFERENCES utils.municipality(muni_id);

        -- No utils.municipality BEFORE
        ALTER TABLE ONLY ext_address ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_district ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_plot ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_streetaxis ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY samplepoint ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    ELSE 

        -- Index
        CREATE INDEX idx_ext_municipality_name ON ext_municipality USING btree (name);
        CREATE INDEX idx_ext_municipality_the_geom ON ext_municipality USING gist(the_geom);

        -- ext_municipality
        ALTER TABLE selector_municipality ADD CONSTRAINT selector_municipality_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_muni_id FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id);

        ALTER TABLE om_visit ADD CONSTRAINT om_visit_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id_fkey FOREIGN KEY (muni_id)
        REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE dimensions ADD CONSTRAINT dimensions_muni_id FOREIGN KEY (muni_id)
        REFERENCES ext_municipality(muni_id);

        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id FOREIGN KEY (muni_id)
        REFERENCES ext_municipality(muni_id);

        -- No utils.municipality
        ALTER TABLE ONLY ext_address ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_district ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_plot ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY ext_streetaxis ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

        ALTER TABLE ONLY samplepoint ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) 
        REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;

    END IF;
END $$;
