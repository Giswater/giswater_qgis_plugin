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
INSERT INTO config_typevalue VALUES ('sys_table_context','CATALOG', null, '{"orderBy":1}');
INSERT INTO config_typevalue VALUES ('sys_table_context','MAPZONE', null, '{"orderBy":2}');
INSERT INTO config_typevalue VALUES ('sys_table_context','NETWORK', null, '{"orderBy":3}');
INSERT INTO config_typevalue VALUES ('sys_table_context','O&M', null, '{"orderBy":4}');
INSERT INTO config_typevalue VALUES ('sys_table_context','EPA', null, '{"orderBy":5}');
INSERT INTO config_typevalue VALUES ('sys_table_context','PLAN', null, '{"orderBy":6}');
INSERT INTO config_typevalue VALUES ('sys_table_context','ADMIN', null, '{"orderBy":7}');


UPDATE sys_table SET context = NULL, alias = NULL, orderby = null;
UPDATE sys_table SET context = '{"level_1":"CATALOG"}', alias = upper(id) WHERE id like 'cat_%' AND sys_role !=  'role_epa';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'EXPLOITATION' WHERE id= 'v_edit_exploitation';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'SECTOR' WHERE id= 'v_edit_sector';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'DMA' WHERE id= 'v_edit_dma';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'PRESSZONE' WHERE id= 'v_edit_presszone';
UPDATE sys_table SET context = '{"level_1":"MAPZONE"}', alias = 'DQA' WHERE id= 'v_edit_dqa';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"ARC"}', alias = cat_feature.id FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'ARC';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"NODE"}', alias = cat_feature.id FROM cat_feature  WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'NODE';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"CONNEC"}', alias = cat_feature.id FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'CONNEC';
UPDATE sys_table SET context = '{"level_1":"NETWORK", "level_2":"GULLY"}', alias = cat_feature.id  FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'GULLY';
UPDATE sys_table SET context = '{"level_1":"O&M"}' WHERE sys_role = 'role_om';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"CATALOG"}' WHERE id like 'cat_%' AND sys_role = 'role_epa';
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"INPUT"}' , alias = s.id FROM sys_feature_epa_type s WHERE sys_table.id = concat('v_edit_',epa_table);
UPDATE sys_table SET context = '{"level_1":"EPA", "level_2":"RESULT"}', alias = id WHERE id like 'v_rpt_%' AND sys_role = 'role_epa';
UPDATE sys_table SET context = '{"level_1":"PLAN"}' , alias = id WHERE sys_role = 'role_plan';
UPDATE sys_table SET context = '{"level_1":"ADMIN"}', alias = id WHERE sys_role = 'role_admin';


INSERT INTO config_form_fields VALUES ('search', 'form_feature', 'main', 'hydro_contains', 'lyt_data_1', NULL, 'string', 'nowidget', 'Use contains', 'Check: allow to search using any of the characters. Unchecked: the search engine only will return results when matching the first characters (useful for short numbers)', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}',NULL,NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_sector','form_feature', 'main', 'parent_id', null, null, 'string', 'combo', 'parent_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline":false}', NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
