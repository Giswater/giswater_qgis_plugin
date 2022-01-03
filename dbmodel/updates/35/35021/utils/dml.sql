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
UPDATE sys_table SET qgis_toc = 'Catalog' WHERE id like 'cat_%' AND sys_role !=  'role_epa';
UPDATE sys_table SET qgis_toc = 'Mapzone' WHERE id in ('v_edit_exploitation', 'v_edit_sector', 'v_edit_dma', 'v_edit_dqa', 'v_edit_presszone');
UPDATE sys_table SET qgis_toc = 'Arc' FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'ARC';
UPDATE sys_table SET qgis_toc = 'Node'FROM cat_feature  WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'NODE';
UPDATE sys_table SET qgis_toc = 'Connec' FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'CONNEC';
UPDATE sys_table SET qgis_toc = 'Gully' FROM cat_feature WHERE sys_table.id = cat_feature.child_layer AND feature_type = 'GULLY';
UPDATE sys_table SET qgis_toc = 'EPA Catalog' WHERE id like 'cat_%' AND sys_role = 'role_epa';

INSERT INTO config_form_fields VALUES ('search', 'form_feature', 'main', 'hydro_contains', 'lyt_data_1', NULL, 'string', 'nowidget', 'Use contains', 'Check: allow to search using any of the characters. Unchecked: the search engine only will return results when matching the first characters (useful for short numbers)', NULL, FALSE, FALSE, FALSE, FALSE, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{"setMultiline":false}',NULL,NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;

INSERT INTO config_form_fields(formname, formtype, tabname, columnname, layoutname, layoutorder, datatype, widgettype, label, tooltip, placeholder, ismandatory, 
isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, 
widgetcontrols, widgetfunction, linkedobject, hidden)
VALUES ('v_edit_sector','form_feature', 'main', 'parent_id', null, null, 'string', 'combo', 'parent_id', NULL, NULL,  FALSE,
FALSE, TRUE, FALSE,FALSE,'SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL AND active IS TRUE ', TRUE, TRUE, NULL, NULL,NULL,
'{"setMultiline": false, "valueRelation":{"nullValue":false, "layer": "v_edit_sector", "activated": true, "keyColumn": "sector_id", "valueColumn": "name", "filterExpression": null}}', 
NULL, NULL, FALSE) ON CONFLICT (formname, formtype, columnname, tabname) DO NOTHING;
