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

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN  '{"valueRelation":{"activated":true, "layer":"cat_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_connec", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END 
WHERE (formname='v_edit_gully' OR formname ilike 've_gully%') AND columnname='connec_arccat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''GULLY''"}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''GULLY''"}}'::jsonb END 
WHERE (formname='cat_grate' OR formname='v_edit_gully' OR formname ilike 've_gully%') AND columnname='gully_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature_node", "keyColumn":"id", "valueColumn":"id", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_node' OR formname ILIKE 've_node%') and columnname='node_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''ARC''"}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''ARC''"}}'::jsonb END
WHERE (formname='v_edit_arc' OR formname ILIKE 've_arc%') and columnname='arc_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''CONNEC''"}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_feature", "keyColumn":"id", "valueColumn":"id", "filterExpression":"feature_type=''CONNEC''"}}'::jsonb END
WHERE (formname='v_edit_connec' OR formname ILIKE 've_connec%') and columnname='connec_type';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_node", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_node", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_node' OR formname ilike 've_node%') AND columnname='matcat_id';

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"cat_mat_arc", "keyColumn":"id", "valueColumn":"descript", "filterExpression":null}}'::jsonb END
WHERE (formname='v_edit_arc' OR formname ilike 've_arc%') AND columnname='matcat_id';

--2021/10/26
UPDATE config_toolbox SET inputparams = '[{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"},
{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":2,"value":0.01},
{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"stateType", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":4, 
"dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id", "selectedId":"1","isparent":"true"},
{"widgetname":"workcatId", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5, "isNullValue":false,"dvQueryText":"select id as id, id as idval from cat_work where id is not null union select null as id, null as idval order by id", "selectedId":"1"},
{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":6, "value":null},
{"widgetname":"nodeType", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null", "selectedId":"$userNodetype", "iseditable":false},
{"widgetname":"nodeCat", "label":"Node catalog:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8, "dvQueryText":"select distinct id as id, id as idval from cat_node where node_type = $userNodetype  OR node_type is null order by id", "selectedId":"$userNodecat"}]'
WHERE id=2118;