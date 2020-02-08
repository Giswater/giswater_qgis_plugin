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
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":8,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"CONCAVE POLYGON: 0.85, PIPE BUFFER: 10", "value":""}]',
descript = 'Function to analyze graf of network. Multiple analysis is avaliable.  On advanced mode multi exploitation is avaliable and update mapzones geometry is enabled. Dynamic analisys to sectorize network using the flow traceability function. 
Before work with this funcion it is mandatory to configurate field graf_delimiter on node_type and field grafconfig on [dma, sector, cat_presszone and dqa] tables.
Standard values for parameter are:
- Concave hull on  CONCAVE POLYGON method: 0.85 (0.5-0.99)
- Buffer for pipes PIPE BUFFER method (mts): 5-50
- Buffer for pipes ON PLOT & PIPE BUFFER method when there is not any plot associated to mapzone (mts): 5-50'
WHERE function_name ='gw_fct_grafanalytics_mapzones_advanced';


UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":6, "value":"FALSE"},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layout_order":8,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"CONCAVE POLYGON: 0.85, PIPE BUFFER: 10", "value":""}]',
descript = 'Dynamic analisys to sectorize network using the flow traceability function. Before work with this funcion it is mandatory to configurate field graf_delimiter on node_type and field grafconfig on [dma, sector, cat_presszone and dqa] tables.
Standard values for parameter are:
- Concave hull on  CONCAVE POLYGON method: 0.85 (0.5-0.99)
- Buffer for pipes PIPE BUFFER method (mts): 5-50
- Buffer for pipes ON PLOT & PIPE BUFFER method when there is not any plot associated to mapzone (mts): 5-50'
WHERE id=2706;
