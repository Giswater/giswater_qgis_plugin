/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/02/06
UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"1"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":8,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"5-30", "value":""}]',
descript = 'Function to analyze graf of network. Multiple analysis is avaliable.  On advanced mode multi exploitation is avaliable and update mapzones geometry is enabled. Dynamic analisys to sectorize network using the flow traceability function. 
Before work with this funcion it is mandatory to configurate field graf_delimiter on node_type and field grafconfig on [dma, sector, cat_presszone and dqa] tables.
A standard value for PIPE BUFFER maybe: 5-30 (mts)'
WHERE function_name ='gw_fct_grafanalytics_mapzones_advanced';



UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":6, "value":"FALSE"},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":8,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"5-30", "value":""}]',
descript = 'Dynamic analisys to sectorize network using the flow traceability function. Before work with this funcion it is mandatory to configurate field graf_delimiter on node_type and field grafconfig on [dma, sector, cat_presszone and dqa] tables.
A standard value for PIPE BUFFER maybe: 5-30 (mts)'
WHERE id=2706;


UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":2, 
"dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name", "selectedId":"1"}]'
WHERE id=2766;


UPDATE audit_cat_param_user SET vdefault = '{"dma":"c:\users\user\dmaline.qml", "dqa":"c:\users\user\dqaline.qml", "sector":"c:\users\user\sectorline.qml", "cat_presszone":"c:\users\user\presszoneline.qml", "minsector":"c:\users\user\minsectorline.qml"}'
WHERE id = 'qgis_qml_linelayer_path';

UPDATE audit_cat_param_user SET vdefault = '{"dma":"c:\users\user\dmapoint.qml", "dqa":"c:\users\user\dqapoint.qml", "sector":"c:\users\user\sectorpoint.qml", "cat_presszone":"c:\users\user\presszonepoint.qml","minsector":"c:\users\user\minsectorpoint.qml"}'
WHERE id = 'qgis_qml_pointlayer_path';

UPDATE audit_cat_param_user SET vdefault = '{"dma":"c:\users\user\dmapol.qml", "dqa":"c:\users\user\dqapol.qml", "sector":"c:\users\user\sectorpol.qml", "cat_presszone":"c:\users\user\presszonepol.qml","minsector":"c:\users\user\minsectorpol.qml"}'
WHERE id = 'qgis_qml_polygonlayer_path';


