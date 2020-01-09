/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET function_name = 'gw_fct_plan_check_data' WHERE id=2436;


UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update geometry (if true choose only one parameter belove)","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"buffer", "label":"1: Buffer for arc disolve approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "isMandatory":false, "placeholder":"10", "value":""},
{"widgetname":"concaveHullParam", "label":"2: Hull parameter for concave polygon approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"0.9", "value":""}]' 
WHERE id=2768;


UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update geometry (if true choose only one parameter belove)","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"buffer", "label":"1: Buffer for arc disolve approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "isMandatory":false, "placeholder":"10", "value":""},
{"widgetname":"concaveHullParam", "label":"2: Hull parameter for concave polygon approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"0.9", "value":""}]'
WHERE id=2706;