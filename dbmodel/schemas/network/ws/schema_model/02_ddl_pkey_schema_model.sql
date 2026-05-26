/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--
-- Name: anl_arc anl_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_arc
    ADD CONSTRAINT anl_arc_pkey PRIMARY KEY (id);


--
-- Name: anl_arc_x_node anl_arc_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_arc_x_node
    ADD CONSTRAINT anl_arc_x_node_pkey PRIMARY KEY (id);


--
-- Name: anl_connec anl_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_connec
    ADD CONSTRAINT anl_connec_pkey PRIMARY KEY (id);


--
-- Name: anl_node anl_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_node
    ADD CONSTRAINT anl_node_pkey PRIMARY KEY (id);


--
-- Name: anl_polygon anl_polygon_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_polygon
    ADD CONSTRAINT anl_polygon_pkey PRIMARY KEY (id);


--
-- Name: arc_add arc_add_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc_add
    ADD CONSTRAINT arc_add_pkey PRIMARY KEY (arc_id);


--
-- Name: arc_border_expl arc_border_expl_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc_border_expl
    ADD CONSTRAINT arc_border_expl_pkey PRIMARY KEY (arc_id, expl_id);


--
-- Name: arc arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY arc
    ADD CONSTRAINT arc_pkey PRIMARY KEY (arc_id);


--
-- Name: audit_check_data audit_check_data_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_check_data
    ADD CONSTRAINT audit_check_data_pkey PRIMARY KEY (id);


--
-- Name: audit_check_project audit_check_project_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_check_project
    ADD CONSTRAINT audit_check_project_pkey PRIMARY KEY (id);


--
-- Name: audit_fid_log audit_fid_log_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_fid_log
    ADD CONSTRAINT audit_fid_log_pkey PRIMARY KEY (id);


--
-- Name: audit_arc_traceability audit_log_arc_traceability_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_arc_traceability
    ADD CONSTRAINT audit_log_arc_traceability_pkey PRIMARY KEY (id);


--
-- Name: audit_log_data audit_log_data_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_log_data
    ADD CONSTRAINT audit_log_data_pkey PRIMARY KEY (id);


--
-- Name: audit_psector_arc_traceability audit_psector_arc_traceability_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_arc_traceability
    ADD CONSTRAINT audit_psector_arc_traceability_pkey PRIMARY KEY (id);


--
-- Name: audit_psector_connec_traceability audit_psector_connec_traceability_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_connec_traceability
    ADD CONSTRAINT audit_psector_connec_traceability_pkey PRIMARY KEY (id);


--
-- Name: audit_psector_node_traceability audit_psector_node_traceability_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_node_traceability
    ADD CONSTRAINT audit_psector_node_traceability_pkey PRIMARY KEY (id);


--
-- Name: cat_arc cat_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc
    ADD CONSTRAINT cat_arc_pkey PRIMARY KEY (id);


--
-- Name: cat_arc_shape cat_arc_shape_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_arc_shape
    ADD CONSTRAINT cat_arc_shape_pkey PRIMARY KEY (id);


--
-- Name: cat_brand cat_brand_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_brand
    ADD CONSTRAINT cat_brand_pkey PRIMARY KEY (id);


--
-- Name: cat_brand_model cat_brand_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_brand_model
    ADD CONSTRAINT cat_brand_type_pkey PRIMARY KEY (id);


--
-- Name: cat_builder cat_builder_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_builder
    ADD CONSTRAINT cat_builder_pkey PRIMARY KEY (id);


--
-- Name: cat_connec cat_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_connec
    ADD CONSTRAINT cat_connec_pkey PRIMARY KEY (id);


--
-- Name: cat_dscenario cat_dscenario_name_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dscenario
    ADD CONSTRAINT cat_dscenario_name_unique UNIQUE (name);


--
-- Name: cat_dscenario cat_dscenario_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dscenario
    ADD CONSTRAINT cat_dscenario_pkey PRIMARY KEY (dscenario_id);


--
-- Name: cat_element cat_element_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_element
    ADD CONSTRAINT cat_element_pkey PRIMARY KEY (id);


--
-- Name: cat_feature_arc cat_feature_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_arc
    ADD CONSTRAINT cat_feature_arc_pkey PRIMARY KEY (id);


--
-- Name: cat_feature_connec cat_feature_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_connec
    ADD CONSTRAINT cat_feature_connec_pkey PRIMARY KEY (id);


--
-- Name: cat_feature_node cat_feature_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_node
    ADD CONSTRAINT cat_feature_node_pkey PRIMARY KEY (id);


--
-- Name: cat_feature cat_feature_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature
    ADD CONSTRAINT cat_feature_pkey PRIMARY KEY (id);


--
-- Name: cat_manager cat_manager_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_manager
    ADD CONSTRAINT cat_manager_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_arc cat_mat_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_arc
    ADD CONSTRAINT cat_mat_arc_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_element cat_mat_element_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_element
    ADD CONSTRAINT cat_mat_element_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_node cat_mat_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_node
    ADD CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_roughness cat_mat_roughness_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_roughness
    ADD CONSTRAINT cat_mat_roughness_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_roughness cat_mat_roughness_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_roughness
    ADD CONSTRAINT cat_mat_roughness_unique UNIQUE (matcat_id, init_age, end_age);


--
-- Name: cat_node cat_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_pkey PRIMARY KEY (id);


--
-- Name: cat_owner cat_owner_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_owner
    ADD CONSTRAINT cat_owner_pkey PRIMARY KEY (id);


--
-- Name: cat_pavement cat_pavement_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_pavement
    ADD CONSTRAINT cat_pavement_pkey PRIMARY KEY (id);


--
-- Name: presszone cat_presszone_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY presszone
    ADD CONSTRAINT cat_presszone_pkey PRIMARY KEY (presszone_id);


--
-- Name: ext_cat_raster cat_raster_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_raster
    ADD CONSTRAINT cat_raster_pkey PRIMARY KEY (id);


--
-- Name: cat_soil cat_soil_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_soil
    ADD CONSTRAINT cat_soil_pkey PRIMARY KEY (id);


--
-- Name: cat_users cat_users_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_users
    ADD CONSTRAINT cat_users_pkey PRIMARY KEY (id);


--
-- Name: cat_work cat_work_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_work
    ADD CONSTRAINT cat_work_pkey PRIMARY KEY (id);


--
-- Name: cat_workspace cat_workspace_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_workspace
    ADD CONSTRAINT cat_workspace_pkey PRIMARY KEY (id);


--
-- Name: cat_workspace cat_workspace_unique_name; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_workspace
    ADD CONSTRAINT cat_workspace_unique_name UNIQUE (name);


--
-- Name: config_csv config_csv_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_csv
    ADD CONSTRAINT config_csv_pkey PRIMARY KEY (fid);


