/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET formname_en_us = 've_node_camera' WHERE formname_en_us LIKE 've_node_chamber';
UPDATE config_form_fields SET formname_en_us = 've_arc_impulsion' WHERE formname_en_us LIKE 've_arc_pump_pipe';
UPDATE config_form_fields SET formname_en_us = 've_arc_ficticio' WHERE formname_en_us LIKE 've_arc_varc';
UPDATE config_form_fields SET formname_en_us = 've_node_edar' WHERE formname_en_us LIKE 've_node_wwtp';
UPDATE config_form_fields SET formname_en_us = 've_connec_acometida_ficticia' WHERE formname_en_us LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname_en_us = 've_node_estacion_bombeo' WHERE formname_en_us LIKE 've_node_pump_station';
UPDATE config_form_fields SET formname_en_us = 've_gully_sumidero_ficticio' WHERE formname_en_us LIKE 've_gully_vgully';
UPDATE config_form_fields SET formname_en_us = 've_node_desague' WHERE formname_en_us LIKE 've_node_outfall';
UPDATE config_form_fields SET formname_en_us = 've_arc_sifon' WHERE formname_en_us LIKE 've_arc_siphon';
UPDATE config_form_fields SET formname_en_us = 've_node_deposito_desbordamiento' WHERE formname_en_us LIKE 've_node_overflow_storage';
UPDATE config_form_fields SET formname_en_us = 've_gully_reja' WHERE formname_en_us LIKE 've_gully_pgully';
UPDATE config_form_fields SET formname_en_us = 've_node_valvula' WHERE formname_en_us LIKE 've_node_valve';
UPDATE config_form_fields SET formname_en_us = 've_node_elemento_topo' WHERE formname_en_us LIKE 've_node_netelement';
UPDATE config_form_fields SET formname_en_us = 've_node_nodo_ficticio' WHERE formname_en_us LIKE 've_node_virtual_node';
UPDATE config_form_fields SET formname_en_us = 've_node_aliviadero' WHERE formname_en_us LIKE 've_node_weir';
UPDATE config_form_fields SET formname_en_us = 've_node_registro' WHERE formname_en_us LIKE 've_node_register';
UPDATE config_form_fields SET formname_en_us = 've_node_cambio_seccion' WHERE formname_en_us LIKE 've_node_change';
UPDATE config_form_fields SET formname_en_us = 've_arc_rapido' WHERE formname_en_us LIKE 've_arc_waccel';
UPDATE config_form_fields SET formname_en_us = 've_node_pozo_circular' WHERE formname_en_us LIKE 've_node_circ_manhole';
UPDATE config_form_fields SET formname_en_us = 've_node_inicio' WHERE formname_en_us LIKE 've_node_netinit';
UPDATE config_form_fields SET formname_en_us = 've_node_pozo_rectangular' WHERE formname_en_us LIKE 've_node_rect_manhole';
UPDATE config_form_fields SET formname_en_us = 've_arc_conducto' WHERE formname_en_us LIKE 've_arc_conduit';
UPDATE config_form_fields SET formname_en_us = 've_connec_acometida' WHERE formname_en_us LIKE 've_connec_connec';
UPDATE config_form_fields SET formname_en_us = 've_node_arqueta_arenal' WHERE formname_en_us LIKE 've_node_sandbox';
UPDATE config_form_fields SET formname_en_us = 've_gully_sumidero' WHERE formname_en_us LIKE 've_gully_gully';
UPDATE config_form_fields SET formname_en_us = 've_node_punto_alto' WHERE formname_en_us LIKE 've_node_highpoint';
UPDATE config_form_fields SET formname_en_us = 've_node_deposito' WHERE formname_en_us LIKE 've_node_sewer_storage';
UPDATE config_form_fields SET formname_en_us = 've_node_salto' WHERE formname_en_us LIKE 've_node_jump';
UPDATE config_form_fields SET formname_en_us = 've_node_union' WHERE formname_en_us LIKE 've_node_junction';
UPDATE config_form_fields SET formname_en_us = 've_node_sumidero_topo' WHERE formname_en_us LIKE 've_node_netgully';
