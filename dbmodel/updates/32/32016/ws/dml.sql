/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



INSERT INTO sys_typevalue_cat (typevalue_table, typevalue_name) VALUES ('edit_typevalue','sector_type');
INSERT INTO sys_typevalue_cat (typevalue_table, typevalue_name) VALUES ('edit_typevalue','dqa_type');


INSERT INTO edit_typevalue VALUES ('sector_type', 'distribution', 'distribution');
INSERT INTO edit_typevalue VALUES ('sector_type', 'undefined', 'undefined');
INSERT INTO edit_typevalue VALUES ('sector_type', 'source', 'source');

INSERT INTO edit_typevalue VALUES ('dqa_type', 'chlorine', 'chlorine');
INSERT INTO edit_typevalue VALUES ('dqa_type', 'undefined', 'undefined');
INSERT INTO edit_typevalue VALUES ('dqa_type', 'other', 'other');

INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue', 'sector_type', 'sector', 'sector_type');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('edit_typevalue', 'dqa_type', 'dqa', 'dqa_type');


UPDATE audit_cat_table SET isdeprecated = TRUE where id='inp_controls_x_node';

INSERT INTO inp_node_type VALUES ('INLET');

INSERT INTO inp_connec SELECT connec_id FROM connec;

UPDATE sys_csv2pg_config SET target='{"Node Results", "MINIMUM Node"}' WHERE tablename = 'rpt_node';
UPDATE sys_csv2pg_config SET target='{"MINIMUM Link", "Link Results"}' WHERE tablename = 'rpt_arc';
UPDATE sys_csv2pg_config SET target='{"Pump Factor"}' WHERE tablename = 'rpt_energy_usage';
UPDATE sys_csv2pg_config SET target='{"Hydraulic Status:"}' WHERE tablename = 'rpt_hydraulic_status';
UPDATE sys_csv2pg_config SET target='{"Input Data"}' WHERE tablename = 'rpt_cat_result';

INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 1, 'BASIC (ONLY MANDATORY NODARC)', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 2, 'ADVANCED (ALL NODARC)', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 3, 'BASIC & TRIMED-ARCS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 4, 'ADVANCED & TRIMED-ARCS', NULL);

INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_dscenario_priority', 1, 'Dscenario overwrites bdemand', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_dscenario_priority', 2, 'Ignore Dscenario when bdemand', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_dscenario_priority', 3, 'Dscenario and bdemand joined', NULL);

