/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t
SET label = v.label, descript = v.descript, placeholder = v.placeholder
FROM (
    VALUES
    ('strategic_1', 'WM', 'Estratégico', NULL, NULL),
    ('strategic_2', 'WM', 'Estratégico', NULL, NULL),
    ('mleak_1', 'WM', 'Probabilidad de falla', NULL, NULL),
    ('mleak_2', 'WM', 'Probabilidad de falla', NULL, NULL),
    ('longevity_1', 'WM', 'Longevidad', NULL, NULL),
    ('compliance_1', 'WM', 'Normativo', NULL, NULL),
    ('longevity_2', 'WM', 'Longevidad', NULL, NULL),
    ('flow_1', 'WM', 'Caudal circulante', NULL, NULL),
    ('compliance_2', 'WM', 'Normativo', NULL, NULL),
    ('flow_2', 'WM', 'Caudal circulante', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('strategic', 'SH', 'Peso de estratégico', 'Peso en matriz final por factores estratégicos', NULL),
    ('expected_year', 'SH', 'Peso de año esperado', 'Peso en matriz final por año de renovación', NULL),
    ('rleak_1', 'WM', 'Roturas reales', NULL, NULL),
    ('rleak_2', 'WM', 'Roturas reales', NULL, NULL),
    ('compliance', 'SH', 'Peso de normativo', 'Peso en matriz final por cumplimiento normativo', NULL),
    ('bratemain0', 'SH', 'Coeficiente de tasa de rotura', 'Tasa de crecimiento de fugas en tuberías', NULL),
    ('drate', 'SH', 'Tasa de descuento (%)', 'Tasa de actualización real de precios (discount rate). Tiene en cuenta el aumento de precios descontando la inflación.', NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL)
) AS v(parameter, method, label, descript, placeholder)
WHERE t.parameter = v.parameter AND t.method = v.method;

UPDATE config_form_tableview AS t
SET alias = v.alias
FROM (
    VALUES
    ('config_engine_def', 'active', 'active'),
    ('config_engine_def', 'layoutname', 'layoutname'),
    ('config_engine_def', 'layoutorder', 'layoutorder'),
    ('cat_result', 'budget', 'budget'),
    ('cat_result', 'presszone_id', 'presszone_id'),
    ('cat_result', 'material_id', 'material_id'),
    ('cat_result', 'features', 'features'),
    ('config_engine_def', 'method', 'method'),
    ('config_engine_def', 'round', 'round'),
    ('config_catalog_def', 'dnom', 'dnom'),
    ('config_catalog_def', 'cost_constr', 'cost_constr'),
    ('config_material_def', 'material', 'material'),
    ('config_material_def', 'pleak', 'pleak'),
    ('config_engine_def', 'parameter', 'parameter'),
    ('config_engine_def', 'value', 'value'),
    ('cat_result', 'result_id', 'result_id'),
    ('cat_result', 'result_name', 'result_name'),
    ('cat_result', 'result_type', 'result_type'),
    ('cat_result', 'descript', 'descript'),
    ('config_engine_def', 'datatype', 'datatype'),
    ('config_engine_def', 'widgettype', 'widgettype'),
    ('config_engine_def', 'dv_querytext', 'dv_querytext'),
    ('config_engine_def', 'dv_controls', 'dv_controls'),
    ('config_engine_def', 'ismandatory', 'ismandatory'),
    ('config_engine_def', 'iseditable', 'iseditable'),
    ('config_engine_def', 'stylesheet', 'stylesheet'),
    ('cat_result', 'cur_user', 'cur_user'),
    ('cat_result', 'target_year', 'target_year'),
    ('config_engine_def', 'widgetcontrols', 'widgetcontrols'),
    ('config_engine_def', 'planceholder', 'planceholder'),
    ('config_catalog_def', 'compliance', 'compliance'),
    ('config_catalog_def', 'cost_repmain', 'cost_repmain'),
    ('config_engine_def', 'label', 'label'),
    ('config_engine_def', 'standardvalue', 'standardvalue'),
    ('cat_result', 'iscorporate', 'iscorporate'),
    ('config_material_def', 'age_max', 'age_max'),
    ('config_material_def', 'age_med', 'age_med'),
    ('cat_result', 'report', 'report'),
    ('cat_result', 'status', 'status'),
    ('cat_result', 'tstamp', 'tstamp'),
    ('config_material_def', 'age_min', 'age_min'),
    ('config_material_def', 'builtdate_vdef', 'builtdate_vdef'),
    ('config_material_def', 'compliance', 'compliance'),
    ('cat_result', 'expl_id', 'expl_id'),
    ('config_engine_def', 'descript', 'descript'),
    ('cat_result', 'dnom', 'dnom')
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE value_result_type AS t
SET idval = v.idval
FROM (
    VALUES
    ('GLOBAL', 'GLOBAL'),
    ('SELECTION', 'SELECCIÓN')
) AS v(id, idval)
WHERE t.id = v.id;

UPDATE value_status AS t
SET idval = v.idval
FROM (
    VALUES
    ('FINISHED', 'ACABADO'),
    ('CANCELED', 'CANCELADO'),
    ('ON PLANNING', 'SOBRE PLANIFICACIÓN')
) AS v(id, idval)
WHERE t.id = v.id;

