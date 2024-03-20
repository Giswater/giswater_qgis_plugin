/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: xxx

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_fix_i18n_36008()
RETURNS integer AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_fix_i18n_36008();


-- QUERY TO CHECK CONSISTENCY OF config_form_fields
----------------------------------------------------
select * from 
(select child_layer as layer, count(*) cat_feature from cat_feature left join config_form_fields ON child_layer = formname group by child_layer order by 2 asc)a
right join
(select formname as layer, count(*) form_fields from cat_feature right join config_form_fields ON child_layer = formname 
where formname like 've_node_%' or formname like 've_arc_%' or formname like 've_connec_%' or formname like 've_gully_%' group by formname order by 2 asc)b
using (layer)

*/

DECLARE
v_projectype text;
v_lang text;

BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT project_type, language INTO v_projectype, v_lang FROM sys_version ORDER BY id DESC LIMIT 1;

	IF v_projectype = 'UD' THEN
	
		ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;

		IF v_lang = 'ca_ES' THEN

			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_chamber' and child_layer = 've_node_cambra';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_change' and child_layer = 've_node_canvi_seccio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_circ_manhole' and child_layer = 've_node_pou_circular';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_conduit' and child_layer = 've_arc_conducte';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_connec' and child_layer = 've_connec_escomesa';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_gully' and child_layer = 've_gully_embornal';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_highpoint' and child_layer = 've_node_punt_alt';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_jump' and child_layer = 've_node_salt';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_unio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netgully' and child_layer = 've_node_embornal_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netinit' and child_layer = 've_node_inici';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall' and child_layer = 've_node_desguas';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_owerflow_storage' and child_layer = 've_node_diposit_desbordament';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_pgully' and child_layer = 've_gully_reixa';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pump_pipe' and child_layer = 've_arc_impulsio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump_station' and child_layer = 've_node_estacio_bombament';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_rect_manhole' and child_layer = 've_node_pou_rectangular';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sandbox' and child_layer = 've_node_arqueta_sorrera';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sewer_storage' and child_layer = 've_node_diposit';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_siphon' and child_layer = 've_arc_sifo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve' and child_layer = 've_node_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_fictici';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_escomesa_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_vgully' and child_layer = 've_gully_embornal_fictici';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_virtual_node' and child_layer = 've_node_node_fictici';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_waccel' and child_layer = 've_arc_rapid';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_weir' and child_layer = 've_node_presa';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wwtp' and child_layer = 've_node_edar';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_element_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registre';

		ELSIF v_lang = 'es_ES' THEN
		
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_chamber' and child_layer = 've_node_camera';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_change' and child_layer = 've_node_cambio_seccion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_circ_manhole' and child_layer = 've_node_pozo_circular';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_conduit' and child_layer = 've_arc_conducto';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_connec' and child_layer = 've_connec_acometida';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_gully' and child_layer = 've_gully_sumidero';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_highpoint' and child_layer = 've_node_punto_alto';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_jump' and child_layer = 've_node_salto';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_union';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netgully' and child_layer = 've_node_sumidero_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netinit' and child_layer = 've_node_inicio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall' and child_layer = 've_node_desague';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_owerflow_storage' and child_layer = 've_node_deposito_desbordamiento';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_pgully' and child_layer = 've_gully_reja';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pump_pipe' and child_layer = 've_arc_impulsion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump_station' and child_layer = 've_node_estacion_bombeo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_rect_manhole' and child_layer = 've_node_pozo_rectangular';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sandbox' and child_layer = 've_node_arqueta_arenal';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sewer_storage' and child_layer = 've_node_deposito';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_siphon' and child_layer = 've_arc_sifon';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve' and child_layer = 've_node_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_ficticio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_acometida_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_vgully' and child_layer = 've_gully_sumidero_ficticio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_virtual_node' and child_layer = 've_node_nodo_ficticio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_waccel' and child_layer = 've_arc_rapido';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_weir' and child_layer = 've_node_presa';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wwtp' and child_layer = 've_node_edar';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_elemento_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registro';
		
		ELSIF v_lang = 'fr_FR' THEN
	
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_chamber' and child_layer = 've_node_chambre';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_change' and child_layer = 've_node_cambio_seccion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_circ_manhole' and child_layer = 've_node_regard_circ';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_conduit' and child_layer = 've_arc_conducto';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_connec' and child_layer = 've_connec_connexion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_gully' and child_layer = 've_gully_sumidero';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_highpoint' and child_layer = 've_node_pointhaut';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_jump' and child_layer = 've_node_saut';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_jonction';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netgully' and child_layer = 've_node_caniveau_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netinit' and child_layer = 've_node_init_reseau';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall' and child_layer = 've_node_chute';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_owerflow_storage' and child_layer = 've_node_bassin_debordement';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_pgully' and child_layer = 've_gully_polygon_caniveau';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pump_pipe' and child_layer = 've_arc_pompe_tuyau';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump_station' and child_layer = 've_node_station_pompage';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_rect_manhole' and child_layer = 've_node_regard_rect';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sandbox' and child_layer = 've_node_arqueta_arenal';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sewer_storage' and child_layer = 've_node_bassin_retention';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_siphon' and child_layer = 've_arc_sifon';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve' and child_layer = 've_node_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_arc_virtuel';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_acometida_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_vgully' and child_layer = 've_gully_deversoir';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_virtual_node' and child_layer = 've_node_noeud_virtuel';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_waccel' and child_layer = 've_arc_accelerateur_eau';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_weir' and child_layer = 've_node_seuil';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wwtp' and child_layer = 've_node_usine_retraitement';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_element_reseau';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_compteur';
					
		ELSIF v_lang = 'pt_BR' THEN
		
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_chamber' and child_layer = 've_node_caixa_inspecao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_change' and child_layer = 've_node_caixa_passagem';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_circ_manhole' and child_layer = 've_node_poco_visita';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_conduit' and child_layer = 've_arc_tubulacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_connec' and child_layer = 've_connec_ligacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_gully' and child_layer = 've_gully_boca_lobo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_highpoint' and child_layer = 've_node_ponto_alto';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_jump' and child_layer = 've_node_ressalto_hidraulico';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_caixa_ligacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netgully' and child_layer = 've_node_boca_lobo_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netinit' and child_layer = 've_node_ponto_inicio_rede';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall' and child_layer = 've_node_exultorio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_owerflow_storage' and child_layer = 've_node_reservatorio_pulmao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_pgully' and child_layer = 've_gully_boca_lobo_mayor';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pump_pipe' and child_layer = 've_arc_tubulacao_recalque';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump_station' and child_layer = 've_node_bombeamento';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_rect_manhole' and child_layer = 've_node_poco_visita_retangular';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sandbox' and child_layer = 've_node_desarenador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sewer_storage' and child_layer = 've_node_reservatorio_contencao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_siphon' and child_layer = 've_arc_sifao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve' and child_layer = 've_node_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_tubulacao_virtual';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_acometida_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_vgully' and child_layer = 've_gully_deversoir';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_virtual_node' and child_layer = 've_node_no_virtual';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_waccel' and child_layer = 've_arc_tubo_queda';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_weir' and child_layer = 've_node_vertedouro';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wwtp' and child_layer = 've_node_ete';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_element_geral_rede';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registro';
					
		ELSIF v_lang = 'pt_PT' THEN

			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_chamber' and child_layer = 've_node_caixa_inspecao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_change' and child_layer = 've_node_caixa_passagem';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_circ_manhole' and child_layer = 've_node_poco_visita';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_conduit' and child_layer = 've_arc_tubulacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_connec' and child_layer = 've_connec_ligacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_gully' and child_layer = 've_gully_boca_lobo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_highpoint' and child_layer = 've_node_ponto_alto';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_jump' and child_layer = 've_node_ressalto_hidraulico';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_caixa_ligacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netgully' and child_layer = 've_node_boca_lobo_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netinit' and child_layer = 've_node_ponto_inicio_rede';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall' and child_layer = 've_node_exultorio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_owerflow_storage' and child_layer = 've_node_reservatorio_pulmao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_pgully' and child_layer = 've_gully_boca_lobo_mayor';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pump_pipe' and child_layer = 've_arc_tubulacao_recalque';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump_station' and child_layer = 've_node_bombeamento';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_rect_manhole' and child_layer = 've_node_poco_visita_retangular';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sandbox' and child_layer = 've_node_desarenador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_sewer_storage' and child_layer = 've_node_reservatorio_contencao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_siphon' and child_layer = 've_arc_sifao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve' and child_layer = 've_node_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_tubulacao_virtual';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_acometida_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_gully_vgully' and child_layer = 've_gully_deversoir';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_virtual_node' and child_layer = 've_node_no_virtual';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_waccel' and child_layer = 've_arc_tubo_queda';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_weir' and child_layer = 've_node_vertedouro';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wwtp' and child_layer = 've_node_ete';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_element_geral_rede';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registro';

		END IF;

		ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

	ELSE 

		ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
		
		IF v_lang = 'ca_ES' THEN
		
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptacio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_valvula_ventosa'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_registre_bypass';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_valvula_control';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_reclorador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_control_register' and child_layer = 've_node_registre_control';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_curve' and child_layer = 've_node_corba';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_endline' and child_layer = 've_node_final_linea';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_expantank' and child_layer = 've_node_tanc_expansio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_filter' and child_layer = 've_node_filtre';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_fl_contr_valve' and child_layer = 've_node_valvula_control_fl';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flexunion' and child_layer = 've_node_dilatador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flowmeter' and child_layer = 've_node_medidor_fluid';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_fountain' and child_layer = 've_connec_font_ornamental';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_gen_purp_valve' and child_layer = 've_node_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_green_valve'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_hydrant' and child_layer = 've_node_hidrant';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_unio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_manhole' and child_layer = 've_node_pou_acces';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netelement' and child_layer = 've_node_netelement';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_netsamplepoint' and child_layer = 've_node_punt_mostreig';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_outfall_valve' and child_layer = 've_node_valvula_desguas';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_pipe' and child_layer = 've_arc_tuberia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_break_valve' and child_layer = 've_node_valvula_trenca_pressio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_reduc_valve' and child_layer = 've_node_valvula_reductora';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pr_susta_valve' and child_layer = 've_node_valvula_sost_pressio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pressure_meter' and child_layer = 've_node_medidor_pressio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_pump' and child_layer = 've_node_bomba';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_reduction' and child_layer = 've_node_reduccio';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_registre';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_shutoff_valve' and child_layer = 've_node_valvula_shutoff';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_t' and child_layer = 've_node_t';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_tank' and child_layer = 've_node_diposit';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_tap' and child_layer = 've_connec_font';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_valvula_accel';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_valvula_registre';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_varc';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_escomesa_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_escomesa';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_estacio_tractament';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_boca_reg';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_pou';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_escomesa_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_captacio';

		ELSIF v_lang = 'es_ES' THEN

			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptacion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_valvula_aire'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_registro_bypass';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_valvula_control';
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_gen_purp_valve' and child_layer = 've_node_valvula';  
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_valvula_verde';  
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_hydrant' and child_layer = 've_node_hidrante';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_junction' and child_layer = 've_node_union';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_manhole' and child_layer = 've_node_pozo_acceso';
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_valvula_accel'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_registro_valvula';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_varc';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_acometida_topo'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_acometida'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_estacion_tratamiento';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_boca_riego';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_captacion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_vconnec' and child_layer = 've_connec_acometida_ficticia';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_pozo_captacion';
		

		ELSIF v_lang = 'fr_FR' THEN

			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_valve_air'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_contournement_compteur'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_valve_verif';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_clorinathor';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_control_register' and child_layer = 've_node_controle_compteur'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_curve' and child_layer = 've_node_courbe';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_endline' and child_layer = 've_node_fin_ligne';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_expantank' and child_layer = 've_node_vase_expansion';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_filter' and child_layer = 've_node_filtre';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_fl_contr_valve' and child_layer = 've_node_vanne_controle_debit';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flexunion' and child_layer = 've_node_flexunion'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_flowmeter' and child_layer = 've_node_capteur_debit';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_fountain' and child_layer = 've_connec_fontaine';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_gen_purp_valve' and child_layer = 've_node_valve_usage_generale'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_valve_verte';  
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_register' and child_layer = 've_node_compteur';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_shutoff_valve' and child_layer = 've_node_vanne_fermeture';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_t' and child_layer = 've_node_t';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_tank' and child_layer = 've_node_reservoir';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_tap' and child_layer = 've_connec_tap';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_throttle_valve'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_valve_compteur';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_arc_virtuel';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_connexion_eau_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_connexion_eau';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_usine_retraitement';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_greentap';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_capt_sup';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_puit';

		ELSIF v_lang = 'pt_BR' THEN

			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_ventosa'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_bypass';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_check_valve';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_clorinathor';
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_valvula_irriga';  
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_throttle_valve';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_valvula_gaveta';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_varc';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_ligacao_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_ligacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_eta';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_ponto_irrigacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_capt_sup';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_capt_subt';

		ELSIF v_lang = 'pt_PT' THEN
					
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_adaptation' and child_layer = 've_node_adaptador';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_air_valve' and child_layer = 've_node_ventosa'; 
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_bypass_register' and child_layer = 've_node_bypass';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_check_valve' and child_layer = 've_node_check_valve';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_clorinathor' and child_layer = 've_node_clorinathor';
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_green_valve' and child_layer = 've_node_valvula_irriga';  
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
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_throttle_valve' and child_layer = 've_node_throttle_valve';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_valve_register' and child_layer = 've_node_valvula_gaveta';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_arc_varc' and child_layer = 've_arc_varc';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_water_connection' and child_layer = 've_node_ligacao_topo';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_wjoin' and child_layer = 've_connec_ligacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_wtp' and child_layer = 've_node_eta';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_x' and child_layer = 've_node_x';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_connec_greentap' and child_layer = 've_connec_ponto_irrigacao';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_source' and child_layer = 've_node_capt_sup';
			update config_form_fields SET formname = child_layer from cat_feature where formname like 've_node_waterwell' and child_layer = 've_node_capt_subt';
		END IF;
		
		ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;
	END IF;
	
	-- Return
	RETURN 1;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
