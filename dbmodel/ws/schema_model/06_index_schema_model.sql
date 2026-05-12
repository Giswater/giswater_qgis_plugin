/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: anl_arc_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_arc_arc_id ON anl_arc USING btree (arc_id);


--
-- Name: anl_arc_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_arc_index ON anl_arc USING gist (the_geom);


--
-- Name: anl_arc_x_node_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_arc_x_node_arc_id ON anl_arc_x_node USING btree (arc_id);


--
-- Name: anl_arc_x_node_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_arc_x_node_index ON anl_arc_x_node USING gist (the_geom);


--
-- Name: anl_arc_x_node_node_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_arc_x_node_node_id ON anl_arc_x_node USING btree (node_id);


--
-- Name: anl_connec_connec_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_connec_connec_id ON anl_connec USING btree (connec_id);


--
-- Name: anl_connec_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_connec_index ON anl_connec USING gist (the_geom);


--
-- Name: anl_node_fprocesscat_id_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_node_fprocesscat_id_index ON anl_node USING btree (fid);


--
-- Name: anl_node_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_node_index ON anl_node USING gist (the_geom);


--
-- Name: anl_node_node_id_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_node_node_id_index ON anl_node USING btree (node_id);


--
-- Name: anl_polygon_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_polygon_index ON anl_polygon USING gist (the_geom);


--
-- Name: anl_polygon_pol_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX anl_polygon_pol_id ON anl_polygon USING btree (pol_id);


--
-- Name: arc_arccat; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_arccat ON arc USING btree (arccat_id);


--
-- Name: arc_dma; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_dma ON arc USING btree (dma_id);


--
-- Name: arc_dqa; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_dqa ON arc USING btree (dqa_id);


--
-- Name: arc_exploitation; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_exploitation ON arc USING btree (expl_id);


--
-- Name: arc_exploitation2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_exploitation2 ON arc USING btree (expl_id2);


--
-- Name: arc_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_index ON arc USING gist (the_geom);


--
-- Name: arc_node1; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_node1 ON arc USING btree (node_1);


--
-- Name: arc_node2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_node2 ON arc USING btree (node_2);


--
-- Name: arc_presszone; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_presszone ON arc USING btree (presszone_id);


--
-- Name: arc_sector; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_sector ON arc USING btree (sector_id);


--
-- Name: arc_street1; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_street1 ON arc USING btree (streetaxis_id);


--
-- Name: arc_street2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX arc_street2 ON arc USING btree (streetaxis2_id);


--
-- Name: cat_arc_cost_pkey; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX cat_arc_cost_pkey ON cat_arc USING btree (cost);


--
-- Name: cat_arc_m2bottom_cost_pkey; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX cat_arc_m2bottom_cost_pkey ON cat_arc USING btree (m2bottom_cost);


--
-- Name: cat_arc_m3protec_cost_pkey; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX cat_arc_m3protec_cost_pkey ON cat_arc USING btree (m3protec_cost);


--
-- Name: connec_connecat; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_connecat ON connec USING btree (connecat_id);


--
-- Name: connec_dma; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_dma ON connec USING btree (dma_id);


--
-- Name: connec_dqa; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_dqa ON connec USING btree (dqa_id);


--
-- Name: connec_exploitation; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_exploitation ON connec USING btree (expl_id);


--
-- Name: connec_exploitation2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_exploitation2 ON connec USING btree (expl_id2);


--
-- Name: connec_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_index ON connec USING gist (the_geom);


--
-- Name: connec_presszone; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_presszone ON connec USING btree (presszone_id);


--
-- Name: connec_sector; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_sector ON connec USING btree (sector_id);


--
-- Name: connec_street1; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_street1 ON connec USING btree (streetaxis_id);


--
-- Name: connec_street2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX connec_street2 ON connec USING btree (streetaxis2_id);


--
-- Name: dma_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX dma_index ON dma USING gist (the_geom);


--
-- Name: element_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX element_index ON element USING gist (the_geom);


--
-- Name: exploitation_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX exploitation_index ON exploitation USING gist (the_geom);


--
-- Name: ext_rtc_hydrometer_x_data_index_cat_period_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX ext_rtc_hydrometer_x_data_index_cat_period_id ON ext_rtc_hydrometer_x_data USING btree (cat_period_id);


