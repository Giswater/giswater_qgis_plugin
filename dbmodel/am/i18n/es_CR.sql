/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association,
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_engine_def SET label = 'Probabilidad de falla', descript = '', placeholder = '' WHERE parameter = 'mleak_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Probabilidad de falla', descript = '', placeholder = '' WHERE parameter = 'mleak_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Longevidad', descript = '', placeholder = '' WHERE parameter = 'longevity_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Longevidad', descript = '', placeholder = '' WHERE parameter = 'longevity_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Caudal circulante', descript = '', placeholder = '' WHERE parameter = 'flow_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Caudal circulante', descript = '', placeholder = '' WHERE parameter = 'flow_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'ANC', descript = '', placeholder = '' WHERE parameter = 'nrw_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Estratégico', descript = '', placeholder = '' WHERE parameter = 'strategic_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Estratégico', descript = '', placeholder = '' WHERE parameter = 'strategic_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Normativo', descript = '', placeholder = '' WHERE parameter = 'compliance_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Normativo', descript = '', placeholder = '' WHERE parameter = 'compliance_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Peso de estratégico', descript = 'Peso en matriz final por factores estratégicos', placeholder = '' WHERE parameter = 'strategic' AND method = 'SH';
UPDATE config_engine_def SET label = 'Peso de año esperado', descript = 'Peso en matriz final por año de renovación', placeholder = '' WHERE parameter = 'expected_year' AND method = 'SH';
UPDATE config_engine_def SET label = 'Roturas reales', descript = '', placeholder = '' WHERE parameter = 'rleak_1' AND method = 'WM';
UPDATE config_engine_def SET label = 'Roturas reales', descript = '', placeholder = '' WHERE parameter = 'rleak_2' AND method = 'WM';
UPDATE config_engine_def SET label = 'Peso de normativo', descript = 'Peso en matriz final por cumplimiento normativo', placeholder = '' WHERE parameter = 'compliance' AND method = 'SH';
UPDATE config_engine_def SET label = 'Coeficiente de tasa de rotura', descript = 'Tasa de crecimiento de fugas en tuberías', placeholder = '' WHERE parameter = 'bratemain0' AND method = 'SH';
UPDATE config_engine_def SET label = 'Tasa de descuento (%)', descript = 'Tasa de actualización real de precios (discount rate). Tiene en cuenta el aumento de precios descontando la inflación.', placeholder = '' WHERE parameter = 'drate' AND method = 'SH';
UPDATE config_engine_def SET label = 'ANC', descript = '', placeholder = '' WHERE parameter = 'nrw_2' AND method = 'WM';
UPDATE config_form_tableview SET alias = 'Grado de normatividad' WHERE objectname = 'config_catalog_def' AND columnname = 'compliance';
UPDATE config_form_tableview SET alias = 'Coste reparación tubería' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_repmain';
UPDATE config_form_tableview SET alias = 'Estado' WHERE objectname = 'cat_result' AND columnname = 'status';
UPDATE config_form_tableview SET alias = 'Zona de presión' WHERE objectname = 'cat_result' AND columnname = 'presszone_id';
UPDATE config_form_tableview SET alias = 'Material' WHERE objectname = 'cat_result' AND columnname = 'material_id';
UPDATE config_form_tableview SET alias = 'Selección' WHERE objectname = 'cat_result' AND columnname = 'features';
UPDATE config_form_tableview SET alias = 'método' WHERE objectname = 'config_engine_def' AND columnname = 'method';
UPDATE config_form_tableview SET alias = 'redondo' WHERE objectname = 'config_engine_def' AND columnname = 'round';
UPDATE config_form_tableview SET alias = 'Diámetro' WHERE objectname = 'config_catalog_def' AND columnname = 'dnom';
UPDATE config_form_tableview SET alias = 'Coste reconstrucción' WHERE objectname = 'config_catalog_def' AND columnname = 'cost_constr';
UPDATE config_form_tableview SET alias = 'Material' WHERE objectname = 'config_material_def' AND columnname = 'material';
UPDATE config_form_tableview SET alias = 'Prob. de fallo' WHERE objectname = 'config_material_def' AND columnname = 'pleak';
UPDATE config_form_tableview SET alias = 'Parámetro' WHERE objectname = 'config_engine_def' AND columnname = 'parameter';
UPDATE config_form_tableview SET alias = 'Valor' WHERE objectname = 'config_engine_def' AND columnname = 'value';
UPDATE config_form_tableview SET alias = 'Id' WHERE objectname = 'cat_result' AND columnname = 'result_id';
UPDATE config_form_tableview SET alias = 'Resultado' WHERE objectname = 'cat_result' AND columnname = 'result_name';
UPDATE config_form_tableview SET alias = 'Tipo' WHERE objectname = 'cat_result' AND columnname = 'result_type';
UPDATE config_form_tableview SET alias = 'Descripción' WHERE objectname = 'cat_result' AND columnname = 'descript';
UPDATE config_form_tableview SET alias = 'etiqueta' WHERE objectname = 'config_engine_def' AND columnname = 'label';
UPDATE config_form_tableview SET alias = 'valor estándar' WHERE objectname = 'config_engine_def' AND columnname = 'standardvalue';
UPDATE config_form_tableview SET alias = 'Informe' WHERE objectname = 'cat_result' AND columnname = 'report';
UPDATE config_form_tableview SET alias = 'iscorporativo' WHERE objectname = 'cat_result' AND columnname = 'iscorporate';
UPDATE config_form_tableview SET alias = 'Fecha' WHERE objectname = 'cat_result' AND columnname = 'tstamp';
UPDATE config_form_tableview SET alias = 'descripción' WHERE objectname = 'config_engine_def' AND columnname = 'descript';
UPDATE config_form_tableview SET alias = 'activo' WHERE objectname = 'config_engine_def' AND columnname = 'active';
UPDATE config_form_tableview SET alias = 'nombre del diseño' WHERE objectname = 'config_engine_def' AND columnname = 'layoutname';
UPDATE config_form_tableview SET alias = 'layoutorder' WHERE objectname = 'config_engine_def' AND columnname = 'layoutorder';
UPDATE config_form_tableview SET alias = 'tipo de datos' WHERE objectname = 'config_engine_def' AND columnname = 'datatype';
UPDATE config_form_tableview SET alias = 'widgettype' WHERE objectname = 'config_engine_def' AND columnname = 'widgettype';
UPDATE config_form_tableview SET alias = 'dv_querytext' WHERE objectname = 'config_engine_def' AND columnname = 'dv_querytext';
UPDATE config_form_tableview SET alias = 'dv_controls' WHERE objectname = 'config_engine_def' AND columnname = 'dv_controls';
UPDATE config_form_tableview SET alias = 'isobligatorio' WHERE objectname = 'config_engine_def' AND columnname = 'ismandatory';
UPDATE config_form_tableview SET alias = 'iseditable' WHERE objectname = 'config_engine_def' AND columnname = 'iseditable';
UPDATE config_form_tableview SET alias = 'hoja de estilo' WHERE objectname = 'config_engine_def' AND columnname = 'stylesheet';
UPDATE config_form_tableview SET alias = 'Usuario' WHERE objectname = 'cat_result' AND columnname = 'cur_user';
UPDATE config_form_tableview SET alias = 'Año horizonte' WHERE objectname = 'cat_result' AND columnname = 'target_year';
UPDATE config_form_tableview SET alias = 'widgetcontrols' WHERE objectname = 'config_engine_def' AND columnname = 'widgetcontrols';
UPDATE config_form_tableview SET alias = 'soporte en blanco' WHERE objectname = 'config_engine_def' AND columnname = 'planceholder';
UPDATE config_form_tableview SET alias = 'Longevidad máx.' WHERE objectname = 'config_material_def' AND columnname = 'age_max';
UPDATE config_form_tableview SET alias = 'Longevidad med.' WHERE objectname = 'config_material_def' AND columnname = 'age_med';
UPDATE config_form_tableview SET alias = 'Longevidad mín.' WHERE objectname = 'config_material_def' AND columnname = 'age_min';
UPDATE config_form_tableview SET alias = 'Año instalación' WHERE objectname = 'config_material_def' AND columnname = 'builtdate_vdef';
UPDATE config_form_tableview SET alias = 'Grado de normatividad' WHERE objectname = 'config_material_def' AND columnname = 'compliance';
UPDATE config_form_tableview SET alias = 'Explotación' WHERE objectname = 'cat_result' AND columnname = 'expl_id';
UPDATE config_form_tableview SET alias = 'Presupuesto anual' WHERE objectname = 'cat_result' AND columnname = 'budget';
UPDATE config_form_tableview SET alias = 'Diámetro' WHERE objectname = 'cat_result' AND columnname = 'dnom';
