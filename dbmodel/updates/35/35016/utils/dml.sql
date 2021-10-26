/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/14
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (408, 'Import istram nodes','ud', null, null) ON CONFLICT (fid) DO NOTHING ;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (409, 'Import istram arcs','ud', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3104, 'gw_fct_import_istram', 'ud', 'function', 'json', 
'json', 'Function to import arcs and nodes from istram files', 'role_edit', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message(id, error_message, hint_message, log_level, show_user, project_type, source)
VALUES (3190, 'There are no nodes defined as arcs finals','First insert csv file with nodes definition', 2, true, 'ud',null) ON CONFLICT (id) DO NOTHING;

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE formname='cat_node' AND (columnname='nodetype_id' OR columnname='node_type');

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_node", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_node", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE formname='cat_node' AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''ARC''"}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''ARC''"}}'::jsonb END 
WHERE formname='cat_arc' AND (columnname='arctype_id' OR columnname='arc_type') ;

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE formname in ('cat_arc', 'cat_mat_roughness') AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''CONNEC''"}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''CONNEC''"}}'::jsonb END 
WHERE formname='cat_connec' AND (columnname='connectype_id' OR columnname = 'connec_type');

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END 
WHERE formname='cat_connec' AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_sector", "keyColumn":"sector_id", "valueColumn":"name", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_sector", "keyColumn":"sector_id", "valueColumn":"name", "filterExpression":null}}'::jsonb END 
WHERE formtype = 'form_feature' AND columnname='sector_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_dma", "keyColumn":"dma_id", "valueColumn":"name", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_dma", "keyColumn":"dma_id", "valueColumn":"name", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND columnname='dma_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_exploitation", "keyColumn":"expl_id", "valueColumn":"name", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_exploitation", "keyColumn":"expl_id", "valueColumn":"name", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND columnname='expl_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_presszone", "keyColumn":"presszone_id", "valueColumn":"name", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_presszone", "keyColumn":"presszone_id", "valueColumn":"name", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND columnname='presszone_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_dqa", "keyColumn":"dqa_id", "valueColumn":"name", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_dqa", "keyColumn":"dqa_id", "valueColumn":"name", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature'  AND columnname='dqa_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND columnname='nodecat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_arc", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_arc", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND  columnname='arccat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND columnname='connecat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_inp_curve", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}' 
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_inp_curve", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE formtype = 'form_feature' AND columnname='curve_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_inp_pattern", "keyColumn":"pattern_id", "valueColumn":"pattern_id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_inp_pattern", "keyColumn":"pattern_id", "valueColumn":"pattern_id", "filterExpression":null}}'::jsonb END 
WHERE formtype = 'form_feature' AND formname !='inp_pattern' AND (columnname='pattern_id' or columnname='pattern');

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_dscenario", "keyColumn":"dscenario_id", "valueColumn":"name", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_dscenario", "keyColumn":"dscenario_id", "valueColumn":"name", "filterExpression":null}}'::jsonb END 
WHERE  formtype = 'form_feature' AND formname !='cat_dscenario' AND columnname='dscenario_id';

update plan_psector set active=true WHERE active is null;

UPDATE sys_function SET source=null WHERE source='giswater';

UPDATE config_toolbox SET 
	inputparams = '[{"widgetname":"resultId", "label":"Result Id:","widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT result_id as id, result_id as idval FROM rpt_cat_result WHERE status > 0","layoutname":"grl_option_parameters","layoutorder":1,"selectedId":"$userInpResult"}]'
	WHERE id IN (2848, 2858);

UPDATE sys_table SET sys_role='role_basic' WHERE source='selector_sector';

-- 26/10/2021
UPDATE config_form_tableview SET columnindex=1 WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'cur_user';
UPDATE config_form_tableview SET columnindex=2 WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'exec_date';
UPDATE config_form_tableview SET columnindex=0 WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'result_id';
UPDATE config_form_tableview SET columnindex=7 WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'rpt_stats';
UPDATE config_form_tableview SET columnindex=3 WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'status';
UPDATE config_form_tableview SET columnindex=4, visible = False WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'export_options';
UPDATE config_form_tableview SET columnindex=6, visible = False WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'inp_options';
UPDATE config_form_tableview SET columnindex=5, visible = False WHERE location_type = 'epa_toolbar' AND tablename = 'v_ui_rpt_cat_result' and columnname = 'network_stats';

INSERT INTO config_function (id, function_name) VALUES (2796, 'gw_fct_getselectors');
