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


INSERT INTO config_param_system (parameter, value, data_type, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated) 
VALUES ('om_dynamicmapzones_status', '{"SECTOR":false, "DMA":false, "PRESSZONE":false, "DQA":false, "MINSECTOR":false}', 'json', 'system', 'Dynamic mapzones', 'Dynamic mapzones', TRUE, 'ws', 'string', 'linetext', true, false) ON CONFLICT (parameter) DO NOTHING;

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2790, 'gw_fct_grafanalytics_check_data', 'ws','function', '{"featureType":[]}',
'[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"},
{"widgetname":"selectionMode", "label":"Selection mode:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":2,"comboIds":["userSelectors","wholeSystem"],
"comboNames":["Users selection (expl & state & psector)", "Whole system"], "selectedId":"userSelectors"}]',
'Function to analyze data quality of grafclass', 'role_om',FALSE, TRUE, 'Check data for grafanalytics process', TRUE)
ON conflict (id) DO NOTHING;

UPDATE audit_cat_param_user SET isenabled = true , description = 'If true, allows to force arcs downgrade although they have other connected elements. Is a dynamic param because only code switchs the values (when is used tool to downgrade features',
formname='dynamic_param' WHERE id = 'edit_arc_downgrade_force';


INSERT INTO sys_fprocess_cat(id, fprocess_name, context, project_type)
VALUES (111,'Backup and restore tables','admin', 'utils') ON CONFLICT (id) DO NOTHING;


INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params, return_type, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2792, 'gw_fct_admin_manage_backup', 'utils','function', null, null, 'Function to manage backups for specific table to use it to help admin when does a complex operation with data', 'role_om',FALSE, FALSE, null, FALSE)
ON conflict (id) DO NOTHING;



--2020/01/09
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);
--masterplan
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_plan_result_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_plan_result_node') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_plan_result_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_plan_result_arc') AND column_name !='the_geom';



INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('plan_arc_x_pavement') AND 
column_name not in (select column_id from config_api_form_fields where formname='plan_arc_x_pavement') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id as id, id as idval FROM cat_pavement WHERE id IS NOT NULL' 
WHERE column_id='pavcat_id' AND formname = 'plan_arc_x_pavement';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_plan_psector') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_plan_psector') AND column_name !='the_geom';

SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_plan_current_psector') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_plan_current_psector') AND column_name !='the_geom';


UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL' 
WHERE column_id='sector_id' AND formname IN ('v_plan_result_node','v_plan_result_arc','v_edit_plan_psector','v_plan_current_psector');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, name as idval FROM value_state WHERE id IS NOT NULL' 
WHERE column_id='state' AND formname IN ('v_plan_result_node','v_plan_result_arc');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL'
WHERE column_id='expl_id' AND formname IN ('v_plan_result_node','v_plan_result_arc','v_edit_plan_psector','v_plan_current_psector');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, id as idval FROM value_priority WHERE id IS NOT NULL'
WHERE column_id='priority' AND formname IN ('v_edit_plan_psector','v_plan_current_psector');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, name as idval FROM plan_psector_cat_type WHERE id IS NOT NULL'
WHERE column_id='psector_type' AND formname IN ('v_edit_plan_psector','v_plan_current_psector');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('price_compost') AND 
column_name not in (select column_id from config_api_form_fields where formname='price_compost') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, id as idval FROM price_value_unit WHERE id IS NOT NULL'
WHERE column_id='unit' AND formname IN ('price_compost');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT id, id as idval FROM price_cat_simple WHERE id IS NOT NULL'
WHERE column_id='pricecat_id' AND formname IN ('price_compost');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('price_compost_value') AND 
column_name not in (select column_id from config_api_form_fields where formname='price_compost_value') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, id as idval FROM price_compost WHERE id IS NOT NULL'
WHERE column_id='simple_id' AND formname IN ('price_compost_value');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, id as idval FROM price_compost WHERE id IS NOT NULL'
WHERE column_id='compost_id' AND formname IN ('price_compost_value');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('price_value_unit') AND 
column_name not in (select column_id from config_api_form_fields where formname='price_value_unit') AND column_name !='the_geom';

--basemap
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('ext_municipality') AND 
column_name not in (select column_id from config_api_form_fields where formname='ext_municipality') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_ext_address') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_ext_address') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_ext_streetaxis') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_ext_streetaxis') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_ext_plot') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_ext_plot') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', ismandatory=true,
dv_querytext='SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL'
WHERE column_id='expl_id' AND formname IN ('v_ext_address','v_ext_streetaxis','v_ext_plot');