--
-- Name: config_file config_file_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_file
    ADD CONSTRAINT config_file_pkey PRIMARY KEY (filetype, fextension);


--
-- Name: config_form_fields config_form_fields_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_form_fields
    ADD CONSTRAINT config_form_fields_pkey PRIMARY KEY (formname, formtype, columnname, tabname);


--
-- Name: config_form_list config_form_list_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_form_list
    ADD CONSTRAINT config_form_list_pkey PRIMARY KEY (listname, device);


--
-- Name: config_form_tableview config_form_tableview_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_form_tableview
    ADD CONSTRAINT config_form_tableview_pkey PRIMARY KEY (tablename, columnname);


--
-- Name: config_form_tabs config_form_tabs_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_form_tabs
    ADD CONSTRAINT config_form_tabs_pkey PRIMARY KEY (formname, tabname, device);


--
-- Name: config_fprocess config_fprocess_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_fprocess
    ADD CONSTRAINT config_fprocess_pkey PRIMARY KEY (fid, tablename, target);


--
-- Name: config_function config_function_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_function
    ADD CONSTRAINT config_function_pkey PRIMARY KEY (id);


--
-- Name: config_graph_inlet config_graph_inlet_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_graph_inlet
    ADD CONSTRAINT config_graph_inlet_pkey PRIMARY KEY (node_id, expl_id);


--
-- Name: config_info_layer config_info_layer_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_info_layer
    ADD CONSTRAINT config_info_layer_pkey PRIMARY KEY (layer_id);


--
-- Name: config_info_layer_x_type config_info_layer_x_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_info_layer_x_type
    ADD CONSTRAINT config_info_layer_x_type_pkey PRIMARY KEY (tableinfo_id, infotype_id);


--
-- Name: config_graph_checkvalve config_mincut_checkvalve_id_fkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_graph_checkvalve
    ADD CONSTRAINT config_mincut_checkvalve_id_fkey PRIMARY KEY (node_id);


--
-- Name: config_graph_valve config_mincut_valve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_graph_valve
    ADD CONSTRAINT config_mincut_valve_pkey PRIMARY KEY (id);


--
-- Name: config_param_system config_param_system_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_param_system
    ADD CONSTRAINT config_param_system_pkey PRIMARY KEY (parameter);


--
-- Name: config_param_user config_param_user_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_param_user
    ADD CONSTRAINT config_param_user_pkey PRIMARY KEY (parameter, cur_user);


--
-- Name: config_report config_report_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_report
    ADD CONSTRAINT config_report_pkey PRIMARY KEY (id);


--
-- Name: config_table config_table_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_table
    ADD CONSTRAINT config_table_pkey PRIMARY KEY (id);


--
-- Name: config_toolbox config_toolbox_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_toolbox
    ADD CONSTRAINT config_toolbox_pkey PRIMARY KEY (id);


--
-- Name: config_typevalue config_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_typevalue
    ADD CONSTRAINT config_typevalue_pkey PRIMARY KEY (typevalue, id);


--
-- Name: config_user_x_expl config_user_x_expl_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_expl
    ADD CONSTRAINT config_user_x_expl_pkey PRIMARY KEY (expl_id, username);


--
-- Name: config_user_x_sector config_user_x_sector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_user_x_sector
    ADD CONSTRAINT config_user_x_sector_pkey PRIMARY KEY (sector_id, username);


--
-- Name: config_visit_class config_visit_class_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class
    ADD CONSTRAINT config_visit_class_pkey PRIMARY KEY (id);


--
-- Name: config_visit_class_x_feature config_visit_class_x_feature_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class_x_feature
    ADD CONSTRAINT config_visit_class_x_feature_pkey PRIMARY KEY (visitclass_id, tablename);


--
-- Name: config_visit_class_x_parameter config_visit_class_x_parameter_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_class_x_parameter
    ADD CONSTRAINT config_visit_class_x_parameter_pkey PRIMARY KEY (parameter_id, class_id);


--
-- Name: config_visit_parameter_action config_visit_parameter_action_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_parameter_action
    ADD CONSTRAINT config_visit_parameter_action_pkey PRIMARY KEY (parameter_id1, parameter_id2, action_type);


--
-- Name: config_visit_parameter config_visit_parameter_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY config_visit_parameter
    ADD CONSTRAINT config_visit_parameter_pkey PRIMARY KEY (id);


--
-- Name: connec_add connec_add_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec_add
    ADD CONSTRAINT connec_add_pkey PRIMARY KEY (connec_id);


--
-- Name: connec connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY connec
    ADD CONSTRAINT connec_pkey PRIMARY KEY (connec_id);


--
-- Name: crm_typevalue crm_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY crm_typevalue
    ADD CONSTRAINT crm_typevalue_pkey PRIMARY KEY (typevalue, id);


--
-- Name: crm_zone crm_zone_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY crm_zone
    ADD CONSTRAINT crm_zone_pkey PRIMARY KEY (id);


--
-- Name: dimensions dimensions_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dimensions
    ADD CONSTRAINT dimensions_pkey PRIMARY KEY (id);


--
-- Name: ext_district district_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_district
    ADD CONSTRAINT district_pkey PRIMARY KEY (district_id);


--
-- Name: dma dma_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dma
    ADD CONSTRAINT dma_pkey PRIMARY KEY (dma_id);


--
-- Name: doc doc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc
    ADD CONSTRAINT doc_pkey PRIMARY KEY (id);


--
-- Name: doc_type doc_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_type
    ADD CONSTRAINT doc_type_pkey PRIMARY KEY (id);


--
-- Name: doc_x_arc doc_x_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_arc
    ADD CONSTRAINT doc_x_arc_pkey PRIMARY KEY (id);


--
-- Name: doc_x_connec doc_x_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_connec
    ADD CONSTRAINT doc_x_connec_pkey PRIMARY KEY (id);


--
-- Name: doc_x_node doc_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_node
    ADD CONSTRAINT doc_x_node_pkey PRIMARY KEY (id);


--
-- Name: doc_x_psector doc_x_psector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_psector
    ADD CONSTRAINT doc_x_psector_pkey PRIMARY KEY (id);


--
-- Name: doc_x_visit doc_x_visit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_visit
    ADD CONSTRAINT doc_x_visit_pkey PRIMARY KEY (id);


--
-- Name: doc_x_workcat doc_x_workcat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_workcat
    ADD CONSTRAINT doc_x_workcat_pkey PRIMARY KEY (id);


--
-- Name: dqa dqa_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY dqa
    ADD CONSTRAINT dqa_pkey PRIMARY KEY (dqa_id);


--
-- Name: element element_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element
    ADD CONSTRAINT element_pkey PRIMARY KEY (element_id);


