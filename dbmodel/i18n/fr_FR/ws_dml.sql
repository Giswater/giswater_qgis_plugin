/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET formname = 've_node_valve_usage_generale' WHERE formname LIKE 've_node_gen_purp_valve';
UPDATE config_form_fields SET formname = 've_arc_conduit' WHERE formname LIKE 've_arc_pipe';
UPDATE config_form_fields SET formname = 've_node_clorinathor' WHERE formname LIKE 've_node_clorinathor';
UPDATE config_form_fields SET formname = 've_node_regard' WHERE formname LIKE 've_node_manhole';
UPDATE config_form_fields SET formname = 've_node_filtre' WHERE formname LIKE 've_node_filter';
UPDATE config_form_fields SET formname = 've_node_compteur' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_controle_compteur' WHERE formname LIKE 've_node_control_register';
UPDATE config_form_fields SET formname = 've_node_valve_verte' WHERE formname LIKE 've_node_green_valve';
UPDATE config_form_fields SET formname = 've_node_capteur_pression' WHERE formname LIKE 've_node_pressure_meter';
UPDATE config_form_fields SET formname = 've_node_valve_reduc_pression' WHERE formname LIKE 've_node_pr_reduc_valve';
UPDATE config_form_fields SET formname = 've_node_vanne_controle_debit' WHERE formname LIKE 've_node_fl_contr_valve';
UPDATE config_form_fields SET formname = 've_node_borne_incendie' WHERE formname LIKE 've_node_hydrant';
UPDATE config_form_fields SET formname = 've_node_element_reseau' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_x' WHERE formname LIKE 've_node_x';
UPDATE config_form_fields SET formname = 've_node_flexunion' WHERE formname LIKE 've_node_flexunion';
UPDATE config_form_fields SET formname = 've_node_reservoir' WHERE formname LIKE 've_node_tank';
UPDATE config_form_fields SET formname = 've_node_jonction' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_pompe' WHERE formname LIKE 've_node_pump';
UPDATE config_form_fields SET formname = 've_node_netsamplepoint' WHERE formname LIKE 've_node_netsamplepoint';
UPDATE config_form_fields SET formname = 've_node_valve_maintien_pression' WHERE formname LIKE 've_node_pr_susta_valve';
UPDATE config_form_fields SET formname = 've_arc_arc_virtuel' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_valve_chute' WHERE formname LIKE 've_node_outfall_valve';
UPDATE config_form_fields SET formname = 've_node_t' WHERE formname LIKE 've_node_t';
UPDATE config_form_fields SET formname = 've_node_reduction' WHERE formname LIKE 've_node_reduction';
UPDATE config_form_fields SET formname = 've_connec_tap' WHERE formname LIKE 've_connec_tap';
UPDATE config_form_fields SET formname = 've_node_valve_compteur' WHERE formname LIKE 've_node_valve_register';
UPDATE config_form_fields SET formname = 've_node_connexion_eau_topo' WHERE formname LIKE 've_node_water_connection';
UPDATE config_form_fields SET formname = 've_connec_greentap' WHERE formname LIKE 've_connec_greentap';
UPDATE config_form_fields SET formname = 've_connec_connexion_eau' WHERE formname LIKE 've_connec_wjoin';
UPDATE config_form_fields SET formname = 've_node_capt_sup' WHERE formname LIKE 've_node_source';
UPDATE config_form_fields SET formname = 've_node_puit' WHERE formname LIKE 've_node_waterwell';
UPDATE config_form_fields SET formname = 've_node_valve_air' WHERE formname LIKE 've_node_air_valve';
UPDATE config_form_fields SET formname = 've_node_capteur_debit' WHERE formname LIKE 've_node_flowmeter';
UPDATE config_form_fields SET formname = 've_node_adaptador' WHERE formname LIKE 've_node_adaptation';
UPDATE config_form_fields SET formname = 've_connec_vconnec' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_node_valve_verif' WHERE formname LIKE 've_node_check_valve';
UPDATE config_form_fields SET formname = 've_node_contournement_compteur' WHERE formname LIKE 've_node_bypass_register';
UPDATE config_form_fields SET formname = 've_node_courbe' WHERE formname LIKE 've_node_curve';
UPDATE config_form_fields SET formname = 've_node_fin_ligne' WHERE formname LIKE 've_node_endline';
UPDATE config_form_fields SET formname = 've_node_vase_expansion' WHERE formname LIKE 've_node_expantank';
UPDATE config_form_fields SET formname = 've_connec_fontaine' WHERE formname LIKE 've_connec_fountain';
UPDATE config_form_fields SET formname = 've_node_valve_coupure_pression' WHERE formname LIKE 've_node_pr_break_valve';
UPDATE config_form_fields SET formname = 've_node_vanne_fermeture' WHERE formname LIKE 've_node_shutoff_valve';
UPDATE config_form_fields SET formname = 've_node_throttle_valve' WHERE formname LIKE 've_node_throttle_valve';
UPDATE config_form_fields SET formname = 've_node_usine_retraitement' WHERE formname LIKE 've_node_wtp';
