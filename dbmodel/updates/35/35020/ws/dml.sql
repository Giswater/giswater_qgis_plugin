/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/30
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
UPDATE inp_typevalue SET typevalue = '_inp_value_demandtype' WHERE typevalue = 'inp_value_demandtype' and id = '3';
UPDATE inp_typevalue SET typevalue = '_inp_value_patternmethod' WHERE typevalue = 'inp_value_patternmethod' and id = '24';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_edit_inp_pattern', 'View to edit patterns, filteder by sector_id','role_epa', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_edit_inp_pattern_value', 'View to edit curve values, filteder by sector_id','role_epa', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_edit_inp_rules', 'View to edit rules values, filteder by sector_id','role_epa', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_edit_macrodqa', 'Shows editable information about macrodqa.','role_basic', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('config_graf_checkvalve', 'Configuration table of flow direction in check valves.','role_edit', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_inp_pjointpattern', 'View of patterns assigned to point where connec connects with network','role_epa', 0)
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table(id, descript, sys_role, sys_criticity)
VALUES ('v_rtc_interval_nodepattern', 'Unfiltered view that shows planified sectors','role_master', 0)
ON CONFLICT (id) DO NOTHING;

UPDATE sys_table SET descript='View over the temporal tabl that stores the grafanalytics process data' 
WHERE id='v_anl_graf';

DELETE from sys_table where id in ('value_priority','v_edit_man_wtp','v_edit_om_psector','v_edit_om_psector_x_other','v_edit_man_manhole',
'v_ui_workcat_polygon_all','v_edit_man_wjoin','v_edit_man_netwjoin','v_edit_man_register','v_edit_man_waterwell','v_edit_man_source',
'v_edit_man_reduction','v_edit_man_meter','v_edit_man_hydrant','v_edit_man_expansiontank','v_edit_man_netelement','v_edit_man_flexunion',
'v_edit_man_varc','v_edit_man_fountain','v_edit_man_junction','v_edit_man_pump','v_edit_man_tank','v_edit_man_tap','v_edit_man_valve',
'v_edit_man_netsamplepoint','v_edit_man_greentap','v_edit_man_filter','v_edit_man_pipe','v_edit_man_fountain_pol','v_edit_man_register_pol',
'v_edit_man_tank_pol','config_mincut_checkvalve','config_form','config_form_actions','v_plan_aux_arc_cost','v_rtc_dma_parameter_period',
'v_ui_scada_x_node_values','v_om_psector','v_rtc_hydrometer_x_arc','v_inp_pattern','v_price_x_catarc1','v_price_x_catarc2','v_price_x_catarc3',
'v_price_x_catconnec1','v_price_x_catsoil1','v_price_x_catsoil2','v_price_x_catsoil3','v_price_x_catsoil4','v_price_x_catconnec2',
'v_price_x_catconnec3','v_om_psector_x_other','v_om_psector_x_node','v_om_psector_x_arc','v_ui_workcat_polygon','v_ui_om_result_cat',
'v_plan_aux_arc_ml','v_inp_backdrop','v_inp_controls','v_inp_curve','v_inp_demand','v_inp_emitter','v_inp_energy_el','v_inp_energy_gl',
'v_inp_junction','v_inp_label','v_inp_mixing','v_inp_options','v_inp_pipe','v_inp_project_id','v_inp_pump','v_inp_quality','v_inp_reactions_el',
'v_inp_reactions_gl','v_inp_report','v_inp_reservoir','v_inp_rules','v_inp_source','v_inp_status','v_inp_tags','v_inp_tank','v_inp_times',
'v_inp_valve_cu','v_inp_valve_fl','v_inp_valve_lc','v_inp_valve_pr','v_rtc_scada','v_rtc_scada_data','v_rtc_scada_value','v_rtc_hydrometer_x_node_period',
'v_rtc_hydrometer_period','v_rtc_dma_hydrometer_period','v_ui_scada_x_node','v_plan_aux_arc_connec','vi_parent_node','v_inp_vertice') AND
id not in (SELECT table_name FROM information_schema.tables WHERE table_schema = 'SCHEMA_NAME' );