--
-- Name: element_type element_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_type
    ADD CONSTRAINT element_type_pkey PRIMARY KEY (id);


--
-- Name: element_x_arc element_x_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_arc
    ADD CONSTRAINT element_x_arc_pkey PRIMARY KEY (id);


--
-- Name: element_x_arc element_x_arc_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_arc
    ADD CONSTRAINT element_x_arc_unique UNIQUE (element_id, arc_id);


--
-- Name: element_x_connec element_x_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_connec
    ADD CONSTRAINT element_x_connec_pkey PRIMARY KEY (id);


--
-- Name: element_x_connec element_x_connec_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_connec
    ADD CONSTRAINT element_x_connec_unique UNIQUE (element_id, connec_id);


--
-- Name: element_x_node element_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_node
    ADD CONSTRAINT element_x_node_pkey PRIMARY KEY (id);


--
-- Name: element_x_node element_x_node_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_node
    ADD CONSTRAINT element_x_node_unique UNIQUE (element_id, node_id);


--
-- Name: exploitation exploitation_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY exploitation
    ADD CONSTRAINT exploitation_pkey PRIMARY KEY (expl_id);


--
-- Name: ext_address ext_address_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_address
    ADD CONSTRAINT ext_address_pkey PRIMARY KEY (id);


--
-- Name: ext_arc ext_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_arc
    ADD CONSTRAINT ext_arc_pkey PRIMARY KEY (id);


--
-- Name: ext_cat_hydrometer ext_cat_hydrometer_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_hydrometer
    ADD CONSTRAINT ext_cat_hydrometer_pkey PRIMARY KEY (id);


--
-- Name: ext_cat_hydrometer_priority ext_cat_hydrometer_priority_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_hydrometer_priority
    ADD CONSTRAINT ext_cat_hydrometer_priority_pkey PRIMARY KEY (id);


--
-- Name: ext_cat_hydrometer_type ext_cat_hydrometer_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_hydrometer_type
    ADD CONSTRAINT ext_cat_hydrometer_type_pkey PRIMARY KEY (id);


--
-- Name: ext_cat_period ext_cat_period_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_period
    ADD CONSTRAINT ext_cat_period_pkey PRIMARY KEY (id);


--
-- Name: ext_cat_period_type ext_cat_period_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_cat_period_type
    ADD CONSTRAINT ext_cat_period_type_pkey PRIMARY KEY (id);


--
-- Name: ext_hydrometer_category ext_hydrometer_category_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_hydrometer_category
    ADD CONSTRAINT ext_hydrometer_category_pkey PRIMARY KEY (id);


--
-- Name: ext_municipality ext_municipality_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_municipality
    ADD CONSTRAINT ext_municipality_pkey PRIMARY KEY (muni_id);


--
-- Name: ext_node ext_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_node
    ADD CONSTRAINT ext_node_pkey PRIMARY KEY (id);


--
-- Name: ext_plot ext_plot_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_plot
    ADD CONSTRAINT ext_plot_pkey PRIMARY KEY (id);


--
-- Name: ext_rtc_hydrometer ext_rtc_hydrometer_id_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer
    ADD CONSTRAINT ext_rtc_hydrometer_id_pkey PRIMARY KEY (id);


--
-- Name: ext_rtc_hydrometer_state ext_rtc_hydrometer_state_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer_state
    ADD CONSTRAINT ext_rtc_hydrometer_state_pkey PRIMARY KEY (id);


--
-- Name: ext_rtc_hydrometer_x_data ext_rtc_hydrometer_x_data_hydrometer_id_cat_period_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer_x_data
    ADD CONSTRAINT ext_rtc_hydrometer_x_data_hydrometer_id_cat_period_id_unique UNIQUE (hydrometer_id, cat_period_id);


--
-- Name: ext_rtc_hydrometer_x_data ext_rtc_hydrometer_x_data_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer_x_data
    ADD CONSTRAINT ext_rtc_hydrometer_x_data_pkey PRIMARY KEY (id);


--
-- Name: ext_rtc_dma_period ext_rtc_scada_dma_period_dma_id_cat_period_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_dma_period
    ADD CONSTRAINT ext_rtc_scada_dma_period_dma_id_cat_period_id_unique UNIQUE (dma_id, cat_period_id);


--
-- Name: ext_rtc_dma_period ext_rtc_scada_dma_period_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_dma_period
    ADD CONSTRAINT ext_rtc_scada_dma_period_pkey PRIMARY KEY (id);


--
-- Name: ext_rtc_scada ext_rtc_scada_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_scada
    ADD CONSTRAINT ext_rtc_scada_pkey PRIMARY KEY (scada_id);


--
-- Name: ext_rtc_scada ext_rtc_scada_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_scada
    ADD CONSTRAINT ext_rtc_scada_unique UNIQUE (source, source_id);


--
-- Name: ext_rtc_scada_x_data ext_rtc_scada_x_data_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_scada_x_data
    ADD CONSTRAINT ext_rtc_scada_x_data_pkey PRIMARY KEY (node_id, value_date);


--
-- Name: ext_streetaxis ext_streetaxis_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_streetaxis
    ADD CONSTRAINT ext_streetaxis_pkey PRIMARY KEY (id);


--
-- Name: ext_streetaxis ext_streetaxis_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_streetaxis
    ADD CONSTRAINT ext_streetaxis_unique UNIQUE (muni_id, id);


--
-- Name: ext_timeseries ext_timeseries_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_timeseries
    ADD CONSTRAINT ext_timeseries_pkey PRIMARY KEY (id);


--
-- Name: ext_type_street ext_type_street_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_type_street
    ADD CONSTRAINT ext_type_street_pkey PRIMARY KEY (id);


--
-- Name: inp_backdrop inp_backdrop_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_backdrop
    ADD CONSTRAINT inp_backdrop_pkey PRIMARY KEY (id);


--
-- Name: inp_connec inp_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_connec
    ADD CONSTRAINT inp_connec_pkey PRIMARY KEY (connec_id);


--
-- Name: inp_controls inp_controls_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_controls
    ADD CONSTRAINT inp_controls_pkey PRIMARY KEY (id);


--
-- Name: inp_curve inp_curve_id_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_curve
    ADD CONSTRAINT inp_curve_id_pkey PRIMARY KEY (id);


--
-- Name: inp_curve_value inp_curve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_curve_value
    ADD CONSTRAINT inp_curve_pkey PRIMARY KEY (id);


--
-- Name: inp_dscenario_connec inp_dscenario_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_connec
    ADD CONSTRAINT inp_dscenario_connec_pkey PRIMARY KEY (dscenario_id, connec_id);


--
-- Name: inp_dscenario_controls inp_dscenario_controls_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_controls
    ADD CONSTRAINT inp_dscenario_controls_pkey PRIMARY KEY (id);


