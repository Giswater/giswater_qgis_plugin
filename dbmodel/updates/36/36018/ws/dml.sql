/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_toolbox SET inputparams='
[
{"widgetname": "name","label": "Scenario name:","widgettype": "text","datatype": "text","layoutname": "grl_option_parameters", "layoutorder": 1, "value": ""},
{"widgetname": "descript","label": "Scenario descript:","widgettype": "text","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 2,"value": ""},
{"widgetname": "exploitation","label": "Exploitation:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT expl_id as id, name as idval FROM exploitation where expl_id>0 UNION select 99999 as id, ''ALL'' as idval order by id desc", "selectedId":"0"}, 
{"widgetname": "patternOrDate","label": "Choose time method:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","comboIds": [1,2],"comboNames": ["PERIOD ID","DATE INTERVAL"],"layoutorder": 5,"isMandatory":true},
{"widgetname": "period", "label": "if PERIOD_ID - Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 6,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period", "selectedId":"1"},
{"widgetname": "initDate","label": "[if DATE INTERVAL] Source CRM init date:","widgettype": "datetime","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 7,"value": null},
{"widgetname": "endDate","label": "[if DATE INTERVAL] Source CRM end date:","widgettype": "datetime","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 8,"value":"2015-07-30 00:00:00"},
{"widgetname": "onlyIsWaterBal","label": "Only hydrometers with waterbal true:","widgettype": "check","datatype": "boolean","layoutname": "grl_option_parameters","layoutorder": 9,"value": null},
{"widgetname": "pattern","label": "Feature pattern:","widgettype": "combo","tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 10,"comboIds": [1,2,3,4,5,6,7],"comboNames": ["NONE","SECTOR-DEFAULT","DMA-DEFAULT","DMA-PERIOD","HYDROMETER-PERIOD","HYDROMETER-CATEGORY","FEATURE-PATTERN"],"selectedId": ""},
{"widgetname": "demandUnits","label": "Demand units:","tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 11,"comboIds": ["LPS","LPM","MLD","CMH","CMD","CFS","GPM","MGD","AFD"],"comboNames": ["LPS","LPM", "MLD","CMH","CMD","CFS","GPM","MGD","AFD"],"selectedId": ""}
]'::json WHERE id=3110;

INSERT INTO config_param_user ("parameter", value, cur_user) SELECT 'epa_dscenario_percent_hydro_threshold', '10', current_user;

UPDATE sys_function SET descript='Function to create dscenarios from CRM.
This function store values on CONNEC features.
When the network geometry generator works with [NODE] demands are moved 50% to node_1 50% and node_2.'
WHERE id=3110;

UPDATE config_toolbox SET inputparams = '
[
{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text", "isMandatory":true, "tooltip":"Dscenario type", "dvQueryText":"WITH aux AS (SELECT ''ALL'' as id, ''ALL'' as idval, 1 AS rowid UNION SELECT expl_id::text as id, name as idval, row_number() over()+1 AS  rowid FROM exploitation where expl_id>0) SELECT id, idval FROM aux ORDER BY rowid ASC", "layoutname":"grl_option_parameters","layoutorder":1, "value":""},
{"widgetname":"method", "label":"Method:","widgettype":"combo","datatype":"text","isMandatory":true,"tooltip":"Water balance method", "dvQueryText":"SELECT id, idval FROM om_typevalue WHERE typevalue = ''waterbalance_method''", "layoutname":"grl_option_parameters","layoutorder":2, "value":""},
{"widgetname":"period","label": "    [if PERIOD_ID] Period:","widgettype": "combo","datatype": "text","layoutname": "grl_option_parameters","layoutorder": 4,"dvQueryText":"SELECT id, code as idval FROM ext_cat_period ORDER BY id desc","selectedId": ""},
{"widgetname":"initDate", "label":"    [if DATE INTERVAL] Period (init date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"Start date", "layoutname":"grl_option_parameters","layoutorder":5, "value":""},
{"widgetname":"endDate", "label":"    [if DATE INTERVAL] Period (end date):","widgettype":"datetime","datatype":"text", "isMandatory":true, "tooltip":"End date", "layoutname":"grl_option_parameters","layoutorder":6, "value":"1900-01-01"},
{"widgetname":"executeGraphDma", "label":"Execute DMA:","widgettype":"check","datatype":"boolean","isMandatory":true,"tooltip":"Execute DMA","layoutname":"grl_option_parameters","layoutorder":7, "value":""}
]'::JSON WHERE id = 3142;

UPDATE sys_function SET descript='Function to calculate water balance according stardards of IWA.
Before that: 
1) tables ext_cat_period, ext_rtc_hydrometer_x_data, ext_rtc_scada_x_data need to be filled.
2) DMA graph need to be executed.

>End Date proposal for 1% of hydrometers which consum is out of the period: 2015-07-31 00:00:00'
 WHERE id=3142;

INSERT INTO om_typevalue (typevalue, id, idval, descript, addparam) VALUES('waterbalance_method', 'CDI', 'CUSTOM DATE INTERVAL', NULL, NULL) ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE om_typevalue SET idval='DMA CENTROID PERIOD WINDOW' WHERE typevalue='waterbalance_method' AND id='DCW';
