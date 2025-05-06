/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';
UPDATE config_form_fields SET formname = 've_connec_vconnec' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_arc_pipe' WHERE formname LIKE 've_arc_pipe';
UPDATE config_form_fields SET formname = 've_node_clorinathor' WHERE formname LIKE 've_node_clorinathor';
UPDATE config_form_fields SET formname = 've_node_manhole' WHERE formname LIKE 've_node_manhole';
UPDATE config_form_fields SET formname = 've_node_filter' WHERE formname LIKE 've_node_filter';
UPDATE config_form_fields SET formname = 've_node_register' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_control_register' WHERE formname LIKE 've_node_control_register';
UPDATE config_form_fields SET formname = 've_node_green_valve' WHERE formname LIKE 've_node_green_valve';
UPDATE config_form_fields SET formname = 've_node_netsamplepoint' WHERE formname LIKE 've_node_netsamplepoint';
UPDATE config_form_fields SET formname = 've_node_pr_susta_valve' WHERE formname LIKE 've_node_pr_susta_valve';
UPDATE config_form_fields SET formname = 've_connec_greentap' WHERE formname LIKE 've_connec_greentap';
UPDATE config_form_fields SET formname = 've_node_expantank' WHERE formname LIKE 've_node_expantank';
UPDATE config_form_fields SET formname = 've_node_wtp' WHERE formname LIKE 've_node_wtp';
UPDATE config_form_fields SET formname = 've_node_check_valve' WHERE formname LIKE 've_node_check_valve';
UPDATE config_form_fields SET formname = 've_node_x' WHERE formname LIKE 've_node_x';
UPDATE config_form_fields SET formname = 've_node_pressure_meter' WHERE formname LIKE 've_node_pressure_meter';
UPDATE config_form_fields SET formname = 've_node_pr_reduc_valve' WHERE formname LIKE 've_node_pr_reduc_valve';
UPDATE config_form_fields SET formname = 've_node_hydrant' WHERE formname LIKE 've_node_hydrant';
UPDATE config_form_fields SET formname = 've_node_netelement' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_flexunion' WHERE formname LIKE 've_node_flexunion';
UPDATE config_form_fields SET formname = 've_node_tank' WHERE formname LIKE 've_node_tank';
UPDATE config_form_fields SET formname = 've_node_junction' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_pump' WHERE formname LIKE 've_node_pump';
UPDATE config_form_fields SET formname = 've_arc_varc' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_outfall_valve' WHERE formname LIKE 've_node_outfall_valve';
UPDATE config_form_fields SET formname = 've_node_t' WHERE formname LIKE 've_node_t';
UPDATE config_form_fields SET formname = 've_node_reduction' WHERE formname LIKE 've_node_reduction';
UPDATE config_form_fields SET formname = 've_node_fl_contr_valve' WHERE formname LIKE 've_node_fl_contr_valve';
UPDATE config_form_fields SET formname = 've_connec_tap' WHERE formname LIKE 've_connec_tap';
UPDATE config_form_fields SET formname = 've_node_valve_register' WHERE formname LIKE 've_node_valve_register';
UPDATE config_form_fields SET formname = 've_node_water_connection' WHERE formname LIKE 've_node_water_connection';
UPDATE config_form_fields SET formname = 've_connec_wjoin' WHERE formname LIKE 've_connec_wjoin';
UPDATE config_form_fields SET formname = 've_node_source' WHERE formname LIKE 've_node_source';
UPDATE config_form_fields SET formname = 've_node_waterwell' WHERE formname LIKE 've_node_waterwell';
UPDATE config_form_fields SET formname = 've_node_air_valve' WHERE formname LIKE 've_node_air_valve';
UPDATE config_form_fields SET formname = 've_node_flowmeter' WHERE formname LIKE 've_node_flowmeter';
UPDATE config_form_fields SET formname = 've_node_adaptation' WHERE formname LIKE 've_node_adaptation';
UPDATE config_form_fields SET formname = 've_node_bypass_register' WHERE formname LIKE 've_node_bypass_register';
UPDATE config_form_fields SET formname = 've_node_curve' WHERE formname LIKE 've_node_curve';
UPDATE config_form_fields SET formname = 've_node_endline' WHERE formname LIKE 've_node_endline';
UPDATE config_form_fields SET formname = 've_connec_fountain' WHERE formname LIKE 've_connec_fountain';
UPDATE config_form_fields SET formname = 've_node_pr_break_valve' WHERE formname LIKE 've_node_pr_break_valve';
UPDATE config_form_fields SET formname = 've_node_shutoff_valve' WHERE formname LIKE 've_node_shutoff_valve';
UPDATE config_form_fields SET formname = 've_node_throttle_valve' WHERE formname LIKE 've_node_throttle_valve';
UPDATE config_form_fields SET formname = 've_node_gen_purp_valve' WHERE formname LIKE 've_node_gen_purp_valve';
UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';
