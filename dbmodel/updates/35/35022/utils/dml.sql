/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/01/25
UPDATE config_toolbox SET inputparams ='[{"widgetname":"action", "label":"Set topocontrol mode:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["TRUE","FALSE"],"comboNames":["MIGRATION","WORK"], "selectedId":"FALSE"}]'
where id = 3130;

INSERT INTO sys_param_user(id, formname, descript, sys_role, isenabled, project_type, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, source)
VALUES ('edit_disable_topocontrol', 'hidden', 'If true topocontrol and feature proximity is disabled to allow data migration',
'role_admin', true, 'utils', false, 'boolean', 'check', false, true,'core')
ON CONFLICT (id) DO NOTHING;

--2022/01/27
DELETE FROM sys_fprocess where fid in (333, 334, 335, 179);

--2022/01/31
ALTER TABLE plan_price DROP CONSTRAINT IF EXISTS plan_price_unit_check;

UPDATE config_form_fields SET columnname='expl_id', label='expl_id', 
dv_querytext='SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL ',
widgetcontrols='{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_exploitation", "activated": true, "keyColumn": "expl_id", "valueColumn": "name", "filterExpression": null}}'
WHERE columnname='sector_id' AND (formname ilike '%pattern%' OR formname ilike '%inp_curve%' OR formname ilike '%inp_timeseries%');

UPDATE sys_function SET project_type='utils', descript='Allows editing inp patterns view' WHERE id=3062;

UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'query_filter', ' AND id<2'::text) WHERE parameter = 'basic_selector_tab_network_state';

UPDATE sys_table SET sys_role='role_master' WHERE id IN ('plan_psector_x_arc', 'plan_psector_x_node', 'plan_psector_x_connec', 'plan_psector_x_gully', 'plan_psector_x_other');

UPDATE config_form_tabs SET sys_role='role_basic' WHERE formname='selector_basic' AND tabname='tab_psector';

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3132, 'gw_trg_edit_inp_timeseries', 'ud', 'function trigger', NULL, NULL, 'Allows editing inp timeseries view', 'role_epa', NULL, 'core')
ON CONFLICT (id) DO NOTHING;

UPDATE inp_pattern SET expl_id = a.expl_id FROM arc a WHERE inp_pattern.expl_id=a.sector_id;
UPDATE inp_curve SET expl_id = a.expl_id FROM arc a WHERE inp_curve.expl_id=a.sector_id;

ALTER TABLE inp_pattern DROP CONSTRAINT IF EXISTS inp_pattern_expl_id_fkey;
ALTER TABLE inp_pattern ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_curve DROP CONSTRAINT IF EXISTS inp_curve_expl_id_fkey;
ALTER TABLE inp_curve ADD CONSTRAINT inp_curve_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

-- 07/02/2022
UPDATE config_report SET filterparam = '[{"columnname":"arccat_id", "label":"Arc catalog:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select id as id, id as idval FROM cat_arc WHERE id IS NOT NULL ORDER BY id","isNullValue":"true"},{"columnname":"expl_id", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL","isNullValue":"true"}]' WHERE id = 100;

INSERT INTO config_param_system(parameter, value, descript, label, isenabled, layoutorder, project_type, datatype)
VALUES ('basic_selector_tab_macrosector', '{"table":"macrosector","selector":"selector_sector","table_id":"macrosector_id",
"selector_id":"sector_id","label":"macrosector_id, '' - '', m.name","orderBy":"macrosector_id","manageAll":true,"selectionMode":"keepPreviousUsingShift",
"query_filter":" AND macrosector_id > 0","typeaheadForced":true, "sectorFromMacroexpl":true,"explFromMacroexpl":false}', 'Variable to config selector tab macrosector',
'Selector variables', FALSE, null, 'utils', 'json') 
ON CONFLICT(parameter) DO NOTHING;

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue', 'tab_macrosector', 'Macrosector', 'Macrosector', null)
ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO config_form_tabs(formname, tabname, label, tooltip, sys_role, tabfunction, tabactions, device, orderby)
VALUES ('selector_basic', 'tab_macrosector', 'Macrosector', 'Macrosector', 'role_epa', NULL, NULL, 4,7)
ON CONFLICT (formname, tabname, device) DO NOTHING;

UPDATE config_form_fields SET hidden = FALSE WHERE formname='v_edit_sector' AND columnname='macrosector_id';

UPDATE config_form_fields SET widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id",
"valueColumn": "name", "filterExpression": "sector_id > -1 AND active IS TRUE"}}' WHERE formname='v_edit_sector' and columnname='parent_id';

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('sys_table_context', '{"level_1":"BASEMAP","level_2":"CARTO"}', null, '{"orderBy":24}', NULL)
ON CONFLICT (typevalue, id) DO NOTHING;


UPDATE sys_table SET context='{"level_1":"BASEMAP","level_2":"CARTO"}', orderby = 1, alias='DEM', addparam='{"geom":"rast"}' 
WHERE id IN ('v_ext_raster_dem');

INSERT INTO sys_fprocess VALUES (438, 'Create dscenario with empty values', 'utils')
ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3134, 'gw_fct_create_dscenario_empty', 'utils', 'function', 'json', 'json', 'Function to create empty dscenario', 'role_epa', null, null) 
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, functionparams, inputparams, observ, active)
VALUES (3134, 'Create empty Dscenario', '{"featureType":[]}', '[
{"widgetname":"name", "label":"Name:","widgettype":"linetext","datatype":"text", "isMandatory":true, "tooltip":"Name for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},

{"widgetname":"descript", "label":"Descript: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Descript for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},

{"widgetname":"parent", "label":"Parent: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Parent for dscenario", "placeholder":"", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},

{"widgetname":"type", "label":"Type: (*)","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_typevalue_dscenario''", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},

{"widgetname":"active", "label":"Active:", "widgettype":"check", "datatype":"boolean", "tooltip":"If true, active" , "layoutname":"grl_option_parameters","layoutorder":5, "value":""},

{"widgetname":"expl", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"SELECT expl_id AS id, name as idval FROM v_edit_exploitation", "layoutname":"grl_option_parameters","layoutorder":6, "value":""}
]', NULL, true) 
ON CONFLICT (id) DO NOTHING;

-- 15/02/2022
UPDATE sys_style SET idval='v_edit_arc' WHERE id=101;

-- 19/02/2022
UPDATE sys_param_user SET layoutname = 'lyt_inventory', layoutorder = 20+layoutorder WHERE layoutname = 'lyt_edit';

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3194, 'The value can not be inserted',  'It is not present on a table', 2, true, 'utils', 'core') ON CONFLICT (id) DO NOTHING;
