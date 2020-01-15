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