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
-- Name: anl_gully anl_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY anl_gully
    ADD CONSTRAINT anl_gully_pkey PRIMARY KEY (id);


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
-- Name: audit_psector_gully_traceability audit_psector_gully_traceability_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY audit_psector_gully_traceability
    ADD CONSTRAINT audit_psector_gully_traceability_pkey PRIMARY KEY (id);


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
-- Name: cat_dwf_scenario cat_dwf_scenario_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_dwf_scenario
    ADD CONSTRAINT cat_dwf_scenario_pkey PRIMARY KEY (id);


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
-- Name: cat_feature_gully cat_feature_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_feature_gully
    ADD CONSTRAINT cat_feature_gully_pkey PRIMARY KEY (id);


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
-- Name: cat_grate cat_grate_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_grate
    ADD CONSTRAINT cat_grate_pkey PRIMARY KEY (id);


--
-- Name: cat_hydrology cat_hydrology_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_hydrology
    ADD CONSTRAINT cat_hydrology_pkey PRIMARY KEY (hydrology_id);


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
-- Name: cat_mat_grate cat_mat_grate_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_grate
    ADD CONSTRAINT cat_mat_grate_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_gully cat_mat_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_gully
    ADD CONSTRAINT cat_mat_gully_pkey PRIMARY KEY (id);


--
-- Name: cat_mat_node cat_mat_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_mat_node
    ADD CONSTRAINT cat_mat_node_pkey PRIMARY KEY (id);


--
-- Name: cat_node cat_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node
    ADD CONSTRAINT cat_node_pkey PRIMARY KEY (id);


--
-- Name: cat_node_shape cat_node_shape_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY cat_node_shape
    ADD CONSTRAINT cat_node_shape_pkey PRIMARY KEY (id);


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
-- Name: doc_x_gully doc_x_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY doc_x_gully
    ADD CONSTRAINT doc_x_gully_pkey PRIMARY KEY (id);


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
-- Name: drainzone drainzone_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY drainzone
    ADD CONSTRAINT drainzone_pkey PRIMARY KEY (drainzone_id);


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
-- Name: element_x_gully element_x_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_gully
    ADD CONSTRAINT element_x_gully_pkey PRIMARY KEY (id);


--
-- Name: element_x_gully element_x_gully_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY element_x_gully
    ADD CONSTRAINT element_x_gully_unique UNIQUE (element_id, gully_id);


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
-- Name: ext_hydrometer_category_x_pattern ext_hydrometer_category_x_pattern_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_hydrometer_category_x_pattern
    ADD CONSTRAINT ext_hydrometer_category_x_pattern_pkey PRIMARY KEY (category_id);


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
-- Name: ext_rtc_hydrometer_x_data ext_rtc_hydrometer_x_data_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_hydrometer_x_data
    ADD CONSTRAINT ext_rtc_hydrometer_x_data_pkey PRIMARY KEY (id);


--
-- Name: ext_rtc_dma_period ext_rtc_scada_dma_period_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY ext_rtc_dma_period
    ADD CONSTRAINT ext_rtc_scada_dma_period_pkey PRIMARY KEY (id);


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
-- Name: gully gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY gully
    ADD CONSTRAINT gully_pkey PRIMARY KEY (gully_id);


--
-- Name: inp_adjustments inp_adjustments_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_adjustments
    ADD CONSTRAINT inp_adjustments_pkey PRIMARY KEY (id);


--
-- Name: inp_aquifer inp_aquifer_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_aquifer
    ADD CONSTRAINT inp_aquifer_pkey PRIMARY KEY (aquif_id);


--
-- Name: inp_backdrop inp_backdrop_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_backdrop
    ADD CONSTRAINT inp_backdrop_pkey PRIMARY KEY (id);


--
-- Name: inp_buildup inp_buildup_land_x_pol_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_buildup
    ADD CONSTRAINT inp_buildup_land_x_pol_pkey PRIMARY KEY (landus_id, poll_id);


--
-- Name: inp_conduit inp_conduit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_conduit
    ADD CONSTRAINT inp_conduit_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_controls inp_controls_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_controls
    ADD CONSTRAINT inp_controls_pkey PRIMARY KEY (id);


