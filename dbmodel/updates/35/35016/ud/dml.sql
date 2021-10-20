/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/10/14
INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (408, 'Import istram nodes', null, 'gw_fct_import_istram', false, 10, NULL) ON CONFLICT (fid) DO NOTHING;

INSERT INTO config_csv(fid, alias, descript, functionname, active, orderby, addparam)
VALUES (409, 'Import istram arcs', null, 'gw_fct_import_istram', false, 11, NULL) ON CONFLICT (fid) DO NOTHING;


UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_grate", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_grate", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE formname='cat_grate' AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_grate", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_grate", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END 
WHERE formtype = 'form_feature' AND  (columnname='gratecat_id' or columnname='gratecat2_id');

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_gully", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_gully", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END 
WHERE (formname='v_edit_gully' OR formname ilike 've_gully%') AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN  '{"valueRelation":{"activated":true, "layer":"cat_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END 
WHERE (formname='v_edit_gully' OR formname ilike 've_gully%') AND columnname='connec_arccat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature_gully", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature_gully", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END 
WHERE (formname='cat_grate' OR formname='v_edit_gully' OR formname ilike 've_gully%') AND columnname='gully_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_node' OR formname ILIKE 've_node%') and columnname='node_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature_arc", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature_arc", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_arc' OR formname ILIKE 've_arc%') and columnname='arc_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_connec' OR formname ILIKE 've_connec%') and columnname='connec_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_node", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_node", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_node' OR formname ilike 've_node%') AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_arc' OR formname ilike 've_arc%') AND columnname='matcat_id';