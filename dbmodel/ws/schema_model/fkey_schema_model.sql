/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: arc arc_arccat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc_border_expl arc_border_expl_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc_border_expl
    ADD CONSTRAINT arc_border_expl_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: arc_border_expl arc_border_expl_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc_border_expl
    ADD CONSTRAINT arc_border_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node_border_sector arc_border_expl_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node_border_sector
    ADD CONSTRAINT arc_border_expl_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: arc arc_buildercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_buildercat_id_fkey FOREIGN KEY (buildercat_id) REFERENCES cat_builder(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_category_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_category_type_feature_type_fkey FOREIGN KEY (category_type, feature_type) REFERENCES man_type_category(category_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_district_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_dqa_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_expl_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_expl_id2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_fluid_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_fluid_type_feature_type_fkey FOREIGN KEY (fluid_type, feature_type) REFERENCES man_type_fluid(fluid_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_function_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_function_type_feature_type_fkey FOREIGN KEY (function_type, feature_type) REFERENCES man_type_function(function_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_location_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_location_type_feature_type_fkey FOREIGN KEY (location_type, feature_type) REFERENCES man_type_location(location_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_node_1_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_node_1_fkey FOREIGN KEY (node_1) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_node_2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_node_2_fkey FOREIGN KEY (node_2) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_ownercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_parent_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_pavcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_pavcat_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: arc arc_presszonecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_soilcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_state_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_streetaxis2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis2_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_workcat_id_end_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arc arc_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: audit_check_project audit_check_project_fprocesscat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_check_project
    ADD CONSTRAINT audit_check_project_fprocesscat_id_fkey FOREIGN KEY (fid) REFERENCES sys_fprocess(fid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_arc cat_arc_arctype_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_arctype_id_fkey FOREIGN KEY (arctype_id) REFERENCES cat_feature_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_arc cat_arc_brand_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_arc cat_arc_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_cost_fkey FOREIGN KEY (cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_arc cat_arc_m2bottom_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_m2bottom_cost_fkey FOREIGN KEY (m2bottom_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_arc cat_arc_m3protec_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_m3protec_cost_fkey FOREIGN KEY (m3protec_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_arc cat_arc_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_arc cat_arc_model_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_arc cat_arc_shepe_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_shepe_fkey FOREIGN KEY (shape) REFERENCES cat_arc_shape(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_brand_model cat_brand_model_catbrand_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_brand_model
    ADD CONSTRAINT cat_brand_model_catbrand_id_fkey FOREIGN KEY (catbrand_id) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_connec cat_connec_brand_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_connec
    ADD CONSTRAINT cat_connec_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_connec cat_connec_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_connec
    ADD CONSTRAINT cat_connec_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_connec cat_connec_model_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_connec
    ADD CONSTRAINT cat_connec_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_connec cat_connec_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_connec
    ADD CONSTRAINT cat_connec_type_fkey FOREIGN KEY (connectype_id) REFERENCES cat_feature_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_dscenario cat_dscenario_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dscenario
    ADD CONSTRAINT cat_dscenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_dscenario cat_dscenario_parent_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dscenario
    ADD CONSTRAINT cat_dscenario_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_element cat_element_brand_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_element
    ADD CONSTRAINT cat_element_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_element cat_element_elementtype_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_element
    ADD CONSTRAINT cat_element_elementtype_id_fkey FOREIGN KEY (elementtype_id) REFERENCES element_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_element cat_element_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_element
    ADD CONSTRAINT cat_element_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_element(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_element cat_element_model_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_element
    ADD CONSTRAINT cat_element_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_feature_arc cat_feature_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_arc
    ADD CONSTRAINT cat_feature_arc_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_feature_arc cat_feature_arc_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_arc
    ADD CONSTRAINT cat_feature_arc_type_fkey FOREIGN KEY (type) REFERENCES sys_feature_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_feature_connec cat_feature_connec_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_connec
    ADD CONSTRAINT cat_feature_connec_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_feature_connec cat_feature_connec_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_connec
    ADD CONSTRAINT cat_feature_connec_type_fkey FOREIGN KEY (type) REFERENCES sys_feature_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_feature_node cat_feature_node_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_node
    ADD CONSTRAINT cat_feature_node_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_feature_node cat_feature_node_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_node
    ADD CONSTRAINT cat_feature_node_type_fkey FOREIGN KEY (type) REFERENCES sys_feature_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_feature cat_feature_system_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature
    ADD CONSTRAINT cat_feature_system_fkey FOREIGN KEY (system_id, feature_type) REFERENCES sys_feature_cat(id, type) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_mat_roughness cat_mat_roughness_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_roughness
    ADD CONSTRAINT cat_mat_roughness_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_node cat_node_brand_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_node cat_node_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_cost_fkey FOREIGN KEY (cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_node cat_node_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_node cat_node_model_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_node cat_node_nodetype_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_nodetype_id_fkey FOREIGN KEY (nodetype_id) REFERENCES cat_feature_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_pavement cat_pavement_m2_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_pavement
    ADD CONSTRAINT cat_pavement_m2_cost_fkey FOREIGN KEY (m2_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ext_rtc_hydrometer_x_data cat_period_id_fk; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer_x_data
    ADD CONSTRAINT cat_period_id_fk FOREIGN KEY (cat_period_id) REFERENCES ext_cat_period(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: presszone cat_presszone_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY presszone
    ADD CONSTRAINT cat_presszone_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_soil cat_soil_m2trenchl_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_soil
    ADD CONSTRAINT cat_soil_m2trenchl_cost_fkey FOREIGN KEY (m2trenchl_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_soil cat_soil_m3exc_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_soil
    ADD CONSTRAINT cat_soil_m3exc_cost_fkey FOREIGN KEY (m3exc_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_soil cat_soil_m3excess_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_soil
    ADD CONSTRAINT cat_soil_m3excess_cost_fkey FOREIGN KEY (m3excess_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_soil cat_soil_m3fill_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_soil
    ADD CONSTRAINT cat_soil_m3fill_cost_fkey FOREIGN KEY (m3fill_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_users cat_users_sys_role_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_users
    ADD CONSTRAINT cat_users_sys_role_fkey FOREIGN KEY (sys_role) REFERENCES sys_role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_graph_inlet config_graph_inlet_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_graph_inlet
    ADD CONSTRAINT config_graph_inlet_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: config_graph_inlet config_graph_inlet_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_graph_inlet
    ADD CONSTRAINT config_graph_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: config_graph_valve config_mincut_valve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_graph_valve
    ADD CONSTRAINT config_mincut_valve_id_fkey FOREIGN KEY (id) REFERENCES cat_feature_node(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: config_report config_report_sys_role_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_report
    ADD CONSTRAINT config_report_sys_role_id_fkey FOREIGN KEY (sys_role) REFERENCES sys_role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_toolbox config_toolbox_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_toolbox
    ADD CONSTRAINT config_toolbox_id_fkey FOREIGN KEY (id) REFERENCES sys_function(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_user_x_expl config_user_x_expl_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_expl
    ADD CONSTRAINT config_user_x_expl_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_user_x_expl config_user_x_expl_manager_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_expl
    ADD CONSTRAINT config_user_x_expl_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_user_x_expl config_user_x_expl_username_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_expl
    ADD CONSTRAINT config_user_x_expl_username_fkey FOREIGN KEY (username) REFERENCES cat_users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_user_x_sector config_user_x_sector_manager_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_sector
    ADD CONSTRAINT config_user_x_sector_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES cat_manager(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_user_x_sector config_user_x_sector_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_sector
    ADD CONSTRAINT config_user_x_sector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: config_user_x_sector config_user_x_sector_username_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_sector
    ADD CONSTRAINT config_user_x_sector_username_fkey FOREIGN KEY (username) REFERENCES cat_users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_visit_class config_visit_class_sys_role_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class
    ADD CONSTRAINT config_visit_class_sys_role_fkey FOREIGN KEY (sys_role) REFERENCES sys_role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_visit_class_x_feature config_visit_class_x_feature_visitclass_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class_x_feature
    ADD CONSTRAINT config_visit_class_x_feature_visitclass_id_fkey FOREIGN KEY (visitclass_id) REFERENCES config_visit_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_visit_class_x_parameter config_visit_class_x_parameter_class_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class_x_parameter
    ADD CONSTRAINT config_visit_class_x_parameter_class_fkey FOREIGN KEY (class_id) REFERENCES config_visit_class(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_visit_class_x_parameter config_visit_class_x_parameter_parameter_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class_x_parameter
    ADD CONSTRAINT config_visit_class_x_parameter_parameter_fkey FOREIGN KEY (parameter_id) REFERENCES config_visit_parameter(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_visit_parameter_action config_visit_parameter_action_parameter_id1_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_parameter_action
    ADD CONSTRAINT config_visit_parameter_action_parameter_id1_fkey FOREIGN KEY (parameter_id1) REFERENCES config_visit_parameter(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: config_visit_parameter_action config_visit_parameter_action_parameter_id2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_parameter_action
    ADD CONSTRAINT config_visit_parameter_action_parameter_id2_fkey FOREIGN KEY (parameter_id2) REFERENCES config_visit_parameter(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_buildercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_buildercat_id_fkey FOREIGN KEY (buildercat_id) REFERENCES cat_builder(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_category_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_category_type_feature_type_fkey FOREIGN KEY (category_type, feature_type) REFERENCES man_type_category(category_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_connecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_connecat_id_fkey FOREIGN KEY (connecat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_crmzone_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_crmzone_id_fkey FOREIGN KEY (crmzone_id) REFERENCES crm_zone(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_district_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_dqa_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_expl_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_fluid_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_fluid_type_feature_type_fkey FOREIGN KEY (fluid_type, feature_type) REFERENCES man_type_fluid(fluid_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_function_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_function_type_feature_type_fkey FOREIGN KEY (function_type, feature_type) REFERENCES man_type_function(function_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_location_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_location_type_feature_type_fkey FOREIGN KEY (location_type, feature_type) REFERENCES man_type_location(location_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_ownercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_pjoint_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_presszonecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_soilcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_state_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_streetaxis2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis2_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_workcat_id_end_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec connec_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dimensions dimensions_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dimensions
    ADD CONSTRAINT dimensions_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dimensions dimensions_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dimensions
    ADD CONSTRAINT dimensions_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dimensions dimensions_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dimensions
    ADD CONSTRAINT dimensions_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dma dma_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dma
    ADD CONSTRAINT dma_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dma dma_macrodma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dma
    ADD CONSTRAINT dma_macrodma_id_fkey FOREIGN KEY (macrodma_id) REFERENCES macrodma(macrodma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dma dma_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dma
    ADD CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doc doc_doc_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_doc_type_fkey FOREIGN KEY (doc_type) REFERENCES doc_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doc_x_arc doc_x_arc_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_arc
    ADD CONSTRAINT doc_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_arc doc_x_arc_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_arc
    ADD CONSTRAINT doc_x_arc_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_connec doc_x_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_connec
    ADD CONSTRAINT doc_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_connec doc_x_connec_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_connec
    ADD CONSTRAINT doc_x_connec_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_node doc_x_node_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_node
    ADD CONSTRAINT doc_x_node_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_node doc_x_node_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_node
    ADD CONSTRAINT doc_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_psector doc_x_psector_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_psector
    ADD CONSTRAINT doc_x_psector_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_psector doc_x_psector_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_psector
    ADD CONSTRAINT doc_x_psector_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_visit doc_x_visit_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_visit
    ADD CONSTRAINT doc_x_visit_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_visit doc_x_visit_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_visit
    ADD CONSTRAINT doc_x_visit_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_workcat doc_x_workcat_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_workcat
    ADD CONSTRAINT doc_x_workcat_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_workcat doc_x_workcat_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_workcat
    ADD CONSTRAINT doc_x_workcat_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dqa dqa_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dqa
    ADD CONSTRAINT dqa_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dqa dqa_macrodqa_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dqa
    ADD CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id) REFERENCES macrodqa(macrodqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: dqa dqa_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dqa
    ADD CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: element element_buildercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_buildercat_id_fkey FOREIGN KEY (buildercat_id) REFERENCES cat_builder(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_category_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_category_type_feature_type_fkey FOREIGN KEY (category_type, feature_type) REFERENCES man_type_category(category_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_elementcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_elementcat_id_fkey FOREIGN KEY (elementcat_id) REFERENCES cat_element(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_fluid_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_fluid_type_feature_type_fkey FOREIGN KEY (fluid_type, feature_type) REFERENCES man_type_fluid(fluid_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_function_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_function_type_feature_type_fkey FOREIGN KEY (function_type, feature_type) REFERENCES man_type_function(function_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_location_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_location_type_feature_type_fkey FOREIGN KEY (location_type, feature_type) REFERENCES man_type_location(location_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_ownercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_state_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_workcat_id_end_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element element_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element_x_arc element_x_arc_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_arc
    ADD CONSTRAINT element_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: element_x_arc element_x_arc_element_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_arc
    ADD CONSTRAINT element_x_arc_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: element_x_connec element_x_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_connec
    ADD CONSTRAINT element_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: element_x_connec element_x_connec_element_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_connec
    ADD CONSTRAINT element_x_connec_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: element_x_node element_x_node_element_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_node
    ADD CONSTRAINT element_x_node_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: element_x_node element_x_node_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_node
    ADD CONSTRAINT element_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ext_address ext_address_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_address
    ADD CONSTRAINT ext_address_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_address ext_address_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_address
    ADD CONSTRAINT ext_address_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_address ext_address_plot_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_address
    ADD CONSTRAINT ext_address_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES ext_plot(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_address ext_address_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_address
    ADD CONSTRAINT ext_address_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES ext_streetaxis(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_cat_period ext_cat_period_period_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_period
    ADD CONSTRAINT ext_cat_period_period_type_fkey FOREIGN KEY (period_type) REFERENCES ext_cat_period_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_district ext_district_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_district
    ADD CONSTRAINT ext_district_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_hydrometer_category ext_hydrometer_category_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_hydrometer_category
    ADD CONSTRAINT ext_hydrometer_category_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_plot ext_plot_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_plot
    ADD CONSTRAINT ext_plot_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_plot ext_plot_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_plot
    ADD CONSTRAINT ext_plot_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_plot ext_plot_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_plot
    ADD CONSTRAINT ext_plot_streetaxis_id_fkey FOREIGN KEY (streetaxis_id) REFERENCES ext_streetaxis(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_rtc_dma_period ext_rtc_dma_period_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_dma_period
    ADD CONSTRAINT ext_rtc_dma_period_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_streetaxis ext_streetaxis_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_streetaxis
    ADD CONSTRAINT ext_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_streetaxis ext_streetaxis_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_streetaxis
    ADD CONSTRAINT ext_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_streetaxis ext_streetaxis_type_street_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_streetaxis
    ADD CONSTRAINT ext_streetaxis_type_street_fkey FOREIGN KEY (type) REFERENCES ext_type_street(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_connec inp_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_connec
    ADD CONSTRAINT inp_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_connec inp_connec_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_connec
    ADD CONSTRAINT inp_connec_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_controls inp_controls_x_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_controls
    ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_curve_value inp_curve_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_curve_value
    ADD CONSTRAINT inp_curve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_curve inp_curve_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_curve
    ADD CONSTRAINT inp_curve_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_demand inp_demand_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_demand
    ADD CONSTRAINT inp_demand_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_connec inp_demand_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_connec
    ADD CONSTRAINT inp_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_connec inp_dscenario_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_connec
    ADD CONSTRAINT inp_dscenario_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES inp_connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_connec inp_dscenario_connec_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_connec
    ADD CONSTRAINT inp_dscenario_connec_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_controls inp_dscenario_controls_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_controls
    ADD CONSTRAINT inp_dscenario_controls_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_controls inp_dscenario_controls_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_controls
    ADD CONSTRAINT inp_dscenario_controls_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dscenario_demand inp_dscenario_demand_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_demand
    ADD CONSTRAINT inp_dscenario_demand_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_demand inp_dscenario_demand_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_demand
    ADD CONSTRAINT inp_dscenario_demand_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inlet inp_dscenario_inlet_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inlet
    ADD CONSTRAINT inp_dscenario_inlet_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inlet inp_dscenario_inlet_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inlet
    ADD CONSTRAINT inp_dscenario_inlet_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inlet inp_dscenario_inlet_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inlet
    ADD CONSTRAINT inp_dscenario_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_inlet(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inlet inp_dscenario_inlet_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inlet
    ADD CONSTRAINT inp_dscenario_inlet_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_junction inp_dscenario_junction_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_junction
    ADD CONSTRAINT inp_dscenario_junction_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_junction inp_dscenario_junction_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_junction
    ADD CONSTRAINT inp_dscenario_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_junction(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_junction inp_dscenario_junction_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_junction
    ADD CONSTRAINT inp_dscenario_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pipe inp_dscenario_pipe_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pipe
    ADD CONSTRAINT inp_dscenario_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_pipe(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pipe inp_dscenario_pipe_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pipe
    ADD CONSTRAINT inp_dscenario_pipe_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump_additional inp_dscenario_pump_additional_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional
    ADD CONSTRAINT inp_dscenario_pump_additional_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump_additional inp_dscenario_pump_additional_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional
    ADD CONSTRAINT inp_dscenario_pump_additional_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump_additional inp_dscenario_pump_additional_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional
    ADD CONSTRAINT inp_dscenario_pump_additional_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump_additional inp_dscenario_pump_additional_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional
    ADD CONSTRAINT inp_dscenario_pump_additional_pattern_id_fkey FOREIGN KEY (pattern) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump inp_dscenario_pump_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump
    ADD CONSTRAINT inp_dscenario_pump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump inp_dscenario_pump_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump
    ADD CONSTRAINT inp_dscenario_pump_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump inp_dscenario_pump_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump
    ADD CONSTRAINT inp_dscenario_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_pump(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_pump inp_dscenario_pump_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump
    ADD CONSTRAINT inp_dscenario_pump_pattern_id_fkey FOREIGN KEY (pattern) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_reservoir inp_dscenario_reservoir_additional_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_reservoir
    ADD CONSTRAINT inp_dscenario_reservoir_additional_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_reservoir inp_dscenario_reservoir_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_reservoir
    ADD CONSTRAINT inp_dscenario_reservoir_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_reservoir(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_reservoir inp_dscenario_reservoir_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_reservoir
    ADD CONSTRAINT inp_dscenario_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_rules inp_dscenario_rules_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_rules
    ADD CONSTRAINT inp_dscenario_rules_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_rules inp_dscenario_rules_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_rules
    ADD CONSTRAINT inp_dscenario_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dscenario_shortpipe inp_dscenario_shortpipe_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_shortpipe
    ADD CONSTRAINT inp_dscenario_shortpipe_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_shortpipe inp_dscenario_shortpipe_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_shortpipe
    ADD CONSTRAINT inp_dscenario_shortpipe_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_shortpipe(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_tank inp_dscenario_tank_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_tank
    ADD CONSTRAINT inp_dscenario_tank_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_tank inp_dscenario_tank_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_tank
    ADD CONSTRAINT inp_dscenario_tank_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_tank inp_dscenario_tank_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_tank
    ADD CONSTRAINT inp_dscenario_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_tank(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_valve inp_dscenario_valve_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_valve
    ADD CONSTRAINT inp_dscenario_valve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_valve inp_dscenario_valve_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_valve
    ADD CONSTRAINT inp_dscenario_valve_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_valve inp_dscenario_valve_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_valve
    ADD CONSTRAINT inp_dscenario_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_valve(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_virtualvalve inp_dscenario_virtualvalve_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_virtualvalve
    ADD CONSTRAINT inp_dscenario_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_virtualvalve(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_virtualvalve inp_dscenario_virtualvalve_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_virtualvalve
    ADD CONSTRAINT inp_dscenario_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_virtualvalve inp_dscenario_virtualvalve_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_virtualvalve
    ADD CONSTRAINT inp_dscenario_virtualvalve_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_emitter inp_emitter_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_emitter
    ADD CONSTRAINT inp_emitter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_inlet inp_inlet_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inlet
    ADD CONSTRAINT inp_inlet_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_inlet inp_inlet_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inlet
    ADD CONSTRAINT inp_inlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_inlet inp_inlet_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inlet
    ADD CONSTRAINT inp_inlet_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_junction inp_junction_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_junction
    ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_junction inp_junction_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_junction
    ADD CONSTRAINT inp_junction_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_label inp_label_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_label
    ADD CONSTRAINT inp_label_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_mixing inp_mixing_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_mixing
    ADD CONSTRAINT inp_mixing_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pattern inp_pattern_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern
    ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pattern_value inp_pattern_value_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern_value
    ADD CONSTRAINT inp_pattern_value_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pipe inp_pipe_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pipe
    ADD CONSTRAINT inp_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump_additional inp_pump_additional_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_additional
    ADD CONSTRAINT inp_pump_additional_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump_additional inp_pump_additional_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_additional
    ADD CONSTRAINT inp_pump_additional_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump_additional inp_pump_additional_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_additional
    ADD CONSTRAINT inp_pump_additional_pattern_id_fkey FOREIGN KEY (pattern) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump inp_pump_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump_importinp inp_pump_importinp_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_importinp
    ADD CONSTRAINT inp_pump_importinp_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump inp_pump_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump inp_pump_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_quality inp_quality_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_quality
    ADD CONSTRAINT inp_quality_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_reservoir inp_reservoir_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_reservoir
    ADD CONSTRAINT inp_reservoir_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_reservoir inp_reservoir_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_reservoir
    ADD CONSTRAINT inp_reservoir_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_rules inp_rules_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_rules
    ADD CONSTRAINT inp_rules_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: selector_inp_dscenario inp_selector_dscenario_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_inp_dscenario
    ADD CONSTRAINT inp_selector_dscenario_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_inp_result inp_selector_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_inp_result
    ADD CONSTRAINT inp_selector_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_sector inp_selector_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_sector
    ADD CONSTRAINT inp_selector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_shortpipe inp_shortpipe_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_shortpipe
    ADD CONSTRAINT inp_shortpipe_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_source inp_source_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_source
    ADD CONSTRAINT inp_source_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_source inp_source_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_source
    ADD CONSTRAINT inp_source_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_tank inp_tank_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_tank
    ADD CONSTRAINT inp_tank_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_tank inp_tank_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_tank
    ADD CONSTRAINT inp_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_valve inp_valve_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve
    ADD CONSTRAINT inp_valve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_valve_importinp inp_valve_importinp_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve_importinp
    ADD CONSTRAINT inp_valve_importinp_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_valve_importinp inp_valve_importinp_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve_importinp
    ADD CONSTRAINT inp_valve_importinp_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_valve inp_valve_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve
    ADD CONSTRAINT inp_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_valve inp_valve_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve
    ADD CONSTRAINT inp_valve_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_virtualvalve inp_virtualvalve_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_virtualvalve
    ADD CONSTRAINT inp_virtualvalve_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_virtualvalve inp_virtualvalve_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_virtualvalve
    ADD CONSTRAINT inp_virtualvalve_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_virtualvalve inp_virtualvalve_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_virtualvalve
    ADD CONSTRAINT inp_virtualvalve_to_arc_fkey FOREIGN KEY (_to_arc_) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: link link_exit_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_exit_type_fkey FOREIGN KEY (exit_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: link link_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: link link_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: link link_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: macrodma macrodma_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodma
    ADD CONSTRAINT macrodma_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: macrodqa macrodqa_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodqa
    ADD CONSTRAINT macrodqa_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: exploitation macroexpl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY exploitation
    ADD CONSTRAINT macroexpl_id_fkey FOREIGN KEY (macroexpl_id) REFERENCES macroexploitation(macroexpl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_addfields_value man_addfields_value_parameter_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_addfields_value
    ADD CONSTRAINT man_addfields_value_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES sys_addfields(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_expansiontank man_expansiontank_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_expansiontank
    ADD CONSTRAINT man_expansiontank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_filter man_filter_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_filter
    ADD CONSTRAINT man_filter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_flexunion man_flexunion_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_flexunion
    ADD CONSTRAINT man_flexunion_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_fountain man_fountain_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_fountain
    ADD CONSTRAINT man_fountain_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_fountain man_fountain_linked_connec_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_fountain
    ADD CONSTRAINT man_fountain_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_greentap man_greentap_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_greentap
    ADD CONSTRAINT man_greentap_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_greentap man_greentap_linked_connec_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_greentap
    ADD CONSTRAINT man_greentap_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_hydrant man_hydrant_catnode_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_hydrant
    ADD CONSTRAINT man_hydrant_catnode_id_fkey FOREIGN KEY (valve) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_hydrant man_hydrant_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_hydrant
    ADD CONSTRAINT man_hydrant_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_junction man_junction_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_junction
    ADD CONSTRAINT man_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_manhole man_manhole_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_manhole
    ADD CONSTRAINT man_manhole_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_meter man_meter_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_meter
    ADD CONSTRAINT man_meter_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_netelement man_netelement_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netelement
    ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_netsamplepoint man_netsamplepoint_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netsamplepoint
    ADD CONSTRAINT man_netsamplepoint_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_netwjoin man_netwjoin_cat_valve_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netwjoin
    ADD CONSTRAINT man_netwjoin_cat_valve_fkey FOREIGN KEY (cat_valve) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_netwjoin man_netwjoin_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netwjoin
    ADD CONSTRAINT man_netwjoin_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_pipe man_pipe_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_pipe
    ADD CONSTRAINT man_pipe_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_pump man_pump_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_pump
    ADD CONSTRAINT man_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_reduction man_reduction_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_reduction
    ADD CONSTRAINT man_reduction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_register man_register_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_register
    ADD CONSTRAINT man_register_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_source man_source_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_source
    ADD CONSTRAINT man_source_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_tank man_tank_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_tank
    ADD CONSTRAINT man_tank_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_tap man_tap_cat_valve_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_tap
    ADD CONSTRAINT man_tap_cat_valve_fkey FOREIGN KEY (cat_valve) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_tap man_tap_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_tap
    ADD CONSTRAINT man_tap_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_tap man_tap_linked_connec_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_tap
    ADD CONSTRAINT man_tap_linked_connec_fkey FOREIGN KEY (linked_connec) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_type_category man_type_category_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_category
    ADD CONSTRAINT man_type_category_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_type_fluid man_type_fluid_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_fluid
    ADD CONSTRAINT man_type_fluid_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_type_function man_type_function_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_function
    ADD CONSTRAINT man_type_function_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_type_location man_type_location_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_location
    ADD CONSTRAINT man_type_location_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_valve man_valve_cat_valve2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_valve
    ADD CONSTRAINT man_valve_cat_valve2_fkey FOREIGN KEY (cat_valve2) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_valve man_valve_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_valve
    ADD CONSTRAINT man_valve_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_varc man_varc_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_varc
    ADD CONSTRAINT man_varc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_waterwell man_waterwell_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_waterwell
    ADD CONSTRAINT man_waterwell_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_wjoin man_wjoin_cat_valve_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wjoin
    ADD CONSTRAINT man_wjoin_cat_valve_fkey FOREIGN KEY (cat_valve) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_wjoin man_wjoin_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wjoin
    ADD CONSTRAINT man_wjoin_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_wtp man_wtp_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wtp
    ADD CONSTRAINT man_wtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: minsector minsector_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector
    ADD CONSTRAINT minsector_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: minsector minsector_dqa_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector
    ADD CONSTRAINT minsector_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: minsector minsector_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector
    ADD CONSTRAINT minsector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: minsector minsector_presszonecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector
    ADD CONSTRAINT minsector_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: minsector minsector_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector
    ADD CONSTRAINT minsector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node_border_sector node_border_expl_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node_border_sector
    ADD CONSTRAINT node_border_expl_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_buildercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_buildercat_id_fkey FOREIGN KEY (buildercat_id) REFERENCES cat_builder(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_category_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_category_type_feature_type_fkey FOREIGN KEY (category_type, feature_type) REFERENCES man_type_category(category_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_district_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_dqa_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_dqa_id_fkey FOREIGN KEY (dqa_id) REFERENCES dqa(dqa_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_expl_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_expl_id2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec node_expl_id2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT node_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_fluid_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_fluid_type_feature_type_fkey FOREIGN KEY (fluid_type, feature_type) REFERENCES man_type_fluid(fluid_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_function_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_function_type_feature_type_fkey FOREIGN KEY (function_type, feature_type) REFERENCES man_type_function(function_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_location_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_location_type_feature_type_fkey FOREIGN KEY (location_type, feature_type) REFERENCES man_type_location(location_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_nodecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_nodecat_id_fkey FOREIGN KEY (nodecat_id) REFERENCES cat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_ownercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_parent_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_presszonecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_soilcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_state_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_streetaxis2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis2_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_workcat_id_end_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_mincut_arc om_mincut_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_arc
    ADD CONSTRAINT om_mincut_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_mincut om_mincut_assigned_to_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut
    ADD CONSTRAINT om_mincut_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES cat_users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_mincut_connec om_mincut_connec_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_connec
    ADD CONSTRAINT om_mincut_connec_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_mincut om_mincut_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut
    ADD CONSTRAINT om_mincut_feature_type_fkey FOREIGN KEY (anl_feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_mincut_hydrometer om_mincut_hydrometer_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_hydrometer
    ADD CONSTRAINT om_mincut_hydrometer_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_mincut om_mincut_mincut_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut
    ADD CONSTRAINT om_mincut_mincut_type_fkey FOREIGN KEY (mincut_type) REFERENCES om_mincut_cat_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_mincut_node om_mincut_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_node
    ADD CONSTRAINT om_mincut_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_mincut_polygon om_mincut_polygon_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_polygon
    ADD CONSTRAINT om_mincut_polygon_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_mincut_valve om_mincut_valve_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve
    ADD CONSTRAINT om_mincut_valve_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_mincut_valve_unaccess om_mincut_valve_unaccess_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve_unaccess
    ADD CONSTRAINT om_mincut_valve_unaccess_result_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_streetaxis om_streetaxis_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_streetaxis
    ADD CONSTRAINT om_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_streetaxis om_streetaxis_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_streetaxis
    ADD CONSTRAINT om_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_visit_event_photo om_visit_event_foto_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event_photo
    ADD CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_event om_visit_event_parameter_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event
    ADD CONSTRAINT om_visit_event_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES config_visit_parameter(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_event_photo om_visit_event_photo_event_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event_photo
    ADD CONSTRAINT om_visit_event_photo_event_id_fkey FOREIGN KEY (event_id) REFERENCES om_visit_event(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_event om_visit_event_position_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event
    ADD CONSTRAINT om_visit_event_position_id_fkey FOREIGN KEY (position_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_visit_event om_visit_event_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event
    ADD CONSTRAINT om_visit_event_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit om_visit_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit
    ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_visit om_visit_om_visit_cat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit
    ADD CONSTRAINT om_visit_om_visit_cat_id_fkey FOREIGN KEY (visitcat_id) REFERENCES om_visit_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_visit_x_arc om_visit_x_arc_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_arc
    ADD CONSTRAINT om_visit_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_x_arc om_visit_x_arc_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_arc
    ADD CONSTRAINT om_visit_x_arc_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_x_connec om_visit_x_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_connec
    ADD CONSTRAINT om_visit_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_x_connec om_visit_x_connec_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_connec
    ADD CONSTRAINT om_visit_x_connec_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_x_node om_visit_x_node_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_node
    ADD CONSTRAINT om_visit_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_x_node om_visit_x_node_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_node
    ADD CONSTRAINT om_visit_x_node_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_waterbalance om_waterbalance_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_waterbalance
    ADD CONSTRAINT om_waterbalance_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: om_waterbalance om_waterbalance_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_waterbalance
    ADD CONSTRAINT om_waterbalance_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plan_arc_x_pavement plan_arc_x_pavement_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_arc_x_pavement
    ADD CONSTRAINT plan_arc_x_pavement_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_arc_x_pavement plan_arc_x_pavement_pavcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_arc_x_pavement
    ADD CONSTRAINT plan_arc_x_pavement_pavcat_id_fkey FOREIGN KEY (pavcat_id) REFERENCES cat_pavement(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plan_price_compost plan_price_compost_compost_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price_compost
    ADD CONSTRAINT plan_price_compost_compost_id_fkey FOREIGN KEY (compost_id) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_price_compost plan_price_compost_compost_id_fkey2; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price_compost
    ADD CONSTRAINT plan_price_compost_compost_id_fkey2 FOREIGN KEY (simple_id) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_price plan_price_pricecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price
    ADD CONSTRAINT plan_price_pricecat_id_fkey FOREIGN KEY (pricecat_id) REFERENCES plan_price_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: plan_psector plan_psector_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector
    ADD CONSTRAINT plan_psector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_plan_psector plan_psector_selector_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_plan_psector
    ADD CONSTRAINT plan_psector_selector_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_arc plan_psector_x_arc_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_arc
    ADD CONSTRAINT plan_psector_x_arc_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_arc plan_psector_x_arc_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_arc
    ADD CONSTRAINT plan_psector_x_arc_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_connec plan_psector_x_connec_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec
    ADD CONSTRAINT plan_psector_x_connec_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: plan_psector_x_connec plan_psector_x_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec
    ADD CONSTRAINT plan_psector_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_connec plan_psector_x_connec_link_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec
    ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_connec plan_psector_x_connec_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec
    ADD CONSTRAINT plan_psector_x_connec_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_node plan_psector_x_node_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_node
    ADD CONSTRAINT plan_psector_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_node plan_psector_x_node_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_node
    ADD CONSTRAINT plan_psector_x_node_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_other plan_psector_x_other_price_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_other
    ADD CONSTRAINT plan_psector_x_other_price_id_fkey FOREIGN KEY (price_id) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_other plan_psector_x_other_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_other
    ADD CONSTRAINT plan_psector_x_other_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_rec_result_arc plan_rec_result_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_rec_result_arc
    ADD CONSTRAINT plan_rec_result_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES plan_result_cat(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_rec_result_node plan_rec_result_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_rec_result_node
    ADD CONSTRAINT plan_rec_result_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES plan_result_cat(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_reh_result_arc plan_reh_result_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_reh_result_arc
    ADD CONSTRAINT plan_reh_result_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES plan_result_cat(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_reh_result_node plan_reh_result_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_reh_result_node
    ADD CONSTRAINT plan_reh_result_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES plan_result_cat(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_plan_result plan_result_selector_result_id_fk; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_plan_result
    ADD CONSTRAINT plan_result_selector_result_id_fk FOREIGN KEY (result_id) REFERENCES plan_result_cat(result_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: polygon polygon_sys_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY polygon
    ADD CONSTRAINT polygon_sys_type_fkey FOREIGN KEY (sys_type) REFERENCES sys_feature_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pond pond_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pond
    ADD CONSTRAINT pond_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pond pond_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pond
    ADD CONSTRAINT pond_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pond pond_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pond
    ADD CONSTRAINT pond_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pond pond_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pond
    ADD CONSTRAINT pond_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pool pool_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pool
    ADD CONSTRAINT pool_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pool pool_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pool
    ADD CONSTRAINT pool_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pool pool_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pool
    ADD CONSTRAINT pool_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pool pool_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pool
    ADD CONSTRAINT pool_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_raster_dem raster_dem_rastercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_raster_dem
    ADD CONSTRAINT raster_dem_rastercat_id_fkey FOREIGN KEY (rastercat_id) REFERENCES ext_cat_raster(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rpt_arc rpt_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arc
    ADD CONSTRAINT rpt_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_cat_result rpt_cat_result_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_cat_result
    ADD CONSTRAINT rpt_cat_result_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rpt_energy_usage rpt_energy_usage_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_energy_usage
    ADD CONSTRAINT rpt_energy_usage_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_hydraulic_status rpt_hydraulic_status_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_hydraulic_status
    ADD CONSTRAINT rpt_hydraulic_status_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_inp_arc rpt_inp_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_arc
    ADD CONSTRAINT rpt_inp_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_inp_node rpt_inp_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_node
    ADD CONSTRAINT rpt_inp_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_inp_pattern_value rpt_inp_pattern_value_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_pattern_value
    ADD CONSTRAINT rpt_inp_pattern_value_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rpt_inp_pattern_value rpt_inp_pattern_value_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_pattern_value
    ADD CONSTRAINT rpt_inp_pattern_value_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_node rpt_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_node
    ADD CONSTRAINT rpt_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_rpt_compare rpt_selector_compare_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_compare
    ADD CONSTRAINT rpt_selector_compare_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_rpt_main rpt_selector_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_main
    ADD CONSTRAINT rpt_selector_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rtc_hydrometer_x_connec rtc_hydrometer_x_connec_connec_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_hydrometer_x_connec
    ADD CONSTRAINT rtc_hydrometer_x_connec_connec_id_fkey FOREIGN KEY (connec_id) REFERENCES connec(connec_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rtc_hydrometer_x_connec rtc_hydrometer_x_connec_hydrometer_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_hydrometer_x_connec
    ADD CONSTRAINT rtc_hydrometer_x_connec_hydrometer_id_fkey FOREIGN KEY (hydrometer_id) REFERENCES rtc_hydrometer(hydrometer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_waterbalance_dma_graph rtc_scada_x_dma_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_waterbalance_dma_graph
    ADD CONSTRAINT rtc_scada_x_dma_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_district_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_exploitation_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_exploitation_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_featurecat_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_featurecat_fkey FOREIGN KEY (featurecat_id) REFERENCES cat_feature(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_presszonecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_presszonecat_id_fkey FOREIGN KEY (presszone_id) REFERENCES presszone(presszone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_streetaxis2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis2_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_streetaxis_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_streetaxis_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_verified_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_verified_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_workcat_id_end_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: samplepoint samplepoint_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT samplepoint_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sector sector_macrosector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sector
    ADD CONSTRAINT sector_macrosector_id_fkey FOREIGN KEY (macrosector_id) REFERENCES macrosector(macrosector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sector sector_parent_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sector
    ADD CONSTRAINT sector_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sector sector_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sector
    ADD CONSTRAINT sector_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: selector_audit selector_audit_fprocesscat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_audit
    ADD CONSTRAINT selector_audit_fprocesscat_id_fkey FOREIGN KEY (fid) REFERENCES sys_fprocess(fid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_expl selector_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_expl
    ADD CONSTRAINT selector_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_mincut_result selector_mincut_result_selector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_mincut_result
    ADD CONSTRAINT selector_mincut_result_selector_id_fkey FOREIGN KEY (result_id) REFERENCES om_mincut(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_psector selector_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_psector
    ADD CONSTRAINT selector_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_state selector_state_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_state
    ADD CONSTRAINT selector_state_id_fkey FOREIGN KEY (state_id) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: selector_workcat selector_workcat_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_workcat
    ADD CONSTRAINT selector_workcat_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sys_addfields sys_addfields_cat_feature_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_addfields
    ADD CONSTRAINT sys_addfields_cat_feature_id_fkey FOREIGN KEY (cat_feature_id) REFERENCES cat_feature(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sys_feature_cat sys_feature_cat_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_feature_cat
    ADD CONSTRAINT sys_feature_cat_type_fkey FOREIGN KEY (type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sys_function sys_function_sys_role_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_function
    ADD CONSTRAINT sys_function_sys_role_id_fkey FOREIGN KEY (sys_role) REFERENCES sys_role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sys_table sys_table_style_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_table
    ADD CONSTRAINT sys_table_style_id_fkey FOREIGN KEY (style_id) REFERENCES sys_style(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sys_table sys_table_sys_role_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_table
    ADD CONSTRAINT sys_table_sys_role_fkey FOREIGN KEY (sys_role) REFERENCES sys_role(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: temp_csv temp_csv_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_csv
    ADD CONSTRAINT temp_csv_fkey FOREIGN KEY (fid) REFERENCES sys_fprocess(fid) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: value_state_type value_state_type_state_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY value_state_type
    ADD CONSTRAINT value_state_type_state_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;

