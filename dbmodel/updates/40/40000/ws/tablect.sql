/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- add foreign key for presszone_id
ALTER TABLE arc ADD CONSTRAINT arc_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector ADD CONSTRAINT minsector_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE plan_netscenario_presszone ADD CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey FOREIGN KEY (netscenario_id) REFERENCES plan_netscenario(netscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_arc ADD CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_node ADD CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario_connec ADD CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id) REFERENCES plan_netscenario_presszone(netscenario_id, presszone_id) ON UPDATE CASCADE ON DELETE CASCADE;

-- create rules to avoid presszone_id = -1 or 0
CREATE RULE presszone_conflict AS
    ON UPDATE TO presszone
   WHERE ((NEW.presszone_id = -1) OR (OLD.presszone_id = -1)) DO INSTEAD NOTHING;

CREATE RULE presszone_del_uconflict AS
    ON DELETE TO presszone
   WHERE (OLD.presszone_id = -1) DO INSTEAD NOTHING;

CREATE RULE presszone_del_undefined AS
    ON DELETE TO presszone
   WHERE (OLD.presszone_id = 0) DO INSTEAD NOTHING;

CREATE RULE presszone_undefined AS
    ON UPDATE TO presszone
   WHERE ((NEW.presszone_id = 0) OR (OLD.presszone_id = 0)) DO INSTEAD NOTHING;



ALTER TABLE arc ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE minsector ADD CONSTRAINT minsector_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE rpt_inp_pattern_value ADD CONSTRAINT rpt_inp_pattern_value_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_waterbalance_dma_graph ADD CONSTRAINT rtc_scada_x_dma_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_verified_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dma_del_conflict AS
    ON DELETE TO dma
   WHERE (old.dma_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE dma_del_undefined AS
    ON DELETE TO dma
   WHERE (old.dma_id = 0) DO INSTEAD NOTHING;

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE arc ADD CONSTRAINT arc_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE minsector ADD CONSTRAINT minsector_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


CREATE RULE dqa_conflict AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = '-1'::integer) OR (old.dqa_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE dqa_del_conflict AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE dqa_del_undefined AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = 0) DO INSTEAD NOTHING;

CREATE RULE dqa_undefined AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;


ALTER TABLE arc ADD CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_controls ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_rules ADD CONSTRAINT inp_dscenario_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_rules ADD CONSTRAINT inp_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_sector ADD CONSTRAINT inp_selector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE "element" ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE dimensions ADD CONSTRAINT dimensions_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);


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



--30/01/2025

CREATE RULE supplyzone_conflict AS
    ON UPDATE TO supplyzone
   WHERE ((new.supplyzone_id = '-1'::integer) OR (old.supplyzone_id = '-1'::integer)) DO INSTEAD NOTHING;

CREATE RULE supplyzone_del_conflict AS
    ON DELETE TO supplyzone
   WHERE (old.supplyzone_id = '-1'::integer) DO INSTEAD NOTHING;

CREATE RULE supplyzone_del_undefined AS
    ON DELETE TO supplyzone
   WHERE (old.supplyzone_id = 0) DO INSTEAD NOTHING;

CREATE RULE supplyzone_undefined AS
    ON UPDATE TO supplyzone
   WHERE ((new.supplyzone_id = 0) OR (old.supplyzone_id = 0)) DO INSTEAD NOTHING;

-- 06/02/2025
ALTER TABLE arc ADD CONSTRAINT arc_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE arc ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE config_graph_mincut ADD CONSTRAINT config_graph_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_inlet ADD CONSTRAINT inp_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_label ADD CONSTRAINT inp_label_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_reservoir ADD CONSTRAINT inp_reservoir_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_shortpipe ADD CONSTRAINT inp_shortpipe_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_tank ADD CONSTRAINT inp_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_valve ADD CONSTRAINT inp_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_expansiontank ADD CONSTRAINT man_expansiontank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_filter ADD CONSTRAINT man_filter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_flexunion ADD CONSTRAINT man_flexunion_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_hydrant ADD CONSTRAINT man_hydrant_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_junction ADD CONSTRAINT man_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_manhole ADD CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_meter ADD CONSTRAINT man_meter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_netelement ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_netsamplepoint ADD CONSTRAINT man_netsamplepoint_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_netwjoin ADD CONSTRAINT man_netwjoin_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_pump ADD CONSTRAINT man_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_reduction ADD CONSTRAINT man_reduction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_register ADD CONSTRAINT man_register_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_source ADD CONSTRAINT man_source_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_tank ADD CONSTRAINT man_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_waterwell ADD CONSTRAINT man_waterwell_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE man_wtp ADD CONSTRAINT man_wtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE plan_psector_x_node ADD CONSTRAINT plan_psector_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE rtc_hydrometer_x_node ADD CONSTRAINT rtc_hydrometer_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE ext_rtc_scada_x_data ADD CONSTRAINT ext_rtc_scada_x_data_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON DELETE CASCADE ON UPDATE CASCADE;