--
-- Name: ext_rtc_hydrometer_x_data_index_hydrometer_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX ext_rtc_hydrometer_x_data_index_hydrometer_id ON ext_rtc_hydrometer_x_data USING btree (hydrometer_id);


--
-- Name: inp_curve_value_curve_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX inp_curve_value_curve_id ON inp_curve_value USING btree (curve_id);


--
-- Name: inp_dscenario_demand_dscenario_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX inp_dscenario_demand_dscenario_id ON inp_dscenario_demand USING btree (dscenario_id);


--
-- Name: inp_dscenario_demand_source; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX inp_dscenario_demand_source ON inp_dscenario_demand USING btree (source);


--
-- Name: link_exit_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX link_exit_id ON link USING btree (exit_id);


--
-- Name: link_exploitation2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX link_exploitation2 ON link USING btree (expl_id2);


--
-- Name: link_feature_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX link_feature_id ON link USING btree (feature_id);


--
-- Name: link_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX link_index ON link USING gist (the_geom);


--
-- Name: macrodma_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX macrodma_index ON macrodma USING gist (the_geom);


--
-- Name: macrosector_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX macrosector_index ON macrosector USING gist (the_geom);


--
-- Name: man_addfields_parameter_cat_feature_id_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX man_addfields_parameter_cat_feature_id_index ON sys_addfields USING btree (cat_feature_id);


--
-- Name: man_addfields_value_feature_id_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX man_addfields_value_feature_id_index ON man_addfields_value USING btree (feature_id);


--
-- Name: man_addfields_value_parameter_id_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX man_addfields_value_parameter_id_index ON man_addfields_value USING btree (parameter_id);


--
-- Name: mincut_arc_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX mincut_arc_index ON om_mincut_arc USING gist (the_geom);


--
-- Name: mincut_node_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX mincut_node_index ON om_mincut_node USING gist (the_geom);


--
-- Name: mincut_polygon_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX mincut_polygon_index ON om_mincut_polygon USING gist (the_geom);


--
-- Name: mincut_valve_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX mincut_valve_index ON om_mincut_valve USING gist (the_geom);


--
-- Name: node_dma; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_dma ON node USING btree (dma_id);


--
-- Name: node_dqa; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_dqa ON node USING btree (dqa_id);


--
-- Name: node_exploitation; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_exploitation ON node USING btree (expl_id);


--
-- Name: node_exploitation2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_exploitation2 ON node USING btree (expl_id2);


--
-- Name: node_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_index ON node USING gist (the_geom);


--
-- Name: node_nodecat; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_nodecat ON node USING btree (nodecat_id);


--
-- Name: node_presszone; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_presszone ON node USING btree (presszone_id);


--
-- Name: node_sector; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_sector ON node USING btree (sector_id);


--
-- Name: node_street1; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_street1 ON node USING btree (streetaxis_id);


--
-- Name: node_street2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX node_street2 ON node USING btree (streetaxis2_id);


--
-- Name: plan_price_compost_compost_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_price_compost_compost_id ON plan_price_compost USING btree (compost_id);


--
-- Name: plan_psector_psector_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_psector_id ON plan_psector USING btree (psector_id);


--
-- Name: plan_psector_x_arc_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_arc_arc_id ON plan_psector_x_arc USING btree (arc_id);


--
-- Name: plan_psector_x_arc_psector_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_arc_psector_id ON plan_psector_x_arc USING btree (psector_id);


--
-- Name: plan_psector_x_arc_state; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_arc_state ON plan_psector_x_arc USING btree (state);


--
-- Name: plan_psector_x_connec_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_connec_arc_id ON plan_psector_x_connec USING btree (arc_id);


--
-- Name: plan_psector_x_connec_connec_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_connec_connec_id ON plan_psector_x_connec USING btree (connec_id);


--
-- Name: plan_psector_x_connec_psector_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_connec_psector_id ON plan_psector_x_connec USING btree (psector_id);


--
-- Name: plan_psector_x_connec_state; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_connec_state ON plan_psector_x_connec USING btree (state);


--
-- Name: plan_psector_x_node_node_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_node_node_id ON plan_psector_x_node USING btree (node_id);


