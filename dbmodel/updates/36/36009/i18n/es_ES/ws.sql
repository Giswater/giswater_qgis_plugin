/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptacion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_valvula_aire'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_registro_bypass';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_check_valve';------ VALVULA ANTIRETORN
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_reclorador';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_control_register' and child_layer = 've_node_registro_control';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_curve' and child_layer = 've_node_curva';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_endline' and child_layer = 've_node_final_linea';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_expantank' and child_layer = 've_node_calderin_expansion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_filter' and child_layer = 've_node_filtro';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_fl_contr_valve' and child_layer = 've_node_valvula_control_fl';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flexunion' and child_layer = 've_node_dilatador'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flowmeter' and child_layer = 've_node_medidor';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_fountain' and child_layer = 've_connec_fuente_ornamental';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_gen_purp_valve' and child_layer = 've_node_gen_purp_valve';  --- VALVULA PROPOSIT GENERAL
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_acometida_topo';  
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_hydrant' and child_layer = 've_node_hidrante';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_union';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_manhole' and child_layer = 've_node_pozo';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_elemento_red';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netsamplepoint' and child_layer = 've_node_punto_mostreo';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall_valve' and child_layer = 've_node_valvula_desague';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pipe' and child_layer = 've_arc_tuberia';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_break_valve' and child_layer = 've_node_valvula_rotura_pr';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_reduc_valve' and child_layer = 've_node_valvula_reduc_pr';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_susta_valve' and child_layer = 've_node_valvula_sost_pr';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pressure_meter' and child_layer = 've_node_medidor_presion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump' and child_layer = 've_node_bombeo';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_reduction' and child_layer = 've_node_reduccion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registro';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_shutoff_valve' and child_layer = 've_node_valvula_cierre';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_t' and child_layer = 've_node_t';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_tank' and child_layer = 've_node_deposito';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_tap' and child_layer = 've_connec_fuente';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_throttle_valve';  -- VALVULA PAPALLONA
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_registro_valvula';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_varc';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_captacion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_acometida';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_estacion_tratamiento';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_boca_riego';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_captacion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_pozo_captacion';
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;
