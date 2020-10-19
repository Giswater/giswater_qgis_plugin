/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/09/18
UPDATE config_toolbox SET  inputparams =
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","tooltip": "Grafanalytics method used", "layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":""}, 

{"widgetname":"exploitation", "label":"Exploitation:","widgettype":"combo","datatype":"text","tooltip": "Choose exploitation to work with", "layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"$userExploitation"},

{"widgetname":"floodFromNode", "label":"Flood from node: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative parameter to constraint algorithm to work only flooding from any node on network, used to define only the related mapzone", "placeholder":"1015", "layoutname":"grl_option_parameters","layoutorder":3, "value":""},

{"widgetname":"forceOpen", "label":"Force open nodes: (*)","widgettype":"linetext","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary open closed node(s) in order to force algorithm to continue there", "placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":4, "value":""},

{"widgetname":"forceClosed", "label":"Force closed nodes: (*)","widgettype":"text","datatype":"text", "isMandatory":false, "tooltip":"Optative node id(s) to temporary close open node(s) to force algorithm to stop there","placeholder":"1015,2231,3123", "layoutname":"grl_option_parameters","layoutorder":5,"value":""},

{"widgetname":"usePlanPsector", "label":"Use selected psectors:", "widgettype":"check","datatype":"boolean","tooltip":"If true, use selected psectors. If false ignore selected psectors and only works with on-service network" , "layoutname":"grl_option_parameters","layoutorder":6,"value":""},

{"widgetname":"updateMapZone", "label":"Mapzone constructor method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":7,
"comboIds":[0,1,2,3,4], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER", "LINK & PIPE BUFFER"], "selectedId":"4"}, 

{"widgetname":"geomParamUpdate", "label":"Pipe buffer","widgettype":"text","datatype":"float","tooltip":"Buffer from arcs to create mapzone geometry using [PIPE BUFFER] options. Normal values maybe between 3-20 mts.", "layoutname":"grl_option_parameters","layoutorder":8, "isMandatory":false, "placeholder":"5-30", "value":""}]'
WHERE id = 2768;

UPDATE config_toolbox SET  inputparams =
'[{"widgetname":"exploitation", "label":"Exploitation ids:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"1"}]'
WHERE id = 2826;

UPDATE sys_function SET  descript =
'Function to analyze network as a graf. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configurate:
- Field graf_delimiter on [node_type] table. 
- Field grafconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_grafanalytics_status on [config_param_system] table.
Stop your mouse over label for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_grafanalytics_automatic_trigger variable on [config_param_system] table.'
WHERE id = 2768;

INSERT INTO config_param_system (parameter, value, descript, label, isenabled, project_type) VALUES ('utils_grafanalytics_automatic_trigger', '{"status":"false", "parameters":{"updateMapZone":2, "geomParamUpdate":10, "usePlanPsector":false}}', 'Automatic trigger of graf analytics used when valve status is modified (open or close)', 'Automatic grafanalytics trigger', true, 'ws')
ON CONFLICT (parameter) DO NOTHING;

UPDATE config_form_fields SET iseditable=FALSE WHERE columnname IN ('nodetype_1', 'nodetype_2', 'elevation1', 'elevation2', 'depth1', 'depth2') AND formname like 've_arc%';

-- 2020/10/06
UPDATE inp_demand SET feature_type = 'NODE';

UPDATE inp_typevalue SET idval = 'ALWAYS OVERWRITE DEMAND & PATT' WHERE typevalue = 'inp_options_dscenario_priority' AND id = '1';
UPDATE inp_typevalue SET idval = 'ONLY OVERWRITE NULL DEMANDS' WHERE typevalue = 'inp_options_dscenario_priority' AND id = '2';
UPDATE inp_typevalue SET idval = 'JOIN DEMANDS & OVERWRITE PATT' WHERE typevalue = 'inp_options_dscenario_priority' AND id = '3';

UPDATE config_fprocess SET fid = 239 WHERE tablename = 'vi_demands';

