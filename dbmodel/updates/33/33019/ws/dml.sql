/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

update connec set pjoint_id = exit_id, pjoint_type='VNODE' FROM link WHERE link.feature_id=connec_id;

UPDATE inp_typevalue SET idval='DMAPERIOD>NODE' WHERE typevalue='inp_value_patternmethod' AND id='23';
UPDATE inp_typevalue SET idval='HYDROPERIOD>NODE' WHERE typevalue='inp_value_patternmethod' AND id='24';
UPDATE inp_typevalue SET idval='DMAINTERVAL>NODE' WHERE typevalue='inp_value_patternmethod' AND id='25';
UPDATE inp_typevalue SET idval='HYDROPERIOD>NODE::DMAINTERVAL' WHERE typevalue='inp_value_patternmethod' AND id='26';
UPDATE inp_typevalue SET idval='HYDROPERIOD>PJOINT' WHERE typevalue='inp_value_patternmethod' AND id='27';

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod', '27', 'DMAPERIOD>PJOINT')
ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE audit_cat_param_user SET dv_isnullvalue=FALSE WHERE id='inp_options_patternmethod';

UPDATE audit_cat_function SET project_type='ud' WHERE id=2772;


UPDATE audit_cat_function SET istoolbox=false, isparametric=false, alias=null WHERE id=2774;


UPDATE audit_cat_function SET
return_type = '[{"widgetname":"grafClass", "label":"Graf class:", "widgettype":"combo","datatype":"text","layoutname":"grl_option_parameters","layout_order":1,"comboIds":["PRESSZONE","DQA","DMA","SECTOR"],
"comboNames":["Pressure Zonification (PRESSZONE)", "District Quality Areas (DQA) ", "District Metering Areas (DMA)", "Inlet Sectorization (SECTOR-HIGH / SECTOR-LOW)"], "selectedId":"DMA"}, 
{"widgetname":"exploitation", "label":"Exploitation id''s:","widgettype":"text","datatype":"json","layoutname":"grl_option_parameters","layout_order":2, "placeholder":"[1,2]", "value":""},
{"widgetname":"updateFeature", "label":"Update feature attributes:","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":7, "value":"FALSE"},
{"widgetname":"updateMapZone", "label":"Update geometry (if true choose only one parameter belove)","widgettype":"check","datatype":"boolean","layoutname":"grl_option_parameters","layout_order":8, "value":"FALSE"},
{"widgetname":"buffer", "label":"1: Buffer for arc disolve approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "ismandatory":false, "placeholder":"10", "value":""},
{"widgetname":"concaveHullParam", "label":"2: Hull parameter for concave polygon approach:","widgettype":"text","datatype":"float","layoutname":"grl_option_parameters","layout_order":9, "ismandatory":false, "placeholder":"0.9", "value":""}]'
 WHERE id=2768;
 
 
 --2019/12/11
 UPDATE audit_cat_table SET context='Editable view', description='View to edit status of valves on field', sys_role_id='role_om', sys_criticity=0, sys_sequence=null, sys_sequence_field=null WHERE id='v_edit_field_valve';

 --2019/12/13
UPDATE audit_cat_function SET input_params='{"featureType":["node","connec"]}' WHERE function_name = 'gw_fct_update_elevation_from_dem';

INSERT INTO audit_cat_function (id, function_name, project_type, function_type, input_params, 
       return_type, context, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2784,'gw_fct_insert_importdxf','utils','function','{"featureType":[], "btnRunEnabled":false}',
'[{"widgetname": "btn_path", "label": "Select DXF file:", "widgettype": "button",  "datatype": "text", "layoutname": "grl_option_parameters", "layout_order": 2, "value": "...","widgetfunction":"gw_function_dxf" }]',
null,'Function to manage DXF files','role_admin',FALSE,FALSE,'Manage dxf files',TRUE) ON CONFLICT (id) DO NOTHING;

INSERT INTO audit_cat_function (id, function_name, project_type, function_type, input_params, 
       return_type, context, descript, sys_role_id, isdeprecated, istoolbox, alias, isparametric)
VALUES (2786,'gw_fct_check_importdxf','utils','function',null,null, null,'Function to check the quality of imported DXF files',
	'role_admin',FALSE,false,null,false) ON CONFLICT (id) DO NOTHING;

ALTER TABLE IF EXISTS ext_raster_dem ALTER COLUMN rastercat_id TYPE text;

