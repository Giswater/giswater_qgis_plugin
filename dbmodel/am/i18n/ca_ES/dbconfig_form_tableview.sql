/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = am, public;
UPDATE config_form_tableview AS t SET alias = v.alias FROM (
	VALUES
	('config_engine_def', 'active', NULL),
    ('config_material_def', 'age_max', NULL),
    ('config_material_def', 'age_med', NULL),
    ('config_material_def', 'age_min', NULL),
    ('cat_result', 'budget', 'Presssupost'),
    ('config_material_def', 'builtdate_vdef', NULL),
    ('config_catalog_def', 'compliance', NULL),
    ('config_material_def', 'compliance', NULL),
    ('config_catalog_def', 'cost_constr', NULL),
    ('config_catalog_def', 'cost_repmain', NULL),
    ('cat_result', 'cur_user', 'Usuari Actual'),
    ('config_engine_def', 'datatype', NULL),
    ('config_engine_def', 'descript', NULL),
    ('cat_result', 'descript', 'Descr'),
    ('config_catalog_def', 'dnom', NULL),
    ('cat_result', 'dnom', 'DNOM'),
    ('config_engine_def', 'dv_controls', NULL),
    ('config_engine_def', 'dv_querytext', NULL),
    ('cat_result', 'expl_id', 'Id Explotació'),
    ('cat_result', 'features', 'Entitats'),
    ('cat_result', 'iscorporate', 'Corporatiu'),
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
    ('cat_result', 'presszone_id', 'Id Zona Pressió'),
    ('cat_result', 'report', 'Informe'),
    ('cat_result', 'result_id', 'Id Resultat'),
    ('cat_result', 'result_name', 'Nom Resultat'),
    ('cat_result', 'result_type', 'Tipus'),
    ('config_engine_def', 'round', NULL),
    ('config_engine_def', 'standardvalue', NULL),
    ('cat_result', 'status', 'Estat'),
    ('config_engine_def', 'stylesheet', NULL),
    ('cat_result', 'target_year', 'Any Horitzó'),
    ('cat_result', 'tstamp', 'Pas de temps'),
    ('config_engine_def', 'value', NULL),
    ('config_engine_def', 'widgetcontrols', NULL),
    ('config_engine_def', 'widgettype', NULL)
) AS v(objectname, columnname, alias)
WHERE t.objectname = v.objectname AND t.columnname = v.columnname;

