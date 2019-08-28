/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

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

INSERT INTO audit_cat_table VALUES ('v_rtc_period_nodepattern', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_rtc_period_pjointpattern', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_inp_pjointpattern', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('inp_connec', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);


INSERT INTO audit_cat_function VALUES (2730, 'trg_edit_inp_connec', 'ws', 'trigger function', NULL, NULL, NULL, 'Trigger to edit v_edit_inp_connec view', 'role_epa', false, false, NULL, false);

DELETE FROM inp_typevalue WHERE typevalue='inp_value_opti_valvemode';
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 1, 'EPA TABLES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 2, 'INVENTORY VALUES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 3, 'MINCUT RESULTS', NULL);

INSERT INTO cat_arc_shape VALUES ('CIRCULAR', 'CIRCULAR', 'ws_shape.png',null, true) ON CONFLICT ON CONSTRAINT cat_arc_shape_pkey DO NOTHING;