/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

DELETE FROM inp_typevalue WHERE typevalue IN ('inp_value_demandtype','inp_value_patternmethod', 'inp_options_networkmode');

INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '1', 'NODE (MANDATORY NODARCS)', NULL);
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '2', 'NODE (ALL NODARCS)', NULL);
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '3', 'PJOINT (MANDATORY NODARCS)', NULL);
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode', '4', 'PJOINT (ALL NODARCS)', NULL);

INSERT INTO inp_typevalue VALUES ('inp_value_demandtype', '1', 'NODE ESTIMATED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype', '2', 'CONNEC ESTIMATED', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype', '3', 'SIMPLIFIED PERIOD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype', '4', 'DMA-EFFICIENCY PERIOD', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype', '5', 'DMA-PATTERN PERIOD', NULL);

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '11', 'UNIQUE ESTIMATED (NODE)', NULL, '{"DemandType":1}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '12', 'DMA ESTIMATED (NODE)', NULL, '{"DemandType":1}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '13', 'NODE ESTIMATED (NODE)', NULL, '{"DemandType":1}');

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '21', 'UNIQUE ESTIMATED (PJOINT)', NULL, '{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '22', 'DMA ESTIMATED (PJOINT)', NULL, '{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '23', 'CONNEC ESTIMATED (PJOINT)', NULL, '{"DemandType":2}');

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '31', 'UNIQUE PERIOD (NODE)', NULL, '{"DemandType":3}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '32', 'HYDRO PERIOD (NODE)', NULL, '{"DemandType":3}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '33', 'UNIQUE PERIOD (PJOINT)', NULL, '{"DemandType":3}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '34', 'HYDRO PERIOD (PJOINT)', NULL, '{"DemandType":3}');

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '41', 'DMA PERIOD (NODE)', NULL, '{"DemandType":4}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '42', 'HYDRO PERIOD (NODE)', NULL, '{"DemandType":4}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '43', 'DMA PERIOD (PJOINT)', NULL, '{"DemandType":4}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '44', 'HYDRO PERIOD (PJOINT)', NULL, '{"DemandType":4}');

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '51', 'DMA PERIOD (NODE)', NULL, '{"DemandType":5}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '52', 'HYDRO PERIOD (NODE)', NULL, '{"DemandType":5}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '53', 'DMA PERIOD (PJOINT)', NULL, '{"DemandType":5}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '54', 'HYDRO PERIOD (PJOINT)', NULL, '{"DemandType":5}');

DELETE FROM audit_cat_param_user WHERE id = 'inp_options_vdefault';
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated) VALUES 
('inp_options_vdefault', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ws', false, false, 'text', 'linetext', 
'{"status":false, "parameters":{"node":{"nullElevBuffer":100, "ceroElevBuffer":100}, "pipe":{"diameter":"160","roughness":"avg"}}}',
true, false);


DELETE FROM audit_cat_param_user WHERE id = 'inp_options_advancedsettings';
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated) VALUES 
('inp_options_advancedsettings', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ws', false, false, 'text', 'linetext', 
'{"status":false, "parameters":{"junction":{"baseDemand":0},  "reservoir":{"addElevation":1},  "tank":{"addElevation":1}, "valve":{"length":"0.3", "diameter":"100", "minorloss":0.2, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}},"pump":{"length":0.3, "diameter":100, "roughness":{"H-W":100, "D-W":0.5, "C-M":0.011}}}}',
true, false);


DELETE FROM audit_cat_param_user WHERE id = 'inp_options_debug';
INSERT INTO audit_cat_param_user (id, formname, descript, sys_role_id, label, isenabled, project_type, isparent , isautoupdate, datatype, widgettype,
vdefault,ismandatory, isdeprecated) VALUES 
('inp_options_debug', 'hidden_value', 'Additional settings for go2epa', 'role_epa', 'Additional settings for go2epa', true, 'ws', false, false, 'text', 'linetext', 
'{"showLog":false, "onlyExport":false, "setDemand":true, "checkData":true, "checkNetwork":true, "checkResult":true, "onlyIsOperative":true, "delDisconnNetwork":false, "removeDemandOnDryNodes":false}',
true, false);


UPDATE audit_cat_table SET id = 'vi_pjointpattern' WHERE id = 'v_inp_pjointpattern';


INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('vi_pjoint', 'EPA feature', 'Auxiliar view for epa when connecs are used on unique estimated pattern method', 'role_epa', 0, 'role_epa', false);