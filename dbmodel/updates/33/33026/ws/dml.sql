/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/22
UPDATE audit_cat_function SET return_type = 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":6, "value":"FALSE"},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update geometry (if true choose only one parameter belove)","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"buffer", "label":"1: Buffer for arc disolve approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "isMandatory":false, "placeholder":"10", "value":""},
{"widgetname":"concaveHullParam", "label":"2: Hull parameter for concave polygon approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":10, "isMandatory":false, "placeholder":"0.9", "value":""}]'
WHERE id=2706;

UPDATE audit_cat_function SET descript = 'Function of grafanalytics for massive mincutzones identification. 
Multiple analysis is avaliable. It works applying massive mincut for the whole network of selected exploitation. Mincut id =-1 is used.
To work with, be shure minsector data of the analysed network is well structured. This attribute will be used in order to optimize the analysis.
You can use minsector analysis function to update it before.  
This analysis may take a lot of time. Be patient!!!'
WHERE id=2712;

UPDATE config_param_system SET value = 'TRUE' WHERE parameter = 'om_mincut_valvestat_using_valveunaccess';

-- 2020/01/29
UPDATE audit_cat_param_user SET formname = 'hidden_value' WHERE id='inp_options_buildup_mode';

-- 2020/01/28
UPDATE config_param_system SET parameter = 'api_selector_mincut', value =
'{"table":"anl_mincut_result_cat", "selector":"anl_mincut_result_selector", "label":"id, '' ('', CASE WHEN work_order IS NULL THEN ''N/I'' ELSE work_order END, '') on '', forecast_start::date, '' at '', forecast_start::time, ''H-'', forecast_end::time,''H''"}'
WHERE parameter = 'api_selector_label';
