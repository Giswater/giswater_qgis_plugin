/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
UPDATE sys_feature_epa_type SET active = true;
UPDATE sys_feature_epa_type SET active = false WHERE id IN('PUMP-IMPORTINP','VALVE-IMPORTINP', 'INLET');

UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''ARC'''  WHERE columnname = 'epa_type' AND formname like '%_arc%';
UPDATE config_form_fields SET dv_querytext = 'SELECT id, id as idval FROM sys_feature_epa_type WHERE active AND feature_type = ''NODE'''  WHERE columnname = 'epa_type' AND formname like '%_node%';

DELETE FROM sys_table WHERE id = 'inp_rules_controls_importinp';

UPDATE cat_feature_node SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE cat_feature_arc SET epa_default  ='UNDEFINED' WHERE epa_default  ='NOT DEFINED';
UPDATE sys_feature_epa_type SET id  ='UNDEFINED' WHERE id  ='NOT DEFINED';
UPDATE arc SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';
UPDATE node SET epa_type ='UNDEFINED' WHERE epa_type  ='NOT DEFINED';

--2021/03/29
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


UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘REGISTER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’MINSECTOR' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’DQA' WHERE type = ‘NETELEMENT' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘REGISTER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘EXPANSIONTANK' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘FILTER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’MINSECTOR' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘FLEXUNION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’DMA' WHERE type = ‘METER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’MINSECTOR' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘HYDRANT' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘MANHOLE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘NETELEMENT' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘NETSAMPLEPOINT' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’PRESSZONE' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’PRESSZONE' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’PRESSZONE' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘METER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘PUMP' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘REDUCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘REGISTER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’MINSECTOR' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’SECTOR' WHERE type = ‘SOURCE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’SECTOR' WHERE type = ‘TANK' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’MINSECTOR' WHERE type = ‘VALVE' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘REGISTER' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘NETWJOIN' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’SECTOR' WHERE type = ‘WATERWELL' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’SECTOR' WHERE type = ‘WTP' AND grafconfig IS NULL;
UPDATE cat_feature_node SET grafconfig=’NONE' WHERE type = ‘JUNCTION' AND grafconfig IS NULL;