--
-- Name: inp_dscenario_demand inp_dscenario_demand_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_demand
    ADD CONSTRAINT inp_dscenario_demand_pkey PRIMARY KEY (id);


--
-- Name: inp_dscenario_inlet inp_dscenario_inlet_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inlet
    ADD CONSTRAINT inp_dscenario_inlet_pkey PRIMARY KEY (node_id, dscenario_id);


--
-- Name: inp_dscenario_junction inp_dscenario_junction_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_junction
    ADD CONSTRAINT inp_dscenario_junction_pkey PRIMARY KEY (dscenario_id, node_id);


--
-- Name: inp_dscenario_pipe inp_dscenario_pipe_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pipe
    ADD CONSTRAINT inp_dscenario_pipe_pkey PRIMARY KEY (arc_id, dscenario_id);


--
-- Name: inp_dscenario_pump_additional inp_dscenario_pump_additional_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional
    ADD CONSTRAINT inp_dscenario_pump_additional_pkey PRIMARY KEY (id);


--
-- Name: inp_dscenario_pump_additional inp_dscenario_pump_additional_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump_additional
    ADD CONSTRAINT inp_dscenario_pump_additional_unique UNIQUE (dscenario_id, node_id, order_id);


--
-- Name: inp_dscenario_pump inp_dscenario_pump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_pump
    ADD CONSTRAINT inp_dscenario_pump_pkey PRIMARY KEY (node_id, dscenario_id);


--
-- Name: inp_dscenario_reservoir inp_dscenario_reservoir_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_reservoir
    ADD CONSTRAINT inp_dscenario_reservoir_pkey PRIMARY KEY (node_id, dscenario_id);


--
-- Name: inp_dscenario_rules inp_dscenario_rules_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_rules
    ADD CONSTRAINT inp_dscenario_rules_pkey PRIMARY KEY (id);


--
-- Name: inp_dscenario_shortpipe inp_dscenario_shortpipe_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_shortpipe
    ADD CONSTRAINT inp_dscenario_shortpipe_pkey PRIMARY KEY (node_id, dscenario_id);


--
-- Name: inp_dscenario_tank inp_dscenario_tank_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_tank
    ADD CONSTRAINT inp_dscenario_tank_pkey PRIMARY KEY (node_id, dscenario_id);


--
-- Name: inp_dscenario_valve inp_dscenario_valve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_valve
    ADD CONSTRAINT inp_dscenario_valve_pkey PRIMARY KEY (node_id, dscenario_id);


--
-- Name: inp_dscenario_virtualvalve inp_dscenario_virtualvalve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_virtualvalve
    ADD CONSTRAINT inp_dscenario_virtualvalve_pkey PRIMARY KEY (dscenario_id, arc_id);


--
-- Name: inp_emitter inp_emitter_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_emitter
    ADD CONSTRAINT inp_emitter_pkey PRIMARY KEY (node_id);


--
-- Name: inp_energy inp_energy_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_energy
    ADD CONSTRAINT inp_energy_pkey PRIMARY KEY (id);


--
-- Name: inp_inlet inp_inlet_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inlet
    ADD CONSTRAINT inp_inlet_pkey PRIMARY KEY (node_id);


--
-- Name: inp_junction inp_junction_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_junction
    ADD CONSTRAINT inp_junction_pkey PRIMARY KEY (node_id);


--
-- Name: inp_label inp_label_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_label
    ADD CONSTRAINT inp_label_pkey PRIMARY KEY (id);


--
-- Name: inp_mixing inp_mixing_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_mixing
    ADD CONSTRAINT inp_mixing_pkey PRIMARY KEY (node_id);


--
-- Name: inp_pattern inp_pattern_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern
    ADD CONSTRAINT inp_pattern_pkey PRIMARY KEY (pattern_id);


--
-- Name: inp_pattern_value inp_pattern_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern_value
    ADD CONSTRAINT inp_pattern_value_pkey PRIMARY KEY (id);


--
-- Name: inp_pipe inp_pipe_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pipe
    ADD CONSTRAINT inp_pipe_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_project_id inp_project_id_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_project_id
    ADD CONSTRAINT inp_project_id_pkey PRIMARY KEY (title);


--
-- Name: inp_pump_additional inp_pump_additional_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_additional
    ADD CONSTRAINT inp_pump_additional_pkey PRIMARY KEY (id);


--
-- Name: inp_pump_additional inp_pump_additional_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_additional
    ADD CONSTRAINT inp_pump_additional_unique UNIQUE (node_id, order_id);


--
-- Name: inp_pump_importinp inp_pump_importinp_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump_importinp
    ADD CONSTRAINT inp_pump_importinp_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_pump inp_pump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_pkey PRIMARY KEY (node_id);


--
-- Name: inp_quality inp_quality_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_quality
    ADD CONSTRAINT inp_quality_pkey PRIMARY KEY (node_id);


--
-- Name: inp_reactions inp_reactions_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_reactions
    ADD CONSTRAINT inp_reactions_pkey PRIMARY KEY (id);


--
-- Name: inp_reservoir inp_reservoir_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_reservoir
    ADD CONSTRAINT inp_reservoir_pkey PRIMARY KEY (node_id);


--
-- Name: inp_rules inp_rules_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_rules
    ADD CONSTRAINT inp_rules_pkey PRIMARY KEY (id);


--
-- Name: inp_shortpipe inp_shortpipe_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_shortpipe
    ADD CONSTRAINT inp_shortpipe_pkey PRIMARY KEY (node_id);


--
-- Name: inp_source inp_source_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_source
    ADD CONSTRAINT inp_source_pkey PRIMARY KEY (node_id);


--
-- Name: inp_tags inp_tags_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_tags
    ADD CONSTRAINT inp_tags_pkey PRIMARY KEY (feature_type, feature_id);


--
-- Name: inp_tank inp_tank_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_tank
    ADD CONSTRAINT inp_tank_pkey PRIMARY KEY (node_id);


--
-- Name: inp_times inp_times_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_times
    ADD CONSTRAINT inp_times_pkey PRIMARY KEY (id);


--
-- Name: inp_typevalue inp_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_typevalue
    ADD CONSTRAINT inp_typevalue_pkey PRIMARY KEY (typevalue, id);


--
-- Name: inp_value_yesnofull inp_value_yesnofull_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_value_yesnofull
    ADD CONSTRAINT inp_value_yesnofull_pkey PRIMARY KEY (id);


--
-- Name: inp_valve_importinp inp_valve_importinp_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve_importinp
    ADD CONSTRAINT inp_valve_importinp_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_valve inp_valve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_valve
    ADD CONSTRAINT inp_valve_pkey PRIMARY KEY (node_id);


