/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/06/18
INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role)
VALUES (2970, 'gw_fct_grafanalytics_mapzones_config','ws', 'function','json', 'json', 'Function to automatically configure mapzones.', 'role_master')
ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox(id, alias, isparametric, functionparams, inputparams, observ, active)
VALUES (2970, 'Config mapzones', true,'{"featureType":[]}', '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DMA"],"comboNames":["District Metering Areas (DMA)"], "selectedId":"DMA"}, {"widgetname":"mapzoneAddfield", "label":"Mapzone field name:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":2, "value":"c_sector"}]',
null, true) ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type)
VALUES (249, 'Config mapzones', 'ws') ON CONFLICT (fid) DO NOTHING;