ALTER TABLE IF EXISTS ext_cat_raster ALTER COLUMN id TYPE text;

--2019/12/16

INSERT INTO audit_cat_table 
VALUES ('v_edit_inp_connec', 'Hydraulic feature', 'Shows editable information about connecs', 'role_epa', 0, 
	NULL, NULL, NULL, NULL, NULL, NULL, false)ON CONFLICT (id) DO NOTHING;;
UPDATE audit_cat_table SET qgis_role_id=NULL, qgis_criticity=NULL, qgis_message=NULL;

UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macrodma' WHERE id='v_edit_macrodma';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macrodqa' WHERE id='v_edit_macrodqa';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macrosector' WHERE id='v_edit_macrosector';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage macroexploitation' WHERE id='macroexploitation';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage node material catalog' WHERE id='cat_mat_node';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage arc material catalog' WHERE id='cat_mat_arc';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage node catalog' WHERE id='cat_node';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage arc catalog' WHERE id='cat_arc';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage roughness catalog' WHERE id='inp_cat_mat_roughness';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage connec catalog' WHERE id='cat_connec';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage element material catalog' WHERE id='cat_mat_element';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage element catalog' WHERE id='cat_element';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage owner catalog' WHERE id='cat_owner';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage soil catalog' WHERE id='cat_soil';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage pavement catalog' WHERE id='cat_pavement';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage work catalog' WHERE id='cat_work';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage presszone catalog' WHERE id='cat_presszone';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage builder catalog' WHERE id='cat_builder';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage model catalog' WHERE id='cat_brand_model';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage brand catalog' WHERE id='cat_brand';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage users catalog' WHERE id='cat_users';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage peridods catalog' WHERE id='ext_cat_period';
UPDATE audit_cat_table SET qgis_role_id='role_admin', qgis_criticity=2, qgis_message='Cannot manage hydrometer catalog' WHERE id='ext_cat_hydrometer';

UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view prices for nodes' WHERE id='v_plan_result_node';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view prices for arcs' WHERE id='v_plan_result_arc';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage pavements related to arcs' WHERE id='plan_arc_x_pavement';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view the geometry of diferent psectors' WHERE id='v_edit_plan_psector';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot view the geometry of the current psector' WHERE id='v_edit_plan_current_psector';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage the table of prices' WHERE id='price_compost';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage the table of values for create a new compost price' WHERE id='price_compost_value';
UPDATE audit_cat_table SET qgis_role_id='role_master', qgis_criticity=2, qgis_message='Cannot manage the table of units for prices' WHERE id='price_value_unit';

UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view reservoir related to EPA tables' WHERE id='v_edit_inp_reservoir';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view tanks related to EPA tables' WHERE id='v_edit_inp_tank';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view inlets related to EPA tables' WHERE id='v_edit_inp_inlet';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view junctions related to EPA tables' WHERE id='v_edit_inp_junction';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_mixing';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_emitter';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='' WHERE id='inp_source';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage demands related to EPA tables' WHERE id='v_edit_inp_demand';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view virtual valves related to EPA tables' WHERE id='v_edit_inp_virtualvalve';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view shortpipes valves related to EPA tables' WHERE id='v_edit_inp_shortpipe';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view valves related to EPA tables' WHERE id='v_edit_inp_valve';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view pumps related to EPA tables' WHERE id='v_edit_inp_pump';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view pipes related to EPA tables' WHERE id='v_edit_inp_pipes';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage additional pumps related to EPA tables' WHERE id='inp_pump_additional';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view connecs related to EPA tables' WHERE id='v_edit_inp_connec';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage controls for arcs' WHERE id='inp_controls_x_arc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage rules for arcs' WHERE id='inp_rules_x_arc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage rules for nodes' WHERE id='inp_rules_x_node';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage curve catalog related to EPA tables' WHERE id='inp_curve_id';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage curves related to EPA tables' WHERE id='inp_curve';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage pattern catalog related to EPA tables' WHERE id='inp_pattern';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage pattern values related to EPA tables' WHERE id='inp_pattern_value';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage energy values related to EPA tables' WHERE id='inp_energy';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage reaction values related to EPA tables' WHERE id='inp_reactions';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage quality values related to EPA tables' WHERE id='inp_quality';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage energy values related to EPA tables' WHERE id='inp_energy';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view node hourly values related to EPA results' WHERE id='v_rpt_node_hourly';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view node values related to EPA results' WHERE id='v_rpt_node';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view all node values related to EPA results' WHERE id='v_rpt_node_all';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view arc hourly values related to EPA results' WHERE id='v_rpt_arc_hourly';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view arc values related to EPA results' WHERE id='v_rpt_arc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view all arc values related to EPA results' WHERE id='v_rpt_arc_all';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage energy usage values related to EPA results' WHERE id='v_rpt_energy_usage';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage hydraulic status values related to EPA results' WHERE id='v_rpt_hydraulic_status';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view compared node hourly values related to EPA results' WHERE id='v_rpt_comp_node_hourly';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view compared node values related to EPA results' WHERE id='v_rpt_comp_node';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view compared arc hourly values related to EPA results' WHERE id='v_rpt_comp_arc_hourly';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot view compared arc values related to EPA results' WHERE id='v_rpt_comp_arc';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage compared energy usage values related to EPA results' WHERE id='v_rpt_comp_energy_usage';
UPDATE audit_cat_table SET qgis_role_id='role_epa', qgis_criticity=2, qgis_message='Cannot manage compared hydraulic status values related to EPA results' WHERE id='v_rpt_comp_hydraulic_status';

