/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE sys_function SET descript='Check topology assistant. Analyze and validate the length of arcs for potential inconsistencies or errors.' WHERE id=3052;

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb, addparam = '{"pkey": "element_id"}' WHERE id='ve_genelem';

-- 03/07/2025
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3482, 'gw_fct_graphanalytics_macromapzones', 'utils', 'function', 'json', 'json', 'Function to analyze network as a macro graph.', 'role_om', NULL, 'core', NULL);

DELETE FROM config_form_fields where columnname='undelete';

UPDATE config_toolbox SET inputparams='[{"label":"Direct insert into node table:","value":null,"datatype":"boolean","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"insertIntoNode","widgettype":"check","layoutorder":1},{"label":"Node tolerance:","value":null,"datatype":"float","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"nodeTolerance","widgettype":"spinbox","layoutorder":2},{"label":"Exploitation ids:","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"exploitation","widgettype":"combo","dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name","layoutorder":3},{"label":"State:","value":null,"datatype":"integer","isparent":"true","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"stateType","widgettype":"combo","dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id","layoutorder":4},{"label":"Workcat:","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"workcatId","widgettype":"combo","dvQueryText":"select id as id, id as idval from cat_work where id is not null","isNullValue":true,"layoutorder":5},{"label":"Builtdate:","value":null,"datatype":"date","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"builtdate","widgettype":"datetime","layoutorder":6},{"label":"Node type:","isparent":true,"value":null,"datatype":"text","iseditable":true,"layoutname":"grl_option_parameters","selectedId":"$userNodetype","widgetname":"nodeType","widgettype":"combo","dvQueryText":"select distinct cfn.id as id, cfn.id as idval from cat_feature_node cfn JOIN cat_node cn ON cn.node_type=cfn.id where cfn.id is not null","layoutorder":7},{"label":"Node catalog:","dvparentid":"node_type","dvquerytext_filterc":" AND value_state_type.state","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":"$userNodecat","widgetname":"nodeCat","widgettype":"combo","dvQueryText":"select distinct id as id, id as idval from cat_node order by id","parentname":"nodeType","filterquery":"select distinct id as id, id as idval from cat_node where node_type = ''{parent_value}'' order by id","layoutorder":8}]'::json WHERE id=2118;

-- 08/07/2025
INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4140,'The specified feature type is not supported: %feature_type%','Must be ''FEATURE'' or ''ELEMENT''',2,true,'utils','core','UI');

