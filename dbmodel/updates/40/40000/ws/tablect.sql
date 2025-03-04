/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- add foreign key for presszone_id
ALTER TABLE arc ADD CONSTRAINT arc_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE connec ADD CONSTRAINT connec_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE link ADD CONSTRAINT link_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;

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
ALTER TABLE config_user_x_sector ADD CONSTRAINT config_user_x_sector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE connec ADD CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_controls ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_controls ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_dscenario_rules ADD CONSTRAINT inp_dscenario_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE inp_rules ADD CONSTRAINT inp_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE selector_sector ADD CONSTRAINT inp_selector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE samplepoint ADD CONSTRAINT samplepoint_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE "element" ADD CONSTRAINT element_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
ALTER TABLE link ADD CONSTRAINT link_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id);
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

CREATE RULE undelete_node AS
    ON DELETE TO node
   WHERE (old.undelete = true) DO INSTEAD NOTHING;