--
-- Name: inp_coverage inp_coverage_land_x_subc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_coverage
    ADD CONSTRAINT inp_coverage_land_x_subc_pkey PRIMARY KEY (subc_id, landus_id, hydrology_id);


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
-- Name: inp_divider inp_divider_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_divider
    ADD CONSTRAINT inp_divider_pkey PRIMARY KEY (node_id);


--
-- Name: inp_dscenario_conduit inp_dscenario_conduit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_conduit
    ADD CONSTRAINT inp_dscenario_conduit_pkey PRIMARY KEY (dscenario_id, arc_id);


--
-- Name: inp_dscenario_controls inp_dscenario_controls_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_controls
    ADD CONSTRAINT inp_dscenario_controls_pkey PRIMARY KEY (id);


--
-- Name: inp_dscenario_flwreg_orifice inp_dscenario_flwreg_orifice_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_orifice
    ADD CONSTRAINT inp_dscenario_flwreg_orifice_pkey PRIMARY KEY (dscenario_id, nodarc_id);


--
-- Name: inp_dscenario_flwreg_outlet inp_dscenario_flwreg_outlet_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_outlet
    ADD CONSTRAINT inp_dscenario_flwreg_outlet_pkey PRIMARY KEY (dscenario_id, nodarc_id);


--
-- Name: inp_dscenario_flwreg_pump inp_dscenario_flwreg_pump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_pump
    ADD CONSTRAINT inp_dscenario_flwreg_pump_pkey PRIMARY KEY (dscenario_id, nodarc_id);


--
-- Name: inp_dscenario_flwreg_weir inp_dscenario_flwreg_weir_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_flwreg_weir
    ADD CONSTRAINT inp_dscenario_flwreg_weir_pkey PRIMARY KEY (dscenario_id, nodarc_id);


--
-- Name: inp_dscenario_inflows inp_dscenario_inflows_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows
    ADD CONSTRAINT inp_dscenario_inflows_pkey PRIMARY KEY (dscenario_id, node_id, order_id);


--
-- Name: inp_dscenario_inflows_poll inp_dscenario_inflows_pol_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_inflows_poll
    ADD CONSTRAINT inp_dscenario_inflows_pol_pkey PRIMARY KEY (dscenario_id, node_id, poll_id);


--
-- Name: inp_dscenario_junction inp_dscenario_junction_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_junction
    ADD CONSTRAINT inp_dscenario_junction_pkey PRIMARY KEY (dscenario_id, node_id);


--
-- Name: inp_dscenario_lid_usage inp_dscenario_lid_usage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_lid_usage
    ADD CONSTRAINT inp_dscenario_lid_usage_pkey PRIMARY KEY (dscenario_id, subc_id, lidco_id);


--
-- Name: inp_dscenario_outfall inp_dscenario_outfall_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_outfall
    ADD CONSTRAINT inp_dscenario_outfall_pkey PRIMARY KEY (dscenario_id, node_id);


--
-- Name: inp_dscenario_raingage inp_dscenario_raingage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_raingage
    ADD CONSTRAINT inp_dscenario_raingage_pkey PRIMARY KEY (dscenario_id, rg_id);


--
-- Name: inp_dscenario_storage inp_dscenario_storage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_storage
    ADD CONSTRAINT inp_dscenario_storage_pkey PRIMARY KEY (dscenario_id, node_id);


--
-- Name: inp_dwf inp_dwf_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf
    ADD CONSTRAINT inp_dwf_pkey PRIMARY KEY (node_id, dwfscenario_id);


--
-- Name: inp_dwf_pol_x_node inp_dwf_pol_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dwf_pol_x_node
    ADD CONSTRAINT inp_dwf_pol_x_node_pkey PRIMARY KEY (poll_id, node_id, dwfscenario_id);


--
-- Name: inp_evaporation inp_evaporation_pkey1; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_evaporation
    ADD CONSTRAINT inp_evaporation_pkey1 PRIMARY KEY (evap_type);


--
-- Name: inp_files inp_files_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_files
    ADD CONSTRAINT inp_files_pkey PRIMARY KEY (id);


--
-- Name: inp_flwreg_orifice inp_flwreg_orifice_nodarc_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_orifice
    ADD CONSTRAINT inp_flwreg_orifice_nodarc_id_unique UNIQUE (nodarc_id);


--
-- Name: inp_flwreg_orifice inp_flwreg_orifice_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_orifice
    ADD CONSTRAINT inp_flwreg_orifice_pkey PRIMARY KEY (id);


