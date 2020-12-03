/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO cat_mat_grate
SELECT DISTINCT matcat_id FROM cat_grate WHERE matcat_id IS NOT NULL;

UPDATE audit_cat_function SET isdeprecated=TRUE where id=1248;

UPDATE audit_cat_param_user SET vdefault='NO' WHERE id='inp_report_input';
UPDATE audit_cat_param_user SET vdefault='NONE' WHERE id='inp_report_nodes';
UPDATE audit_cat_param_user SET vdefault='NONE' WHERE id='inp_report_subcatchments';
UPDATE audit_cat_param_user SET vdefault='NONE' WHERE id='inp_report_links';

UPDATE inp_timser_id SET idval = id;

UPDATE audit_cat_param_user SET dv_querytext='SELECT id, idval FROM inp_timser_id WHERE timser_type=''Rainfall''',vdefault=null, 
dv_isnullvalue=true, layout_id=2, layout_order=14, layoutname='grl_general_2' WHERE id='inp_options_setallraingages';

UPDATE audit_cat_param_user SET layoutname='grl_general_1', layout_id=1, layout_order=68, vdefault=null, dv_isnullvalue=true WHERE id='inp_options_dwfscenario';

UPDATE audit_cat_param_user SET layout_order=2 WHERE id='inp_options_rtc_period_id';

INSERT INTO audit_cat_table VALUES ('om_visit_lot_x_gully', 'O&M', 'Table of gullys related to lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vp_basic_gully', 'Auxiliar view', 'Auxiliar view for gullys with id and type', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_gully', 'Editable view', 'Editable view for gullys', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_chamber', 'Editable view', 'Editable view for chamber polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_gully', 'Editable view', 'Editable view for gully polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_netgully', 'Editable view', 'Editable view for netgully polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_storage', 'Editable view', 'Editable view for storage polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_wwtp', 'Editable view', 'Editable view for wwtp polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('plan_psector_x_gully', 'masterplan', 'Table of gullys related to plan sectors', 'role_master', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_arc_x_vnode', 'Auxiliar', 'Shows the relation between arc and vnodes', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_ui_event_x_gully', 'User interface view', 'User interface view for gullys related to its events', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_lot_x_gully', 'O&M', 'View that relates gullys and lots', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('cat_mat_grate', 'Catalog', 'Material''s grate catalog', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);


UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id, descript","featureType":["cat_grate"]}]' WHERE id ='cat_mat_grate';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node","v_edit_inp_divider","v_edit_inp_junction",  "v_edit_inp_outfall"]}]' WHERE id ='cat_node';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "v_edit_inp_outlet", "v_edit_inp_orifice", "v_edit_inp_conduit", "v_edit_inp_pump",  "v_edit_inp_weir"]}]' WHERE id ='cat_arc';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_canvas", "enabled":"true", "trg_fields":"the_geom","featureType":["gully"]}]' WHERE id = 'gully';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["gully"]}]' WHERE id ='cat_grate';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc"]}]' WHERE id ='arc_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node"]}]' WHERE id ='node_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["connec"]}]' WHERE id ='connec_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["gully"]}]' WHERE id ='gully_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='cat_builder';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='cat_owner';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='cat_soil';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='cat_work';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"dma_id,name","featureType":["arc", "node", "connec", "gully","v_edit_link", "v_edit_vnode","v_edit_element", "v_edit_samplepoint"]}]' WHERE id ='dma';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"expl_id, name","featureType":["arc", "node", "connec", "gully","v_edit_link", "v_edit_vnode","v_edit_element", "v_edit_samplepoint","v_edit_raingage", "v_edit_inp_outlet", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_orifice", "v_edit_inp_virtual"]}]' 
WHERE id ='exploitation';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='ext_address';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"muni_id, name","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='ext_municipality';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='ext_plot';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='ext_streetaxis';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"sector_id, name","featureType":["arc", "node", "connec", "gully","v_edit_link", 
"v_edit_vnode","v_edit_element", "v_edit_samplepoint","v_edit_subcatchment","v_edit_inp_outlet", "v_edit_inp_pump", "v_edit_inp_weir", "v_edit_inp_orifice", "v_edit_inp_virtual",
"v_edit_inp_conduit", "v_edit_inp_divider","v_edit_inp_junction", "v_edit_inp_outfall","v_edit_inp_storage"]}]' WHERE id ='sector';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='value_state_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec", "gully"]}]' WHERE id ='value_verified';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"rg_id","featureType":["v_edit_subcatchment"]}]' 
WHERE id ='raingage';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"pattern_id","featureType":["inp_aquifer", "inp_inflows", "inp_inflows_pol_x_node",  "inp_dwf_pol_x_node"]}]' 
WHERE id='inp_pattern';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["v_edit_raingage", "inp_inflows", "inp_inflows_pol_x_node","inp_timeseries"]}]' 
WHERE id='inp_timser_id';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"arc_id","featureType":["v_edit_subcatchment"]}]' 
WHERE id='inp_outlet';

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"snow_id","featureType":["v_edit_subcatchment", "inp_snowpack"]}]' 
WHERE id='inp_snowpack_id';

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"hydrology_id,name","featureType":["v_edit_subcatchment"]}]' 
WHERE id='cat_hydrology';

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"aquif_id","featureType":["inp_groundwater"]}]' 
WHERE id='inp_aquifer';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"lidco_id","featureType":["inp_lidusage_subc_x_lidco"]}]' 
WHERE id='inp_lid_control';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id, idval","featureType":["inp_dwf","inp_dwf_pol_x_node"]}]' 
WHERE id='cat_dwf_scenario';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["inp_rdii"]}]' 
WHERE id='inp_hydrograph_id';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["inp_transects"]}]' 
WHERE id='inp_transects_id';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["inp_flwreg_pump", "v_edit_inp_pump", "inp_flwreg_outlet", "v_edit_inp_outlet", "inp_curve","v_edit_inp_divider","v_edit_inp_storage"]}]'
 WHERE id='inp_curve_id';	

 UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"poll_id","featureType":["inp_pollutant", "inp_buildup_land_x_pol", "inp_loadings_pol_x_subc", "inp_washoff_land_x_pol", "inp_inflows_pol_x_node","inp_dwf_pol_x_node", "inp_treatment_node_x_pol"]}]' 
