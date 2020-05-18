/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

 --2019/12/13
UPDATE audit_cat_function SET input_params='{"featureType":["node","connec","gully"]}' WHERE function_name = 'gw_fct_update_elevation_from_dem';

UPDATE audit_cat_table SET qgis_role_id=NULL, qgis_criticity=NULL, qgis_message=NULL;

UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macrodma' WHERE id='v_edit_macrodma';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macrosector' WHERE id='v_edit_macrosector';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macroexploitation' WHERE id='macroexploitation';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage grate material catalog' WHERE id='cat_mat_grate';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage node material catalog' WHERE id='cat_mat_node';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage arc material catalog' WHERE id='cat_mat_arc';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage node shape catalog' WHERE id='cat_node_shape';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage node catalog' WHERE id='cat_node';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage arc shape catalog' WHERE id='cat_arc_shape';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage connec catalog' WHERE id='cat_connec';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage arc catalog' WHERE id='cat_arc';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage element material catalog' WHERE id='cat_mat_element';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage element catalog' WHERE id='cat_element';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage grate catalog' WHERE id='cat_grate';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage owner catalog' WHERE id='cat_owner';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage soil catalog' WHERE id='cat_soil';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage pavement catalog' WHERE id='cat_pavement';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage work catalog' WHERE id='cat_work';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage builder catalog' WHERE id='cat_builder';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage model catalog' WHERE id='cat_brand_model';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage brand catalog' WHERE id='cat_brand';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage users catalog' WHERE id='cat_users';

UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view prices for nodes' WHERE id='v_plan_node';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view prices for arcs' WHERE id='v_plan_arc';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage pavements related to arcs' WHERE id='plan_arc_x_pavement';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view the geometry of diferent psectors' WHERE id='v_edit_plan_psector';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view the geometry of the current psector' WHERE id='v_edit_plan_current_psector';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage the table of prices' WHERE id='price_compost';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage the table of values for create a new compost price' WHERE id='price_compost_value';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage the table of units for prices' WHERE id='price_value_unit';

UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_files';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_snowmelt';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_temperature';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_evaporation';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_adjustments';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage hydrology related to EPA tables' WHERE id='cat_hydrology';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage raingages related to EPA tables' WHERE id='v_edit_raingage';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage subcatchments related to EPA tables' WHERE id='v_edit_subcatchment';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_aquifer';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_groundwater';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_hydrograph';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_snowpack';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_lid_control';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_lidusage_subc_x_lidco';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view junctions related to EPA tables' WHERE id='v_edit_inp_junction';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view outfalls related to EPA tables' WHERE id='v_edit_inp_outfall';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view dividers related to EPA tables' WHERE id='v_edit_inp_divider';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view storages related to EPA tables' WHERE id='v_edit_inp_storage';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_dwf';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_inflows';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_rdii';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view conduits related to EPA tables' WHERE id='v_edit_inp_conduit';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view virtual related to EPA tables' WHERE id='v_edit_inp_virtual';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view pumps related to EPA tables' WHERE id='v_edit_inp_pump';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view weirs related to EPA tables' WHERE id='v_edit_inp_weir';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view outlets related to EPA tables' WHERE id='v_edit_inp_outlet';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view orifices related to EPA tables' WHERE id='v_edit_inp_orifice';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_transects';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_flwreg_orifice';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_flwreg_weir';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_flwreg_pump';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_flwreg_pump';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_flwreg_outlet';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_flwreg_type';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_pollutant';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_landuses';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_coverage_land_x_subc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_buildup_land_x_pol';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_loadings_pol_x_subc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_washoff_land_x_pol';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_inflows_pol_x_node';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_dwf_pol_x_node';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_treatment_node_x_pol';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage pattern catalog related to EPA tables' WHERE id='inp_pattern';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage curve catalog related to EPA tables' WHERE id='inp_curve_id';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage curve values related to EPA tables' WHERE id='inp_curve';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage timeseries catalog related to EPA tables' WHERE id='inp_timser_id';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage timeseries values related to EPA tables' WHERE id='inp_timeseries';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage controls for arcs' WHERE id='inp_controls_x_arc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage controls for nodes' WHERE id='inp_controls_x_node';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node flooding values related to EPA results' WHERE id='v_rpt_nodeflooding_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node surcharge values related to EPA results' WHERE id='v_rpt_nodesurcharge_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node inflow values related to EPA results' WHERE id='v_rpt_nodeinflow_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node depth values related to EPA results' WHERE id='v_rpt_nodedepth_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage arc flow values related to EPA results' WHERE id='v_rpt_arcflow_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage conduit surcharge values related to EPA results' WHERE id='v_rpt_condsurcharge_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage pumping summary values related to EPA results' WHERE id='v_rpt_pumping_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage flowclass values related to EPA results' WHERE id='v_rpt_flowclass_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage arc pollutant load values related to EPA results' WHERE id='v_rpt_arcpolload_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage outfall flow values related to EPA results' WHERE id='v_rpt_outfallflow_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage outfall load values related to EPA results' WHERE id='v_rpt_outfallload_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage storage volume values related to EPA results' WHERE id='v_rpt_storagevol_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage subcatchment runoff values related to EPA results' WHERE id='v_rpt_subcatchrunoff_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage subcatchment washpff values related to EPA results' WHERE id='v_rpt_subcatchwasoff_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage LID performance values related to EPA results' WHERE id='v_rpt_lidperfomance_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='v_rpt_rainfall_dep';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage runoff quality values related to EPA results' WHERE id='v_rpt_runoff_qual';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage runoff quantity values related to EPA results' WHERE id='v_rpt_runoff_quant';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage groundwater continuity values related to EPA results' WHERE id='v_rpt_groundwater_cont';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage flow routing continuity values related to EPA results' WHERE id='v_rpt_flowrouting_cont';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage quality routing continuity values related to EPA results' WHERE id='v_rpt_qualrouting';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage continuity errors values related to EPA results' WHERE id='v_rpt_continuity_errors';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage high continuity values related to EPA results' WHERE id='v_rpt_high_cont_errors';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage critical elements values related to EPA results' WHERE id='v_rpt_critical_elements';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage timestep critical elements values related to EPA results' WHERE id='v_rpt_timestep_critelem';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage instability index values related to EPA results' WHERE id='v_rpt_instability_index';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage high flow instabiltiy index values related to EPA results' WHERE id='v_rpt_high_flowinest_ind';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage routing timestep values related to EPA results' WHERE id='v_rpt_routing_timestep';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node flooding compared values related to EPA results' WHERE id='v_rpt_comp_nodeflooding_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node surcharge compared values related to EPA results' WHERE id='v_rpt_comp_nodesurcharge_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node inflow compared values related to EPA results' WHERE id='v_rpt_comp_nodeinflow_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage node depth compared values related to EPA results' WHERE id='v_rpt_comp_nodedepth_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage arc flow compared values related to EPA results' WHERE id='v_rpt_comp_arcflow_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage conduit surcharge compared values related to EPA results' WHERE id='v_rpt_comp_condsurcharge_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage pumping summary compared values related to EPA results' WHERE id='v_rpt_comp_pumping_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage flowclass compared values related to EPA results' WHERE id='v_rpt_comp_flowclass_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage arc pollutant load compared values related to EPA results' WHERE id='v_rpt_comp_arcpolload_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage outfall flow compared values related to EPA results' WHERE id='v_rpt_comp_outfallflow_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage outfall load compared values related to EPA results' WHERE id='v_rpt_comp_outfallload_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage storage volume compared values related to EPA results' WHERE id='v_rpt_comp_storagevol_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage subcatchment runoff compared values related to EPA results' WHERE id='v_rpt_comp_subcatchrunoff_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage subcatchment washpff compared values related to EPA results' WHERE id='v_rpt_comp_subcatchwasoff_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage LID performance compared values related to EPA results' WHERE id='v_rpt_comp_lidperfomance_sum';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='v_rpt_comp_rainfall_dep';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage runoff quality compared values related to EPA results' WHERE id='v_rpt_comp_runoff_qual';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage runoff quantity compared values related to EPA results' WHERE id='v_rpt_comp_runoff_quant';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage groundwater continuity compared values related to EPA results' WHERE id='v_rpt_comp_groundwater_cont';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage flow routing continuity compared values related to EPA results' WHERE id='v_rpt_comp_flowrouting_cont';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage quality routing continuity compared values related to EPA results' WHERE id='v_rpt_comp_qualrouting';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage continuity errors compared values related to EPA results' WHERE id='v_rpt_comp_continuity_errors';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage high continuity compared values related to EPA results' WHERE id='v_rpt_comp_high_cont_errors';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage critical elements compared values related to EPA results' WHERE id='v_rpt_comp_critical_elements';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage instability index compared values related to EPA results' WHERE id='v_rpt_comp_instability_index';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage high flow instabiltiy index compared values related to EPA results' WHERE id='v_rpt_comp_high_flowinest_ind';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage routing timestep compared values related to EPA results' WHERE id='v_rpt_comp_routing_timestep';

