/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



--2021/08/19
INSERT INTO dma VALUES (-1, 'Conflict',0,null,'DMA used on grafanalytics algorithm when two ore more DMA has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (dma_id) DO NOTHING;
INSERT INTO dqa VALUES (-1, 'Conflict',0, null, 'DQA used on grafanalytics algorithm when two ore more DQA has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (dqa_id) DO NOTHING;
INSERT INTO presszone VALUES (-1, 'Conflict', 0, 'PRESSZONE used on grafanalytics algorithm when two ore more PRESSZONE has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (presszone_id) DO NOTHING;
INSERT INTO sector VALUES (-1, 'Conflict', 0, 'SECTOR used on grafanalytics algorithm when two ore more SECTOR has conflict in terms of some interconnection. Usually opened valve which maybe need to be closed')
ON CONFLICT (sector_id) DO NOTHING;

UPDATE config_param_system SET value = gw_fct_json_object_delete_keys(value::json, 'manageConflict') WHERE parameter = 'utils_grafanalytics_status';

--2021/08/24
INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_pipe', 'Table to manage scenario for pipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_pipe', 'View to manage scenario for pipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_shortpipe', 'Table to manage scenario for shortpipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_shortpipe', 'View to manage scenario for shortpipes', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_valve', 'Table to manage scenario for valves', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_valve', 'View to manage scenario for valves', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_pump', 'Table to manage scenario for pump', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_pump', 'View to manage scenario for pump', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_tank', 'Table to manage scenario for tank', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_tank', 'View to manage scenario for tank', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('inp_dscenario_reservoir', 'Table to manage scenario for reservoir', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_table (id, descript, sys_role, sys_criticity, qgis_role, qgis_criticity, qgis_message, sys_sequence, sys_sequence_field, notify_action, source)
VALUES ('v_edit_inp_dscenario_reservoir', 'View to manage scenario for reservoir', 'role_epa', 0, null, null, null, null, null, null, 'giswater') 
ON CONFLICT (id) DO NOTHING;

