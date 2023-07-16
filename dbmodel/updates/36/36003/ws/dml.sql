/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, source)
VALUES (3250, 'gw_trg_edit_minsector', 'ws', 'trigger function', NULL, NULL, 'Allows editing minsector view', 'role_edit', NULL, 'core');

UPDATE sys_style SET idval = 'v_edit_minsector' WHERE  idval = 'v_minsector';
UPDATE sys_table SET id = 'v_edit_minsector' WHERE  id = 'v_minsector';
UPDATE config_function SET layermanager = '{"visible": ["v_edit_minsector"]}' WHERE  id = 2706;

UPDATE config_toolbox SET inputparams = 
'[{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":1, "placeholder":"[1,2]", "value":""},
{"widgetname":"sector", "label":"Sector id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layoutorder":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"usePsectors", "label":"Use masterplan psectors:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":6, "value":"FALSE"},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layoutorder":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update mapzone geometry method:","widgettype":"combo","datatype":"integer","layoutname":"grl_option_parameters","layoutorder":8,
"comboIds":[0,1,2,3], "comboNames":["NONE", "CONCAVE POLYGON", "PIPE BUFFER", "PLOT & PIPE BUFFER"], "selectedId":"2"}, 
{"widgetname":"geomParamUpdate", "label":"Update parameter:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layoutorder":10, "isMandatory":false, "placeholder":"5-30", "value":""}]'
WHERE id = 2706;