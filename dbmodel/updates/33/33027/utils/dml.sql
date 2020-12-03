/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/03

UPDATE audit_cat_function SET 
return_type ='[{"widgetname":"state_type", "label":"State:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":3, "dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by state, id", "selectedId":"2","isparent":"true"},{"widgetname":"workcat_id", "label":"Workcat:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":4, "dvQueryText":"select id as id, id as idval from cat_work where id is not null order by id", "selectedId":"1"},{"widgetname":"builtdate", "label":"Builtdate:", "widgettype":"datepickertime","datatype":"date","layoutname":"grl_option_parameters","layout_order":5, "value":null },{"widgetname":"arc_type", "label":"Arc type:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":6, "dvQueryText":"select distinct id as id, id as idval from arc_type where id is not null order by id", "selectedId":"1"},{"widgetname":"node_type", "label":"Node type:", "widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":7, "dvQueryText":"select distinct id as id, id as idval from node_type where id is not null order by id", "selectedId":"1"},{"widgetname":"topocontrol", "label":"Active topocontrol:", "widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"true"}, {"widgetname": "btn_path", "label": "Select DXF file:", "widgettype": "button",  "datatype": "text", "layoutname": "grl_option_parameters", "layout_order": 9, "value": "...","widgetfunction":"gw_function_dxf" }]',
descript='This function to import dxf files into a Giswater schema works using the DXF layername(s) AS Giswater catalogs. 
If catalog does not exists, the process will propose to create a new one. It has two steps:
- STEP 1: A preview of data is showed. Topological information is provided in order to show user the topological consistency of dxf data.
- STEP 2: User can run or cancel the importation process.',
sys_role_id='role_edit', istoolbox=true where function_name='gw_fct_insert_importdxf';


--2020/02/04

UPDATE audit_cat_function SET return_type ='[{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"text", "datatype":"integer","layoutname":"grl_option_parameters","layout_order":1,"value":null},{"widgetname":"insertIntoNode", "label":"Direct insert into node table:", "widgettype":"check", "datatype":"boolean","layoutname":"grl_option_parameters","layout_order":2,"value":"true"},{"widgetname":"nodeTolerance", "label":"Node tolerance:", "widgettype":"spinbox","datatype":"float","layoutname":"grl_option_parameters","layout_order":3,"value":0.01}]'
where function_name='gw_fct_built_nodefromarc';
