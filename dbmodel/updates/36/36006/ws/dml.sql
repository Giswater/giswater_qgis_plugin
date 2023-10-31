/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_arc', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_node', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_connec', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_dma', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('netscenario manager', 'ws', 'plan_netscenario_valve', 'netscenari_id', 0, false, NULL, NULL, NULL, NULL);

-- 27/10/23
UPDATE cat_feature_node SET epa_default='UNDEFINED', isarcdivide=false WHERE id='AIR_VALVE';
UPDATE config_form_fields SET hidden=false, iseditable=true, label = 'Exit elevation' where formname = 'v_edit_link' and columnname = 'exit_topelev';

-- 31/10/23
UPDATE sys_param_user SET "label"='Hydraulic timestep' WHERE id='inp_times_hydraulic_timestep';
