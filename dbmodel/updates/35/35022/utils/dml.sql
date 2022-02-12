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
'role_admin', true, 'utils', false, 'boolean', 'check', false, true,'core');

--2022/01/27
DELETE FROM sys_fprocess where fid in (333, 334, 335, 179);

--2022/01/31
ALTER TABLE plan_price DROP CONSTRAINT plan_price_unit_check;

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
VALUES (3132, 'gw_trg_edit_inp_timeseries', 'ud', 'function trigger', NULL, NULL, 'Allows editing inp timeseries view', 'role_epa', NULL, 'core');

UPDATE inp_pattern SET expl_id = a.expl_id FROM arc a WHERE inp_pattern.expl_id=a.sector_id;
UPDATE inp_curve SET expl_id = a.expl_id FROM arc a WHERE inp_curve.expl_id=a.sector_id;

ALTER TABLE inp_pattern ADD CONSTRAINT inp_pattern_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
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
'Selector variables', FALSE, null, 'utils', 'json') ON CONFLICT(parameter) DO NOTHING;

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('tabname_typevalue', 'tab_macrosector', 'Macrosector', 'Macrosector', null);

INSERT INTO config_form_tabs(formname, tabname, label, tooltip, sys_role, tabfunction, tabactions, device, orderby)
VALUES ('selector_basic', 'tab_macrosector', 'Macrosector', 'Macrosector', 'role_epa', NULL, NULL, 4,7);

UPDATE config_form_fields SET hidden = FALSE WHERE formname='v_edit_sector' AND columnname='macrosector_id';

UPDATE config_form_fields SET widgetcontrols = '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id",
"valueColumn": "name", "filterExpression": "sector_id > -1 AND active IS TRUE"}}' WHERE formname='v_edit_sector' and columnname='parent_id';

INSERT INTO config_typevalue(typevalue, id, idval, camelstyle, addparam)
VALUES ('sys_table_context', '{"level_1":"BASEMAP","level_2":"CARTO"}', null, '{"orderBy":24}', NULL);

UPDATE sys_table SET context='{"level_1":"BASEMAP","level_2":"CARTO"}', orderby = 1, alias='DEM', addparam='{"geom":"rast"}' 
WHERE id IN ('v_ext_raster_dem');