/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET formname = 've_node_cambra' WHERE formname LIKE 've_node_chamber';
UPDATE config_form_fields SET formname = 've_node_desguas' WHERE formname LIKE 've_node_outfall';
UPDATE config_form_fields SET formname = 've_arc_sifo' WHERE formname LIKE 've_arc_siphon';
UPDATE config_form_fields SET formname = 've_node_diposit_desbordament' WHERE formname LIKE 've_node_overflow_storage';
UPDATE config_form_fields SET formname = 've_gully_reixa' WHERE formname LIKE 've_gully_pgully';
UPDATE config_form_fields SET formname = 've_node_valvula' WHERE formname LIKE 've_node_valve';
UPDATE config_form_fields SET formname = 've_arc_impulsio' WHERE formname LIKE 've_arc_pump_pipe';
UPDATE config_form_fields SET formname = 've_arc_fictici' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_edar' WHERE formname LIKE 've_node_wwtp';
UPDATE config_form_fields SET formname = 've_connec_escomesa_ficticia' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_gully_embornal_fictici' WHERE formname LIKE 've_gully_vgully';
UPDATE config_form_fields SET formname = 've_node_element_topo' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_node_fictici' WHERE formname LIKE 've_node_virtual_node';
UPDATE config_form_fields SET formname = 've_node_sobreixidor' WHERE formname LIKE 've_node_weir';
UPDATE config_form_fields SET formname = 've_node_registre' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_estacio_bombament' WHERE formname LIKE 've_node_pump_station';
UPDATE config_form_fields SET formname = 've_node_canvi_seccio' WHERE formname LIKE 've_node_change';
UPDATE config_form_fields SET formname = 've_arc_rapid' WHERE formname LIKE 've_arc_waccel';
UPDATE config_form_fields SET formname = 've_node_pou_circular' WHERE formname LIKE 've_node_circ_manhole';
UPDATE config_form_fields SET formname = 've_node_pou_rectangular' WHERE formname LIKE 've_node_rect_manhole';
UPDATE config_form_fields SET formname = 've_arc_conducte' WHERE formname LIKE 've_arc_conduit';
UPDATE config_form_fields SET formname = 've_connec_escomesa' WHERE formname LIKE 've_connec_connec';
UPDATE config_form_fields SET formname = 've_node_arqueta_sorrera' WHERE formname LIKE 've_node_sandbox';
UPDATE config_form_fields SET formname = 've_gully_embornal' WHERE formname LIKE 've_gully_gully';
UPDATE config_form_fields SET formname = 've_node_punt_alt' WHERE formname LIKE 've_node_highpoint';
UPDATE config_form_fields SET formname = 've_node_diposit' WHERE formname LIKE 've_node_sewer_storage';
UPDATE config_form_fields SET formname = 've_node_salt' WHERE formname LIKE 've_node_jump';
UPDATE config_form_fields SET formname = 've_node_unio' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_embornal_topo' WHERE formname LIKE 've_node_netgully';
UPDATE config_form_fields SET formname = 've_node_inici' WHERE formname LIKE 've_node_netinit';
