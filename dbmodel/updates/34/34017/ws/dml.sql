/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/14
UPDATE sys_table SET id = 'config_valve' WHERE id = 'config_mincut_valve';


UPDATE config_toolbox SET inputparams  = 
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},
{"widgetname":"forceOpen", "label":"Force Open nodes:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":3, "isMandatory":false, "placeholder":"[1,2,3]", "value":""},
{"widgetname":"forceClose", "label":"Force Close nodes:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":4,"isMandatory":false, "placeholder":"[1,2,3]", "value":""},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":6,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":8, "isMandatory":false, "placeholder":"5-30", "value":""}]'
WHERE id = 2768;


SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);
 
 SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);
