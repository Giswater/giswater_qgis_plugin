/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptador';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_valve_air'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_bypass_register'; ---- BYPASS
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_check_valve';------ VALVULA ANTIRETORNO
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_clorinathor';------ CLORADOR
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_control_register' and child_layer = 've_node_control_register'; ------ CONTROL REGISTRO
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_curve' and child_layer = 've_node_courbe';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_endline' and child_layer = 've_node_fin_ligne';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_expantank' and child_layer = 've_node_vase_expansion';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_filter' and child_layer = 've_node_filtre';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_fl_contr_valve' and child_layer = 've_node_vanne_controle_debit';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flexunion' and child_layer = 've_node_flexunion'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flowmeter' and child_layer = 've_node_capteur_debit';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_fountain' and child_layer = 've_connec_fontaine';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_gen_purp_valve' and child_layer = 've_node_valve_usage_generale'; 
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_green_valve';  
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_hydrant' and child_layer = 've_node_borne_incendie';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_jonction';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_manhole' and child_layer = 've_node_regard';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_element_reseau';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netsamplepoint' and child_layer = 've_node_netsamplepoint';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall_valve' and child_layer = 've_node_valve_chute';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pipe' and child_layer = 've_arc_conduit';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_break_valve' and child_layer = 've_node_valve_coupure_pression';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_reduc_valve' and child_layer = 've_node_valve_reduc_pression';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_susta_valve' and child_layer = 've_node_valve_maintien_pression';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pressure_meter' and child_layer = 've_node_capteur_pression';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump' and child_layer = 've_node_pompe';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_reduction' and child_layer = 've_node_reduction';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_valve_compteur';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_shutoff_valve' and child_layer = 've_node_vanne_fermeture';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_t' and child_layer = 've_node_t';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_tank' and child_layer = 've_node_reservoir';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_tap' and child_layer = 've_connec_tap';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_throttle_valve';  -- VALVULA PAPALLONA
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_registro_valvula';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_arc_virtuel';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_connexion_eau_topo';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_connexion_eau';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_usine_retraitement';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_greentap';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_capt_sup';
update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_puit';
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

