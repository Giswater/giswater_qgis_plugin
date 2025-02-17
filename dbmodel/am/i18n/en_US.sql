/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public;

INSERT INTO value_result_type VALUES ('GLOBAL', 'GLOBAL');
INSERT INTO value_result_type VALUES ('SELECTION', 'SELECTION');

INSERT INTO value_status VALUES ('CANCELED', 'CANCELED');
INSERT INTO value_status VALUES ('ON PLANNING', 'ON PLANNING');
INSERT INTO value_status VALUES ('FINISHED', 'FINISHED');

UPDATE config_engine_def SET label = 'Real leaks' WHERE parameter = 'rleak_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Real leaks' WHERE parameter = 'rleak_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Failure probability' WHERE parameter = 'mleak_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Failure probability' WHERE parameter = 'mleak_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Longevity' WHERE parameter = 'longevity_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Longevity' WHERE parameter = 'longevity_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Circulant flow' WHERE parameter = 'flow_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Circulant flow' WHERE parameter = 'flow_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'NRW' WHERE parameter = 'nrw_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'NRW' WHERE parameter = 'nrw_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Strategic' WHERE parameter = 'strategic_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Strategic' WHERE parameter = 'strategic_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Compliance' WHERE parameter = 'compliance_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Compliance' WHERE parameter = 'compliance_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Break rate coefficient' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE config_engine_def SET label = 'Discount rate (%)' WHERE parameter = 'drate' AND method = 'SH';
UPDATE config_engine_def SET label = 'Weight expected year' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE config_engine_def SET label = 'Weight compliance' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE config_engine_def SET label = 'Weight strategic' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Weight in final matrix due to strategic factors' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Weight in final matrix due to renewal year' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Weight in final matrix due to compliance value' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Pipe breaks growth rate coefficient' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE config_engine_def SET descript = 'Discount rate. It takes into account the increase in prices discounting inflation.' WHERE parameter = 'drate' AND method = 'SH';

UPDATE config_form_tableview SET alias = 'Diameter' WHERE objectname = 'config_catalog_def' AND columnname = 'dnom';
UPDATE config_form_tableview SET alias = 'Renewal cost' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_constr';
UPDATE config_form_tableview SET alias = 'Repair cost (main)' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_repmain';
UPDATE config_form_tableview SET alias = 'Repais cost (connec)' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_repserv';
UPDATE config_form_tableview SET alias = 'Compliance grade' WHERE objectname = 'config_catalog_def' AND columnname = 'compliance';
UPDATE config_form_tableview SET alias = 'Material' WHERE objectname = 'config_material_def' AND columnname = 'material';
UPDATE config_form_tableview SET alias = 'Failure prob.' WHERE objectname = 'config_material_def' AND columnname = 'pleak';
UPDATE config_form_tableview SET alias = 'Max. longevity' WHERE objectname = 'config_material_def' AND columnname = 'age_max';
UPDATE config_form_tableview SET alias = 'Med. longevity' WHERE objectname = 'config_material_def' AND columnname = 'age_med';
UPDATE config_form_tableview SET alias = 'Min. longevity' WHERE objectname = 'config_material_def' AND columnname = 'age_min';
UPDATE config_form_tableview SET alias = 'Built date' WHERE objectname = 'config_material_def' AND columnname = 'builtdate_vdef';
UPDATE config_form_tableview SET alias = 'Compliance grade' WHERE objectname = 'config_material_def' AND columnname = 'compliance';
UPDATE config_form_tableview SET alias = 'Parameter' WHERE objectname = 'config_engine_def' AND columnname = 'parameter';
UPDATE config_form_tableview SET alias = 'Value' WHERE objectname = 'config_engine_def' AND columnname = 'value';
UPDATE config_form_tableview SET alias = 'Description' WHERE objectname = 'config_engine_def' AND columnname = 'alias';
UPDATE config_form_tableview SET alias = 'Id' WHERE objectname = 'cat_result' AND columnname = 'result_id';
UPDATE config_form_tableview SET alias = 'Result' WHERE objectname = 'cat_result' AND columnname = 'result_name';
UPDATE config_form_tableview SET alias = 'Type' WHERE objectname = 'cat_result' AND columnname = 'result_type';
UPDATE config_form_tableview SET alias = 'Description' WHERE objectname = 'cat_result' AND columnname = 'descript';
UPDATE config_form_tableview SET alias = 'Report' WHERE objectname = 'cat_result' AND columnname = 'report';
UPDATE config_form_tableview SET alias = 'Explotation' WHERE objectname = 'cat_result' AND columnname = 'expl_id';
UPDATE config_form_tableview SET alias = 'Yearly budget' WHERE objectname = 'cat_result' AND columnname = 'budget';
UPDATE config_form_tableview SET alias = 'Horizon year' WHERE objectname = 'cat_result' AND columnname = 'target_year';
UPDATE config_form_tableview SET alias = 'Date' WHERE objectname = 'cat_result' AND columnname = 'tstamp';
UPDATE config_form_tableview SET alias = 'User' WHERE objectname = 'cat_result' AND columnname = 'cur_user';
UPDATE config_form_tableview SET alias = 'Status' WHERE objectname = 'cat_result' AND columnname = 'status';
UPDATE config_form_tableview SET alias = 'Presszone' WHERE objectname = 'cat_result' AND columnname = 'presszone_id';
UPDATE config_form_tableview SET alias = 'Material' WHERE objectname = 'cat_result' AND columnname = 'material_id';
UPDATE config_form_tableview SET alias = 'Selection' WHERE objectname = 'cat_result' AND columnname = 'features';
UPDATE config_form_tableview SET alias = 'Diameter' WHERE objectname = 'cat_result' AND columnname = 'dnom';