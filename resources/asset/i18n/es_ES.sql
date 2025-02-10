/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

INSERT INTO asset.value_result_type VALUES ('GLOBAL', 'GLOBAL');
INSERT INTO asset.value_result_type VALUES ('SELECTION', 'SELECCIÓN');

INSERT INTO asset.value_status VALUES ('CANCELED', 'CANCELADO');
INSERT INTO asset.value_status VALUES ('ON PLANNING', 'EN PLANIFICACIÓN');
INSERT INTO asset.value_status VALUES ('FINISHED', 'FINALIZADO');

UPDATE asset.config_engine_def SET label = 'Roturas reales' WHERE parameter = 'rleak_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Roturas reales' WHERE parameter = 'rleak_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Probabilidad de falla' WHERE parameter = 'mleak_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Probabilidad de falla' WHERE parameter = 'mleak_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Longevidad' WHERE parameter = 'longevity_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Longevidad' WHERE parameter = 'longevity_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Caudal circulante' WHERE parameter = 'flow_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Caudal circulante' WHERE parameter = 'flow_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'ANC' WHERE parameter = 'nrw_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'ANC' WHERE parameter = 'nrw_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Estratégico' WHERE parameter = 'strategic_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Estratégico' WHERE parameter = 'strategic_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Normativo' WHERE parameter = 'compliance_1' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Normativo' WHERE parameter = 'compliance_2' AND method = 'WM';
UPDATE asset.config_engine_def SET label = 'Coeficiente de tasa de rotura' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Tasa de descuento (%)' WHERE parameter = 'drate' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Peso de año esperado' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Peso de normativo' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE asset.config_engine_def SET label = 'Peso de estratégico' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Peso en matriz final por factores estratégicos' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Peso en matriz final por año de renovación' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Peso en matriz final por cumplimiento normativo' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Tasa de crecimiento de fugas en tuberías' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE asset.config_engine_def SET descript = 'Tasa de actualización real de precios (discount rate). Tiene en cuenta el aumento de precios descontando la inflación.' WHERE parameter = 'drate' AND method = 'SH';

UPDATE asset.config_form_tableview SET alias = 'Diámetro' WHERE tablename = 'config_catalog_def' AND columnname = 'dnom';
UPDATE asset.config_form_tableview SET alias = 'Coste reconstrucción' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_constr';
UPDATE asset.config_form_tableview SET alias = 'Coste reparación tubería' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_repmain';
UPDATE asset.config_form_tableview SET alias = 'Coste reparación acometida' WHERE tablename = 'config_catalog_def' AND columnname = 'cost_repserv';
UPDATE asset.config_form_tableview SET alias = 'Grado de normatividad' WHERE tablename = 'config_catalog_def' AND columnname = 'compliance';
UPDATE asset.config_form_tableview SET alias = 'Material' WHERE tablename = 'config_material_def' AND columnname = 'material';
UPDATE asset.config_form_tableview SET alias = 'Prob. de fallo' WHERE tablename = 'config_material_def' AND columnname = 'pleak';
UPDATE asset.config_form_tableview SET alias = 'Longevidad máx.' WHERE tablename = 'config_material_def' AND columnname = 'age_max';
UPDATE asset.config_form_tableview SET alias = 'Longevidad med.' WHERE tablename = 'config_material_def' AND columnname = 'age_med';
UPDATE asset.config_form_tableview SET alias = 'Longevidad mín.' WHERE tablename = 'config_material_def' AND columnname = 'age_min';
UPDATE asset.config_form_tableview SET alias = 'Año instalación' WHERE tablename = 'config_material_def' AND columnname = 'builtdate_vdef';
UPDATE asset.config_form_tableview SET alias = 'Grado de normatividad' WHERE tablename = 'config_material_def' AND columnname = 'compliance';
UPDATE asset.config_form_tableview SET alias = 'Parámetro' WHERE tablename = 'config_engine_def' AND columnname = 'parameter';
UPDATE asset.config_form_tableview SET alias = 'Valor' WHERE tablename = 'config_engine_def' AND columnname = 'value';
UPDATE asset.config_form_tableview SET alias = 'Descripción' WHERE tablename = 'config_engine_def' AND columnname = 'alias';
UPDATE asset.config_form_tableview SET alias = 'Id' WHERE tablename = 'cat_result' AND columnname = 'result_id';
UPDATE asset.config_form_tableview SET alias = 'Resultado' WHERE tablename = 'cat_result' AND columnname = 'result_name';
UPDATE asset.config_form_tableview SET alias = 'Tipo' WHERE tablename = 'cat_result' AND columnname = 'result_type';
UPDATE asset.config_form_tableview SET alias = 'Descripción' WHERE tablename = 'cat_result' AND columnname = 'descript';
UPDATE asset.config_form_tableview SET alias = 'Informe' WHERE tablename = 'cat_result' AND columnname = 'report';
UPDATE asset.config_form_tableview SET alias = 'Explotación' WHERE tablename = 'cat_result' AND columnname = 'expl_id';
UPDATE asset.config_form_tableview SET alias = 'Presupuesto anual' WHERE tablename = 'cat_result' AND columnname = 'budget';
UPDATE asset.config_form_tableview SET alias = 'Año horizonte' WHERE tablename = 'cat_result' AND columnname = 'target_year';
UPDATE asset.config_form_tableview SET alias = 'Fecha' WHERE tablename = 'cat_result' AND columnname = 'tstamp';
UPDATE asset.config_form_tableview SET alias = 'Usuario' WHERE tablename = 'cat_result' AND columnname = 'cur_user';
UPDATE asset.config_form_tableview SET alias = 'Estado' WHERE tablename = 'cat_result' AND columnname = 'status';
UPDATE asset.config_form_tableview SET alias = 'Zona de presión' WHERE tablename = 'cat_result' AND columnname = 'presszone_id';
UPDATE asset.config_form_tableview SET alias = 'Material' WHERE tablename = 'cat_result' AND columnname = 'material_id';
UPDATE asset.config_form_tableview SET alias = 'Selección' WHERE tablename = 'cat_result' AND columnname = 'features';
UPDATE asset.config_form_tableview SET alias = 'Diámetro' WHERE tablename = 'cat_result' AND columnname = 'dnom';