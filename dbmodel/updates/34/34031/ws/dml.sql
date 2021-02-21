/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/10
UPDATE config_fprocess SET fid = 141 WHERE target  ='[DEMANDS]';
INSERT INTO inp_typevalue values ('inp_value_patternmethod','24','PJOINT ESTIMATED (PJOINT)',NULL, '{"DemandType":2}') ON CONFLICT (typevalue, id) DO NOTHING;

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue WHERE typevalue  ='inp_options_dscenario_priority' and id = '2';
UPDATE inp_typevalue SET id='2' WHERE id='3' and typevalue  ='inp_options_dscenario_priority';
UPDATE inp_typevalue SET idval = 'JOIN DEMANDS & PATTERNS' WHERE id='2' and typevalue  ='inp_options_dscenario_priority'; 
UPDATE inp_typevalue SET typevalue = concat('_',typevalue) WHERE typevalue = 'inp_value_demandtype' AND id::integer IN (4,5);
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO sys_table VALUES ('temp_demand','Table with temporal demands when go2epa inp file is created',
'role_epa',0, 'role_epa',null,null,'temp_demand_id_seq', 'id') ON CONFLICT (id) DO NOTHING;


--2021/02/11
INSERT INTO config_form_fields VALUES ('v_edit_arc', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;
INSERT INTO config_form_fields VALUES ('ve_arc', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('v_edit_node', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('ve_node', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('v_edit_connec', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;

INSERT INTO config_form_fields VALUES ('ve_connec', 'form_feature', 'workcat_id_plan', 41, 'string', 'typeahead', 'workcat_id_plan', NULL, 'workcat_id_plan - Expediente de planificación del elemento', NULL, FALSE, FALSE, TRUE, FALSE, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_data_2', NULL, FALSE)
ON CONFLICT (formname, formtype, columnname) DO NOTHING;


--2021/02/17
UPDATE sys_table SET sys_sequence='cat_mat_roughness_id_seq' WHERE sys_sequence='inp_cat_mat_roughness_id_seq';


-- 2021/02/19
DELETE FROM config_toolbox WHERE id  = 2766;