--
-- Name: inp_flwreg_pump inp_flwreg_orifice_pump_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_pump
    ADD CONSTRAINT inp_flwreg_orifice_pump_id_unique UNIQUE (nodarc_id);


--
-- Name: inp_flwreg_outlet inp_flwreg_outlet_nodarc_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_outlet
    ADD CONSTRAINT inp_flwreg_outlet_nodarc_id_unique UNIQUE (nodarc_id);


--
-- Name: inp_flwreg_outlet inp_flwreg_outlet_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_outlet
    ADD CONSTRAINT inp_flwreg_outlet_pkey PRIMARY KEY (id);


--
-- Name: inp_flwreg_pump inp_flwreg_pump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_pump
    ADD CONSTRAINT inp_flwreg_pump_pkey PRIMARY KEY (id);


--
-- Name: inp_flwreg_weir inp_flwreg_weir_nodarc_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_weir
    ADD CONSTRAINT inp_flwreg_weir_nodarc_id_unique UNIQUE (nodarc_id);


--
-- Name: inp_flwreg_weir inp_flwreg_weir_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_flwreg_weir
    ADD CONSTRAINT inp_flwreg_weir_pkey PRIMARY KEY (id);


--
-- Name: inp_groundwater inp_groundwater_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_groundwater
    ADD CONSTRAINT inp_groundwater_pkey PRIMARY KEY (subc_id, hydrology_id);


--
-- Name: inp_gully inp_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_gully
    ADD CONSTRAINT inp_gully_pkey PRIMARY KEY (gully_id);


--
-- Name: inp_hydrograph inp_hydrograph_id_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_hydrograph
    ADD CONSTRAINT inp_hydrograph_id_pkey PRIMARY KEY (id);


--
-- Name: inp_hydrograph_value inp_hydrograph_pkey1; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_hydrograph_value
    ADD CONSTRAINT inp_hydrograph_pkey1 PRIMARY KEY (id);


--
-- Name: inp_inflows inp_inflows_pkey2; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows
    ADD CONSTRAINT inp_inflows_pkey2 PRIMARY KEY (order_id);


--
-- Name: inp_inflows_poll inp_inflows_pol_x_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_inflows_poll
    ADD CONSTRAINT inp_inflows_pol_x_node_pkey PRIMARY KEY (poll_id, node_id);


--
-- Name: inp_junction inp_junction_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_junction
    ADD CONSTRAINT inp_junction_pkey PRIMARY KEY (node_id);


--
-- Name: inp_label inp_label_pkey1; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_label
    ADD CONSTRAINT inp_label_pkey1 PRIMARY KEY (label);


--
-- Name: inp_landuses inp_landuses_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_landuses
    ADD CONSTRAINT inp_landuses_pkey PRIMARY KEY (landus_id);


--
-- Name: inp_lid inp_lid_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_lid
    ADD CONSTRAINT inp_lid_pkey PRIMARY KEY (lidco_id);


--
-- Name: inp_lid_value inp_lid_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_lid_value
    ADD CONSTRAINT inp_lid_value_pkey PRIMARY KEY (id);


--
-- Name: inp_loadings inp_loadings_pol_x_subc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_loadings
    ADD CONSTRAINT inp_loadings_pol_x_subc_pkey PRIMARY KEY (subc_id, poll_id, hydrology_id);


--
-- Name: inp_mapdim inp_mapdim_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_mapdim
    ADD CONSTRAINT inp_mapdim_pkey PRIMARY KEY (type_dim);


--
-- Name: inp_mapunits inp_mapunits_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_mapunits
    ADD CONSTRAINT inp_mapunits_pkey PRIMARY KEY (type_units);


--
-- Name: inp_netgully inp_netgully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_netgully
    ADD CONSTRAINT inp_netgully_pkey PRIMARY KEY (node_id);


--
-- Name: inp_orifice inp_orifice_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_orifice
    ADD CONSTRAINT inp_orifice_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_outfall inp_outfall_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outfall
    ADD CONSTRAINT inp_outfall_pkey PRIMARY KEY (node_id);


--
-- Name: inp_outlet inp_outlet_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_outlet
    ADD CONSTRAINT inp_outlet_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_pattern inp_pattern_pkey1; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern
    ADD CONSTRAINT inp_pattern_pkey1 PRIMARY KEY (pattern_id);


