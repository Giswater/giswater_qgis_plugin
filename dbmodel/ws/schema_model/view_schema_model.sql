/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: v_rpt_energy_usage _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_rpt_energy_usage AS
 SELECT rpt_energy_usage.id,
    rpt_energy_usage.result_id,
    rpt_energy_usage.nodarc_id,
    rpt_energy_usage.usage_fact,
    rpt_energy_usage.avg_effic,
    rpt_energy_usage.kwhr_mgal,
    rpt_energy_usage.avg_kw,
    rpt_energy_usage.peak_kw,
    rpt_energy_usage.cost_day
   FROM rpt_energy_usage,
    selector_rpt_main
  WHERE (((selector_rpt_main.result_id)::text = (rpt_energy_usage.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()))
  GROUP BY rpt_energy_usage.id, selector_rpt_main.result_id;


--
-- Name: v_rpt_hydraulic_status _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_rpt_hydraulic_status AS
 SELECT rpt_hydraulic_status.id,
    rpt_hydraulic_status.result_id,
    rpt_hydraulic_status."time",
    rpt_hydraulic_status.text
   FROM rpt_hydraulic_status,
    selector_rpt_main
  WHERE (((selector_rpt_main.result_id)::text = (rpt_hydraulic_status.result_id)::text) AND (selector_rpt_main.cur_user = "current_user"()))
  GROUP BY rpt_hydraulic_status.id, selector_rpt_main.result_id;


--
-- Name: v_price_compost _RETURN; Type: RULE; Schema: Schema; Owner: -
--

CREATE OR REPLACE VIEW v_price_compost AS
 SELECT plan_price.id,
    plan_price.unit,
    plan_price.descript,
        CASE
            WHEN (plan_price.price IS NOT NULL) THEN (plan_price.price)::numeric(14,2)
            ELSE (sum((plan_price.price * plan_price_compost.value)))::numeric(14,2)
        END AS price
   FROM (plan_price
     LEFT JOIN plan_price_compost ON (((plan_price.id)::text = (plan_price_compost.compost_id)::text)))
  GROUP BY plan_price.id, plan_price.unit, plan_price.descript;


--
-- Name: dma dma_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_conflict AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = '-1'::integer) OR (old.dma_id = '-1'::integer)) DO INSTEAD NOTHING;


--
-- Name: dma dma_del_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_del_conflict AS
    ON DELETE TO dma
   WHERE (old.dma_id = '-1'::integer) DO INSTEAD NOTHING;


--
-- Name: dma dma_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_del_undefined AS
    ON DELETE TO dma
   WHERE (old.dma_id = 0) DO INSTEAD NOTHING;


--
-- Name: dma dma_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dma_undefined AS
    ON UPDATE TO dma
   WHERE ((new.dma_id = 0) OR (old.dma_id = 0)) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_conflict AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = '-1'::integer) OR (old.dqa_id = '-1'::integer)) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_del_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_del_conflict AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = '-1'::integer) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_del_undefined AS
    ON DELETE TO dqa
   WHERE (old.dqa_id = 0) DO INSTEAD NOTHING;


