/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/10/21

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (410, 'Create dscenario from ToC','ws', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_function(id, function_name, project_type, function_type, input_params, 
return_type, descript, sys_role, sample_query, source)
VALUES (3104, 'gw_fct_create_dscenario_from_toc', 'ws', 'function', 'json', 
'json', 'Function to create dscenario getting values from some layer of ToC, including inp layers of EPA group', 'role_epa', null, null) ON CONFLICT (id) DO NOTHING;

INSERT INTO config_toolbox VALUES (3104, 'Create Dscenario with values from ToC','{"featureType":["node", "arc"]}',
'[{"widgetname":"name", "label":"Scenario name:", "widgettype":"text","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"value":""},
  {"widgetname":"type", "label":"Scenario type:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":2, "dvQueryText":"SELECT id, idval FROM inp_typevalue where typevalue = ''inp_typevalue_dscenario''", "selectedId":""}]',
  NULL,TRUE)  ON CONFLICT (id) DO NOTHING;
  
  
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (411, 'Mandatory nodarc over other EPA node','ws', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (412, 'Shortpipe nodarc over other EPA node','ws', null, null) ON CONFLICT (fid) DO NOTHING;

INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (413, 'EPA connec over EPA node','ws', null, null) ON CONFLICT (fid) DO NOTHING;


--2021/10/26
UPDATE config_function SET actions = $$[{"funcName": "set_style_mapzones", "params": {}}]$$ WHERE id = 2710;

UPDATE config_form_fields SET widgetcontrols = CASE WHEN widgetcontrols IS NULL THEN '{"valueRelation":{"activated":true, "layer":"v_edit_inp_pattern", "keyColumn":"pattern_id", "valueColumn":"pattern_id", "filterExpression":null}}'
ELSE widgetcontrols::jsonb ||'{"valueRelation":{"activated":true, "layer":"v_edit_inp_pattern", "keyColumn":"pattern_id", "valueColumn":"pattern_id", "filterExpression":null}}'::jsonb END 
WHERE formtype = 'form_feature' AND formname !='inp_pattern' AND (columnname='pattern_id' or columnname='pattern');

UPDATE config_toolbox SET inputparams = '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layoutorder":1,"comboIds":["DMA","PRESSZONE","SECTOR"],"comboNames":["District Metering Areas (DMA)","Pressure zones (PRESSZONE)", "Inlet sectors (SECTOR)"], "selectedId":""}, {"widgetname":"mapzoneField", "label":"Mapzone field name:","widgettype":"text","datatype":"string","layoutname":"grl_option_parameters","layoutorder":2, "value":""}]'
WHERE id = 2970;

UPDATE sys_function SET descript = 'Function to configure mapzones. 
To execute it, system has two requirements:
 - Mapzone need to be created
 - Closest arcs need appropiate values on mapzonefield'
WHERE id = 2970;

INSERT INTO config_param_system (parameter, value, descript, project_type) 
VALUES ('utils_grafanalytics_automatic_config', 'FALSE', 'Variable to automatize inserts into config_graf_valve acording with graf_delimiter value of cat_feature_node', 'ws');