--
-- Name: inp_pattern_value inp_pattern_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pattern_value
    ADD CONSTRAINT inp_pattern_value_pkey PRIMARY KEY (pattern_id);


--
-- Name: inp_pollutant inp_pollutant_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pollutant
    ADD CONSTRAINT inp_pollutant_pkey PRIMARY KEY (poll_id);


--
-- Name: inp_project_id inp_project_id_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_project_id
    ADD CONSTRAINT inp_project_id_pkey PRIMARY KEY (title);


--
-- Name: inp_pump inp_pump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_pump
    ADD CONSTRAINT inp_pump_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_rdii inp_rdii_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_rdii
    ADD CONSTRAINT inp_rdii_pkey PRIMARY KEY (node_id);


--
-- Name: inp_snowmelt inp_snowmelt_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_snowmelt
    ADD CONSTRAINT inp_snowmelt_pkey PRIMARY KEY (stemp);


--
-- Name: inp_snowpack inp_snowpack_id_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_snowpack
    ADD CONSTRAINT inp_snowpack_id_pkey PRIMARY KEY (snow_id);


--
-- Name: inp_snowpack_value inp_snowpack_pkey1; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_snowpack_value
    ADD CONSTRAINT inp_snowpack_pkey1 PRIMARY KEY (id);


--
-- Name: inp_storage inp_storage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_storage
    ADD CONSTRAINT inp_storage_pkey PRIMARY KEY (node_id);


--
-- Name: inp_temperature inp_temperature_pkey1; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_temperature
    ADD CONSTRAINT inp_temperature_pkey1 PRIMARY KEY (id);


--
-- Name: inp_timeseries inp_timeseries_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_timeseries
    ADD CONSTRAINT inp_timeseries_pkey PRIMARY KEY (id);


--
-- Name: inp_timeseries_value inp_timeseries_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_timeseries_value
    ADD CONSTRAINT inp_timeseries_value_pkey PRIMARY KEY (id);


--
-- Name: inp_transects inp_transects_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_transects
    ADD CONSTRAINT inp_transects_pkey PRIMARY KEY (id);


--
-- Name: inp_transects_value inp_transects_value_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_transects_value
    ADD CONSTRAINT inp_transects_value_pkey PRIMARY KEY (id);


--
-- Name: inp_treatment inp_treatment_node_x_pol_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_treatment
    ADD CONSTRAINT inp_treatment_node_x_pol_pkey PRIMARY KEY (node_id);


--
-- Name: inp_dscenario_treatment inp_treatment_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_dscenario_treatment
    ADD CONSTRAINT inp_treatment_pkey PRIMARY KEY (dscenario_id, node_id, poll_id);


--
-- Name: inp_typevalue inp_typevalue_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_typevalue
    ADD CONSTRAINT inp_typevalue_pkey PRIMARY KEY (typevalue, id);


--
-- Name: inp_virtual inp_virtual_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_virtual
    ADD CONSTRAINT inp_virtual_pkey PRIMARY KEY (arc_id);


--
-- Name: inp_washoff inp_washoff_land_x_pol_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_washoff
    ADD CONSTRAINT inp_washoff_land_x_pol_pkey PRIMARY KEY (landus_id, poll_id);


--
-- Name: inp_weir inp_weir_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_weir
    ADD CONSTRAINT inp_weir_pkey PRIMARY KEY (arc_id);


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
-- Name: man_chamber man_chamber_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_chamber
    ADD CONSTRAINT man_chamber_pkey PRIMARY KEY (node_id);


--
-- Name: man_conduit man_conduit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_conduit
    ADD CONSTRAINT man_conduit_pkey PRIMARY KEY (arc_id);


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
-- Name: man_netelement man_netelement_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netelement
    ADD CONSTRAINT man_netelement_pkey PRIMARY KEY (node_id);


--
-- Name: man_netgully man_netgully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netgully
    ADD CONSTRAINT man_netgully_pkey PRIMARY KEY (node_id);


--
-- Name: man_netinit man_netinit_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_netinit
    ADD CONSTRAINT man_netinit_pkey PRIMARY KEY (node_id);


--
-- Name: man_outfall man_outfall_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_outfall
    ADD CONSTRAINT man_outfall_pkey PRIMARY KEY (node_id);


