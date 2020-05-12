/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_param_system(parameter, value, data_type, context, descript, label, project_type, isdeprecated)
VALUES ('plan_statetype_planned', '3', 'integer', 'plan', 'State type for planned elements', 'State type for planned elements', 'utils', false) 
-- in case existing
ON CONFLICT (parameter) DO NOTHING;

--in case existing
UPDATE  config_param_system SET label='State type for planned elements', project_type='utils', isdeprecated=FALSE WHERE parameter='plan_statetype_planned';

UPDATE value_state_type SET is_operative=false WHERE state=0;


UPDATE audit_cat_function SET input_params='{"featureType":[]}' WHERE input_params='{"featureType":""}';
UPDATE audit_cat_function SET input_params='{"featureType":["node"]}' WHERE input_params='{"featureType":"node"}';
UPDATE audit_cat_function SET input_params='{"featureType":["connec"]}' WHERE input_params='{"featureType":"connec"}';
UPDATE audit_cat_function SET input_params='{"featureType":["arc"]}' WHERE input_params='{"featureType":"arc"}';


INSERT INTO sys_fprocess_cat VALUES (68,'Update elevation from DEM', 'edit','Update elevation from DEM','utils');

INSERT INTO audit_cat_function(id, function_name, project_type, function_type, input_params,return_type, descript, sys_role_id, isdeprecated, 
istoolbox, alias, isparametric)
VALUES (2760, 'gw_fct_update_elevation_from_dem', 'utils', 'function','{"featureType":["node","connec","vnode"]}',
'[{"widgetname":"exploitation", "label":"Exploitation:", "widgettype":"text", "datatype":"integer","layoutname":"grl_option_parameters","layout_order":1,"value":null},
{"widgetname":"updateValues", "label":"Update values:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":4,
"comboIds":["allValues","nullValues"],"comboNames":["allValues", "nullValues"],"comboNames":["Update all values","Update only null values"], "selectedId":"allValues"}]',
'Function that updates the values of elevation using ones captured from raster DEM', 'role_edit', false, true,'Capture elevation from DEM',true);

INSERT INTO config_param_system( parameter, value, data_type, context, descript, label, isenabled, project_type, isdeprecated)
VALUES ('sys_raster_dem', 'FALSE','boolean','edit','Use raster DEM for elevation values', 'Raster DEM', false, 'utils', false);

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id, label, isenabled, layout_id, layout_order, 
project_type, isparent, isautoupdate, datatype, widgettype,ismandatory, isdeprecated)
VALUES ('edit_upsert_elevation_from_dem','config','If true, the the elevation will be automatically inserted from the DEM raster',
'role_edit', 'Elevation from DEM:', true, 5,7,'utils',false,false,'boolean','check',false,false);

ALTER TABLE edit_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO edit_typevalue (typevalue, id, idval) VALUES ('raster_type', 'DEM','DEM');
INSERT INTO edit_typevalue (typevalue, id, idval) VALUES ('raster_type', 'Slope','Slope');

INSERT INTO typevalue_fk(typevalue_table, typevalue_name, target_table, target_field)
VALUES ('edit_typevalue', 'raster_type', 'cat_raster', 'raster_type');

UPDATE sys_feature_type SET parentlayer = 'v_edit_vnode' WHERE id='VNODE';