INSERT INTO audit_cat_param_user VALUES ('inp_options_skipdemandpattern', 'epaoptions', 'Skip update demands and patterns when EPANET is used. Only for iterative model', 'role_epa', NULL, NULL, NULL, 
			NULL, NULL, true, NULL, NULL, 'ws', FALSE, NULL, NULL, NULL, FALSE, 'boolean', 'check', true, 
			NULL, 'FALSE', NULL, NULL, TRUE, TRUE, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
				

UPDATE audit_cat_param_user SET id='inp_options_networkmode', 
	label='Network geometry generator:', datatype ='integer' , widgettype ='combo', 
	dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_networkmode''',
	description='Generates the network onfly transformation to epa with 3 options; Faster: Only mandatory nodarc (EPANET valves and pumps); Normal: All nodarcs (GIS shutoff valves); Slower: All nodarcs and in addition treaming all pipes with vnode creating the vnodearcs',
	layout_id=1, layout_order=1, layoutname ='grl_general_1', dv_orderby_id=true, vdefault=1, idval=null
	WHERE id = 'inp_options_nodarc_onlymandatory';

UPDATE audit_cat_param_user SET  id='inp_options_dscenario_priority', 
	label='Demand scenario priority:', datatype ='integer' , widgettype ='combo', 
	dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_dscenario_priority''',
	description='Dscenario priority', vdefault=1, idval=null
	WHERE id = 'inp_options_overwritedemands';
	
	
UPDATE audit_cat_param_user SET
	layout_id=2, layout_order=1, layoutname ='grl_general_2', idval=null 
	WHERE id = 'inp_options_nodarc_length';
	
UPDATE audit_cat_param_user SET
	dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_valvemode'''
	WHERE id = 'inp_options_valve_mode';
	

UPDATE config_param_user SET value = 1 WHERE cur_user=current_user AND parameter ='inp_options_valve_mode';

UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='v_rtc_dma_hydrometer_period';
UPDATE audit_cat_table SET isdeprecated=TRUE WHERE id='v_rtc_dma_parameter_period';

INSERT INTO audit_cat_table VALUES ('v_rtc_period_pjointpattern', 'Hydraulic data', NULL, 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_inp_pjointpattern', 'Hydraulic data', NULL, 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('inp_connec', 'Hydraulic input data', 'Table that relates connecs with its pattern and demand', 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL);

DELETE FROM inp_typevalue WHERE typevalue='inp_value_opti_valvemode';
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 1, 'EPA TABLES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 2, 'INVENTORY VALUES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 3, 'MINCUT RESULTS', NULL);

INSERT INTO inp_typevalue VALUES ('inp_value_pattern_type', 'VOLUME', 'VOLUME', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_pattern_type', 'UNITARY', 'UNITARY', NULL);

INSERT INTO cat_arc_shape VALUES ('CIRCULAR', 'CIRCULAR', 'ws_shape.png',null, true) ON CONFLICT ON CONSTRAINT cat_arc_shape_pkey DO NOTHING;

INSERT INTO audit_cat_table VALUES ('cat_arc_shape', 'Catalog', 'Catalog of arc shapes', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_tank', 'Editable view', 'Editable view for tank polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_register', 'Editable view', 'Editable view for register polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('ve_pol_fountain', 'Editable view', 'Editable view for fountain polygons', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('rpt_inp_pattern_value', 'Hydraulic result data', NULL, 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('macrodqa', 'GIS feature', 'Table of macrodqas', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('dqa', 'GIS feature', 'Table of spatial objects representing District Quality Area', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('anl_graf', 'Analysis', NULL, 'role_admin', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('inp_inlet', 'Hydraulic input data', NULL, 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('minsector', 'GIS feature', 'Table of minsectors', 'role_edit', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('minsector_graf', NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_graf', 'Analysis', NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_rtc_period_nodepattern', 'Real time control', NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vi_parent_connec', 'Hydraulic input data', 'Parent table of nodes filtered by inp selector', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vi_parent_hydrometer', 'Hydraulic input data', 'Parent table of hydrometers', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('vi_parent_dma', 'Hydraulic input data', 'Parent table of dmas', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_edit_inp_inlet', 'Hydraulic input data', NULL, 'role_epa', 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);
INSERT INTO audit_cat_table VALUES ('v_arc_x_vnode', 'Auxiliar', 'Shows the relation between arc and vnodes', NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, FALSE, NULL);


INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_noneall');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_hyd');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_demandtype');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_ampm');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_status_valve');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_options_networkmode');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_qual');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_param_energy');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_times');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_yesnofull');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_iterative_function');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_patternmethod');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_typevalue_source');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_options_dscenario_priority');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_typevalue_energy');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_reactions');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_curve');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_status_pipe');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_headloss');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_typevalue_valve');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_unbal');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_yesno');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_status_pump');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_rtc_coef');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_units');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_mixing');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_opti_valvemode');
INSERT INTO sys_typevalue_cat (typevalue_table,typevalue_name) VALUES ('inp_typevalue', 'inp_value_pattern_type');



INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_status_pump','inp_pump', 'status');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_typevalue_source','inp_source', 'sourc_type');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_typevalue_valve','inp_valve', 'valv_type');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_status_valve','inp_valve', 'status');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_status_pump','inp_pump_additional', 'status');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_status_pipe','inp_pipe', 'status');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_curve','inp_curve_id', 'curve_type');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_demandtype','inp_demand', 'deman_type');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_mixing','inp_mixing', 'mix_type');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_noneall','inp_report', 'links');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_noneall','inp_report', 'nodes');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesnofull','inp_report', 'status');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'f_factor');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'diameter');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'length');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'energy');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'flow');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'elevation');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'head');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'demand');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'setting');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'reaction');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'pressure');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'summary');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'quality');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'velocity');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_yesno','inp_report', 'headloss');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_times','inp_times', 'statistic');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_param_energy','inp_pump', 'energyparam');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_param_energy','inp_pump_additional', 'energyparam');
INSERT INTO typevalue_fk (typevalue_table, typevalue_name, target_table, target_field) VALUES ('inp_typevalue', 'inp_value_pattern_type','inp_pattern', 'pattern_type');


UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_node"]}]' WHERE id ='node_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id, descript","featureType":["cat_node", "cat_connec"]}]' WHERE id ='cat_mat_node';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_arc"]}]' WHERE id ='arc_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["cat_connec"]}]' WHERE id ='connec_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id, descript","featureType":["cat_arc"]}]' WHERE id ='cat_mat_arc';



UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["node","v_edit_inp_tank", "v_edit_inp_shortpipe", "v_edit_inp_junction","v_edit_inp_pump","v_edit_inp_valve", "v_edit_inp_reservoir"]}]' WHERE id ='cat_node';

UPDATE audit_cat_table SET notify_action = '[
{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc","v_edit_inp_pipe"]}]' WHERE id ='cat_arc';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='cat_builder';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"category_type, feature_type","featureType":["arc", "node", "connec"]}]' WHERE id ='man_type_category';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"fluid_type, feature_type","featureType":["arc", "node", "connec"]}]' WHERE id ='man_type_fluid';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"function_type, feature_type","featureType":["arc", "node", "connec"]}]' WHERE id ='man_type_function';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"location_type, feature_type","featureType":["arc", "node", "connec"]}]' WHERE id ='man_type_location';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='cat_owner';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='cat_presszone';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='cat_soil';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='cat_work';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"dma_id, name","featureType":["arc", "node", "connec","v_edit_link", "v_edit_vnode","v_edit_element", "v_edit_samplepoint","v_edit_pond", "v_edit_pool"]}]' WHERE id ='dma';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"expl_id, name","featureType":["arc", "node", "connec","v_edit_link", "v_edit_vnode","v_edit_element", "v_edit_samplepoint","v_edit_pond", "v_edit_pool"]}]' WHERE id ='exploitation';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='ext_address';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='ext_plot';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"muni_id, name","featureType":["arc", "node", "connec"]}]' WHERE id ='ext_municipality';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='ext_streetaxis';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"sector_id, name","featureType":["arc", "node", "connec","v_edit_link", "v_edit_vnode", "v_edit_inp_tank", "v_edit_inp_shortpipe", "v_edit_inp_junction","v_edit_inp_pump","v_edit_inp_valve", "v_edit_inp_reservoir","v_edit_inp_pipe"]}]' WHERE id ='sector';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='value_verified';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["arc", "node", "connec"]}]' WHERE id ='value_state_type';

UPDATE audit_cat_table SET notify_action = '[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"dqa_id, name","featureType":["arc", "node", "connec"]}]' WHERE id ='dqa';

--inp
UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"id","featureType":["inp_pump_additional", "inp_curve","v_edit_inp_valve","v_edit_inp_tank","v_edit_inp_pump"]}]' 
WHERE id='inp_curve_id';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"pattern_id","featureType":["inp_pump_additional", "inp_source", "inp_pattern_value", "v_edit_inp_demand","v_edit_inp_pump","v_edit_inp_reservoir","v_edit_inp_junction"]}]' 
WHERE id='inp_pattern';	

UPDATE audit_cat_table SET notify_action = 
'[{"action":"desktop","name":"refresh_attribute_table", "enabled":"true", "trg_fields":"dscenario_id","featureType":["v_edit_inp_demand"]}]' 
WHERE id='cat_dscenario';	

UPDATE sys_csv2pg_config SET target='Node Results, MINIMUM Node' WHERE tablename='rpt_node';
UPDATE sys_csv2pg_config SET target='MINIMUM Link, Link Results' WHERE tablename='rpt_arc';
UPDATE sys_csv2pg_config SET target='Pump Factor' WHERE tablename='rpt_energy_usage';
UPDATE sys_csv2pg_config SET target='Hydraulic Status:' WHERE tablename='rpt_hydraulic_status';
UPDATE sys_csv2pg_config SET target='Input Data' WHERE tablename='rpt_cat_result';

UPDATE config_param_system SET value='FALSE' WHERE parameter='om_mincut_use_pgrouting';