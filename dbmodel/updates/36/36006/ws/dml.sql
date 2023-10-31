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

-- 30/10/23
INSERT INTO config_form_fields values ('ve_epa_pump', 'form_feature', 'tab_epa', 'effic_curve_id', 'lyt_epa_data_1', 11, 'string', 'combo', 'Eff. curve', 'Eff. curve', null, false, false, true, false, false, 'SELECT id as id, id as idval FROM v_edit_inp_curve WHERE curve_type = ''EFFICIENCY''', true, true, null, null, null, null, null, null, false);

UPDATE config_form_fields set widgettype = 'combo', dv_querytext = 'SELECT pattern_id as id, pattern_id as idval FROM v_edit_inp_pattern WHERE pattern_id is not null' 
where formname like 've_epa_pump' and columnname ='energy_pattern_id';

UPDATE config_form_fields set iseditable = false  where formname = 've_epa_pump' and columnname = 'avg_effic';


