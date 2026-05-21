/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_engine_def AS t
SET label = v.label, descript = v.descript, placeholder = v.placeholder
FROM (
    VALUES
    ('bratemain0', 'SH', 'Breakage rate coefficient', 'Pipe leak growth rate', NULL),
    ('compliance', 'SH', 'Regulatory weight', 'Weight in final matrix for regulatory compliance', NULL),
    ('compliance_1', 'WM', 'Regulacyjne', NULL, NULL),
    ('compliance_2', 'WM', 'Regulacyjne', NULL, NULL),
    ('drate', 'SH', 'Discount rate (%)', 'Real price discount rate. Takes into account price increases by discounting inflation.', NULL),
    ('expected_year', 'SH', 'Expected annual weight', 'Weight in final matrix per year of renewal', NULL),
    ('flow_1', 'WM', 'Working capital', NULL, NULL),
    ('flow_2', 'WM', 'Working capital', NULL, NULL),
    ('longevity_1', 'WM', 'Długowieczność', NULL, NULL),
    ('longevity_2', 'WM', 'Długowieczność', NULL, NULL),
    ('mleak_1', 'WM', 'Prawdopodobieństwo awarii', NULL, NULL),
    ('mleak_2', 'WM', 'Prawdopodobieństwo awarii', NULL, NULL),
    ('nrw_1', 'WM', 'ANC', NULL, NULL),
    ('nrw_2', 'WM', 'ANC', NULL, NULL),
    ('rleak_1', 'WM', 'Rzeczywiste przerwy', NULL, NULL),
    ('rleak_2', 'WM', 'Rzeczywiste przerwy', NULL, NULL),
    ('strategic', 'SH', 'Waga strategiczna', 'Waga w końcowej macierzy według czynników strategicznych', NULL),
    ('strategic_1', 'WM', 'Strategiczny', NULL, NULL),
    ('strategic_2', 'WM', 'Strategiczny', NULL, NULL)
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
    ('cat_result', 'budget', 'Budget'),
    ('config_material_def', 'builtdate_vdef', NULL),
    ('config_catalog_def', 'compliance', NULL),
    ('config_material_def', 'compliance', NULL),
    ('config_catalog_def', 'cost_constr', NULL),
    ('config_catalog_def', 'cost_repmain', NULL),
    ('cat_result', 'cur_user', 'Current User'),
    ('config_engine_def', 'datatype', NULL),
    ('config_engine_def', 'descript', NULL),
    ('cat_result', 'descript', 'Descript'),
    ('config_catalog_def', 'dnom', NULL),
    ('cat_result', 'dnom', 'DNOM'),
    ('config_engine_def', 'dv_controls', NULL),
    ('config_engine_def', 'dv_querytext', NULL),
    ('cat_result', 'expl_id', 'Expl Id'),
    ('cat_result', 'features', 'Features'),
    ('cat_result', 'iscorporate', 'Corporate'),
    ('config_engine_def', 'iseditable', NULL),
    ('config_engine_def', 'ismandatory', NULL),
    ('config_engine_def', 'label', NULL),
    ('config_engine_def', 'layoutname', NULL),
    ('config_engine_def', 'layoutorder', NULL),
    ('config_material_def', 'material', NULL),
    ('cat_result', 'material_id', 'Material Id'),
    ('config_engine_def', 'method', NULL),
    ('config_engine_def', 'parameter', NULL),
    ('config_engine_def', 'planceholder', NULL),
    ('config_material_def', 'pleak', NULL),
    ('cat_result', 'presszone_id', 'Presszone Id'),
    ('cat_result', 'report', 'Report'),
    ('cat_result', 'result_id', 'Result Id'),
    ('cat_result', 'result_name', 'Result Name'),
    ('cat_result', 'result_type', 'Type'),
    ('config_engine_def', 'round', NULL),
    ('config_engine_def', 'standardvalue', NULL),
    ('cat_result', 'status', 'Status'),
    ('config_engine_def', 'stylesheet', NULL),
    ('cat_result', 'target_year', 'Horizon Year'),
    ('cat_result', 'tstamp', 'Timestamp'),
    ('config_engine_def', 'value', NULL),
    ('config_engine_def', 'widgetcontrols', NULL),
    ('config_engine_def', 'widgettype', NULL)
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

UPDATE value_result_type AS t
SET idval = v.idval
FROM (
    VALUES
    ('GLOBAL', 'GLOBALNY'),
    ('SELECTION', 'SELEKCJA')
) AS v(id, idval)
WHERE t.id = v.id;

UPDATE value_status AS t
SET idval = v.idval
FROM (
    VALUES
    ('CANCELED', 'ODWOŁANE'),
    ('FINISHED', 'ZAKOŃCZONE'),
    ('ON PLANNING', 'O PLANOWANIU')
) AS v(id, idval)
WHERE t.id = v.id;