--
-- Name: inp_virtualvalve inp_virtualvalve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_virtualvalve
    ADD CONSTRAINT inp_virtualvalve_pkey PRIMARY KEY (arc_id);


--
-- Name: link link_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY link
    ADD CONSTRAINT link_pkey PRIMARY KEY (link_id);


--
-- Name: macrodma macrodma_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodma
    ADD CONSTRAINT macrodma_pkey PRIMARY KEY (macrodma_id);


--
-- Name: macrodqa macrodqa_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrodqa
    ADD CONSTRAINT macrodqa_pkey PRIMARY KEY (macrodqa_id);


--
-- Name: macroexploitation macroexploitation_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macroexploitation
    ADD CONSTRAINT macroexploitation_pkey PRIMARY KEY (macroexpl_id);


--
-- Name: macrosector macrosector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY macrosector
    ADD CONSTRAINT macrosector_pkey PRIMARY KEY (macrosector_id);


--
-- Name: man_addfields_value man_addfields_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_addfields_value
    ADD CONSTRAINT man_addfields_value_pkey PRIMARY KEY (id);


--
-- Name: man_addfields_value man_addfields_value_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_addfields_value
    ADD CONSTRAINT man_addfields_value_unique UNIQUE (feature_id, parameter_id);


--
-- Name: man_expansiontank man_expansiontank_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_expansiontank
    ADD CONSTRAINT man_expansiontank_pkey PRIMARY KEY (node_id);


--
-- Name: man_filter man_filter_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_filter
    ADD CONSTRAINT man_filter_pkey PRIMARY KEY (node_id);


--
-- Name: man_flexunion man_flexunion_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_flexunion
    ADD CONSTRAINT man_flexunion_pkey PRIMARY KEY (node_id);


--
-- Name: man_fountain man_fountain_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_fountain
    ADD CONSTRAINT man_fountain_pkey PRIMARY KEY (connec_id);


--
-- Name: man_greentap man_greentap_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_greentap
    ADD CONSTRAINT man_greentap_pkey PRIMARY KEY (connec_id);


--
-- Name: man_hydrant man_hydrant_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_hydrant
    ADD CONSTRAINT man_hydrant_pkey PRIMARY KEY (node_id);


--
-- Name: man_junction man_junction_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_junction
    ADD CONSTRAINT man_junction_pkey PRIMARY KEY (node_id);


--
-- Name: man_manhole man_manhole_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_manhole
    ADD CONSTRAINT man_manhole_pkey PRIMARY KEY (node_id);


--
-- Name: man_meter man_meter_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_meter
    ADD CONSTRAINT man_meter_pkey PRIMARY KEY (node_id);


--
-- Name: man_netelement man_netelement_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netelement
    ADD CONSTRAINT man_netelement_pkey PRIMARY KEY (node_id);


--
-- Name: man_netsamplepoint man_netsamplepoint_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netsamplepoint
    ADD CONSTRAINT man_netsamplepoint_pkey PRIMARY KEY (node_id);


--
-- Name: man_netwjoin man_netwjoin_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netwjoin
    ADD CONSTRAINT man_netwjoin_pkey PRIMARY KEY (node_id);


--
-- Name: man_pipe man_pipe_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_pipe
    ADD CONSTRAINT man_pipe_pkey PRIMARY KEY (arc_id);


--
-- Name: pond man_pond_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pond
    ADD CONSTRAINT man_pond_pkey PRIMARY KEY (pond_id);


--
-- Name: pool man_pool_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY pool
    ADD CONSTRAINT man_pool_pkey PRIMARY KEY (pool_id);


--
-- Name: man_pump man_pump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_pump
    ADD CONSTRAINT man_pump_pkey PRIMARY KEY (node_id);


--
-- Name: man_reduction man_reduction_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_reduction
    ADD CONSTRAINT man_reduction_pkey PRIMARY KEY (node_id);


--
-- Name: man_register man_register_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_register
    ADD CONSTRAINT man_register_pkey PRIMARY KEY (node_id);


--
-- Name: samplepoint man_samplepoint_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT man_samplepoint_pkey PRIMARY KEY (sample_id);


--
-- Name: man_source man_source_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_source
    ADD CONSTRAINT man_source_pkey PRIMARY KEY (node_id);


--
-- Name: man_tank man_tank_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_tank
    ADD CONSTRAINT man_tank_pkey PRIMARY KEY (node_id);


--
-- Name: man_tap man_tap_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_tap
    ADD CONSTRAINT man_tap_pkey PRIMARY KEY (connec_id);


--
-- Name: man_type_category man_type_category_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_category
    ADD CONSTRAINT man_type_category_pkey PRIMARY KEY (id);


--
-- Name: man_type_category man_type_category_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_category
    ADD CONSTRAINT man_type_category_unique UNIQUE (category_type, feature_type);


--
-- Name: man_type_fluid man_type_fluid_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_fluid
    ADD CONSTRAINT man_type_fluid_pkey PRIMARY KEY (id);


--
-- Name: man_type_fluid man_type_fluid_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_fluid
    ADD CONSTRAINT man_type_fluid_unique UNIQUE (fluid_type, feature_type);


--
-- Name: man_type_function man_type_function_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_function
    ADD CONSTRAINT man_type_function_pkey PRIMARY KEY (id);


--
-- Name: man_type_function man_type_function_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_function
    ADD CONSTRAINT man_type_function_unique UNIQUE (function_type, feature_type);


--
-- Name: man_type_location man_type_location_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_location
    ADD CONSTRAINT man_type_location_pkey PRIMARY KEY (id);


--
-- Name: man_type_location man_type_location_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_type_location
    ADD CONSTRAINT man_type_location_unique UNIQUE (location_type, feature_type);


--
-- Name: man_valve man_valve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_valve
    ADD CONSTRAINT man_valve_pkey PRIMARY KEY (node_id);


--
-- Name: man_varc man_varc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_varc
    ADD CONSTRAINT man_varc_pkey PRIMARY KEY (arc_id);


--
-- Name: man_waterwell man_waterwell_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_waterwell
    ADD CONSTRAINT man_waterwell_pkey PRIMARY KEY (node_id);


--
-- Name: man_wjoin man_wjoin_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wjoin
    ADD CONSTRAINT man_wjoin_pkey PRIMARY KEY (connec_id);


--
-- Name: man_wtp man_wtp_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wtp
    ADD CONSTRAINT man_wtp_pkey PRIMARY KEY (node_id);


--
-- Name: minsector_graph minsector_graph_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector_graph
    ADD CONSTRAINT minsector_graph_pkey PRIMARY KEY (node_id);


--
-- Name: minsector minsector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY minsector
    ADD CONSTRAINT minsector_pkey PRIMARY KEY (minsector_id);


--
-- Name: node_add node_add_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node_add
    ADD CONSTRAINT node_add_pkey PRIMARY KEY (node_id);