--
-- Name: samplepoint man_samplepoint_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY samplepoint
    ADD CONSTRAINT man_samplepoint_pkey PRIMARY KEY (sample_id);


--
-- Name: man_siphon man_siphon_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_siphon
    ADD CONSTRAINT man_siphon_pkey PRIMARY KEY (arc_id);


--
-- Name: man_storage man_storage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_storage
    ADD CONSTRAINT man_storage_pkey PRIMARY KEY (node_id);


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
-- Name: man_waccel man_waccel_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_waccel
    ADD CONSTRAINT man_waccel_pkey PRIMARY KEY (arc_id);


--
-- Name: man_wjump man_wjump_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wjump
    ADD CONSTRAINT man_wjump_pkey PRIMARY KEY (node_id);


--
-- Name: man_wwtp man_wwtp_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY man_wwtp
    ADD CONSTRAINT man_wwtp_pkey PRIMARY KEY (node_id);


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
-- Name: om_profile om_profile_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_profile
    ADD CONSTRAINT om_profile_pkey PRIMARY KEY (profile_id);


--
-- Name: om_reh_cat_works om_reh_cat_works_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_reh_cat_works
    ADD CONSTRAINT om_reh_cat_works_pkey PRIMARY KEY (id);


--
-- Name: om_reh_parameter_x_works om_reh_parameter_x_works_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_reh_parameter_x_works
    ADD CONSTRAINT om_reh_parameter_x_works_pkey PRIMARY KEY (id);


--
-- Name: om_reh_value_loc_condition om_reh_value_loc_condition_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_reh_value_loc_condition
    ADD CONSTRAINT om_reh_value_loc_condition_pkey PRIMARY KEY (id);


--
-- Name: om_reh_works_x_pcompost om_reh_works_x_pcompost_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_reh_works_x_pcompost
    ADD CONSTRAINT om_reh_works_x_pcompost_pkey PRIMARY KEY (id);


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
-- Name: om_visit_x_gully om_visit_x_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_gully
    ADD CONSTRAINT om_visit_x_gully_pkey PRIMARY KEY (id);


--
-- Name: om_visit_x_gully om_visit_x_gully_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY om_visit_x_gully
    ADD CONSTRAINT om_visit_x_gully_unique UNIQUE (gully_id, visit_id);


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
-- Name: plan_psector_x_gully plan_psector_x_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully
    ADD CONSTRAINT plan_psector_x_gully_pkey PRIMARY KEY (id);


--
-- Name: plan_psector_x_gully plan_psector_x_gully_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY plan_psector_x_gully
    ADD CONSTRAINT plan_psector_x_gully_unique UNIQUE (gully_id, psector_id, state);


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
-- Name: raingage raingage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY raingage
    ADD CONSTRAINT raingage_pkey PRIMARY KEY (rg_id);


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
-- Name: review_audit_gully review_audit_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_audit_gully
    ADD CONSTRAINT review_audit_gully_pkey PRIMARY KEY (id);


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
-- Name: review_gully review_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY review_gully
    ADD CONSTRAINT review_gully_pkey PRIMARY KEY (gully_id);


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
-- Name: rpt_arcflow_sum rpt_arcflow_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcflow_sum
    ADD CONSTRAINT rpt_arcflow_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_arcpolload_sum rpt_arcpolload_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcpolload_sum
    ADD CONSTRAINT rpt_arcpolload_pkey PRIMARY KEY (id);


--
-- Name: rpt_arcpollutant_sum rpt_arcpollutant_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_arcpollutant_sum
    ADD CONSTRAINT rpt_arcpollutant_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_cat_result rpt_cat_result_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_cat_result
    ADD CONSTRAINT rpt_cat_result_pkey PRIMARY KEY (result_id);


--
-- Name: rpt_condsurcharge_sum rpt_condsurcharge_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_condsurcharge_sum
    ADD CONSTRAINT rpt_condsurcharge_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_continuity_errors rpt_continuity_errors_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_continuity_errors
    ADD CONSTRAINT rpt_continuity_errors_pkey PRIMARY KEY (id);


--
-- Name: rpt_control_actions_taken rpt_control_actions_taken_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_control_actions_taken
    ADD CONSTRAINT rpt_control_actions_taken_pkey PRIMARY KEY (id);


