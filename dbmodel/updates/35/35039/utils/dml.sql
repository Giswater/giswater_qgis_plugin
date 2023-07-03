/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

UPDATE config_toolbox SET inputparams = '[{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":1,"value":"true"},
{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layoutorder":2,"value":0.01},
{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name"},
{"widgetname":"stateType", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":4, 
"dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id", "selectedId":"1","isparent":"true"},
{"widgetname":"workcatId", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5, "isNullValue":false,"dvQueryText":"select id as id, id as idval from cat_work where id is not null union select null as id, null as idval order by id", "selectedId":"1"},
{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datetime","datatype":"date","layoutname":"grl_option_parameters","layoutorder":6, "value":null},
{"widgetname":"nodeType", "label":"Node type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":7, "dvQueryText":"select distinct id as id, id as idval from cat_feature_node where id is not null", "selectedId":"$userNodetype", "iseditable":false},
{"widgetname":"nodeCat", "label":"Node catalog:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8, "dvQueryText":"select distinct id as id, id as idval from cat_node where nodetype_id = $userNodetype  OR nodetype_id is null order by id", "selectedId":"$userNodecat"}]' 
WHERE id = 2118;


UPDATE config_form_fields set dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''ELEMENT'' AND active IS TRUE'
WHERE columnname='location_type' AND formname = 'v_edit_element';

UPDATE config_form_fields set dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''ELEMENT'' AND active IS TRUE',
dv_orderby_id=true, dv_isnullvalue=true
WHERE columnname='function_type' AND formname = 'v_edit_element';

UPDATE config_form_fields set dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type=''ELEMENT'' AND active IS TRUE'
WHERE columnname='category_type' AND formname = 'v_edit_element';

UPDATE config_form_fields set dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type=''ELEMENT'' AND active IS TRUE'
WHERE columnname='fluid_type' AND formname = 'v_edit_element';

UPDATE config_typevalue SET addparam=camelstyle::json WHERE typevalue='sys_table_context';
UPDATE config_typevalue SET camelstyle=null WHERE typevalue='sys_table_context';