--
-- Name: node_border_sector node_border_sector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node_border_sector
    ADD CONSTRAINT node_border_sector_pkey PRIMARY KEY (node_id, sector_id);


--
-- Name: node node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY node
    ADD CONSTRAINT node_pkey PRIMARY KEY (node_id);


--
-- Name: om_mincut_arc om_mincut_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_arc
    ADD CONSTRAINT om_mincut_arc_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_arc om_mincut_arc_unique_result_arc; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_arc
    ADD CONSTRAINT om_mincut_arc_unique_result_arc UNIQUE (result_id, arc_id);


--
-- Name: om_mincut_cat_type om_mincut_cat_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_cat_type
    ADD CONSTRAINT om_mincut_cat_type_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_connec om_mincut_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_connec
    ADD CONSTRAINT om_mincut_connec_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_connec om_mincut_connec_unique_result_connec; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_connec
    ADD CONSTRAINT om_mincut_connec_unique_result_connec UNIQUE (result_id, connec_id);


--
-- Name: om_mincut_hydrometer om_mincut_hydrometer_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_hydrometer
    ADD CONSTRAINT om_mincut_hydrometer_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_hydrometer om_mincut_hydrometer_unique_result_hydrometer; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_hydrometer
    ADD CONSTRAINT om_mincut_hydrometer_unique_result_hydrometer UNIQUE (result_id, hydrometer_id);


--
-- Name: om_mincut_node om_mincut_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_node
    ADD CONSTRAINT om_mincut_node_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_node om_mincut_node_unique_result_node; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_node
    ADD CONSTRAINT om_mincut_node_unique_result_node UNIQUE (result_id, node_id);


--
-- Name: om_mincut om_mincut_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut
    ADD CONSTRAINT om_mincut_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_polygon om_mincut_polygon_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_polygon
    ADD CONSTRAINT om_mincut_polygon_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_valve om_mincut_valve_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve
    ADD CONSTRAINT om_mincut_valve_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_valve_unaccess om_mincut_valve_unaccess_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve_unaccess
    ADD CONSTRAINT om_mincut_valve_unaccess_pkey PRIMARY KEY (id);


--
-- Name: om_mincut_valve om_mincut_valve_unique_result_node; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_mincut_valve
    ADD CONSTRAINT om_mincut_valve_unique_result_node UNIQUE (result_id, node_id);


--
-- Name: om_profile om_profile_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_profile
    ADD CONSTRAINT om_profile_pkey PRIMARY KEY (profile_id);


--
-- Name: om_streetaxis om_streetaxis_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_streetaxis
    ADD CONSTRAINT om_streetaxis_pkey PRIMARY KEY (id);


--
-- Name: om_streetaxis om_streetaxis_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_streetaxis
    ADD CONSTRAINT om_streetaxis_unique UNIQUE (muni_id, id);


--
-- Name: om_typevalue om_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_typevalue
    ADD CONSTRAINT om_typevalue_pkey PRIMARY KEY (typevalue, id);


--
-- Name: om_visit_cat om_visit_cat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_cat
    ADD CONSTRAINT om_visit_cat_pkey PRIMARY KEY (id);


--
-- Name: om_visit_event_photo om_visit_event_photo_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event_photo
    ADD CONSTRAINT om_visit_event_photo_pkey PRIMARY KEY (id);


--
-- Name: om_visit_event om_visit_event_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_event
    ADD CONSTRAINT om_visit_event_pkey PRIMARY KEY (id);


--
-- Name: om_visit om_visit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit
    ADD CONSTRAINT om_visit_pkey PRIMARY KEY (id);


--
-- Name: om_visit_x_arc om_visit_x_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_arc
    ADD CONSTRAINT om_visit_x_arc_pkey PRIMARY KEY (id);


--
-- Name: om_visit_x_arc om_visit_x_arc_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_arc
    ADD CONSTRAINT om_visit_x_arc_unique UNIQUE (arc_id, visit_id);


--
-- Name: om_visit_x_connec om_visit_x_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_connec
    ADD CONSTRAINT om_visit_x_connec_pkey PRIMARY KEY (id);


--
-- Name: om_visit_x_connec om_visit_x_connec_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_connec
    ADD CONSTRAINT om_visit_x_connec_unique UNIQUE (connec_id, visit_id);


--
-- Name: om_visit_x_node om_visit_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_node
    ADD CONSTRAINT om_visit_x_node_pkey PRIMARY KEY (id);


--
-- Name: om_visit_x_node om_visit_x_node_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_node
    ADD CONSTRAINT om_visit_x_node_unique UNIQUE (node_id, visit_id);


--
-- Name: om_waterbalance om_waterbalance_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_waterbalance
    ADD CONSTRAINT om_waterbalance_pkey PRIMARY KEY (dma_id, cat_period_id);


--
-- Name: plan_arc_x_pavement plan_arc_x_pavement_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_arc_x_pavement
    ADD CONSTRAINT plan_arc_x_pavement_pkey PRIMARY KEY (id);


--
-- Name: plan_price_cat plan_price_cat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price_cat
    ADD CONSTRAINT plan_price_cat_pkey PRIMARY KEY (id);


--
-- Name: plan_price_compost plan_price_compost_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price_compost
    ADD CONSTRAINT plan_price_compost_pkey PRIMARY KEY (id);


--
-- Name: plan_price plan_price_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_price
    ADD CONSTRAINT plan_price_pkey PRIMARY KEY (id);


--
-- Name: plan_psector plan_psector_name_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector
    ADD CONSTRAINT plan_psector_name_unique UNIQUE (name, expl_id);


--
-- Name: plan_psector plan_psector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector
    ADD CONSTRAINT plan_psector_pkey PRIMARY KEY (psector_id);


--
-- Name: selector_plan_psector plan_psector_selector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_plan_psector
    ADD CONSTRAINT plan_psector_selector_pkey PRIMARY KEY (psector_id, cur_user);


--
-- Name: plan_psector_x_arc plan_psector_x_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_arc
    ADD CONSTRAINT plan_psector_x_arc_pkey PRIMARY KEY (id);


--
-- Name: plan_psector_x_arc plan_psector_x_arc_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_arc
    ADD CONSTRAINT plan_psector_x_arc_unique UNIQUE (arc_id, psector_id);


--
-- Name: plan_psector_x_connec plan_psector_x_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec
    ADD CONSTRAINT plan_psector_x_connec_pkey PRIMARY KEY (id);


--
-- Name: plan_psector_x_connec plan_psector_x_connec_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_connec
    ADD CONSTRAINT plan_psector_x_connec_unique UNIQUE (connec_id, psector_id, state);


