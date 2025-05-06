/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_param_system SET value = FALSE WHERE parameter = 'admin_config_control_trigger';
UPDATE config_form_fields SET formname = 've_node_chamber' WHERE formname LIKE 've_node_chamber';
UPDATE config_form_fields SET formname = 've_arc_pump_pipe' WHERE formname LIKE 've_arc_pump_pipe';
UPDATE config_form_fields SET formname = 've_arc_varc' WHERE formname LIKE 've_arc_varc';
UPDATE config_form_fields SET formname = 've_node_wwtp' WHERE formname LIKE 've_node_wwtp';
UPDATE config_form_fields SET formname = 've_connec_vconnec' WHERE formname LIKE 've_connec_vconnec';
UPDATE config_form_fields SET formname = 've_node_pump_station' WHERE formname LIKE 've_node_pump_station';
UPDATE config_form_fields SET formname = 've_gully_vgully' WHERE formname LIKE 've_gully_vgully';
UPDATE config_form_fields SET formname = 've_node_outfall' WHERE formname LIKE 've_node_outfall';
UPDATE config_form_fields SET formname = 've_arc_siphon' WHERE formname LIKE 've_arc_siphon';
UPDATE config_form_fields SET formname = 've_node_overflow_storage' WHERE formname LIKE 've_node_overflow_storage';
UPDATE config_form_fields SET formname = 've_gully_pgully' WHERE formname LIKE 've_gully_pgully';
UPDATE config_form_fields SET formname = 've_node_valve' WHERE formname LIKE 've_node_valve';
UPDATE config_form_fields SET formname = 've_node_netelement' WHERE formname LIKE 've_node_netelement';
UPDATE config_form_fields SET formname = 've_node_virtual_node' WHERE formname LIKE 've_node_virtual_node';
UPDATE config_form_fields SET formname = 've_node_weir' WHERE formname LIKE 've_node_weir';
UPDATE config_form_fields SET formname = 've_node_register' WHERE formname LIKE 've_node_register';
UPDATE config_form_fields SET formname = 've_node_change' WHERE formname LIKE 've_node_change';
UPDATE config_form_fields SET formname = 've_arc_waccel' WHERE formname LIKE 've_arc_waccel';
UPDATE config_form_fields SET formname = 've_node_circ_manhole' WHERE formname LIKE 've_node_circ_manhole';
UPDATE config_form_fields SET formname = 've_node_netinit' WHERE formname LIKE 've_node_netinit';
UPDATE config_form_fields SET formname = 've_node_rect_manhole' WHERE formname LIKE 've_node_rect_manhole';
UPDATE config_form_fields SET formname = 've_arc_conduit' WHERE formname LIKE 've_arc_conduit';
UPDATE config_form_fields SET formname = 've_connec_connec' WHERE formname LIKE 've_connec_connec';
UPDATE config_form_fields SET formname = 've_node_sandbox' WHERE formname LIKE 've_node_sandbox';
UPDATE config_form_fields SET formname = 've_gully_gully' WHERE formname LIKE 've_gully_gully';
UPDATE config_form_fields SET formname = 've_node_highpoint' WHERE formname LIKE 've_node_highpoint';
UPDATE config_form_fields SET formname = 've_node_sewer_storage' WHERE formname LIKE 've_node_sewer_storage';
UPDATE config_form_fields SET formname = 've_node_jump' WHERE formname LIKE 've_node_jump';
UPDATE config_form_fields SET formname = 've_node_junction' WHERE formname LIKE 've_node_junction';
UPDATE config_form_fields SET formname = 've_node_netgully' WHERE formname LIKE 've_node_netgully';
UPDATE config_param_system SET value = TRUE WHERE parameter = 'admin_config_control_trigger';

