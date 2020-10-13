/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/01/10
UPDATE sys_csv2pg_config SET target = 'Flow Routing continuity' WHERE target = 'Flow Routing';
UPDATE sys_csv2pg_config SET target = 'FRouting Time Step' WHERE target = 'Routing Time';

--2020/01/15
INSERT INTO audit_cat_function (id, function_name, project_type, function_type, input_params, 
       return_type, context, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2784,'gw_fct_insert_importdxf','utils','function','{"featureType":[], "btnRunEnabled":false}',
'[{"widgetname": "btn_path", "label": "Select DXF file:", "widgettype": "button",  "datatype": "text", "layoutname": "grl_option_parameters", "layout_order": 2, "value": "...","widgetfunction":"gw_function_dxf" }]',
null,'Function to manage DXF files','role_admin',FALSE,FALSE,'Manage dxf files',TRUE) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function (id, function_name, project_type, function_type, input_params, 
       return_type, context, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2786,'gw_fct_check_importdxf','utils','function',null,null, null,'Function to check the quality of imported DXF files',
'role_admin',FALSE,false,null,false) ON CONFLICT (id) DO NOTHING;


--2020/01/07
UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_grate_matcat"]}', isautoupdate = TRUE
WHERE column_id='gratecat_id ' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id"]}', isautoupdate = TRUE
WHERE column_id='connecat_id' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id"]}', isautoupdate = TRUE
WHERE column_id='nodecat_id' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["cat_matcat_id", "cat_shape", "cat_geom1", "cat_geom2"]}',
isautoupdate = TRUE
WHERE column_id='arccat_id ' and formtype='feature';

UPDATE config_api_form_fields SET reload_field = '{"reload":["sys_top_elev", "sys_ymax", "sys_elev"]}', isautoupdate = TRUE
WHERE (column_id='top_elev' or column_id='custom_top_elev' or column_id='ymax' or column_id='custom_ymax' or 
column_id='elev' or column_id='custom_elev') and formtype='feature' and (formname like 've_node%' or formname like 've_arc%');

UPDATE config_api_form_fields SET reload_field = '{"reload":["sys_y1", "sys_elev1", "z1", "r1", "slope"]}', isautoupdate = TRUE
WHERE (column_id='y1' or column_id='custom_y1' or column_id='elev1' or column_id='custom_elev1') 
and formtype='feature' and (formname like 've_node%' or formname like 've_arc%');

UPDATE config_api_form_fields SET reload_field = '{"reload":["sys_y2", "sys_elev2", "z2", "r2", "slope"]}', isautoupdate = TRUE
WHERE (column_id='y2' or column_id='custom_y2' or column_id='elev2' or column_id='custom_elev2') 
and formtype='feature' and (formname like 've_node%' or formname like 've_arc%');


--2020/01/09
SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_files') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_files');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_snowmelt') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_snowmelt');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_temperature') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_temperature');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_evaporation') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_evaporation');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_adjustments') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_adjustments');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_hydrology') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_hydrology');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_raingage') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_raingage') AND column_name!='the_geom';




INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_edit_subcatchment') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_edit_subcatchment') AND column_name!='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_aquifer') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_aquifer');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_groundwater') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_groundwater');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_hydrograph') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_hydrograph');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_snowpack') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_snowpack');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_lid_control') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_lid_control');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_lidusage_subc_x_lidco') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_lidusage_subc_x_lidco');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_dwf') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_dwf');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_inflows') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_inflows');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_rdii') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_rdii');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_transects') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_transects');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' or data_type ='double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_flwreg_orifice') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_flwreg_orifice');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' or data_type ='double precision'  THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_flwreg_weir') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_flwreg_weir');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' or data_type ='double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_flwreg_pump') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_flwreg_pump');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' or data_type ='double precision' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_flwreg_outlet') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_flwreg_outlet');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_flwreg_type') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_flwreg_type');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_pollutant') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_pollutant');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_landuses') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_landuses');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_coverage_land_x_subc') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_coverage_land_x_subc');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_buildup_land_x_pol') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_buildup_land_x_pol');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_loadings_pol_x_subc') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_loadings_pol_x_subc');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_washoff_land_x_pol') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_washoff_land_x_pol');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_inflows_pol_x_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_inflows_pol_x_node');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_dwf_pol_x_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_dwf_pol_x_node');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_treatment_node_x_pol') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_treatment_node_x_pol');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_pattern') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_pattern');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_curve_id') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_curve_id');



INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_curve') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_curve');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_timser_id') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_timser_id');


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, true, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('inp_timeseries') AND 
column_name not in (select column_id from config_api_form_fields where formname='inp_timeseries');


--rpt output


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_nodeflooding_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_nodeflooding_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_nodeinflow_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_nodeinflow_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_nodedepth_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_nodedepth_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_arcflow_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_arcflow_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_condsurcharge_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_condsurcharge_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_pumping_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_pumping_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_flowclass_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_flowclass_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_arcpolload_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_arcpolload_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_outfallflow_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_outfallflow_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_outfallload_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_outfallload_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_storagevol_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_storagevol_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_subcatchrunoff_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_subcatchrunoff_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_subcatchwasoff_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_subcatchwasoff_sum') AND column_name !='the_geom';


UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL' 
WHERE column_id='sector_id' AND 
formname in ('v_rpt_nodeflooding_sum' ,'v_rpt_nodedepth_sum','v_rpt_arcflow_sum',
'v_rpt_condsurcharge_sum' ,'v_rpt_pumping_sum', 'v_rpt_flowclass_sum' ,'v_rpt_arcpolload_sum', 
'v_rpt_outfallflow_sum', 'v_rpt_outfallload_sum', 'v_rpt_storagevol_sum','v_rpt_subcatchrunoff_sum',
'v_rpt_subcatchwasoff_sum', 'v_rpt_lidperfomance_sum');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_rainfall_dep') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_rainfall_dep') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_runoff_qual') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_runoff_qual') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_runoff_quant') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_runoff_quant') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_groundwater_cont') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_groundwater_cont') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_flowrouting_cont') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_flowrouting_cont') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_qualrouting') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_qualrouting') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_continuity_errors') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_continuity_errors') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_high_cont_errors') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_high_cont_errors') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_critical_elements') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_critical_elements') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_timestep_critelem') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_timestep_critelem') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_instability_index') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_instability_index') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_high_flowinest_ind') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_high_flowinest_ind') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_routing_timestep') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_routing_timestep') AND column_name !='the_geom';

--rpt compare


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_nodeflooding_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_nodeflooding_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_nodeinflow_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_nodeinflow_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_nodedepth_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_nodedepth_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_arcflow_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_arcflow_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_condsurcharge_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_condsurcharge_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_pumping_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_pumping_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_flowclass_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_flowclass_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_arcpolload_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_arcpolload_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_outfallflow_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_outfallflow_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_outfallload_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_outfallload_sum') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_storagevol_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_storagevol_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_subcatchrunoff_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_subcatchrunoff_sum') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_subcatchwasoff_sum') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_subcatchwasoff_sum') AND column_name !='the_geom';


UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT sector_id as id,name as idval FROM sector WHERE sector_id IS NOT NULL' 
WHERE column_id='sector_id' AND 
formname in ('v_rpt_comp_nodeflooding_sum' ,'v_rpt_comp_nodedepth_sum','v_rpt_comp_arcflow_sum',
'v_rpt_comp_condsurcharge_sum' ,'v_rpt_comp_pumping_sum', 'v_rpt_comp_flowclass_sum' ,'v_rpt_comp_arcpolload_sum', 
'v_rpt_comp_outfallflow_sum', 'v_rpt_comp_outfallload_sum', 'v_rpt_comp_storagevol_sum','v_rpt_comp_subcatchrunoff_sum',
'v_rpt_comp_subcatchwasoff_sum', 'v_rpt_comp_lidperfomance_sum');

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_rainfall_dep') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_rainfall_dep') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_runoff_qual') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_runoff_qual') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_runoff_quant') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_runoff_quant') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_groundwater_cont') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_groundwater_cont') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_flowrouting_cont') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_flowrouting_cont') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_qualrouting') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_qualrouting') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_continuity_errors') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_continuity_errors') AND column_name !='the_geom';

INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_high_cont_errors') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_high_cont_errors') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_critical_elements') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_critical_elements') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_timestep_critelem') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_timestep_critelem') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_instability_index') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_instability_index') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_high_flowinest_ind') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_high_flowinest_ind') AND column_name !='the_geom';


INSERT INTO config_api_form_fields (formname, formtype, column_id,isenabled, datatype, widgettype, label, ismandatory, 
iseditable, isparent, isautoupdate)
SELECT table_name, 'form',column_name, true, 
CASE WHEN data_type = 'character varying' or data_type = 'json' or data_type IS NULL THEN 'string'
WHEN data_type = 'numeric' THEN 'double' 
WHEN data_type = 'smallint' THEN 'integer'
else data_type END AS datattype,
CASE WHEN data_type='boolean' THEN 'check'
ELSE 'text' END AS widgettype,
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_rpt_comp_routing_timestep') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_rpt_comp_routing_timestep') AND column_name !='the_geom';


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
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_flow_connec') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_flow_connec') AND column_name !='the_geom';

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
column_name, false, false, false, false FROM information_schema.columns
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('v_anl_flow_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='v_anl_flow_arc') AND column_name !='the_geom';


UPDATE config_api_form_fields set widgettype='combo', 
dv_querytext='SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL'
WHERE column_id='expl_id' AND formname IN ('v_anl_flow_connec','v_anl_flow_arc');

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_mat_arc') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_mat_arc') AND column_name !='the_geom';

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_node') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_node') AND column_name !='the_geom';

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_connec') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_connec') AND column_name !='the_geom';

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_mat_grate') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_mat_grate') AND column_name !='the_geom';

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_node_shape') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_node_shape') AND column_name !='the_geom';

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_arc_shape') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_arc_shape') AND column_name !='the_geom' 
AND column_name != '_tsect_id' AND column_name != '_curve_id';

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
WHERE table_schema = 'SCHEMA_NAME' AND table_name IN ('cat_grate') AND 
column_name not in (select column_id from config_api_form_fields where formname='cat_grate') AND column_name !='the_geom' 
AND column_name != '_tsect_id' AND column_name != '_curve_id';

UPDATE config_api_form_fields set widgettype='combo', dv_isnullvalue=true,
dv_querytext='SELECT id as id, id as idval FROM gully_type WHERE id IS NOT NULL'
WHERE column_id='gully_type' AND formname IN ('cat_grate');