--
-- Name: dqa dqa_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE dqa_undefined AS
    ON UPDATE TO dqa
   WHERE ((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;


--
-- Name: exploitation exploitation_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE exploitation_del_undefined AS
    ON DELETE TO exploitation
   WHERE (old.expl_id = 0) DO INSTEAD NOTHING;


--
-- Name: exploitation exploitation_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE exploitation_undefined AS
    ON UPDATE TO exploitation
   WHERE ((new.expl_id = 0) OR (old.expl_id = 0)) DO INSTEAD NOTHING;


--
-- Name: cat_mat_arc insert_inp_cat_mat_roughness; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE insert_inp_cat_mat_roughness AS
    ON INSERT TO cat_mat_arc DO  INSERT INTO cat_mat_roughness (matcat_id)
  VALUES (new.id);


--
-- Name: arc insert_plan_psector_x_arc; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE insert_plan_psector_x_arc AS
    ON INSERT TO arc
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
  VALUES (new.arc_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_vdefault'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);


--
-- Name: node insert_plan_psector_x_node; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE insert_plan_psector_x_node AS
    ON INSERT TO node
   WHERE (new.state = 2) DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
  VALUES (new.node_id, ( SELECT (config_param_user.value)::integer AS value
           FROM config_param_user
          WHERE (((config_param_user.parameter)::text = 'plan_psector_vdefault'::text) AND ((config_param_user.cur_user)::name = "current_user"()))
         LIMIT 1), 1, true);


--
-- Name: macrodma macrodma_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrodma_del_undefined AS
    ON DELETE TO macrodma
   WHERE (old.macrodma_id = 0) DO INSTEAD NOTHING;


--
-- Name: macrodma macrodma_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrodma_undefined AS
    ON UPDATE TO macrodma
   WHERE ((new.macrodma_id = 0) OR (old.macrodma_id = 0)) DO INSTEAD NOTHING;


--
-- Name: macroexploitation macroexploitation_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macroexploitation_del_undefined AS
    ON DELETE TO macroexploitation
   WHERE (old.macroexpl_id = 0) DO INSTEAD NOTHING;


--
-- Name: macroexploitation macroexploitation_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macroexploitation_undefined AS
    ON UPDATE TO macroexploitation
   WHERE ((new.macroexpl_id = 0) OR (old.macroexpl_id = 0)) DO INSTEAD NOTHING;


--
-- Name: macrosector macrosector_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrosector_del_undefined AS
    ON DELETE TO macrosector
   WHERE (old.macrosector_id = 0) DO INSTEAD NOTHING;


--
-- Name: macrosector macrosector_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE macrosector_undefined AS
    ON UPDATE TO macrosector
   WHERE ((new.macrosector_id = 0) OR (old.macrosector_id = 0)) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_conflict AS
    ON UPDATE TO presszone
   WHERE (((new.presszone_id)::text = '-1'::text) OR ((old.presszone_id)::text = '-1'::text)) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_del_uconflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_del_uconflict AS
    ON DELETE TO presszone
   WHERE ((old.presszone_id)::text = '-1'::text) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_del_undefined AS
    ON DELETE TO presszone
   WHERE ((old.presszone_id)::text = '0'::text) DO INSTEAD NOTHING;


--
-- Name: presszone presszone_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE presszone_undefined AS
    ON UPDATE TO presszone
   WHERE (((new.presszone_id)::text = '0'::text) OR ((old.presszone_id)::text = '0'::text)) DO INSTEAD NOTHING;


--
-- Name: sector sector_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_conflict AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = '-1'::integer) OR (old.sector_id = '-1'::integer)) DO INSTEAD NOTHING;


--
-- Name: sector sector_del_conflict; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_del_conflict AS
    ON DELETE TO sector
   WHERE (old.sector_id = '-1'::integer) DO INSTEAD NOTHING;


--
-- Name: sector sector_del_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_del_undefined AS
    ON DELETE TO sector
   WHERE (old.sector_id = 0) DO INSTEAD NOTHING;


--
-- Name: sector sector_undefined; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE sector_undefined AS
    ON UPDATE TO sector
   WHERE ((new.sector_id = 0) OR (old.sector_id = 0)) DO INSTEAD NOTHING;


--
-- Name: arc undelete_arc; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_arc AS
    ON DELETE TO arc
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: connec undelete_connec; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_connec AS
    ON DELETE TO connec
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: macrodma undelete_dma; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_dma AS
    ON DELETE TO macrodma
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: exploitation undelete_dma; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_dma AS
    ON DELETE TO exploitation
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: dma undelete_dma; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_dma AS
    ON DELETE TO dma
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: macrosector undelete_macrosector; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_macrosector AS
    ON DELETE TO macrosector
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: node undelete_node; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_node AS
    ON DELETE TO node
   WHERE (old.undelete = true) DO INSTEAD NOTHING;


--
-- Name: sector undelete_sector; Type: RULE; Schema: Schema; Owner: -
--

CREATE RULE undelete_sector AS
    ON DELETE TO sector
   WHERE (old.undelete = true) DO INSTEAD NOTHING;

