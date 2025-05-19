/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';

UPDATE config_form_fields SET formname = 've_node_valvula_geral' WHERE formname LIKE 've_node_gen_purp_valve';
UPDATE config_form_fields SET formname = 've_arc_tubulacao' WHERE formname LIKE 've_arc_pipe';
UPDATE config_form_fields SET formname = 've_node_clorinathor' WHERE formname LIKE 've_node_clorinathor';
UPDATE config_form_fields SET formname = 've_node_ponto_inspecao' WHERE formname LIKE 've_node_manhole';
UPDATE config_form_fields SET formname = 've_node_filtro' WHERE formname LIKE 've_node_filter';
UPDATE config_form_fields SET formname = 've_node_registro' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_registro_valvula' WHERE formname LIKE 've_node_control_register';
UPDATE config_form_fields SET formname = 've_node_valvula_irriga' WHERE formname LIKE 've_node_green_valve';
UPDATE config_form_fields SET formname = 've_node_medidor_pres' WHERE formname LIKE 've_node_pressure_meter';
UPDATE config_form_fields SET formname = 've_node_valvula_redu_pres' WHERE formname LIKE 've_node_pr_reduc_valve';
UPDATE config_form_fields SET formname = 've_node_valvula_borboleta' WHERE formname LIKE 've_node_fl_contr_valve';
UPDATE config_form_fields SET formname = 've_node_hidrante' WHERE formname LIKE 've_node_hydrant';
UPDATE config_form_fields SET formname = 've_node_netelement' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_x' WHERE formname LIKE 've_node_x';
UPDATE config_form_fields SET formname = 've_node_junta_elastica' WHERE formname LIKE 've_node_flexunion';
UPDATE config_form_fields SET formname = 've_node_reservatorio' WHERE formname LIKE 've_node_tank';
UPDATE config_form_fields SET formname = 've_node_uniao' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_bomba' WHERE formname LIKE 've_node_pump';
UPDATE config_form_fields SET formname = 've_node_coleta_amostra' WHERE formname LIKE 've_node_netsamplepoint';
UPDATE config_form_fields SET formname = 've_node_valvula_sust_pres' WHERE formname LIKE 've_node_pr_susta_valve';
UPDATE config_form_fields SET formname = 've_arc_varc' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_valvula_exultorio' WHERE formname LIKE 've_node_outfall_valve';
UPDATE config_form_fields SET formname = 've_node_t' WHERE formname LIKE 've_node_t';
UPDATE config_form_fields SET formname = 've_node_cone_reducao' WHERE formname LIKE 've_node_reduction';
UPDATE config_form_fields SET formname = 've_connec_torneria' WHERE formname LIKE 've_connec_tap';
UPDATE config_form_fields SET formname = 've_node_valvula_gaveta' WHERE formname LIKE 've_node_valve_register';
UPDATE config_form_fields SET formname = 've_node_ligacao_topo' WHERE formname LIKE 've_node_water_connection';
UPDATE config_form_fields SET formname = 've_connec_ponto_irrigacao' WHERE formname LIKE 've_connec_greentap';
UPDATE config_form_fields SET formname = 've_connec_ligacao' WHERE formname LIKE 've_connec_wjoin';
UPDATE config_form_fields SET formname = 've_node_capt_sup' WHERE formname LIKE 've_node_source';
UPDATE config_form_fields SET formname = 've_node_capt_subt' WHERE formname LIKE 've_node_waterwell';
UPDATE config_form_fields SET formname = 've_node_ventosa' WHERE formname LIKE 've_node_air_valve';
UPDATE config_form_fields SET formname = 've_node_medidor' WHERE formname LIKE 've_node_flowmeter';
UPDATE config_form_fields SET formname = 've_node_adaptador' WHERE formname LIKE 've_node_adaptation';
UPDATE config_form_fields SET formname = 've_connec_vconnec' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_node_check_valve' WHERE formname LIKE 've_node_check_valve';
UPDATE config_form_fields SET formname = 've_node_bypass' WHERE formname LIKE 've_node_bypass_register';
UPDATE config_form_fields SET formname = 've_node_curva' WHERE formname LIKE 've_node_curve';
UPDATE config_form_fields SET formname = 've_node_fim_rede' WHERE formname LIKE 've_node_endline';
UPDATE config_form_fields SET formname = 've_node_tanque_expan' WHERE formname LIKE 've_node_expantank';
UPDATE config_form_fields SET formname = 've_connec_fonte_ornamental' WHERE formname LIKE 've_connec_fountain';
UPDATE config_form_fields SET formname = 've_node_valvula_quebra_vacuo' WHERE formname LIKE 've_node_pr_break_valve';
UPDATE config_form_fields SET formname = 've_node_valvula_parada' WHERE formname LIKE 've_node_shutoff_valve';
UPDATE config_form_fields SET formname = 've_node_throttle_valve' WHERE formname LIKE 've_node_throttle_valve';
UPDATE config_form_fields SET formname = 've_node_eta' WHERE formname LIKE 've_node_wtp';
UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';
