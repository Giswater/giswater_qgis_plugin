/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET formname = 've_node_valvula' WHERE formname LIKE 've_node_gen_purp_valve';
UPDATE config_form_fields SET formname = 've_arc_tuberia' WHERE formname LIKE 've_arc_pipe';
UPDATE config_form_fields SET formname = 've_node_reclorador' WHERE formname LIKE 've_node_clorinathor';
UPDATE config_form_fields SET formname = 've_node_pou_acces' WHERE formname LIKE 've_node_manhole';
UPDATE config_form_fields SET formname = 've_node_filtre' WHERE formname LIKE 've_node_filter';
UPDATE config_form_fields SET formname = 've_node_registre' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_registre_control' WHERE formname LIKE 've_node_control_register';
UPDATE config_form_fields SET formname = 've_node_green_valve' WHERE formname LIKE 've_node_green_valve';
UPDATE config_form_fields SET formname = 've_node_medidor_pressio' WHERE formname LIKE 've_node_pressure_meter';
UPDATE config_form_fields SET formname = 've_node_valvula_reductora' WHERE formname LIKE 've_node_pr_reduc_valve';
UPDATE config_form_fields SET formname = 've_node_hidrant' WHERE formname LIKE 've_node_hydrant';
UPDATE config_form_fields SET formname = 've_node_netelement' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_x' WHERE formname LIKE 've_node_x';
UPDATE config_form_fields SET formname = 've_node_dilatador' WHERE formname LIKE 've_node_flexunion';
UPDATE config_form_fields SET formname = 've_node_diposit' WHERE formname LIKE 've_node_tank';
UPDATE config_form_fields SET formname = 've_node_unio' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_bomba' WHERE formname LIKE 've_node_pump';
UPDATE config_form_fields SET formname = 've_node_punt_mostreig' WHERE formname LIKE 've_node_netsamplepoint';
UPDATE config_form_fields SET formname = 've_node_valvula_sost_pressio' WHERE formname LIKE 've_node_pr_susta_valve';
UPDATE config_form_fields SET formname = 've_arc_varc' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_valvula_desguas' WHERE formname LIKE 've_node_outfall_valve';
UPDATE config_form_fields SET formname = 've_node_t' WHERE formname LIKE 've_node_t';
UPDATE config_form_fields SET formname = 've_node_reduccio' WHERE formname LIKE 've_node_reduction';
UPDATE config_form_fields SET formname = 've_node_valvula_antiretorn_fl' WHERE formname LIKE 've_node_fl_contr_valve';
UPDATE config_form_fields SET formname = 've_connec_font' WHERE formname LIKE 've_connec_tap';
UPDATE config_form_fields SET formname = 've_node_valvula_registre' WHERE formname LIKE 've_node_valve_register';
UPDATE config_form_fields SET formname = 've_node_escomesa_topo' WHERE formname LIKE 've_node_water_connection';
UPDATE config_form_fields SET formname = 've_connec_boca_reg' WHERE formname LIKE 've_connec_greentap';
UPDATE config_form_fields SET formname = 've_connec_escomesa' WHERE formname LIKE 've_connec_wjoin';
UPDATE config_form_fields SET formname = 've_node_captacio' WHERE formname LIKE 've_node_source';
UPDATE config_form_fields SET formname = 've_node_pou' WHERE formname LIKE 've_node_waterwell';
UPDATE config_form_fields SET formname = 've_node_valvula_ventosa' WHERE formname LIKE 've_node_air_valve';
UPDATE config_form_fields SET formname = 've_node_medidor_fluid' WHERE formname LIKE 've_node_flowmeter';
UPDATE config_form_fields SET formname = 've_node_adaptacio' WHERE formname LIKE 've_node_adaptation';
UPDATE config_form_fields SET formname = 've_connec_escomesa_ficticia' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_node_registre_bypass' WHERE formname LIKE 've_node_bypass_register';
UPDATE config_form_fields SET formname = 've_node_corba' WHERE formname LIKE 've_node_curve';
UPDATE config_form_fields SET formname = 've_node_final_linea' WHERE formname LIKE 've_node_endline';
UPDATE config_form_fields SET formname = 've_node_tanc_expansio' WHERE formname LIKE 've_node_expantank';
UPDATE config_form_fields SET formname = 've_connec_font_ornamental' WHERE formname LIKE 've_connec_fountain';
UPDATE config_form_fields SET formname = 've_node_valvula_trenca_pressio' WHERE formname LIKE 've_node_pr_break_valve';
UPDATE config_form_fields SET formname = 've_node_valvula_shutoff' WHERE formname LIKE 've_node_shutoff_valve';
UPDATE config_form_fields SET formname = 've_node_valvula_accel' WHERE formname LIKE 've_node_throttle_valve';
UPDATE config_form_fields SET formname = 've_node_estacio_tractament' WHERE formname LIKE 've_node_wtp';
UPDATE config_form_fields SET formname = 've_node_valvula_antiretorn' WHERE formname LIKE 've_node_check_valve';
