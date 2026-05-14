/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t
SET label = v.label, descript = v.descript, placeholder = v.placeholder
FROM (
    VALUES
    ('bratemain0', 'SH', 'Coeficiente de tasa de rotura', 'Tasa de crecimiento de fugas en tuberías', NULL),
    ('compliance', 'SH', 'Peso de normativo', 'Peso en matriz final por cumplimiento normativo', NULL),
    ('compliance_1', 'WM', 'Normativo', NULL, NULL),
    ('compliance_2', 'WM', 'Normativo', NULL, NULL),
    ('drate', 'SH', 'Tasa de descuento (%)', 'Tasa de actualización real de precios (discount rate). Tiene en cuenta el aumento de precios descontando la inflación.', NULL),
    ('expected_year', 'SH', 'Peso de año esperado', 'Peso en matriz final por año de renovación', NULL),
    ('flow_1', 'WM', 'Caudal circulante', NULL, NULL),
    ('flow_2', 'WM', 'Caudal circulante', NULL, NULL),
    ('longevity_1', 'WM', 'Longevidad', NULL, NULL),
    ('longevity_2', 'WM', 'Longevidad', NULL, NULL),
    ('mleak_1', 'WM', 'Probabilidad de falla', NULL, NULL),
    ('mleak_2', 'WM', 'Probabilidad de falla', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL),
    ('rleak_1', 'WM', 'Roturas reales', NULL, NULL),
    ('rleak_2', 'WM', 'Roturas reales', NULL, NULL),
    ('strategic', 'SH', 'Peso de estratégico', 'Peso en matriz final por factores estratégicos', NULL),
    ('strategic_1', 'WM', 'Estratégico', NULL, NULL),
    ('strategic_2', 'WM', 'Estratégico', NULL, NULL)
) AS v(parameter, method, label, descript, placeholder)
WHERE t.parameter = v.parameter AND t.method = v.method;

UPDATE config_form_tableview AS t
SET alias = v.alias
FROM (
    VALUES
    ('config_engine_def', 'active', NULL),
    ('config_material_def', 'age_max', NULL),
    ('config_material_def', 'age_med', NULL),
    ('config_material_def', 'age_min', NULL),
    ('cat_result', 'budget', 'Presupuesto'),
    ('config_material_def', 'builtdate_vdef', NULL),
    ('config_catalog_def', 'compliance', NULL),
    ('config_material_def', 'compliance', NULL),
    ('config_catalog_def', 'cost_constr', NULL),
    ('config_catalog_def', 'cost_repmain', NULL),
    ('cat_result', 'cur_user', 'Usuario Actual'),
    ('config_engine_def', 'datatype', NULL),
    ('config_engine_def', 'descript', NULL),
    ('cat_result', 'descript', 'Descr'),
    ('config_catalog_def', 'dnom', NULL),
    ('cat_result', 'dnom', 'DNOM'),
    ('config_engine_def', 'dv_controls', NULL),
    ('config_engine_def', 'dv_querytext', NULL),
    ('cat_result', 'expl_id', 'Id Explotación'),
    ('cat_result', 'features', 'Entidades'),
    ('cat_result', 'iscorporate', 'Corporativo'),
    ('config_engine_def', 'iseditable', NULL),
    ('config_engine_def', 'ismandatory', NULL),
    ('config_engine_def', 'label', NULL),
    ('config_engine_def', 'layoutname', NULL),
    ('config_engine_def', 'layoutorder', NULL),
    ('config_material_def', 'material', NULL),
    ('cat_result', 'material_id', 'Id Material'),
    ('config_engine_def', 'method', NULL),
    ('config_engine_def', 'parameter', NULL),
    ('config_engine_def', 'planceholder', NULL),
    ('config_material_def', 'pleak', NULL),
    ('cat_result', 'presszone_id', 'Id Zona Presión'),
    ('cat_result', 'report', 'Informe'),
    ('cat_result', 'result_id', 'Id Resultado'),
    ('cat_result', 'result_name', 'Nombre Resultado'),
    ('cat_result', 'result_type', 'Tipo'),
    ('config_engine_def', 'round', NULL),
    ('config_engine_def', 'standardvalue', NULL),
    ('cat_result', 'status', 'Estado'),
    ('config_engine_def', 'stylesheet', NULL),
    ('cat_result', 'target_year', 'Año Horizonte'),
    ('cat_result', 'tstamp', 'Paso de tiempo'),
    ('config_engine_def', 'value', NULL),
    ('config_engine_def', 'widgetcontrols', NULL),
    ('config_engine_def', 'widgettype', NULL)
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
    ('CANCELED', 'CANCELADO'),
    ('FINISHED', 'ACABADO'),
    ('ON PLANNING', 'EN PLANIFICACIÓN')
) AS v(id, idval)
WHERE t.id = v.id;

