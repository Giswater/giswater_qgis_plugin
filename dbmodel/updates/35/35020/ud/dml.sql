/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/30
UPDATE sys_table SET id = 'inp_snowpack_value' WHERE id = 'inp_snowpack_values';

UPDATE config_form_fields SET widgettype='combo', dv_querytext='SELECT id, descript AS idval FROM cat_mat_arc WHERE id IS NOT NULL',
iseditable=true, dv_isnullvalue=true
WHERE formname='v_edit_connec' AND columnname='matcat_id';

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_anl_graf', 'View over the temporal tabl that stores the grafanalytics process data','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_arc_all', 'Shows the simulation results of arcs','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_arc_compare_all', 'Shows the simulation results of arcs for comparing','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_arc_timestep', 'Shows the simulation results of arcs over time','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_arc_compare_timestep', 'Shows the simulation results of arcs for comparing it over time','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_node_all', 'Shows the simulation results of nodes','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_node_compare_all', 'Shows the simulation results of nodes for comparing','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_node_timestep', 'Shows the simulation results of nodes over time','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rpt_node_compare_timestep', 'Shows the simulation results of nodes for comparing it over time','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rtc_hydrometer', 'Shows the hydrometer receivers.','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rtc_hydrometer_x_connec', 'Shows the hydrometer receivers related to connecs.','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rtc_period_hydrometer', 'Shows editable information about raingages.','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('ve_raingage', 'Shows editable information about raingages.','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('vi_junction', 'Used to export to SWMM the information about junctions','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('vi_raingages', 'Used to export to SWMM the information about raingages','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('vi_lxsections', 'Used to export to SWMM the information about sections','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('vu_gully', 'Unfiltered view with no state and no sector','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_edit_rtc_hydro_data_x_connec', 'Shows editable information data from hydrometers related to connecs','role_edit', 0)
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET id = 'v_edit_inp_subcatchment' WHERE id = 'v_edit_subcatchment';

DELETE from sys_table where id in ('value_priority','v_edit_om_psector','v_edit_om_psector_x_other','v_inp_files','v_ui_workcat_polygon_all',
'v_edit_man_gully','v_edit_man_netinit','v_edit_man_waccel','v_edit_man_wjump','v_edit_man_outfall','v_edit_man_conduit','v_edit_man_netgully',
'v_edit_man_varc','v_edit_man_siphon','v_edit_man_connec','v_edit_man_chamber','v_edit_man_junction','v_edit_man_manhole','v_edit_man_valve',
'v_edit_man_wwtp','v_edit_man_storage','v_edit_man_gully_pol','v_edit_man_netgully_pol','v_edit_man_wwtp_pol','v_edit_man_chamber_pol',
'v_edit_man_storage_pol','config_form','selector_inp_hydrology','config_form_actions','v_plan_aux_arc_ml','v_inp_pattern_dl','v_price_x_catarc3',
'v_price_x_catconnec1','v_om_psector','v_ui_arc_x_node','v_price_x_catarc1','v_price_x_catsoil4','v_price_x_catsoil2','v_price_x_catarc2',
'v_anl_flow_hydrometer','v_arc_x_node','v_price_x_catconnec2','v_price_x_catsoil1','v_price_x_catsoil3','v_price_x_catconnec3',
'v_om_psector_x_other','v_om_psector_x_node','v_om_psector_x_arc','v_rtc_scada','v_ui_workcat_polygon','v_ui_om_result_cat',
'v_inp_pump','vi_raingage','vi_junctions','vi_title','v_ui_scada_x_node','v_ui_scada_x_node_values','v_inp_rdii','v_inp_divider_tb',
'v_inp_divider_wr','v_inp_report','v_inp_evap_ts','v_inp_dwf_flow','v_inp_temp_wm','v_inp_evap_mo','v_inp_dwf_load','v_inp_mapunits',
'v_inp_project_id','v_node_x_arc','v_plan_aux_arc_gully','v_plan_aux_arc_cost','v_plan_aux_arc_connec','vi_parent_node','v_inp_evap_co',
'v_inp_temp_ts','v_inp_pattern_mo','v_inp_evap_do','v_inp_evap_fl','v_inp_evap_pa','v_inp_evap_te','v_inp_pattern_we','v_inp_hydrograph',
'v_inp_pattern_ho','v_inp_lidcontrol','v_inp_temp_fl','v_inp_snowpack','v_inp_landuses','v_inp_adjustments','v_inp_aquifer',
'v_inp_backdrop','v_inp_buildup','v_inp_conduit_cu','v_inp_conduit_no','v_inp_conduit_xs','v_inp_controls','v_inp_coverages',
'v_inp_curve','v_inp_divider_cu','v_inp_divider_ov','v_inp_groundwater','v_inp_infiltration_cu','v_inp_infiltration_gr',
'v_inp_infiltration_ho','v_inp_inflows_flow','v_inp_inflows_load','v_inp_junction','v_inp_label','v_inp_lidusage','v_inp_loadings',
'v_inp_losses','v_inp_mapdim','v_inp_options','v_inp_orifice','v_inp_outfall_fi','v_inp_outfall_fr','v_inp_outfall_nm','v_inp_outfall_ti',
'v_inp_outfall_ts','v_inp_outlet_fcd','v_inp_outlet_fch','v_inp_outlet_tbd','v_inp_outlet_tbh','v_inp_pollutant','v_inp_rgage_fl','v_inp_rgage_ts',
'v_inp_storage_fc','v_inp_storage_tb','v_inp_subcatch','v_inp_temp_sn','v_inp_temp_wf','v_inp_timser_abs','v_inp_timser_rel','v_inp_timser_fl',
'v_inp_transects','v_inp_treatment','v_inp_washoff','v_inp_weir','v_inp_vertice','v_rpt_comp_arcpolload_sum','vi_lsections') AND
id not in (SELECT table_name FROM information_schema.tables WHERE table_schema = 'SCHEMA_NAME');