WHERE id='inp_pollutant';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"landus_id","featureType":["inp_coverage_land_x_subc", "inp_buildup_land_x_pol", "inp_washoff_land_x_pol"]}]' 
WHERE id='inp_landuses';	


UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"category_type, feature_type","featureType":["arc", "node", "connec","gully"]}]' WHERE id ='man_type_category';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"fluid_type, feature_type","featureType":["arc", "node", "connec","gully"]}]' WHERE id ='man_type_fluid';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"function_type, feature_type","featureType":["arc", "node", "connec","gully"]}]' WHERE id ='man_type_function';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"location_type, feature_type","featureType":["arc", "node", "connec","gully"]}]' WHERE id ='man_type_location';

INSERT INTO inp_typevalue VALUES ('inp_typevalue_temp', 'WINDSPEED MONTHLY', 'WINDSPEED MONTHLY');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_temp', 'WINDSPEED FILE', 'WINDSPEED FILE');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_temp', 'ADC IMPERVIOUS', 'ADC IMPERVIOUS');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_temp', 'ADC PERVIUOS', 'ADC PERVIUOS');
DELETE FROM inp_typevalue WHERE typevalue = 'inp_typevalue_temp' AND id = 'ADC';
DELETE FROM inp_typevalue WHERE typevalue = 'inp_typevalue_temp' AND id = 'WINDSPEED';
DELETE FROM inp_typevalue WHERE typevalue = 'inp_typevalue_temp' AND id = 'MONTHLY';
INSERT INTO inp_typevalue VALUES ('inp_typevalue_snow', 'PLOWABLE', 'PLOWABLE');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_snow', 'IMPERVIOUS', 'IMPERVIOUS');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_snow', 'PERVIOUS', 'PERVIOUS');
INSERT INTO inp_typevalue VALUES ('inp_typevalue_snow', 'REMOVAL', 'REMOVAL	');

INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_snow', 'inp_snowpack', 'snow_type ', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_temp', 'inp_temperature', 'temp_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_timeseries', 'inp_timser_id', 'times_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_timserid', 'inp_timser_id', 'timser_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_divider', 'inp_divider', 'divider_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_curve', 'inp_curve_id', 'curve_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_files_actio', 'inp_files', 'actio_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_files_type', 'inp_files', 'file_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_storage', 'inp_storage', 'storage_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_outlet', 'inp_outlet', 'outlet_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_outfall', 'inp_outfall', 'outfall_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_orifice', 'inp_orifice', 'ori_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_orifice', 'inp_orifice', 'shape', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_pattern', 'inp_pattern', 'pattern_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_evap', 'inp_evaporation', 'evap_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_report', 'flowstats', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_report', 'controls', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_report', 'input', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_report', 'continuity', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_allnone', 'inp_report', 'subcatchments', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_allnone', 'inp_report', 'nodes', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_allnone', 'inp_report', 'links', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_weirs', 'inp_weir', 'weir_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_weir', 'flap', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_lidcontrol', 'inp_lid_control', 'lidco_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_status', 'inp_flwreg_pump', 'status', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_outlet', 'inp_flwreg_outlet', 'outlet_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_weirs', 'inp_flwreg_weir', 'weir_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_yesno', 'inp_flwreg_weir', 'flap', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_status', 'inp_pump', 'status', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_mapunits', 'inp_mapunits', 'type_units', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_pollutants', 'inp_pollutant', 'units_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_typevalue_raingage', 'raingage', 'rgage_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_raingage', 'raingage', 'form_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_washoff', 'inp_washoff_land_x_pol', 'funcw_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_routeto', 'subcatchment', 'routeto', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_buildup', 'inp_buildup_land_x_pol', 'funcb_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_catarc', 'cat_arc_shape', 'epa', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_inflows', 'inp_inflows_pol_x_node', 'form_type', NULL);
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field, parameter_id) VALUES ('inp_typevalue', 'inp_value_options_in', 'cat_hydrology', 'infiltration', NULL);

