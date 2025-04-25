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
    ('config_engine_def', 'active', 'activo'),
    ('config_engine_def', 'layoutname', 'nombre del diseño'),
    ('config_engine_def', 'layoutorder', 'layoutorder'),
    ('cat_result', 'budget', 'Presupuesto anual'),
    ('cat_result', 'presszone_id', 'Zona de presión'),
    ('cat_result', 'material_id', 'Material'),
    ('cat_result', 'features', 'Selección'),
    ('config_engine_def', 'method', 'método'),
    ('config_engine_def', 'round', 'redondo'),
    ('config_catalog_def', 'dnom', 'Diámetro'),
    ('config_catalog_def', 'cost_constr', 'Coste reconstrucción'),
    ('config_material_def', 'material', 'Material'),
    ('config_material_def', 'pleak', 'Prob. de fallo'),
    ('config_engine_def', 'parameter', 'Parámetro'),
    ('config_engine_def', 'value', 'Valor'),
    ('cat_result', 'result_id', 'Id'),
    ('cat_result', 'result_name', 'Resultado'),
    ('cat_result', 'result_type', 'Tipo'),
    ('cat_result', 'descript', 'Descripción'),
    ('config_engine_def', 'datatype', 'tipo de datos'),
    ('config_engine_def', 'widgettype', 'widgettype'),
    ('config_engine_def', 'dv_querytext', 'dv_querytext'),
    ('config_engine_def', 'dv_controls', 'dv_controls'),
    ('config_engine_def', 'ismandatory', 'isobligatorio'),
    ('config_engine_def', 'iseditable', 'iseditable'),
    ('config_engine_def', 'stylesheet', 'hoja de estilo'),
    ('cat_result', 'cur_user', 'Usuario'),
    ('cat_result', 'target_year', 'Año horizonte'),
    ('config_engine_def', 'widgetcontrols', 'widgetcontrols'),
    ('config_engine_def', 'planceholder', 'soporte en blanco'),
    ('config_catalog_def', 'compliance', 'Grado de normatividad'),
    ('config_catalog_def', 'cost_repmain', 'Coste reparación tubería'),
    ('config_engine_def', 'label', 'etiqueta'),
    ('config_engine_def', 'standardvalue', 'valor estándar'),
    ('cat_result', 'iscorporate', 'iscorporativo'),
    ('config_material_def', 'age_max', 'Longevidad máx.'),
    ('config_material_def', 'age_med', 'Longevidad med.'),
    ('cat_result', 'report', 'Informe'),
    ('cat_result', 'status', 'Estado'),
    ('cat_result', 'tstamp', 'Fecha'),
    ('config_material_def', 'age_min', 'Longevidad mín.'),
    ('config_material_def', 'builtdate_vdef', 'Año instalación'),
    ('config_material_def', 'compliance', 'Grado de normatividad'),
    ('cat_result', 'expl_id', 'Explotación'),
    ('config_engine_def', 'descript', 'descripción'),
    ('cat_result', 'dnom', 'Diámetro')
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

