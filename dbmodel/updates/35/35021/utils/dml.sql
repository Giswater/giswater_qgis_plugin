/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
UPDATE sys_param_user SET source = 'core' WHERE source IS NULL;
UPDATE sys_param_user SET source = 'core' WHERE source ='giswater';

UPDATE sys_fprocess SET source = 'core' WHERE source IS NULL;
UPDATE sys_fprocess SET source = 'core' WHERE source ='giswater';

UPDATE sys_function SET source = 'core' WHERE source IS NULL;
UPDATE sys_function SET source = 'core' WHERE source ='giswater';

UPDATE sys_message SET source = 'core' WHERE source IS NULL;
UPDATE sys_message SET source = 'core' WHERE source ='giswater';

UPDATE sys_table SET source = 'core' WHERE source IS NULL;
UPDATE sys_table SET source = 'core' WHERE source ='giswater';

UPDATE config_toolbox SET inputparams = 
'[{"widgetname":"target", "label":"Target:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":1, "selectedId":""},
  {"widgetname":"action", "label":"Action:", "widgettype":"combo", "datatype":"text", "comboIds":["DELETE-COPY", "KEEP-COPY", "DELETE-ONLY"], "comboNames":["DELETE VALUES & COPY FROM", "KEEP VALUES & COPY FROM", "DELETE SCENARIO"], "layoutname":"grl_option_parameters","layoutorder":2, "selectedId":""},
  {"widgetname":"copyFrom", "label":"Copy from:", "widgettype":"combo", "datatype":"text", "dvQueryText":"SELECT dscenario_id as id, name as idval FROM cat_dscenario WHERE active IS TRUE", "layoutname":"grl_option_parameters","layoutorder":3, "selectedId":"$userDscenario"}
  ]'
WHERE id = 3042;



--2022/01/03
UPDATE sys_table SET context = NULL, alias = NULL, orderby = null;
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Feature catalog' , orderby=1 WHERE id ='cat_feature';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Node feature catalog' , orderby=2 WHERE id ='cat_feature_node';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Node material catalog' , orderby=3 WHERE id ='cat_mat_node';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Node catalog' , orderby=4 WHERE id ='cat_node';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Arc material catalog' , orderby=5 WHERE id ='cat_mat_arc';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Arc catalog' , orderby=6 WHERE id ='cat_arc';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Connec catalog' , orderby=7 WHERE id ='cat_connec';
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = 'Grate catalog' , orderby=8 WHERE id ='cat_grate';

UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'Exploitation', orderby=1 WHERE id= 'v_edit_exploitation';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'Sector', orderby=2 WHERE id= 'v_edit_sector';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'DMA' , orderby=3 WHERE id= 'v_edit_dma';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'Presszone', orderby=4 WHERE id= 'v_edit_presszone';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'DQA' , orderby=5 WHERE id= 'v_edit_dqa';

UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"ARC"}', alias = initcap(cat_feature.id) FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'ARC';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"NODE"}', alias = initcap(cat_feature.id) FROM cat_feature  WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'NODE';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"CONNEC"}', alias = initcap(cat_feature.id) FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'CONNEC';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"GULLY"}', alias = initcap(cat_feature.id)  FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'GULLY';

UPDATE sys_table SET context = '{"level_1":"O&M"}' WHERE sys_role = 'role_om';

UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Hydrology catalog' , orderby=1 WHERE id ='v_edit_inp_hydrology';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'DWF catalog' , orderby=2 WHERE id ='v_edit_inp_dwf';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Dscenario catalog' , orderby=3 WHERE id ='v_edit_cat_dscenario';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Roughness catalog' , orderby=4 WHERE id ='cat_mat_roughness';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Curve catalog' , orderby=5 WHERE id ='v_edit_inp_curve';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Pattern catalog' , orderby=6 WHERE id ='v_edit_inp_pattern';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' , alias = 'Timeseries catalog' , orderby=7 WHERE id ='v_edit_inp_timeseries';

UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"INPUT"}' , alias = initcap(s.id) FROM sys_feature_epa_type s WHERE sys_table.id = concat('v_edit_',epa_table);
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"RESULT"}', alias = initcap(replace(id,'v_rpt_','')) WHERE id like 'v_rpt%' and id not in (SELECT id FROM sys_table WHERE id like 'v_rpt_comp%');


UPDATE sys_table SET context = '{"level_1":"PLAN"}' , alias = 'Plan psector', orderby = 1 WHERE id = 'v_edit_plan_psector';
UPDATE sys_table SET context = '{"level_1":"PLAN"}' , alias = 'Plan current psector', orderby = 2 WHERE id = 'v_plan_current_psector';
UPDATE sys_table SET context = '{"level_1":"PLAN"}' , alias = 'Arc pavement', orderby = 3 WHERE id = 'plan_arc_x_pavement';


INSERT INTO config_typevalue VALUES ('sys_table_context','CATALOG', null, '{"orderBy":1}');
INSERT INTO config_typevalue VALUES ('sys_table_context','MAPZONE', null, '{"orderBy":2}');
INSERT INTO config_typevalue VALUES ('sys_table_context','NETWORK', null, '{"orderBy":3}');
INSERT INTO config_typevalue VALUES ('sys_table_context','O&M', null, '{"orderBy":4}');
INSERT INTO config_typevalue VALUES ('sys_table_context','EPA', null, '{"orderBy":5}');
INSERT INTO config_typevalue VALUES ('sys_table_context','PLAN', null, '{"orderBy":6}');
INSERT INTO config_typevalue VALUES ('sys_table_context','ADMIN', null, '{"orderBy":7}');


INSERT INTO config_form_fields VALUES ('search', 'form_feature', 'main', 'hydro_contains', 'lyt_data_1', NULL, 'string', 'nowidget', 'Use contains', 'Check: allow to search using any of the characters. Unchecked: the search engine only will return results when matching the first characters (useful for short numbers)', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}',NULL,NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_sector','form_feature', 'main', 'parent_id', null, null, 'string', 'combo', 'parent_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}', 
NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

UPDATE sys_fprocess set project_type='utils' where fid=213;
UPDATE sys_function set project_type='utils' where id=2720;