DELETE FROM audit_cat_param_user WHERE id='visitclass_vdefault_gully';


UPDATE inp_typevalue SET id = 'RECT-CLOSED' WHERE typevalue = 'inp_value_orifice' AND idval = 'RECT-CLOSED';

--vdefaults for man_type
INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id,label, dv_querytext, isenabled, layout_id, layout_order,project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, isdeprecated)
VALUES ('gully_location_vdefault', 'config', 'Default value of location type for gully', 'role_edit', 'Gully location:', 
'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type=''GULLY'' and featurecat_id IS NULL',true, 19,4,'ud',
false, false, 'string','combo',false,true,false);

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id,label, dv_querytext, isenabled, layout_id, layout_order,project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, isdeprecated)
VALUES ('gully_category_vdefault', 'config', 'Default value of category type for gully', 'role_edit', 'Gully category:', 
'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type=''GULLY'' and featurecat_id IS NULL',true, 20,4,'ud',
false, false, 'string','combo',false,true,false);

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id,label, dv_querytext, isenabled, layout_id, layout_order,project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, isdeprecated)
VALUES ('gully_fluid_vdefault', 'config', 'Default value of fluid type for gully', 'role_edit', 'Gully fluid:', 
'SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type=''GULLY'' and featurecat_id IS NULL',true, 18,4,'ud',
false, false, 'string','combo',false,true,false);

INSERT INTO audit_cat_param_user(id, formname, description, sys_role_id,label, dv_querytext, isenabled, layout_id, layout_order,project_type, isparent, isautoupdate, datatype, widgettype, ismandatory, dv_isnullvalue, isdeprecated)
VALUES ('gully_function_vdefault', 'config', 'Default value of function type for gully', 'role_edit', 'Gully function:', 
'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type=''GULLY'' and featurecat_id IS NULL',true, 21,4,'ud',
false, false, 'string','combo',false,true,false);

INSERT INTO config_param_system ( parameter, value, data_type, context, descript, label, dv_querytext, dv_filterbyfield, isenabled, layout_id, layout_order, project_type, dv_isparent, isautoupdate, datatype, widgettype,tooltip) VALUES ('api_search_gully', '{"sys_table_id":"v_edit_gully", "sys_id_field":"gully_id", "sys_search_field":"code", "alias":"Gullys", "cat_field":"gratecat_id", "orderby":"3", "feature_type":"gully_id"}', NULL, 'api_search_network', NULL, 'api_search_gully:', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) ON CONFLICT (parameter) DO NOTHING;



INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_storage');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_orifice');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_inflows');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_lidcontrol');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_weirs');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_routeto');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_pattern');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_catarc');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_files_type');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_outlet');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_timeseries');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_files_actio');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_raingage');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_yesno');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_divider');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_washoff');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_temp');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_curve');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_pollutants');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_timserid');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_allnone');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_treatment');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_status');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_raingage');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_evap');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_orifice');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_mapunits');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_value_buildup');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_outfall');
INSERT INTO sys_typevalue_cat(typevalue_table, typevalue_name) VALUES ('inp_typevalue','inp_typevalue_snow');

INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('edit_gully_force_automatic_connect2network', TRUE, current_user);

UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_node_elevation_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_node_depth_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_arc_y1_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_arc_y2_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_arc_geom1_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_arc_geom2_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_node_top_elev_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_node_ymax_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_node_geom1_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_node_geom2_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_connec_y1_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_connec_y2_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_connec_geom1_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_connec_geom2_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_gully_top_elev_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_gully_ymax_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_gully_sandbox_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_gully_connec_geom1_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_gully_connec_geom2_tol';
UPDATE config_param_system SET isenabled=FALSE WHERE parameter='rev_gully_units_tol';

UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='inp_windspeed ';


UPDATE audit_cat_param_user SET feature_field_id = 'gully_type' WHERE id='gullycat_vdefault';
UPDATE audit_cat_param_user SET feature_field_id = 'node_type' WHERE id='nodetype_vdefault';
UPDATE audit_cat_param_user SET feature_field_id = 'gratecat_id' WHERE id='gratecat_vdefault';

update config_api_form_fields set ismandatory=false where column_id = 'gully_id';