--
-- Name: plan_psector_x_node_psector_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_node_psector_id ON plan_psector_x_node USING btree (psector_id);


--
-- Name: plan_psector_x_node_state; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX plan_psector_x_node_state ON plan_psector_x_node USING btree (state);


--
-- Name: rpt_inp_arc_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_arc_id ON rpt_inp_arc USING btree (arc_id);


--
-- Name: rpt_inp_arc_arc_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_arc_type ON rpt_inp_arc USING btree (arc_type);


--
-- Name: rpt_inp_arc_epa_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_epa_type ON rpt_inp_arc USING btree (epa_type);


--
-- Name: rpt_inp_arc_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_index ON rpt_inp_arc USING gist (the_geom);


--
-- Name: rpt_inp_arc_node_1_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_node_1_type ON rpt_inp_arc USING btree (node_1);


--
-- Name: rpt_inp_arc_node_2_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_node_2_type ON rpt_inp_arc USING btree (node_2);


--
-- Name: rpt_inp_arc_result_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_arc_result_id ON rpt_inp_arc USING btree (result_id);


--
-- Name: rpt_inp_node_epa_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_node_epa_type ON rpt_inp_node USING btree (epa_type);


--
-- Name: rpt_inp_node_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_node_index ON rpt_inp_node USING gist (the_geom);


--
-- Name: rpt_inp_node_node_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_node_node_id ON rpt_inp_node USING btree (node_id);


--
-- Name: rpt_inp_node_node_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_node_node_type ON rpt_inp_node USING btree (node_type);


--
-- Name: rpt_inp_node_nodeparent; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_node_nodeparent ON rpt_inp_node USING btree (nodeparent);


--
-- Name: rpt_inp_node_result_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rpt_inp_node_result_id ON rpt_inp_node USING btree (result_id);


--
-- Name: rtc_hydrometer_x_connec_index_connec_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX rtc_hydrometer_x_connec_index_connec_id ON rtc_hydrometer_x_connec USING btree (connec_id);


--
-- Name: sector_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX sector_index ON sector USING gist (the_geom);


--
-- Name: shortcut_unique; Type: INDEX; Schema: Schema; Owner: -
--

CREATE UNIQUE INDEX shortcut_unique ON cat_feature USING btree (shortcut_key);


--
-- Name: temp_anlgraph_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_anlgraph_arc_id ON temp_anlgraph USING btree (arc_id);


--
-- Name: temp_anlgraph_node_1; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_anlgraph_node_1 ON temp_anlgraph USING btree (node_1);


--
-- Name: temp_anlgraph_node_2; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_anlgraph_node_2 ON temp_anlgraph USING btree (node_2);


--
-- Name: temp_arc_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_arc_arc_id ON temp_arc USING btree (arc_id);


--
-- Name: temp_arc_arc_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_arc_arc_type ON temp_arc USING btree (arc_type);


--
-- Name: temp_arc_epa_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_arc_epa_type ON temp_arc USING btree (epa_type);


--
-- Name: temp_arc_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_arc_index ON temp_arc USING gist (the_geom);


--
-- Name: temp_arc_node_1_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_arc_node_1_type ON temp_arc USING btree (node_1);


--
-- Name: temp_arc_node_2_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_arc_node_2_type ON temp_arc USING btree (node_2);


--
-- Name: temp_data_feature_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_data_feature_id ON temp_data USING btree (feature_id);


--
-- Name: temp_data_feature_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_data_feature_type ON temp_data USING btree (feature_type);


--
-- Name: temp_go2epa_arc_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_go2epa_arc_id ON temp_go2epa USING btree (arc_id);


--
-- Name: temp_node_epa_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_node_epa_type ON temp_node USING btree (epa_type);


--
-- Name: temp_node_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_node_index ON temp_node USING gist (the_geom);


--
-- Name: temp_node_node_id; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_node_node_id ON temp_node USING btree (node_id);


--
-- Name: temp_node_node_type; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_node_node_type ON temp_node USING btree (node_type);


--
-- Name: temp_node_nodeparent; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX temp_node_nodeparent ON temp_node USING btree (nodeparent);


--
-- Name: visit_index; Type: INDEX; Schema: Schema; Owner: -
--

CREATE INDEX visit_index ON om_visit USING gist (the_geom);
