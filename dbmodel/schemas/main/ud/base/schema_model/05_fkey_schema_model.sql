/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: arc arc_arc_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_arc_type_fkey FOREIGN KEY (arc_type) REFERENCES cat_feature_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: arc arc_drainzone_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node arc_drainzone_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: connec arc_drainzone_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully arc_drainzone_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id) REFERENCES drainzone(drainzone_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: arc arc_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_arc cat_arc_arc_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_arc_type_fkey FOREIGN KEY (arc_type) REFERENCES cat_feature_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_arc cat_arc_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_cost_fkey FOREIGN KEY (cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_arc cat_arc_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_arc cat_arc_shape_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_shape_id_fkey FOREIGN KEY (shape) REFERENCES cat_arc_shape(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_arc cat_arc_tsect_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_tsect_id_fkey FOREIGN KEY (tsect_id) REFERENCES inp_transects(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_connec cat_connec_connec_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_connec
    ADD CONSTRAINT cat_connec_connec_type_fkey FOREIGN KEY (connec_type) REFERENCES cat_feature_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_dwf_scenario cat_dwf_scenario_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dwf_scenario
    ADD CONSTRAINT cat_dwf_scenario_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_feature_gully cat_feature_gully_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_gully
    ADD CONSTRAINT cat_feature_gully_fkey FOREIGN KEY (id) REFERENCES cat_feature(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_feature_gully cat_feature_gully_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_gully
    ADD CONSTRAINT cat_feature_gully_type_fkey FOREIGN KEY (type) REFERENCES sys_feature_cat(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_grate cat_grate_brand_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_grate
    ADD CONSTRAINT cat_grate_brand_fkey FOREIGN KEY (brand) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_grate cat_grate_gully_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_grate
    ADD CONSTRAINT cat_grate_gully_type_fkey FOREIGN KEY (gully_type) REFERENCES cat_feature_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_grate cat_grate_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_grate
    ADD CONSTRAINT cat_grate_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_grate cat_grate_model_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_grate
    ADD CONSTRAINT cat_grate_model_fkey FOREIGN KEY (model) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cat_hydrology cat_hydrology_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_hydrology
    ADD CONSTRAINT cat_hydrology_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: cat_node cat_node_node_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_node_type_fkey FOREIGN KEY (node_type) REFERENCES cat_feature_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_node cat_node_shape_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_shape_fkey FOREIGN KEY (shape) REFERENCES cat_node_shape(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cat_pavement cat_pavement_m2_cost_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_pavement
    ADD CONSTRAINT cat_pavement_m2_cost_fkey FOREIGN KEY (m2_cost) REFERENCES plan_price(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
    ADD CONSTRAINT config_user_x_sector_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: connec connec_connectype_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_connectype_id_fkey FOREIGN KEY (connec_type) REFERENCES cat_feature_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: connec connec_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: connec connec_private_connecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_private_connecat_id_fkey FOREIGN KEY (private_connecat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: doc_x_gully doc_x_gully_doc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_gully
    ADD CONSTRAINT doc_x_gully_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: doc_x_gully doc_x_gully_gully_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_gully
    ADD CONSTRAINT doc_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: element_x_gully element_x_gully_element_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_gully
    ADD CONSTRAINT element_x_gully_element_id_fkey FOREIGN KEY (element_id) REFERENCES element(element_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: element_x_gully element_x_gully_gully_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_gully
    ADD CONSTRAINT element_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: gully gully_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_buildercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_buildercat_id_fkey FOREIGN KEY (buildercat_id) REFERENCES cat_builder(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_category_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_category_type_feature_type_fkey FOREIGN KEY (category_type, feature_type) REFERENCES man_type_category(category_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_connec_arccat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_connec_arccat_id_fkey FOREIGN KEY (connec_arccat_id) REFERENCES cat_connec(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_connec_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_connec_matcat_id_fkey FOREIGN KEY (connec_matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gully gully_district_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_district_id_fkey FOREIGN KEY (district_id) REFERENCES ext_district(district_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_dma_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_expl_id2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_expl_id2_fkey FOREIGN KEY (expl_id2) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_feature_type_fkey FOREIGN KEY (feature_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_fluid_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_fluid_type_feature_type_fkey FOREIGN KEY (fluid_type, feature_type) REFERENCES man_type_fluid(fluid_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_function_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_function_type_feature_type_fkey FOREIGN KEY (function_type, feature_type) REFERENCES man_type_function(function_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_gratecat2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_gratecat2_id_fkey FOREIGN KEY (gratecat2_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_gratecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_gratecat_id_fkey FOREIGN KEY (gratecat_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_gullytype_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_gullytype_id_fkey FOREIGN KEY (gully_type) REFERENCES cat_feature_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_location_type_feature_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_location_type_feature_type_fkey FOREIGN KEY (location_type, feature_type) REFERENCES man_type_location(location_type, feature_type) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_gully(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_ownercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_ownercat_id_fkey FOREIGN KEY (ownercat_id) REFERENCES cat_owner(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_pjoint_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_pjoint_type_fkey FOREIGN KEY (pjoint_type) REFERENCES sys_feature_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_pol_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_pol_id_fkey FOREIGN KEY (_pol_id_) REFERENCES polygon(pol_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: gully gully_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_soilcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_soilcat_id_fkey FOREIGN KEY (soilcat_id) REFERENCES cat_soil(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_state_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_state_id_fkey FOREIGN KEY (state) REFERENCES value_state(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_state_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_state_type_fkey FOREIGN KEY (state_type) REFERENCES value_state_type(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_streetaxis2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_streetaxis2_id_fkey FOREIGN KEY (muni_id, streetaxis2_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_streetaxis_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_streetaxis_id_fkey FOREIGN KEY (muni_id, streetaxis_id) REFERENCES ext_streetaxis(muni_id, id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_workcat_id_end_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_workcat_id_end_fkey FOREIGN KEY (workcat_id_end) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: gully gully_workcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_workcat_id_fkey FOREIGN KEY (workcat_id) REFERENCES cat_work(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dscenario_raingage iinp_dscenario_raingage_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_raingage
    ADD CONSTRAINT iinp_dscenario_raingage_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_aquifer inp_aquifer_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_aquifer
    ADD CONSTRAINT inp_aquifer_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_buildup inp_buildup_land_x_pol_landus_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_buildup
    ADD CONSTRAINT inp_buildup_land_x_pol_landus_id_fkey FOREIGN KEY (landus_id) REFERENCES inp_landuses(landus_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_buildup inp_buildup_land_x_pol_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_buildup
    ADD CONSTRAINT inp_buildup_land_x_pol_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_conduit inp_conduit_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_conduit
    ADD CONSTRAINT inp_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_controls inp_controls_x_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_controls
    ADD CONSTRAINT inp_controls_x_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_coverage inp_coverage_land_x_subc_landus_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_coverage
    ADD CONSTRAINT inp_coverage_land_x_subc_landus_id_fkey FOREIGN KEY (landus_id) REFERENCES inp_landuses(landus_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_coverage inp_coverage_land_x_subc_subc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_coverage
    ADD CONSTRAINT inp_coverage_land_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id) REFERENCES inp_subcatchment(subc_id, hydrology_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: inp_divider inp_divider_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_divider
    ADD CONSTRAINT inp_divider_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_divider inp_divider_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_divider
    ADD CONSTRAINT inp_divider_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_divider inp_divider_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_divider
    ADD CONSTRAINT inp_divider_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_conduit inp_dscenario_conduit_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_conduit
    ADD CONSTRAINT inp_dscenario_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES inp_conduit(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_conduit inp_dscenario_conduit_arccat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_conduit
    ADD CONSTRAINT inp_dscenario_conduit_arccat_id_fkey FOREIGN KEY (arccat_id) REFERENCES cat_arc(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_conduit inp_dscenario_conduit_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_conduit
    ADD CONSTRAINT inp_dscenario_conduit_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_conduit inp_dscenario_conduit_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_conduit
    ADD CONSTRAINT inp_dscenario_conduit_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_arc(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: inp_dscenario_flwreg_orifice inp_dscenario_flwreg_orifice_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_orifice
    ADD CONSTRAINT inp_dscenario_flwreg_orifice_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_orifice inp_dscenario_flwreg_orifice_nodarc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_orifice
    ADD CONSTRAINT inp_dscenario_flwreg_orifice_nodarc_id_fkey FOREIGN KEY (nodarc_id) REFERENCES inp_flwreg_orifice(nodarc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_outlet inp_dscenario_flwreg_outlet_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_outlet
    ADD CONSTRAINT inp_dscenario_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_outlet inp_dscenario_flwreg_outlet_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_outlet
    ADD CONSTRAINT inp_dscenario_flwreg_outlet_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_outlet inp_dscenario_flwreg_outlet_nodarc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_outlet
    ADD CONSTRAINT inp_dscenario_flwreg_outlet_nodarc_id_fkey FOREIGN KEY (nodarc_id) REFERENCES inp_flwreg_outlet(nodarc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_pump inp_dscenario_flwreg_pump_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_pump
    ADD CONSTRAINT inp_dscenario_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_pump inp_dscenario_flwreg_pump_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_pump
    ADD CONSTRAINT inp_dscenario_flwreg_pump_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_pump inp_dscenario_flwreg_pump_nodarc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_pump
    ADD CONSTRAINT inp_dscenario_flwreg_pump_nodarc_id_fkey FOREIGN KEY (nodarc_id) REFERENCES inp_flwreg_pump(nodarc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_weir inp_dscenario_flwreg_weir_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_weir
    ADD CONSTRAINT inp_dscenario_flwreg_weir_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_flwreg_weir inp_dscenario_flwreg_weir_nodarc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_weir
    ADD CONSTRAINT inp_dscenario_flwreg_weir_nodarc_id_fkey FOREIGN KEY (nodarc_id) REFERENCES inp_flwreg_weir(nodarc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inflows inp_dscenario_inflows_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows
    ADD CONSTRAINT inp_dscenario_inflows_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inflows inp_dscenario_inflows_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows
    ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dscenario_inflows_poll inp_dscenario_inflows_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows_poll
    ADD CONSTRAINT inp_dscenario_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inflows inp_dscenario_inflows_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows
    ADD CONSTRAINT inp_dscenario_inflows_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dscenario_inflows_poll inp_dscenario_inflows_pol_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows_poll
    ADD CONSTRAINT inp_dscenario_inflows_pol_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inflows_poll inp_dscenario_inflows_pol_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows_poll
    ADD CONSTRAINT inp_dscenario_inflows_pol_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dscenario_inflows_poll inp_dscenario_inflows_pol_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows_poll
    ADD CONSTRAINT inp_dscenario_inflows_pol_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_inflows_poll inp_dscenario_inflows_pol_timser_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows_poll
    ADD CONSTRAINT inp_dscenario_inflows_pol_timser_id_fkey FOREIGN KEY (timser_id) REFERENCES inp_timeseries(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: inp_dscenario_lid_usage inp_dscenario_lid_usage_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_lid_usage
    ADD CONSTRAINT inp_dscenario_lid_usage_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_lid_usage inp_dscenario_lid_usage_lidco_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_lid_usage
    ADD CONSTRAINT inp_dscenario_lid_usage_lidco_id_fkey FOREIGN KEY (lidco_id) REFERENCES inp_lid(lidco_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_outfall inp_dscenario_outfall_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_outfall
    ADD CONSTRAINT inp_dscenario_outfall_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_outfall inp_dscenario_outfall_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_outfall
    ADD CONSTRAINT inp_dscenario_outfall_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_outfall inp_dscenario_outfall_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_outfall
    ADD CONSTRAINT inp_dscenario_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_outfall(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_outfall inp_dscenario_outfall_timser_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_outfall
    ADD CONSTRAINT inp_dscenario_outfall_timser_id_fkey FOREIGN KEY (timser_id) REFERENCES inp_timeseries(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_raingage inp_dscenario_raingage_dscenario_rg_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_raingage
    ADD CONSTRAINT inp_dscenario_raingage_dscenario_rg_id_fkey FOREIGN KEY (rg_id) REFERENCES raingage(rg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_storage inp_dscenario_storage_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_storage
    ADD CONSTRAINT inp_dscenario_storage_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_storage inp_dscenario_storage_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_storage
    ADD CONSTRAINT inp_dscenario_storage_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_storage inp_dscenario_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_storage
    ADD CONSTRAINT inp_dscenario_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_storage(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_treatment inp_dscenario_treatment_dscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_treatment
    ADD CONSTRAINT inp_dscenario_treatment_dscenario_id_fkey FOREIGN KEY (dscenario_id) REFERENCES cat_dscenario(dscenario_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dwf inp_dwf_dwfscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_dwfscenario_id_fkey FOREIGN KEY (dwfscenario_id) REFERENCES cat_dwf_scenario(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dwf inp_dwf_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dwf inp_dwf_pat1_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_pat1_fkey FOREIGN KEY (pat1) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf inp_dwf_pat2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_pat2_fkey FOREIGN KEY (pat2) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf inp_dwf_pat3_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_pat3_fkey FOREIGN KEY (pat3) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf inp_dwf_pat4_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_pat4_fkey FOREIGN KEY (pat4) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_dwfscenario_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_dwfscenario_id_fkey FOREIGN KEY (dwfscenario_id) REFERENCES cat_dwf_scenario(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_pat1_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_pat1_fkey FOREIGN KEY (pat1) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_pat2_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_pat2_fkey FOREIGN KEY (pat2) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_pat3_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_pat3_fkey FOREIGN KEY (pat3) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_pat4_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_pat4_fkey FOREIGN KEY (pat4) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_orifice inp_flwreg_orifice_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_orifice
    ADD CONSTRAINT inp_flwreg_orifice_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_orifice inp_flwreg_orifice_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_orifice
    ADD CONSTRAINT inp_flwreg_orifice_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_outlet inp_flwreg_outlet_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_outlet
    ADD CONSTRAINT inp_flwreg_outlet_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_outlet inp_flwreg_outlet_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_outlet
    ADD CONSTRAINT inp_flwreg_outlet_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_outlet inp_flwreg_outlet_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_outlet
    ADD CONSTRAINT inp_flwreg_outlet_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_pump inp_flwreg_pump_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_pump
    ADD CONSTRAINT inp_flwreg_pump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_pump inp_flwreg_pump_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_pump
    ADD CONSTRAINT inp_flwreg_pump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_pump inp_flwreg_pump_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_pump
    ADD CONSTRAINT inp_flwreg_pump_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_weir inp_flwreg_weir_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_weir
    ADD CONSTRAINT inp_flwreg_weir_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_flwreg_weir inp_flwreg_weir_to_arc_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_weir
    ADD CONSTRAINT inp_flwreg_weir_to_arc_fkey FOREIGN KEY (to_arc) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_groundwater inp_groundwater_aquif_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_groundwater
    ADD CONSTRAINT inp_groundwater_aquif_id_fkey FOREIGN KEY (aquif_id) REFERENCES inp_aquifer(aquif_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_groundwater inp_groundwater_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_groundwater
    ADD CONSTRAINT inp_groundwater_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_groundwater inp_groundwater_subc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_groundwater
    ADD CONSTRAINT inp_groundwater_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id) REFERENCES inp_subcatchment(subc_id, hydrology_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_gully inp_gully_gully_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_gully
    ADD CONSTRAINT inp_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_inflows inp_inflows_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows
    ADD CONSTRAINT inp_inflows_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_inflows inp_inflows_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows
    ADD CONSTRAINT inp_inflows_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_inflows_poll inp_inflows_pol_x_node_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows_poll
    ADD CONSTRAINT inp_inflows_pol_x_node_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_inflows_poll inp_inflows_pol_x_node_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows_poll
    ADD CONSTRAINT inp_inflows_pol_x_node_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_inflows_poll inp_inflows_pol_x_node_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows_poll
    ADD CONSTRAINT inp_inflows_pol_x_node_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_inflows_poll inp_inflows_pol_x_node_timser_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows_poll
    ADD CONSTRAINT inp_inflows_pol_x_node_timser_id_fkey FOREIGN KEY (timser_id) REFERENCES inp_timeseries(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_junction inp_junction_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_junction
    ADD CONSTRAINT inp_junction_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_lid_value inp_lid_lidco_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_lid_value
    ADD CONSTRAINT inp_lid_lidco_id_fkey FOREIGN KEY (lidco_id) REFERENCES inp_lid(lidco_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_loadings inp_loadings_pol_x_subc_subc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_loadings
    ADD CONSTRAINT inp_loadings_pol_x_subc_subc_id_fkey FOREIGN KEY (subc_id, hydrology_id) REFERENCES inp_subcatchment(subc_id, hydrology_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_netgully inp_netgully_gully_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_netgully
    ADD CONSTRAINT inp_netgully_gully_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_orifice inp_orifice_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_orifice
    ADD CONSTRAINT inp_orifice_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_outfall inp_outfall_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outfall
    ADD CONSTRAINT inp_outfall_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_outfall inp_outfall_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outfall
    ADD CONSTRAINT inp_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_outfall inp_outfall_timser_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outfall
    ADD CONSTRAINT inp_outfall_timser_id_fkey FOREIGN KEY (timser_id) REFERENCES inp_timeseries(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_outlet inp_outlet_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outlet
    ADD CONSTRAINT inp_outlet_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_outlet inp_outlet_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outlet
    ADD CONSTRAINT inp_outlet_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pattern inp_pattern_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern
    ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pattern_value inp_pattern_pattern_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern_value
    ADD CONSTRAINT inp_pattern_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES inp_pattern(pattern_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_pump inp_pump_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_pump inp_pump_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_rdii inp_rdii_hydro_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_rdii
    ADD CONSTRAINT inp_rdii_hydro_id_fkey FOREIGN KEY (hydro_id) REFERENCES inp_hydrograph(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_rdii inp_rdii_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_rdii
    ADD CONSTRAINT inp_rdii_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: inp_snowpack_value inp_snowpack_snow_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_snowpack_value
    ADD CONSTRAINT inp_snowpack_snow_id_fkey FOREIGN KEY (snow_id) REFERENCES inp_snowpack(snow_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_storage inp_storage_curve_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_storage
    ADD CONSTRAINT inp_storage_curve_id_fkey FOREIGN KEY (curve_id) REFERENCES inp_curve(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_storage inp_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_storage
    ADD CONSTRAINT inp_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_timeseries inp_timeseries_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_timeseries
    ADD CONSTRAINT inp_timeseries_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_timeseries_value inp_timeseries_value_timser_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_timeseries_value
    ADD CONSTRAINT inp_timeseries_value_timser_id_fkey FOREIGN KEY (timser_id) REFERENCES inp_timeseries(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_transects_value inp_transects_value_tsect_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_transects_value
    ADD CONSTRAINT inp_transects_value_tsect_id_fkey FOREIGN KEY (tsect_id) REFERENCES inp_transects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_treatment inp_treatment_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_treatment
    ADD CONSTRAINT inp_treatment_node_id_fkey FOREIGN KEY (node_id) REFERENCES inp_treatment(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_treatment inp_treatment_node_x_pol_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_treatment
    ADD CONSTRAINT inp_treatment_node_x_pol_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_treatment inp_treatment_node_x_pol_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_treatment
    ADD CONSTRAINT inp_treatment_node_x_pol_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_dscenario_treatment inp_treatment_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_treatment
    ADD CONSTRAINT inp_treatment_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_washoff inp_washoff_land_x_pol_landus_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_washoff
    ADD CONSTRAINT inp_washoff_land_x_pol_landus_id_fkey FOREIGN KEY (landus_id) REFERENCES inp_landuses(landus_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_washoff inp_washoff_land_x_pol_poll_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_washoff
    ADD CONSTRAINT inp_washoff_land_x_pol_poll_id_fkey FOREIGN KEY (poll_id) REFERENCES inp_pollutant(poll_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_weir inp_weir_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_weir
    ADD CONSTRAINT inp_weir_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: man_chamber man_chamber_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_chamber
    ADD CONSTRAINT man_chamber_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_conduit man_conduit_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_conduit
    ADD CONSTRAINT man_conduit_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: man_netelement man_netelement_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netelement
    ADD CONSTRAINT man_netelement_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_netgully man_netgully_gratecat2_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netgully
    ADD CONSTRAINT man_netgully_gratecat2_id_fkey FOREIGN KEY (gratecat2_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_netgully man_netgully_gratecat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netgully
    ADD CONSTRAINT man_netgully_gratecat_id_fkey FOREIGN KEY (gratecat_id) REFERENCES cat_grate(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: man_netgully man_netgully_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netgully
    ADD CONSTRAINT man_netgully_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_netinit man_netinit_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netinit
    ADD CONSTRAINT man_netinit_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_outfall man_outfall_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_outfall
    ADD CONSTRAINT man_outfall_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_siphon man_siphon_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_siphon
    ADD CONSTRAINT man_siphon_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_storage man_storage_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_storage
    ADD CONSTRAINT man_storage_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: man_waccel man_waccel_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_waccel
    ADD CONSTRAINT man_waccel_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_wjump man_wjump_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wjump
    ADD CONSTRAINT man_wjump_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: man_wwtp man_wwtp_node_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wwtp
    ADD CONSTRAINT man_wwtp_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: node node_matcat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_matcat_id_fkey FOREIGN KEY (matcat_id) REFERENCES cat_mat_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_muni_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: node node_node_type_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_node_type_fkey FOREIGN KEY (node_type) REFERENCES cat_feature_node(id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: om_visit_x_gully om_visit_x_gully_gully_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_gully
    ADD CONSTRAINT om_visit_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: om_visit_x_gully om_visit_x_gully_visit_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_gully
    ADD CONSTRAINT om_visit_x_gully_visit_id_fkey FOREIGN KEY (visit_id) REFERENCES om_visit(id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: plan_psector_x_gully plan_psector_x_gully_arc_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully
    ADD CONSTRAINT plan_psector_x_gully_arc_id_fkey FOREIGN KEY (arc_id) REFERENCES arc(arc_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: plan_psector_x_gully plan_psector_x_gully_gully_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully
    ADD CONSTRAINT plan_psector_x_gully_gully_id_fkey FOREIGN KEY (gully_id) REFERENCES gully(gully_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_gully plan_psector_x_gully_link_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully
    ADD CONSTRAINT plan_psector_x_gully_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: plan_psector_x_gully plan_psector_x_gully_psector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully
    ADD CONSTRAINT plan_psector_x_gully_psector_id_fkey FOREIGN KEY (psector_id) REFERENCES plan_psector(psector_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: raingage raingage_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY raingage
    ADD CONSTRAINT raingage_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: raingage raingage_timser_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY raingage
    ADD CONSTRAINT raingage_timser_id_fkey FOREIGN KEY (timser_id) REFERENCES inp_timeseries(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ext_raster_dem raster_dem_rastercat_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_raster_dem
    ADD CONSTRAINT raster_dem_rastercat_id_fkey FOREIGN KEY (rastercat_id) REFERENCES ext_cat_raster(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rpt_arc rpt_arc_result_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arc
    ADD CONSTRAINT rpt_arc_result_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_arc rpt_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arc
    ADD CONSTRAINT rpt_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_arcflow_sum rpt_arcflow_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcflow_sum
    ADD CONSTRAINT rpt_arcflow_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_arcpolload_sum rpt_arcpolload_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcpolload_sum
    ADD CONSTRAINT rpt_arcpolload_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_arcpollutant_sum rpt_arcpollutant_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcpollutant_sum
    ADD CONSTRAINT rpt_arcpollutant_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_cat_result rpt_cat_result_expl_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_cat_result
    ADD CONSTRAINT rpt_cat_result_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: rpt_condsurcharge_sum rpt_condsurcharge_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_condsurcharge_sum
    ADD CONSTRAINT rpt_condsurcharge_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_continuity_errors rpt_continuity_errors_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_continuity_errors
    ADD CONSTRAINT rpt_continuity_errors_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_control_actions_taken rpt_control_actions_taken_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_control_actions_taken
    ADD CONSTRAINT rpt_control_actions_taken_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_critical_elements rpt_critical_elements_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_critical_elements
    ADD CONSTRAINT rpt_critical_elements_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_flowclass_sum rpt_flowclass_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_flowclass_sum
    ADD CONSTRAINT rpt_flowclass_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_flowrouting_cont rpt_flowrouting_cont_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_flowrouting_cont
    ADD CONSTRAINT rpt_flowrouting_cont_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_groundwater_cont rpt_groundwater_cont_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_groundwater_cont
    ADD CONSTRAINT rpt_groundwater_cont_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_high_conterrors rpt_high_conterrors_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_high_conterrors
    ADD CONSTRAINT rpt_high_conterrors_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_high_flowinest_ind rpt_high_flowinest_ind_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_high_flowinest_ind
    ADD CONSTRAINT rpt_high_flowinest_ind_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: rpt_instability_index rpt_instability_index_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_instability_index
    ADD CONSTRAINT rpt_instability_index_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_lidperformance_sum rpt_lidperformance_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_lidperformance_sum
    ADD CONSTRAINT rpt_lidperformance_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_node rpt_node_result_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_node
    ADD CONSTRAINT rpt_node_result_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_node rpt_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_node
    ADD CONSTRAINT rpt_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_nodedepth_sum rpt_nodedepth_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodedepth_sum
    ADD CONSTRAINT rpt_nodedepth_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_nodeflooding_sum rpt_nodeflooding_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodeflooding_sum
    ADD CONSTRAINT rpt_nodeflooding_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_nodeinflow_sum rpt_nodeinflow_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodeinflow_sum
    ADD CONSTRAINT rpt_nodeinflow_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_nodesurcharge_sum rpt_nodesurcharge_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodesurcharge_sum
    ADD CONSTRAINT rpt_nodesurcharge_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_outfallflow_sum rpt_outfallflow_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_outfallflow_sum
    ADD CONSTRAINT rpt_outfallflow_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_outfallload_sum rpt_outfallload_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_outfallload_sum
    ADD CONSTRAINT rpt_outfallload_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_pumping_sum rpt_pumping_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_pumping_sum
    ADD CONSTRAINT rpt_pumping_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_qualrouting_cont rpt_qualrouting_cont_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_qualrouting_cont
    ADD CONSTRAINT rpt_qualrouting_cont_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_rainfall_dep rpt_rainfall_dep_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_rainfall_dep
    ADD CONSTRAINT rpt_rainfall_dep_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_routing_timestep rpt_routing_timestep_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_routing_timestep
    ADD CONSTRAINT rpt_routing_timestep_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_runoff_qual rpt_runoff_qual_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_runoff_qual
    ADD CONSTRAINT rpt_runoff_qual_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_runoff_quant rpt_runoff_quant_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_runoff_quant
    ADD CONSTRAINT rpt_runoff_quant_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: rpt_storagevol_sum rpt_storagevol_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_storagevol_sum
    ADD CONSTRAINT rpt_storagevol_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_subcatchment rpt_subcatchment_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchment
    ADD CONSTRAINT rpt_subcatchment_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_subcatchment rpt_subcatchment_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchment
    ADD CONSTRAINT rpt_subcatchment_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_subcatchwashoff_sum rpt_subcatchwashoff_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchwashoff_sum
    ADD CONSTRAINT rpt_subcatchwashoff_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_subcatchrunoff_sum rpt_subcathrunoff_sum_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchrunoff_sum
    ADD CONSTRAINT rpt_subcathrunoff_sum_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_summary_arc rpt_summary_arc_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_arc
    ADD CONSTRAINT rpt_summary_arc_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_summary_crossection rpt_summary_crossection_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_crossection
    ADD CONSTRAINT rpt_summary_crossection_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_summary_node rpt_summary_node_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_node
    ADD CONSTRAINT rpt_summary_node_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_summary_subcatchment rpt_summary_subcatchment_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_subcatchment
    ADD CONSTRAINT rpt_summary_subcatchment_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rpt_timestep_critelem rpt_timestep_critelem_result_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_timestep_critelem
    ADD CONSTRAINT rpt_timestep_critelem_result_id_fkey FOREIGN KEY (result_id) REFERENCES rpt_cat_result(result_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: inp_subcatchment subcatchment_hydrology_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_subcatchment
    ADD CONSTRAINT subcatchment_hydrology_id_fkey FOREIGN KEY (hydrology_id) REFERENCES cat_hydrology(hydrology_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inp_subcatchment subcatchment_rg_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_subcatchment
    ADD CONSTRAINT subcatchment_rg_id_fkey FOREIGN KEY (rg_id) REFERENCES raingage(rg_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_subcatchment subcatchment_sector_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_subcatchment
    ADD CONSTRAINT subcatchment_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: inp_subcatchment subcatchment_snow_id_fkey; Type: FK CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_subcatchment
    ADD CONSTRAINT subcatchment_snow_id_fkey FOREIGN KEY (snow_id) REFERENCES inp_snowpack(snow_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