--
-- Name: rpt_critical_elements rpt_critical_elements_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_critical_elements
    ADD CONSTRAINT rpt_critical_elements_pkey PRIMARY KEY (id);


--
-- Name: rpt_flowclass_sum rpt_flowclass_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_flowclass_sum
    ADD CONSTRAINT rpt_flowclass_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_flowrouting_cont rpt_flowrouting_cont_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_flowrouting_cont
    ADD CONSTRAINT rpt_flowrouting_cont_pkey PRIMARY KEY (result_id);


--
-- Name: rpt_groundwater_cont rpt_groundwater_cont_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_groundwater_cont
    ADD CONSTRAINT rpt_groundwater_cont_pkey PRIMARY KEY (id);


--
-- Name: rpt_high_conterrors rpt_high_conterrors_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_high_conterrors
    ADD CONSTRAINT rpt_high_conterrors_pkey PRIMARY KEY (id);


--
-- Name: rpt_high_flowinest_ind rpt_high_flowinest_ind_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_high_flowinest_ind
    ADD CONSTRAINT rpt_high_flowinest_ind_pkey PRIMARY KEY (id);


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
-- Name: rpt_inp_raingage rpt_inp_raingage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_inp_raingage
    ADD CONSTRAINT rpt_inp_raingage_pkey PRIMARY KEY (result_id, rg_id);


--
-- Name: rpt_instability_index rpt_instability_index_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_instability_index
    ADD CONSTRAINT rpt_instability_index_pkey PRIMARY KEY (id);


--
-- Name: rpt_lidperformance_sum rpt_lidperformance_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_lidperformance_sum
    ADD CONSTRAINT rpt_lidperformance_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_node rpt_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_node
    ADD CONSTRAINT rpt_node_pkey PRIMARY KEY (id);


--
-- Name: rpt_nodedepth_sum rpt_nodedepth_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodedepth_sum
    ADD CONSTRAINT rpt_nodedepth_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_nodeflooding_sum rpt_nodeflooding_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodeflooding_sum
    ADD CONSTRAINT rpt_nodeflooding_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_nodeinflow_sum rpt_nodeinflow_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodeinflow_sum
    ADD CONSTRAINT rpt_nodeinflow_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_nodesurcharge_sum rpt_nodesurcharge_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_nodesurcharge_sum
    ADD CONSTRAINT rpt_nodesurcharge_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_outfallflow_sum rpt_outfallflow_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_outfallflow_sum
    ADD CONSTRAINT rpt_outfallflow_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_outfallload_sum rpt_outfallload_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_outfallload_sum
    ADD CONSTRAINT rpt_outfallload_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_pumping_sum rpt_pumping_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_pumping_sum
    ADD CONSTRAINT rpt_pumping_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_qualrouting_cont rpt_qualrouting_cont_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_qualrouting_cont
    ADD CONSTRAINT rpt_qualrouting_cont_pkey PRIMARY KEY (id);


--
-- Name: rpt_rainfall_dep rpt_rainfall_dep_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_rainfall_dep
    ADD CONSTRAINT rpt_rainfall_dep_pkey PRIMARY KEY (id);


--
-- Name: rpt_routing_timestep rpt_routing_timestep_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_routing_timestep
    ADD CONSTRAINT rpt_routing_timestep_pkey PRIMARY KEY (id);


--
-- Name: rpt_runoff_qual rpt_runoff_qual_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_runoff_qual
    ADD CONSTRAINT rpt_runoff_qual_pkey PRIMARY KEY (id);


--
-- Name: rpt_runoff_quant rpt_runoff_quant_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_runoff_quant
    ADD CONSTRAINT rpt_runoff_quant_pkey PRIMARY KEY (id);


--
-- Name: rpt_storagevol_sum rpt_storagevol_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_storagevol_sum
    ADD CONSTRAINT rpt_storagevol_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_subcatchment rpt_subcatchment_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchment
    ADD CONSTRAINT rpt_subcatchment_pkey PRIMARY KEY (id);


--
-- Name: rpt_subcatchwashoff_sum rpt_subcatchwashoff_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchwashoff_sum
    ADD CONSTRAINT rpt_subcatchwashoff_sum_pkey PRIMARY KEY (result_id, subc_id, poll_id);


