/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptador';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_ventosa'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_bypass';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_check_valve';------ VALVULA ANTIRETORNO
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_clorinathor';------ CLORADOR
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_control_register' and child_layer = 've_node_registro_valvula';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_curve' and child_layer = 've_node_curva';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_endline' and child_layer = 've_node_fim_rede';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_expantank' and child_layer = 've_node_tanque_expan';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_filter' and child_layer = 've_node_filtro';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_fl_contr_valve' and child_layer = 've_node_valvula_borboleta';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flexunion' and child_layer = 've_node_junta_elastica'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flowmeter' and child_layer = 've_node_medidor';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_fountain' and child_layer = 've_connec_fonte_ornamental';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_gen_purp_valve' and child_layer = 've_node_valvula_geral'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_green_valve';  
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_hydrant' and child_layer = 've_node_hidrante';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_uniao';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_manhole' and child_layer = 've_node_ponto_inspecao';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_netelement';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netsamplepoint' and child_layer = 've_node_coleta_amostra';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall_valve' and child_layer = 've_node_valvula_exultorio';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pipe' and child_layer = 've_arc_tubulacao';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_break_valve' and child_layer = 've_node_valvula_quebra_vacuo';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_reduc_valve' and child_layer = 've_node_valvula_redu_pres';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_susta_valve' and child_layer = 've_node_valvula_sust_pres';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pressure_meter' and child_layer = 've_node_medidor_pres';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump' and child_layer = 've_node_bomba';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_reduction' and child_layer = 've_node_cone_reducao';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registro';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_shutoff_valve' and child_layer = 've_node_valvula_parada';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_t' and child_layer = 've_node_t';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_tank' and child_layer = 've_node_reservatorio';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_tap' and child_layer = 've_connec_torneria';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_throttle_valve';  -- VALVULA PAPALLONA
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_registro_valvula';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_varc';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_ligacao_topo';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_ligacao';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_eta';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_ponto_irrigacao';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_capt_sup';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_capt_supt';
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;