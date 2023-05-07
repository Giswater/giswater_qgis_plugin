/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

update config_toolbox
set inputparams='
[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
{"widgetname":"descript", "label":"Scenario descript:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2,"value":""}, 
{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":4, "dvQueryText":"SELECT expl_id as id, name as idval FROM v_edit_exploitation", "selectedId":""}, 
{"widgetname":"period", "label":"Source CRM period:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":6, "dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "selectedId":""},
{"widgetname":"pattern", "label":"Feature pattern:","widgettype":"combo","tooltip":"This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.", "datatype":"text","layoutname":"grl_option_parameters","layoutorder":7,"comboIds":[1,2,3,4,5,6,7], "comboNames":["NONE", "SECTOR-DEFAULT", "DMA-DEFAULT", "DMA-PERIOD","HYDROMETER-PERIOD","HYDROMETER-CATEGORY", "CONNEC-PATTERN"], "selectedId":""}, 
{"widgetname":"demandUnits", "label":"Demand units:","tooltip": "Choose units to insert volume data on demand column. <br> This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":8 ,"comboIds":["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"], "comboNames":["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"], "selectedId":""}]'
WHERE id=3110;