--
-- Name: rpt_subcatchrunoff_sum rpt_subcathrunoff_sum_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_subcatchrunoff_sum
    ADD CONSTRAINT rpt_subcathrunoff_sum_pkey PRIMARY KEY (id);


--
-- Name: rpt_summary_arc rpt_summary_arc_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_arc
    ADD CONSTRAINT rpt_summary_arc_pkey PRIMARY KEY (id);


--
-- Name: rpt_summary_crossection rpt_summary_crossection_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_crossection
    ADD CONSTRAINT rpt_summary_crossection_pkey PRIMARY KEY (id);


--
-- Name: rpt_summary_node rpt_summary_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_node
    ADD CONSTRAINT rpt_summary_node_pkey PRIMARY KEY (id);


--
-- Name: rpt_summary_raingage rpt_summary_raingage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_raingage
    ADD CONSTRAINT rpt_summary_raingage_pkey PRIMARY KEY (id);


--
-- Name: rpt_summary_subcatchment rpt_summary_subcatchment_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_summary_subcatchment
    ADD CONSTRAINT rpt_summary_subcatchment_pkey PRIMARY KEY (id);


--
-- Name: rpt_timestep_critelem rpt_timestep_critelem_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_timestep_critelem
    ADD CONSTRAINT rpt_timestep_critelem_pkey PRIMARY KEY (id);


--
-- Name: rpt_warning_summary rpt_warning_summary_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rpt_warning_summary
    ADD CONSTRAINT rpt_warning_summary_pkey PRIMARY KEY (id);


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
-- Name: rtc_scada_x_dma rtc_scada_dma_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_scada_x_dma
    ADD CONSTRAINT rtc_scada_dma_pkey PRIMARY KEY (id);


--
-- Name: rtc_scada_node rtc_scada_node_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_scada_node
    ADD CONSTRAINT rtc_scada_node_pkey PRIMARY KEY (scada_id);


--
-- Name: rtc_scada_x_sector rtc_scada_sector_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY rtc_scada_x_sector
    ADD CONSTRAINT rtc_scada_sector_pkey PRIMARY KEY (scada_id);


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
-- Name: selector_inp_dscenario selector_inp_dscenario_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_inp_dscenario
    ADD CONSTRAINT selector_inp_dscenario_pkey PRIMARY KEY (dscenario_id, cur_user);


--
-- Name: selector_inp_result selector_inp_result_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_inp_result
    ADD CONSTRAINT selector_inp_result_pkey PRIMARY KEY (result_id, cur_user);


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
    ADD CONSTRAINT selector_rpt_compare_tstep_pkey PRIMARY KEY (resultdate, resulttime, cur_user);


--
-- Name: selector_rpt_main selector_rpt_main_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_main
    ADD CONSTRAINT selector_rpt_main_pkey PRIMARY KEY (result_id, cur_user);


--
-- Name: selector_rpt_main_tstep selector_rpt_main_tstep_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY selector_rpt_main_tstep
    ADD CONSTRAINT selector_rpt_main_tstep_pkey PRIMARY KEY (resultdate, resulttime, cur_user);


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
-- Name: inp_subcatchment subcatchment_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY inp_subcatchment
    ADD CONSTRAINT subcatchment_pkey PRIMARY KEY (subc_id, hydrology_id);


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
-- Name: temp_arc_flowregulator temp_arc_flowregulator_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_arc_flowregulator
    ADD CONSTRAINT temp_arc_flowregulator_pkey PRIMARY KEY (arc_id);


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
-- Name: temp_gully temp_gully_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_gully
    ADD CONSTRAINT temp_gully_pkey PRIMARY KEY (gully_id);


--
-- Name: temp_lid_usage temp_lid_usage_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_lid_usage
    ADD CONSTRAINT temp_lid_usage_pkey PRIMARY KEY (subc_id, lidco_id);


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
-- Name: temp_node temp_node_node_id_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node
    ADD CONSTRAINT temp_node_node_id_unique UNIQUE (node_id);


--
-- Name: temp_node_other temp_node_other_pkey; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node_other
    ADD CONSTRAINT temp_node_other_pkey PRIMARY KEY (id);


--
-- Name: temp_node_other temp_node_other_unique; Type: CONSTRAINT; Schema: Schema; Owner: -
--

ALTER TABLE ONLY temp_node_other
    ADD CONSTRAINT temp_node_other_unique UNIQUE (node_id, type);


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