UPDATE config_api_form_fields set widgettype='combo', ismandatory=true,
dv_querytext='SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL'
WHERE column_id='muni_id' AND formname IN ('v_ext_address','v_ext_streetaxis','v_ext_plot');

UPDATE config_api_form_fields set widgettype='combo', ismandatory=true,
dv_querytext='SELECT id as id, name as idval FROM ext_streetaxis WHERE id IS NOT NULL'
WHERE column_id='streetaxis_id' AND formname IN ('v_ext_address','v_ext_plot');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT id as id, id as idval FROM ext_type_street WHERE id IS NOT NULL'
WHERE column_id='type' AND formname IN ('v_ext_streetaxis');

--mapzones
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_dma') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_dma') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL'
WHERE column_id='pattern_id' AND formname IN ('v_edit_dma');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_exploitation') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_exploitation') AND column_name !='the_geom';


UPDATE config_api_form_fields set widgettype='combo',ismandatory=true,
dv_querytext='SELECT macroexpl_id as id, name as idval FROM macroexploitation WHERE macroexpl_id IS NOT NULL'
WHERE column_id='macroexpl_id' AND formname IN ('v_edit_exploitation');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_sector') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_sector') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_macrodma') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_macrodma') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_macrosector') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_macrosector') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('macroexploitation') AND 
column_name not in (select column_id from config_api_form_fields where formname='macroexploitation') AND column_name !='the_geom';

--inventory
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_element') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_element') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo',ismandatory=true,
dv_querytext='SELECT macroexpl_id as id, name as idval FROM macroexploitation WHERE macroexpl_id IS NOT NULL'
WHERE column_id='dma_id' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL' 
WHERE column_id='sector_id' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', ismandatory=true,
dv_querytext='SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL',
dv_parent_id='state', dv_querytext_filterc=' AND value_state_type.state='
WHERE column_id='state_type' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL'
WHERE column_id='ownercat_id' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT id, id as idval FROM cat_builder WHERE id IS NOT NULL'
WHERE column_id='buildercat_id' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE (featurecat_id is null AND feature_type=''ELEMENT'') '
WHERE column_id='location_type' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE (featurecat_id is null AND feature_type=''ELEMENT'') '
WHERE column_id='category_type' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE (featurecat_id is null AND feature_type=''ELEMENT'') '
WHERE column_id='fluid_type' AND formname IN ('v_edit_element');

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT id, id as idval FROM value_verified WHERE id IS NOT NULL'
WHERE column_id='verified' AND formname IN ('v_edit_element');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_dimensions') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_dimensions') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', ismandatory=true, isparent=true,
dv_querytext='SELECT id, name as idval FROM value_state WHERE id IS NOT NULL' 
WHERE column_id='state' AND formname IN ('v_edit_element','v_edit_dimensions');

UPDATE config_api_form_fields set widgettype='combo', ismandatory=true,
dv_querytext='SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL'
WHERE column_id='expl_id' AND formname IN ('v_edit_element','v_edit_dimensions');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_samplepoint') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_samplepoint') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric'or data_type = 'double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_link') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_link') AND column_name !='the_geom';


--om

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_om_visit') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_om_visit') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL'
WHERE column_id='expl_id' AND formname IN ('v_edit_om_visit');

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id as id, name as idval FROM om_visit_cat WHERE id IS NOT NULL'
WHERE column_id='visitcat_id' AND formname IN ('v_edit_om_visit');


--catalogs
INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_mat_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_mat_node') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_mat_element') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_mat_element') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_element') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_element') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_owner') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_owner') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_soil') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_soil') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_pavement') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_pavement') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_work') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_work') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_builder') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_builder') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_brand_model') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_brand_model') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_brand') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_brand') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_users') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_users') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type = 'ARRAY' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('ext_cat_period') AND 
column_name not in (select column_id from config_api_form_fields where formname='ext_cat_period') AND column_name !='the_geom';

UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT id, idval FROM ext_cat_period_type WHERE id IS NOT NULL'
WHERE column_id='period_type' AND formname IN ('ext_cat_period');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' or data_type = 'bigint' THEN 'integer'
WHEN data_type='timestamp without time zone' THEN 'date'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('ext_cat_hydrometer') AND 
column_name not in (select column_id from config_api_form_fields where formname='ext_cat_hydrometer') AND column_name !='the_geom';