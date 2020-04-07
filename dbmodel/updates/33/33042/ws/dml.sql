/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '28', 'UNIQUEPERIOD>PJOINT', NULL, '{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '15', 'UNIQUEESTIMATED>PJOINT', NULL, '{"DemandType":1}');


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
			   "pump":{"length":0.3, "diameter":100, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}},
  "debug":{"export":true, "setDemand":true, "checkData":true, "onlyIsOperative":true}
 }',
true, false)
ON conflict (id) DO NOTHING;


UPDATE audit_cat_table SET id = 'vi_pjointpattern' WHERE id = 'v_inp_pjointpattern';


INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('vi_pjoint', 'EPA feature', 'Auxiliar view for epa when connecs are used on unique estimated pattern method', 'role_epa', 0, 'role_epa', false);