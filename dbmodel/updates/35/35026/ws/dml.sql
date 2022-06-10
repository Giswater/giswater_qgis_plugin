/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/07
update config_toolbox
set inputparams='[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":3, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""},
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""},
{"widgetname":"descript", "label":"Descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":5,"value":""}]' 
WHERE id=3108;

UPDATE om_mincut_node SET node_type=nodetype_id FROM node JOIN cat_node cn ON cn.id=nodecat_id WHERE node.node_id=om_mincut_node.node_id;
UPDATE om_mincut_connec SET customer_code=a.customer_code FROM connec a WHERE a.connec_id=om_mincut_connec.connec_id;