--
-- Name: plan_psector_x_node plan_psector_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_node
    ADD CONSTRAINT plan_psector_x_node_pkey PRIMARY KEY (id);


--
-- Name: plan_psector_x_node plan_psector_x_node_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_node
    ADD CONSTRAINT plan_psector_x_node_unique UNIQUE (node_id, psector_id);


--
-- Name: plan_psector_x_other plan_psector_x_other_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_other
    ADD CONSTRAINT plan_psector_x_other_pkey PRIMARY KEY (id);


--
-- Name: plan_rec_result_arc plan_rec_result_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_rec_result_arc
    ADD CONSTRAINT plan_rec_result_arc_pkey PRIMARY KEY (arc_id, result_id);


--
-- Name: plan_rec_result_node plan_rec_result_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_rec_result_node
    ADD CONSTRAINT plan_rec_result_node_pkey PRIMARY KEY (node_id, result_id);


--
-- Name: plan_reh_result_arc plan_reh_result_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_reh_result_arc
    ADD CONSTRAINT plan_reh_result_arc_pkey PRIMARY KEY (arc_id, result_id);


--
-- Name: plan_reh_result_node plan_reh_result_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_reh_result_node
    ADD CONSTRAINT plan_reh_result_node_pkey PRIMARY KEY (node_id, result_id);


--
-- Name: plan_result_cat plan_result_cat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_result_cat
    ADD CONSTRAINT plan_result_cat_pkey PRIMARY KEY (result_id);


--
-- Name: plan_result_cat plan_result_cat_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_result_cat
    ADD CONSTRAINT plan_result_cat_unique UNIQUE (name);


--
-- Name: plan_typevalue plan_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_typevalue
    ADD CONSTRAINT plan_typevalue_pkey PRIMARY KEY (typevalue, id);


--
-- Name: polygon polygon_feature_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY polygon
    ADD CONSTRAINT polygon_feature_id_unique UNIQUE (feature_id);


--
-- Name: polygon polygon_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY polygon
    ADD CONSTRAINT polygon_pkey PRIMARY KEY (pol_id);


--
-- Name: ext_raster_dem raster_dem_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_raster_dem
    ADD CONSTRAINT raster_dem_pkey PRIMARY KEY (id);


--
-- Name: review_arc review_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_arc
    ADD CONSTRAINT review_arc_pkey PRIMARY KEY (arc_id);


--
-- Name: review_audit_arc review_audit_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_arc
    ADD CONSTRAINT review_audit_arc_pkey PRIMARY KEY (id);


--
-- Name: review_audit_connec review_audit_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_connec
    ADD CONSTRAINT review_audit_connec_pkey PRIMARY KEY (id);


--
-- Name: review_audit_node review_audit_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_node
    ADD CONSTRAINT review_audit_node_pkey PRIMARY KEY (id);


--
-- Name: review_connec review_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_connec
    ADD CONSTRAINT review_connec_pkey PRIMARY KEY (connec_id);


--
-- Name: review_node review_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_node
    ADD CONSTRAINT review_node_pkey PRIMARY KEY (node_id);


--
-- Name: rpt_arc rpt_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arc
    ADD CONSTRAINT rpt_arc_pkey PRIMARY KEY (id);


--
-- Name: rpt_cat_result rpt_cat_result_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_cat_result
    ADD CONSTRAINT rpt_cat_result_pkey PRIMARY KEY (result_id);


--
-- Name: rpt_energy_usage rpt_energy_usage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_energy_usage
    ADD CONSTRAINT rpt_energy_usage_pkey PRIMARY KEY (id);


--
-- Name: rpt_hydraulic_status rpt_hydraulic_status_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_hydraulic_status
    ADD CONSTRAINT rpt_hydraulic_status_pkey PRIMARY KEY (id);


--
-- Name: rpt_inp_arc rpt_inp_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_arc
    ADD CONSTRAINT rpt_inp_arc_pkey PRIMARY KEY (id);


--
-- Name: rpt_inp_node rpt_inp_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_node
    ADD CONSTRAINT rpt_inp_node_pkey PRIMARY KEY (id);


--
-- Name: rpt_inp_pattern_value rpt_inp_pattern_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_pattern_value
    ADD CONSTRAINT rpt_inp_pattern_value_pkey PRIMARY KEY (id);


--
-- Name: rpt_node rpt_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_node
    ADD CONSTRAINT rpt_node_pkey PRIMARY KEY (id);


--
-- Name: rtc_hydrometer rtc_hydrometer_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_hydrometer
    ADD CONSTRAINT rtc_hydrometer_pkey PRIMARY KEY (hydrometer_id);


--
-- Name: rtc_hydrometer_x_connec rtc_hydrometer_x_connec_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_hydrometer_x_connec
    ADD CONSTRAINT rtc_hydrometer_x_connec_pkey PRIMARY KEY (hydrometer_id);


--
-- Name: om_waterbalance_dma_graph rtc_scada_x_dma_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_waterbalance_dma_graph
    ADD CONSTRAINT rtc_scada_x_dma_pkey PRIMARY KEY (node_id, dma_id);


--
-- Name: sector sector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sector
    ADD CONSTRAINT sector_pkey PRIMARY KEY (sector_id);


--
-- Name: selector_audit selector_audit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_audit
    ADD CONSTRAINT selector_audit_pkey PRIMARY KEY (fid, cur_user);


--
-- Name: selector_date selector_date_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_date
    ADD CONSTRAINT selector_date_pkey PRIMARY KEY (context, cur_user);


--
-- Name: selector_expl selector_expl_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_expl
    ADD CONSTRAINT selector_expl_pkey PRIMARY KEY (expl_id, cur_user);


--
-- Name: selector_hydrometer selector_hydrometer_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_hydrometer
    ADD CONSTRAINT selector_hydrometer_pkey PRIMARY KEY (state_id, cur_user);


--
-- Name: selector_inp_dscenario selector_inp_demand_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_inp_dscenario
    ADD CONSTRAINT selector_inp_demand_pkey PRIMARY KEY (dscenario_id, cur_user);


--
-- Name: selector_inp_result selector_inp_result_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_inp_result
    ADD CONSTRAINT selector_inp_result_pkey PRIMARY KEY (result_id, cur_user);


--
-- Name: selector_mincut_result selector_mincut_result_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_mincut_result
    ADD CONSTRAINT selector_mincut_result_pkey PRIMARY KEY (result_id, cur_user);


--
-- Name: selector_plan_result selector_plan_result_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_plan_result
    ADD CONSTRAINT selector_plan_result_pkey PRIMARY KEY (result_id, cur_user);


--
-- Name: selector_psector selector_psector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_psector
    ADD CONSTRAINT selector_psector_pkey PRIMARY KEY (psector_id, cur_user);


