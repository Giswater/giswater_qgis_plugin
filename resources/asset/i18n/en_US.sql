/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
INSERT INTO asset.value_result_type VALUES ('GLOBAL', 'GLOBAL');
INSERT INTO asset.value_result_type VALUES ('SELECTION', 'SELECTION');

INSERT INTO asset.value_status VALUES ('CANCELED', 'CANCELED');
INSERT INTO asset.value_status VALUES ('ON PLANNING', 'ON PLANNING');
INSERT INTO asset.value_status VALUES ('FINISHED', 'FINISHED');

UPDATE asset.config_engine_def SET label = 'Real leaks' WHERE parameter = 'rleak_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Real leaks' WHERE parameter = 'rleak_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Failure probability' WHERE parameter = 'mleak_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Failure probability' WHERE parameter = 'mleak_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Longevity' WHERE parameter = 'longevity_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Longevity' WHERE parameter = 'longevity_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Circulant flow' WHERE parameter = 'flow_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Circulant flow' WHERE parameter = 'flow_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'NRW' WHERE parameter = 'nrw_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'NRW' WHERE parameter = 'nrw_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Strategic' WHERE parameter = 'strategic_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Strategic' WHERE parameter = 'strategic_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Compliance' WHERE parameter = 'compliance_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Compliance' WHERE parameter = 'compliance_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Break rate coefficient' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Discount rate (%)' WHERE parameter = 'drate' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Weight expected year' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Weight compliance' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Weight strategic' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Weight in final matrix due to strategic factors' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Weight in final matrix due to renewal year' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Weight in final matrix due to compliance value' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Pipe breaks growth rate coefficient' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Discount rate. It takes into account the increase in prices discounting inflation.' WHERE parameter = 'drate' AND method = 'SH';

UPDATE asset.config_form_tableview SET alias = 'Diameter' WHERE tablename = 'config_catalog_def' AND columnname = 'dnom';
UPDATE asset.config_form_tableview SET alias = 'Renewal cost' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_constr';
UPDATE asset.config_form_tableview SET alias = 'Repair cost (main)' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_repmain';
UPDATE asset.config_form_tableview SET alias = 'Repais cost (connec)' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_repserv';
UPDATE asset.config_form_tableview SET alias = 'Compliance grade' WHERE tablename = 'config_catalog_def' AND columnname = 'compliance';
UPDATE asset.config_form_tableview SET alias = 'Material' WHERE tablename = 'config_material_def' AND columnname = 'material';
UPDATE asset.config_form_tableview SET alias = 'Failure prob.' WHERE tablename = 'config_material_def' AND columnname = 'pleak';
UPDATE asset.config_form_tableview SET alias = 'Max. longevity' WHERE tablename = 'config_material_def' AND columnname = 'age_max';
UPDATE asset.config_form_tableview SET alias = 'Med. longevity' WHERE tablename = 'config_material_def' AND columnname = 'age_med';
UPDATE asset.config_form_tableview SET alias = 'Min. longevity' WHERE tablename = 'config_material_def' AND columnname = 'age_min';
UPDATE asset.config_form_tableview SET alias = 'Built date' WHERE tablename = 'config_material_def' AND columnname = 'builtdate_vdef';
UPDATE asset.config_form_tableview SET alias = 'Compliance grade' WHERE tablename = 'config_material_def' AND columnname = 'compliance';
UPDATE asset.config_form_tableview SET alias = 'Parameter' WHERE tablename = 'config_engine_def' AND columnname = 'parameter';
UPDATE asset.config_form_tableview SET alias = 'Value' WHERE tablename = 'config_engine_def' AND columnname = 'value';
UPDATE asset.config_form_tableview SET alias = 'Description' WHERE tablename = 'config_engine_def' AND columnname = 'alias';
UPDATE asset.config_form_tableview SET alias = 'Id' WHERE tablename = 'cat_result' AND columnname = 'result_id';
UPDATE asset.config_form_tableview SET alias = 'Result' WHERE tablename = 'cat_result' AND columnname = 'result_name';
UPDATE asset.config_form_tableview SET alias = 'Type' WHERE tablename = 'cat_result' AND columnname = 'result_type';
UPDATE asset.config_form_tableview SET alias = 'Description' WHERE tablename = 'cat_result' AND columnname = 'descript';
UPDATE asset.config_form_tableview SET alias = 'Report' WHERE tablename = 'cat_result' AND columnname = 'report';
UPDATE asset.config_form_tableview SET alias = 'Explotation' WHERE tablename = 'cat_result' AND columnname = 'expl_id';
UPDATE asset.config_form_tableview SET alias = 'Yearly budget' WHERE tablename = 'cat_result' AND columnname = 'budget';
UPDATE asset.config_form_tableview SET alias = 'Horizon year' WHERE tablename = 'cat_result' AND columnname = 'target_year';
UPDATE asset.config_form_tableview SET alias = 'Date' WHERE tablename = 'cat_result' AND columnname = 'tstamp';
UPDATE asset.config_form_tableview SET alias = 'User' WHERE tablename = 'cat_result' AND columnname = 'cur_user';
UPDATE asset.config_form_tableview SET alias = 'Status' WHERE tablename = 'cat_result' AND columnname = 'status';
UPDATE asset.config_form_tableview SET alias = 'Presszone' WHERE tablename = 'cat_result' AND columnname = 'presszone_id';
UPDATE asset.config_form_tableview SET alias = 'Material' WHERE tablename = 'cat_result' AND columnname = 'material_id';
UPDATE asset.config_form_tableview SET alias = 'Selection' WHERE tablename = 'cat_result' AND columnname = 'features';
UPDATE asset.config_form_tableview SET alias = 'Diameter' WHERE tablename = 'cat_result' AND columnname = 'dnom';