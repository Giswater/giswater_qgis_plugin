/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE inp_typevalue SET idval = 'VOLUME PERIOD' WHERE id = '2' AND typevalue = 'inp_value_demandtype';
UPDATE inp_typevalue SET id = '4' WHERE id = '3' AND typevalue = 'inp_value_demandtype';
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype', '3', 'UNITARY PERIOD', NULL);


UPDATE inp_typevalue SET idval = 'UNIQUE ESTIMATED (NODE)' WHERE id = '11' AND typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'DMA ESTIMATED (NODE)' WHERE id = '12' AND typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'NODE ESTIMATED (NODE)' WHERE id = '13' AND typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'CONNEC ESTIMATED (PJOINT)', id= '16' WHERE id = '14' AND typevalue = 'inp_value_patternmethod';
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '14', 'UNIQUE ESTIMATED (PJOINT)', NULL, '{"DemandType":1}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '15', 'DMA ESTIMATED (PJOINT)', NULL, '{"DemandType":1}');

UPDATE inp_typevalue SET idval = 'DMA INTERVAL (NODE)', id = '31', descript  ='{"DemandType":3}' WHERE id = '25' AND typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'DMA::HYDRO HIBRID (NODE)', id ='32', descript  ='{"DemandType":3}' WHERE id = '26' AND typevalue = 'inp_value_patternmethod';

UPDATE inp_typevalue SET idval = 'UNIQUE PERIOD (NODE)', id = '21' WHERE id = '23' AND typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'DMA PERIOD (NODE)', id = '22' WHERE id = '24' AND typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'HYDRO PERIOD (NODE)', id = '23' WHERE id = '25' AND typevalue = 'inp_value_patternmethod';
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '24', 'UNIQUE PERIOD (PJOINT)', NULL, '{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '25', 'DMA PERIOD (PJOINT)', NULL, '{"DemandType":2}');
UPDATE inp_typevalue SET idval = 'HYDRO PERIOD (PJOINT)', id = '26' WHERE id = '27' AND typevalue = 'inp_value_patternmethod';

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '33', 'DMA INTERVAL (PJOINT)', NULL, '{"DemandType":3}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '34', 'DMA::HYDRO HIBRID (PJOINT)', NULL, '{"DemandType":3}');

ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

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
  "debug":{"onlyExport":false, "setDemand":true, "checkData":true, "checkNetwork":true, "checkResult":true, "onlyIsOperative":true}
 }',
true, false)
ON conflict (id) DO NOTHING;


UPDATE audit_cat_table SET id = 'vi_pjointpattern' WHERE id = 'v_inp_pjointpattern';


INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('vi_pjoint', 'EPA feature', 'Auxiliar view for epa when connecs are used on unique estimated pattern method', 'role_epa', 0, 'role_epa', false);