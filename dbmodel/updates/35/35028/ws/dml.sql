/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/31
UPDATE sys_param_user SET vdefault = '{"forceReservoirsOnInlets":true,"setDemand":true,"checkResult":true,"onlyIsOperative":true,"delDisconnNetwork":false,"removeDemandOnDryNodes":false,"breakPipes":{"status":false, "maxLength":10, "removeVnodeBuffer":1},"graphicLog":"true","steps":0,"autoRepair":true}'
WHERE id = 'inp_options_debug';

DELETE FROM sys_function where function_name = 'gw_fct_pg2epa_inlet_flowtrace';

UPDATE config_toolbox SET inputparams = b.inp FROM
(SELECT json_agg(a.inputs::json) AS inp FROM
(SELECT json_array_elements_text(inputparams) as inputs
FROM config_toolbox
WHERE id=2768
union select concat('{"widgetname":"commitChanges", "label":"Commit changes:", "widgettype":"check","datatype":"boolean","tooltip":"If true, changes will be applied to DB. If false, algorithm results will be saved in anl tables" , "layoutname":"grl_option_parameters","layoutorder":',maxord+1,',"value":""}')
from (select max(d.layoutord::integer) as maxord from
(SELECT json_extract_path_text(json_array_elements(inputparams),'layoutorder') as layoutord
FROM config_toolbox
WHERE id=2768)d where layoutord is not null)e)a)b WHERE id=2768;

UPDATE sys_function SET descript='Function to analyze network as a graph. Multiple analysis is avaliable (SECTOR, DQA, PRESSZONE & DMA). Before start you need to configurate:
- Field graph_delimiter on [cat_feature_node] table. 
- Field graphconfig on [dma, sector, cat_presszone and dqa] tables.
- Enable status for variable utils_graphanalytics_status on [config_param_system] table.
Stop your mouse over labels for more information about input parameters.
This function could be automatic triggered by valve status (open or closed) by configuring utils_graphanalytics_automatic_trigger variable on [config_param_system] table.'
WHERE id=2768;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active)
VALUES (3008, 'Arc reverse', '{"featureType":["arc"]}',null, null, TRUE)
ON CONFLICT (id) DO NOTHING;

UPDATE cat_feature_node SET isprofilesurface = false WHERE isprofilesurface IS NULL;


--2022/09/13
UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_demand' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_pipe' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_connec' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_controls' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_inlet' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_junction' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_pump' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_pump_additional' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_reservoir' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_rules' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_shortpipe' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_tank' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_valve' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":false, "layer": "v_edit_cat_dscenario", "activated": true, "keyColumn": "dscenario_id", "valueColumn": "name", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_virtualvalve' AND columnname ='dscenario_id';

UPDATE config_form_fields SET widgetcontrols = '{"valueRelation":{"nullValue":true, "layer": "v_edit_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}' 
WHERE formname = 'v_edit_inp_dscenario_demand' AND columnname ='pattern_id';