--
-- Name: selector_rpt_compare selector_rpt_compare_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_compare
    ADD CONSTRAINT selector_rpt_compare_pkey PRIMARY KEY (result_id, cur_user);


--
-- Name: selector_rpt_compare_tstep selector_rpt_compare_tstep_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_compare_tstep
    ADD CONSTRAINT selector_rpt_compare_tstep_pkey PRIMARY KEY (timestep, cur_user);


--
-- Name: selector_rpt_main selector_rpt_main_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_main
    ADD CONSTRAINT selector_rpt_main_pkey PRIMARY KEY (result_id, cur_user);


--
-- Name: selector_rpt_main_tstep selector_rpt_main_tstep_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_main_tstep
    ADD CONSTRAINT selector_rpt_main_tstep_pkey PRIMARY KEY (timestep, cur_user);


--
-- Name: selector_sector selector_sector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_sector
    ADD CONSTRAINT selector_sector_pkey PRIMARY KEY (sector_id, cur_user);


--
-- Name: selector_state selector_state_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_state
    ADD CONSTRAINT selector_state_pkey PRIMARY KEY (state_id, cur_user);


--
-- Name: selector_workcat selector_workcat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_workcat
    ADD CONSTRAINT selector_workcat_pkey PRIMARY KEY (workcat_id, cur_user);


--
-- Name: sys_addfields sys_addfields_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_addfields
    ADD CONSTRAINT sys_addfields_pkey PRIMARY KEY (id);


--
-- Name: sys_addfields sys_addfields_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_addfields
    ADD CONSTRAINT sys_addfields_unique UNIQUE (param_name, cat_feature_id);


--
-- Name: sys_feature_cat sys_feature_cat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_feature_cat
    ADD CONSTRAINT sys_feature_cat_pkey PRIMARY KEY (id);


--
-- Name: sys_feature_cat sys_feature_cat_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_feature_cat
    ADD CONSTRAINT sys_feature_cat_unique UNIQUE (id, type);


--
-- Name: sys_feature_epa_type sys_feature_inp_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_feature_epa_type
    ADD CONSTRAINT sys_feature_inp_pkey PRIMARY KEY (id, feature_type);


--
-- Name: sys_feature_type sys_feature_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_feature_type
    ADD CONSTRAINT sys_feature_type_pkey PRIMARY KEY (id);


--
-- Name: sys_foreignkey sys_foreingkey_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_foreignkey
    ADD CONSTRAINT sys_foreingkey_pkey PRIMARY KEY (id);


--
-- Name: sys_foreignkey sys_foreingkey_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_foreignkey
    ADD CONSTRAINT sys_foreingkey_unique UNIQUE (typevalue_table, typevalue_name, target_table, target_field, parameter_id);


--
-- Name: sys_fprocess sys_fprocess_cat_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_fprocess
    ADD CONSTRAINT sys_fprocess_cat_pkey PRIMARY KEY (fid);


--
-- Name: sys_function sys_function_function_name_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_function
    ADD CONSTRAINT sys_function_function_name_unique UNIQUE (function_name, project_type);


--
-- Name: sys_function sys_function_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_function
    ADD CONSTRAINT sys_function_pkey PRIMARY KEY (id);


--
-- Name: sys_image sys_image_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_image
    ADD CONSTRAINT sys_image_pkey PRIMARY KEY (id);


--
-- Name: sys_message sys_message_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_message
    ADD CONSTRAINT sys_message_pkey PRIMARY KEY (id);


--
-- Name: sys_param_user sys_param_user_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_param_user
    ADD CONSTRAINT sys_param_user_pkey PRIMARY KEY (id);


--
-- Name: sys_role sys_role_context_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_role
    ADD CONSTRAINT sys_role_context_unique UNIQUE (context);


--
-- Name: sys_role sys_role_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_role
    ADD CONSTRAINT sys_role_pkey PRIMARY KEY (id);


--
-- Name: sys_style sys_style_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_style
    ADD CONSTRAINT sys_style_pkey PRIMARY KEY (id);


--
-- Name: sys_table sys_table_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_table
    ADD CONSTRAINT sys_table_pkey PRIMARY KEY (id);


--
-- Name: sys_typevalue sys_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_typevalue
    ADD CONSTRAINT sys_typevalue_pkey PRIMARY KEY (typevalue_table, typevalue_name);


--
-- Name: sys_version sys_version_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY sys_version
    ADD CONSTRAINT sys_version_pkey PRIMARY KEY (id);


--
-- Name: temp_anlgraph temp_anlgraph_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_anlgraph
    ADD CONSTRAINT temp_anlgraph_pkey PRIMARY KEY (id);


--
-- Name: temp_anlgraph temp_anlgraph_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_anlgraph
    ADD CONSTRAINT temp_anlgraph_unique UNIQUE (arc_id, node_1);


--
-- Name: temp_arc temp_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_arc
    ADD CONSTRAINT temp_arc_pkey PRIMARY KEY (id);


--
-- Name: temp_csv temp_csv_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_csv
    ADD CONSTRAINT temp_csv_pkey PRIMARY KEY (id);


--
-- Name: temp_data temp_data_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_data
    ADD CONSTRAINT temp_data_pkey PRIMARY KEY (id);


--
-- Name: temp_demand temp_demand_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_demand
    ADD CONSTRAINT temp_demand_pkey PRIMARY KEY (id);


--
-- Name: temp_link temp_link_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_link
    ADD CONSTRAINT temp_link_pkey PRIMARY KEY (link_id);


--
-- Name: temp_link_x_arc temp_link_x_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_link_x_arc
    ADD CONSTRAINT temp_link_x_arc_pkey PRIMARY KEY (link_id);


--
-- Name: temp_mincut temp_mincut_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_mincut
    ADD CONSTRAINT temp_mincut_pkey PRIMARY KEY (id);


--
-- Name: temp_node temp_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node
    ADD CONSTRAINT temp_node_pkey PRIMARY KEY (id);


--
-- Name: temp_table temp_table_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_table
    ADD CONSTRAINT temp_table_pkey PRIMARY KEY (id);


--
-- Name: temp_vnode temp_vnode_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_vnode
    ADD CONSTRAINT temp_vnode_pkey PRIMARY KEY (id);


--
-- Name: selector_rpt_main_tstep time_cur_user_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_main_tstep
    ADD CONSTRAINT time_cur_user_unique UNIQUE (timestep, cur_user);


--
-- Name: value_state value_state_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY value_state
    ADD CONSTRAINT value_state_pkey PRIMARY KEY (id);


--
-- Name: value_state_type value_state_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY value_state_type
    ADD CONSTRAINT value_state_type_pkey PRIMARY KEY (id);


--
-- Name: edit_typevalue value_type_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY edit_typevalue
    ADD CONSTRAINT value_type_pkey PRIMARY KEY (typevalue, id);