UPDATE audit_cat_table SET qgis_role_id='role_edit', qgis_criticity=2, qgis_message='Cannot use Add circle tool' WHERE id='v_edit_cad_auxcircle';
UPDATE audit_cat_table SET qgis_role_id='role_edit', qgis_criticity=2, qgis_message='Cannot use Add point tool' WHERE id='v_edit_cad_auxpoint';

UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of diferent visits' WHERE id='v_edit_om_visit';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of mincut initial points' WHERE id='v_anl_mincut_result_cat';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of mincut affected valves' WHERE id='v_anl_mincut_result_valve';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of mincut affected connecs' WHERE id='v_anl_mincut_result_connec';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of mincut affected nodes' WHERE id='v_anl_mincut_result_node';
UPDATE audit_cat_table SET qgis_role_id='role_om', qgis_criticity=2, qgis_message='Cannot view the geometry of mincut affected arcs' WHERE id='v_anl_mincut_result_arc';

UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage exploitations' WHERE id='v_edit_exploitation';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage dma''s' WHERE id='v_edit_dma';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage hydraulic sectors' WHERE id='v_edit_sector';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage dqa''s' WHERE id='v_edit_dqa';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage presszones' WHERE id='v_edit_presszone';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage exploitations' WHERE id='v_edit_exploitation';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=3, qgis_message='Cannot manage arcs. Imposible to use Giswater' WHERE id='v_edit_arc';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage connecs' WHERE id='v_edit_connec';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage links' WHERE id='v_edit_link';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to fountains' WHERE id='v_edit_man_fountain_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to registers' WHERE id='v_edit_man_register_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot view polygons related to tanks' WHERE id='v_edit_man_tank_pol';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot use dimensioning tool' WHERE id='v_edit_dimensions';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage related elements' WHERE id='v_edit_element';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage samplepoints' WHERE id='v_edit_samplepoint';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage municipality limits related to BASEMAP' WHERE id='ext_municipality';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage address related to BASEMAP' WHERE id='v_ext_address';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage streets related to BASEMAP' WHERE id='v_ext_streetaxis';
UPDATE audit_cat_table SET qgis_role_id='role_basic', qgis_criticity=2, qgis_message='Cannot manage plots related to BASEMAP' WHERE id='v_ext_plot';


--2019/12/19
INSERT INTO audit_cat_table(id, context, description, sys_role_id, sys_criticity, sys_rows, isdeprecated)
VALUES ('anl_mincut_arc_x_node','Mincut','Table of minimum cut analysis related to arcs and its final nodes', 'role_om',0,null, false) ON CONFLICT (id) DO NOTHING;



DELETE FROM config_api_form_tabs WHERE formname ='v_edit_connec' AND tabname = 'tab_plan';

DELETE FROM config_api_form_tabs WHERE formname ='ve_arc';
DELETE FROM config_api_form_tabs WHERE formname ='ve_node';
DELETE FROM config_api_form_tabs WHERE formname ='ve_connec';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false}]'
WHERE formname ='v_edit_node';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionSection", "actionTooltip":"Show Section",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false}]' 
WHERE formname ='v_edit_arc';


UPDATE config_api_form_tabs SET tabactions= '[
{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false}]'
WHERE formname ='v_edit_connec';





