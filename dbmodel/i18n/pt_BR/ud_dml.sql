/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET formname = 've_node_caixa_inspecao' WHERE formname LIKE 've_node_chamber';
UPDATE config_form_fields SET formname = 've_node_exultorio' WHERE formname LIKE 've_node_outfall';
UPDATE config_form_fields SET formname = 've_arc_sifao' WHERE formname LIKE 've_arc_siphon';
UPDATE config_form_fields SET formname = 've_node_reservatorio_pulmao' WHERE formname LIKE 've_node_owerflow_storage';
UPDATE config_form_fields SET formname = 've_node_vertedouro' WHERE formname LIKE 've_node_weir';
UPDATE config_form_fields SET formname = 've_gully_boca_lobo_mayor' WHERE formname LIKE 've_gully_pgully';
UPDATE config_form_fields SET formname = 've_node_valvula' WHERE formname LIKE 've_node_valve';
UPDATE config_form_fields SET formname = 've_arc_tubulacao_recalque' WHERE formname LIKE 've_arc_pump_pipe';
UPDATE config_form_fields SET formname = 've_arc_tubulacao_virtual' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_ete' WHERE formname LIKE 've_node_wwtp';
UPDATE config_form_fields SET formname = 've_connec_acometida_ficticia' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_gully_deversoir' WHERE formname LIKE 've_gully_vgully';
UPDATE config_form_fields SET formname = 've_node_element_geral_rede' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_no_virtual' WHERE formname LIKE 've_node_virtual_node';
UPDATE config_form_fields SET formname = 've_node_registro' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_bombeamento' WHERE formname LIKE 've_node_pump_station';
UPDATE config_form_fields SET formname = 've_node_caixa_passagem' WHERE formname LIKE 've_node_change';
UPDATE config_form_fields SET formname = 've_arc_tubo_queda' WHERE formname LIKE 've_arc_waccel';
UPDATE config_form_fields SET formname = 've_node_poco_visita' WHERE formname LIKE 've_node_circ_manhole';
UPDATE config_form_fields SET formname = 've_node_poco_visita_retangular' WHERE formname LIKE 've_node_rect_manhole';
UPDATE config_form_fields SET formname = 've_arc_tubulacao' WHERE formname LIKE 've_arc_conduit';
UPDATE config_form_fields SET formname = 've_connec_ligacao' WHERE formname LIKE 've_connec_connec';
UPDATE config_form_fields SET formname = 've_node_desarenador' WHERE formname LIKE 've_node_sandbox';
UPDATE config_form_fields SET formname = 've_gully_boca_lobo' WHERE formname LIKE 've_gully_gully';
UPDATE config_form_fields SET formname = 've_node_ponto_alto' WHERE formname LIKE 've_node_highpoint';
UPDATE config_form_fields SET formname = 've_node_reservatorio_contencao' WHERE formname LIKE 've_node_sewer_storage';
UPDATE config_form_fields SET formname = 've_node_ressalto_hidraulico' WHERE formname LIKE 've_node_jump';
UPDATE config_form_fields SET formname = 've_node_caixa_ligacao' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_boca_lobo_topo' WHERE formname LIKE 've_node_netgully';
UPDATE config_form_fields SET formname = 've_node_ponto_inicio_rede' WHERE formname LIKE 've_node_netinit';