-- 06/03/2025
ALTER TABLE ext_hydrometer_category ADD CONSTRAINT ext_hydrometer_category_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE ext_rtc_dma_period ADD CONSTRAINT ext_rtc_dma_period_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_inlet ADD CONSTRAINT inp_inlet_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pattern_value ADD CONSTRAINT inp_pattern_value_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_inlet ADD CONSTRAINT inp_dscenario_inlet_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_junction ADD CONSTRAINT inp_dscenario_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump ADD CONSTRAINT inp_dscenario_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_pump_additional ADD CONSTRAINT inp_dscenario_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_reservoir ADD CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_virtualpump ADD CONSTRAINT inp_dscenario_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_junction ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump ADD CONSTRAINT inp_pump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_pump_additional ADD CONSTRAINT inp_pump_additional_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_reservoir ADD CONSTRAINT inp_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_virtualpump ADD CONSTRAINT inp_virtualpump_energy_pattern_id_fkey FOREIGN KEY (energy_pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE dma ADD CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE dqa ADD CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE sector ADD CONSTRAINT sector_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE inp_dscenario_demand ADD CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE supplyzone ADD CONSTRAINT supplyzone_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON DELETE RESTRICT ON UPDATE CASCADE;

-- 10/03/2025
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"node", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"connec", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"element", "column":"buildercat_id"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_arc_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_node_traceability", "column":"buildercat_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"archived_psector_connec_traceability", "column":"buildercat_id"}}$$);

DROP TABLE cat_builder;


-- 14/03/2025

ALTER TABLE config_graph_checkvalve ADD CONSTRAINT config_graph_checkvalve_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_pipe ADD CONSTRAINT inp_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_virtualvalve ADD CONSTRAINT inp_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_pipe ADD CONSTRAINT man_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_pump ADD CONSTRAINT man_pump_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_valve ADD CONSTRAINT man_valve_to_arc_fky FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_varc ADD CONSTRAINT man_varc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_arc_x_pavement ADD CONSTRAINT plan_arc_x_pavement_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_arc ADD CONSTRAINT plan_psector_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_fountain ADD CONSTRAINT man_fountain_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_fountain ADD CONSTRAINT man_fountain_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_greentap ADD CONSTRAINT man_greentap_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_greentap ADD CONSTRAINT man_greentap_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_tap ADD CONSTRAINT man_tap_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE man_tap ADD CONSTRAINT man_tap_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE man_wjoin ADD CONSTRAINT man_wjoin_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE rtc_hydrometer_x_connec ADD CONSTRAINT rtc_hydrometer_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE element_x_node ADD CONSTRAINT element_x_node_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_arc ADD CONSTRAINT element_x_arc_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_connec ADD CONSTRAINT element_x_connec_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE om_visit_x_link ADD CONSTRAINT om_visit_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE doc_x_link ADD CONSTRAINT doc_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE element_x_link ADD CONSTRAINT element_x_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;


-- 09/04/2025
-- macrosector
ALTER TABLE sector ADD CONSTRAINT sector_macrosector_id_fkey FOREIGN KEY (macrosector_id) REFERENCES macrosector(macrosector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE macrosector_del_undefined AS
    ON DELETE TO macrosector
   WHERE (old.macrosector_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrosector_undefined AS
    ON UPDATE TO macrosector
   WHERE ((new.macrosector_id = 0) OR (old.macrosector_id = 0)) DO INSTEAD NOTHING;

-- macrodma
ALTER TABLE dma ADD CONSTRAINT dma_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma(macrodma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE macrodma_del_undefined AS
    ON DELETE TO macrodma
   WHERE (old.macrodma_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrodma_undefined AS
    ON UPDATE TO macrodma
   WHERE ((new.macrodma_id = 0) OR (old.macrodma_id = 0)) DO INSTEAD NOTHING;

-- macrodqa
ALTER TABLE dqa ADD CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id) REFERENCES macrodqa(macrodqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE macrodqa_del_undefined AS
    ON DELETE TO macrodqa
   WHERE (old.macrodqa_id = 0) DO INSTEAD NOTHING;

CREATE RULE macrodqa_undefined AS
    ON UPDATE TO macrodqa
   WHERE ((new.macrodqa_id = 0) OR (old.macrodqa_id = 0)) DO INSTEAD NOTHING;


-- exploitation
ALTER TABLE ext_streetaxis ADD CONSTRAINT ext_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

CREATE RULE exploitation_del_undefined AS
    ON DELETE TO exploitation
   WHERE (old.expl_id = 0) DO INSTEAD NOTHING;

CREATE RULE exploitation_undefined AS
    ON UPDATE TO exploitation
   WHERE ((new.expl_id = 0) OR (old.expl_id = 0)) DO INSTEAD NOTHING;


-- macroexploitation
CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;

CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;

ALTER TABLE node ADD CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE config_user_x_expl ADD CONSTRAINT config_user_x_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE macrodqa ADD CONSTRAINT macrodqa_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_waterbalance ADD CONSTRAINT om_waterbalance_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ext_address ADD CONSTRAINT ext_address_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE dimensions ADD CONSTRAINT dimensions_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_mincut ADD CONSTRAINT om_mincut_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_expl ADD CONSTRAINT selector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE macrodma ADD CONSTRAINT macrodma_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE plan_netscenario ADD CONSTRAINT plan_netscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE arc ADD CONSTRAINT arc_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_pattern ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE minsector ADD CONSTRAINT minsector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE cat_dscenario ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ext_plot ADD CONSTRAINT ext_plot_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_curve ADD CONSTRAINT inp_curve_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE _pond_ ADD CONSTRAINT pond_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE _pool_ ADD CONSTRAINT pool_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE _arc_border_expl_ ADD CONSTRAINT arc_border_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

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

ALTER TABLE arc ADD CONSTRAINT arc_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE node ADD CONSTRAINT node_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_omzone_id_fkey FOREIGN KEY (omzone_id) REFERENCES omzone(omzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
