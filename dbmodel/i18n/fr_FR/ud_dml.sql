/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';

UPDATE config_form_fields SET formname = 've_node_chambre' WHERE formname LIKE 've_node_chamber';
UPDATE config_form_fields SET formname = 've_node_chute' WHERE formname LIKE 've_node_outfall';
UPDATE config_form_fields SET formname = 've_arc_sifon' WHERE formname LIKE 've_arc_siphon';
UPDATE config_form_fields SET formname = 've_node_bassin_debordement' WHERE formname LIKE 've_node_owerflow_storage';
UPDATE config_form_fields SET formname = 've_node_seuil' WHERE formname LIKE 've_node_weir';
UPDATE config_form_fields SET formname = 've_gully_polygon_caniveau' WHERE formname LIKE 've_gully_pgully';
UPDATE config_form_fields SET formname = 've_node_valvula' WHERE formname LIKE 've_node_valve';
UPDATE config_form_fields SET formname = 've_arc_pompe_tuyau' WHERE formname LIKE 've_arc_pump_pipe';
UPDATE config_form_fields SET formname = 've_arc_arc_virtuel' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_usine_retraitement' WHERE formname LIKE 've_node_wwtp';
UPDATE config_form_fields SET formname = 've_connec_acometida_ficticia' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_gully_deversoir' WHERE formname LIKE 've_gully_vgully';
UPDATE config_form_fields SET formname = 've_node_element_reseau' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_noeud_virtuel' WHERE formname LIKE 've_node_virtual_node';
UPDATE config_form_fields SET formname = 've_node_compteur' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_station_pompage' WHERE formname LIKE 've_node_pump_station';
UPDATE config_form_fields SET formname = 've_node_cambio_seccion' WHERE formname LIKE 've_node_change';
UPDATE config_form_fields SET formname = 've_arc_accelerateur_eau' WHERE formname LIKE 've_arc_waccel';
UPDATE config_form_fields SET formname = 've_node_regard_circ' WHERE formname LIKE 've_node_circ_manhole';
UPDATE config_form_fields SET formname = 've_node_regard_rect' WHERE formname LIKE 've_node_rect_manhole';
UPDATE config_form_fields SET formname = 've_arc_conducto' WHERE formname LIKE 've_arc_conduit';
UPDATE config_form_fields SET formname = 've_connec_connexion' WHERE formname LIKE 've_connec_connec';
UPDATE config_form_fields SET formname = 've_node_arqueta_arenal' WHERE formname LIKE 've_node_sandbox';
UPDATE config_form_fields SET formname = 've_gully_sumidero' WHERE formname LIKE 've_gully_gully';
UPDATE config_form_fields SET formname = 've_node_pointhaut' WHERE formname LIKE 've_node_highpoint';
UPDATE config_form_fields SET formname = 've_node_bassin_retention' WHERE formname LIKE 've_node_sewer_storage';
UPDATE config_form_fields SET formname = 've_node_saut' WHERE formname LIKE 've_node_jump';
UPDATE config_form_fields SET formname = 've_node_jonction' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_caniveau_topo' WHERE formname LIKE 've_node_netgully';
UPDATE config_form_fields SET formname = 've_node_init_reseau' WHERE formname LIKE 've_node_netinit';
UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';
