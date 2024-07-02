/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET formname = 've_node_valvula' WHERE formname LIKE 've_node_gen_purp_valve';
UPDATE config_form_fields SET formname = 've_arc_tuberia' WHERE formname LIKE 've_arc_pipe';
UPDATE config_form_fields SET formname = 've_node_reclorador' WHERE formname LIKE 've_node_clorinathor';
UPDATE config_form_fields SET formname = 've_node_pozo_acceso' WHERE formname LIKE 've_node_manhole';
UPDATE config_form_fields SET formname = 've_node_filtro' WHERE formname LIKE 've_node_filter';
UPDATE config_form_fields SET formname = 've_node_registro' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_registro_control' WHERE formname LIKE 've_node_control_register';
UPDATE config_form_fields SET formname = 've_node_valvula_verde' WHERE formname LIKE 've_node_green_valve';
UPDATE config_form_fields SET formname = 've_node_medidor_presion' WHERE formname LIKE 've_node_pressure_meter';
UPDATE config_form_fields SET formname = 've_node_valvula_reduc_pr' WHERE formname LIKE 've_node_pr_reduc_valve';
UPDATE config_form_fields SET formname = 've_node_hidrante' WHERE formname LIKE 've_node_hydrant';
UPDATE config_form_fields SET formname = 've_node_elemento_red' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_x' WHERE formname LIKE 've_node_x';
UPDATE config_form_fields SET formname = 've_node_dilatador' WHERE formname LIKE 've_node_flexunion';
UPDATE config_form_fields SET formname = 've_node_deposito' WHERE formname LIKE 've_node_tank';
UPDATE config_form_fields SET formname = 've_node_union' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_bombeo' WHERE formname LIKE 've_node_pump';
UPDATE config_form_fields SET formname = 've_node_punto_mostreo' WHERE formname LIKE 've_node_netsamplepoint';
UPDATE config_form_fields SET formname = 've_node_valvula_sost_pr' WHERE formname LIKE 've_node_pr_susta_valve';
UPDATE config_form_fields SET formname = 've_arc_varc' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_valvula_desague' WHERE formname LIKE 've_node_outfall_valve';
UPDATE config_form_fields SET formname = 've_node_t' WHERE formname LIKE 've_node_t';
UPDATE config_form_fields SET formname = 've_node_reduccion' WHERE formname LIKE 've_node_reduction';
UPDATE config_form_fields SET formname = 've_node_valvula_antiretorno_fl' WHERE formname LIKE 've_node_fl_contr_valve';
UPDATE config_form_fields SET formname = 've_connec_fuente' WHERE formname LIKE 've_connec_tap';
UPDATE config_form_fields SET formname = 've_node_registro_valvula' WHERE formname LIKE 've_node_valve_register';
UPDATE config_form_fields SET formname = 've_node_acometida_topo' WHERE formname LIKE 've_node_water_connection';
UPDATE config_form_fields SET formname = 've_connec_boca_riego' WHERE formname LIKE 've_connec_greentap';
UPDATE config_form_fields SET formname = 've_connec_acometida' WHERE formname LIKE 've_connec_wjoin';
UPDATE config_form_fields SET formname = 've_node_captacion' WHERE formname LIKE 've_node_source';
UPDATE config_form_fields SET formname = 've_node_pozo_captacion' WHERE formname LIKE 've_node_waterwell';
UPDATE config_form_fields SET formname = 've_node_valvula_aire' WHERE formname LIKE 've_node_air_valve';
UPDATE config_form_fields SET formname = 've_node_medidor' WHERE formname LIKE 've_node_flowmeter';
UPDATE config_form_fields SET formname = 've_node_adaptacion' WHERE formname LIKE 've_node_adaptation';
UPDATE config_form_fields SET formname = 've_connec_acometida_ficticia' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_node_registro_bypass' WHERE formname LIKE 've_node_bypass_register';
UPDATE config_form_fields SET formname = 've_node_curva' WHERE formname LIKE 've_node_curve';
UPDATE config_form_fields SET formname = 've_node_final_linea' WHERE formname LIKE 've_node_endline';
UPDATE config_form_fields SET formname = 've_node_calderin_expansion' WHERE formname LIKE 've_node_expantank';
UPDATE config_form_fields SET formname = 've_connec_fuente_ornamental' WHERE formname LIKE 've_connec_fountain';
UPDATE config_form_fields SET formname = 've_node_valvula_rotura_pr' WHERE formname LIKE 've_node_pr_break_valve';
UPDATE config_form_fields SET formname = 've_node_valvula_cierre' WHERE formname LIKE 've_node_shutoff_valve';
UPDATE config_form_fields SET formname = 've_node_valvula_accel' WHERE formname LIKE 've_node_throttle_valve';
UPDATE config_form_fields SET formname = 've_node_estacion_tratamiento' WHERE formname LIKE 've_node_wtp';
UPDATE config_form_fields SET formname = 've_node_valvula_antiretorno' WHERE formname LIKE 've_node_check_valve';