UPDATE audit_cat_table SET qgis_role_id='role_edit', qgis_criticity=2, qgis_message='Cannot use Add circle tool' WHERE id='v_edit_cad_auxcircle';
UPDATE audit_cat_table SET qgis_role_id='role_edit', qgis_criticity=2, qgis_message='Cannot use Add point tool' WHERE id='v_edit_cad_auxpoint';

UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of diferent visits' WHERE id='v_edit_om_visit';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the results of flowtrace analytics tool related to connecs' WHERE id='v_anl_flow_connec';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the results of flowtrace analytics tool related to arcs' WHERE id='v_anl_flow_arc';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the results of flowtrace analytics tool related to nodes' WHERE id='v_anl_flow_node';

UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage exploitations' WHERE id='v_edit_exploitation';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage dma''s' WHERE id='v_edit_dma';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage hydraulic sectors' WHERE id='v_edit_sector';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=3, qgis_message='Cannot manage arcs. Imposible to use Giswater' WHERE id='v_edit_arc';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage connecs' WHERE id='v_edit_connec';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage gullys' WHERE id='v_edit_gully';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage links' WHERE id='v_edit_link';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to gullys' WHERE id='v_edit_man_gully_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to netgullys' WHERE id='v_edit_man_netgully_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to wwtps' WHERE id='v_edit_man_wwtp_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to chambers' WHERE id='v_edit_man_chamber_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to storages' WHERE id='v_edit_man_storage_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot use dimensioning tool' WHERE id='v_edit_dimensions';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage related elements' WHERE id='v_edit_element';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage samplepoints' WHERE id='v_edit_samplepoint';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage municipality limits related to BASEMAP' WHERE id='ext_municipality';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage address related to BASEMAP' WHERE id='v_ext_address';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage streets related to BASEMAP' WHERE id='v_ext_streetaxis';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage plots related to BASEMAP' WHERE id='v_ext_plot';



--12/12/2019
UPDATE config_api_form_fields SET widgettype='typeahead',
typeahead='{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}'
WHERE column_id in ('nodecat_id', 'arccat_id', 'connecat_id');


UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='node_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='node_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='node_type', dv_querytext_filterc=' AND cat_node.node_type IS NULL OR cat_node.node_type=' WHERE column_id='nodecat_id' AND formtype='feature';

UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='arc_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='arc_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='arc_type', dv_querytext_filterc=' AND cat_arc.arc_type IS NULL OR cat_arc.arc_type=' WHERE column_id='arccat_id' AND formtype='feature';

UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='connec_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='connec_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='connec_type', dv_querytext_filterc=' AND cat_connec.connec_type IS NULL OR cat_connec.connec_type=' WHERE column_id='connecat_id' AND formtype='feature';

UPDATE config_api_form_fields SET isparent=TRUE WHERE column_id='gully_type' AND formtype='feature';
UPDATE config_api_form_fields SET iseditable=FALSE WHERE column_id='gully_type' AND formtype='feature';
UPDATE config_api_form_fields SET dv_parent_id='gully_type', dv_querytext_filterc=' AND cat_grate.gully_type IS NULL OR cat_grate.gully_type=' WHERE column_id='gratecat_id' AND formtype='feature';


DELETE FROM config_api_form_fields WHERE formname='upsert_catalog_grate';

DELETE FROM config_api_form_tabs WHERE formname ='v_edit_connec' AND tabname = 'tab_plan';

DELETE FROM config_api_form_tabs WHERE formname ='ve_arc';
DELETE FROM config_api_form_tabs WHERE formname ='ve_node';
DELETE FROM config_api_form_tabs WHERE formname ='ve_connec';
DELETE FROM config_api_form_tabs WHERE formname ='ve_gully';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]' 
WHERE formname ='v_edit_node';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]' 
WHERE formname ='v_edit_arc';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}, 
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false}]'
WHERE formname ='v_edit_connec';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":true},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}, 
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false}]'
WHERE formname ='v_edit_gully';