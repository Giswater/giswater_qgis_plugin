/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (124,'Go2epa-temporal nodarcs','ws', 'epa') ON CONFLICT (id) DO NOTHING;

UPDATE audit_cat_function set function_name = 'gw_fct_pg2epa_demand' where function_name = 'gw_fct_pg2epa_rtc';

INSERT INTO audit_cat_function VALUES (2846, 'gw_fct_pg2epa_vdefault', 'ws', 'Default values for epanet', NULL, NULL, NULL, 'Default values for epanet', 'role_epa', false) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated)
VALUES 
('inp_options_settings', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ws', false, false, 'text', 'linetext', 
'{"vdefault":{"node":{"nullElevBuffer":100, "ceroElevBuffer":100}, 
			  "pipe":{"diameter":"160","roughness":"avg"}},
  "advanced": {"status":"false", 
			   "junction":{"baseDemand":0},
			   "reservoir":{"addElevation":1}, 
			   "tank":{"addElevation":1}, 
			   "valve":{"length":"0.3", "diameter":"100", "minorloss":0.2, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}, 
			   "pump":{"length":0.3, "diameter":100, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}}
  "debug":{"export":true, "useNetworkDemand":false, "checkData":true, "onlyIsOperative":true}
 }',
true, false)
ON conflict (id) DO NOTHING;