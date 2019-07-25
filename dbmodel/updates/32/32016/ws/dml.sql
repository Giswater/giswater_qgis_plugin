/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 1, 'BASIC', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 2, 'SHUTOFF-VALVES', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 3, 'TRIMED-ARCS', NULL);
INSERT INTO inp_typevalue (typevalue, id, idval, descript) VALUES ('inp_options_networkmode', 4, 'SHUTOFF-VALVES & TRIMED ARCS', NULL);


UPDATE audit_cat_param_user SET id='inp_options_networkmode', 
	label='Network geometry generator:', datatype ='integer' , widgettype ='combo', 
	dv_querytext = 'SELECT id, idval FROM inp_typevalue WHERE typevalue = ''inp_options_networkmode''',
	description='Generates the network onfly transformation to epa with 3 options; Faster: Only mandatory nodarc (EPANET valves and pumps); Normal: All nodarcs (GIS shutoff valves); Slower: All nodarcs and in addition treaming all pipes with vnode creating the vnodearcs',
	layout_id=1, layout_order=4, layoutname ='grl_general_1', dv_orderby_id=true, vdefault=1, idval=null
	WHERE id = 'inp_options_nodarc_onlymandatory';

UPDATE audit_cat_param_user SET
	layout_id=2, layout_order=4, layoutname ='grl_general_2', idval=null 
	WHERE id = 'inp_options_nodarc_length';
	
UPDATE audit_cat_param_user SET
	dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_value_opti_valvemode'''
	WHERE id = 'inp_options_valve_mode';
	

UPDATE config_param_user SET value = 1 WHERE cur_user=current_user AND parameter ='inp_options_valve_mode';

	
INSERT INTO audit_cat_table VALUES ('v_rtc_period_nodepattern', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_rtc_period_pjointpattern', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_inp_pjointpattern', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('inp_connec', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);


INSERT INTO audit_cat_function VALUES (2730, 'trg_edit_inp_connec', 'ws', 'trigger function', NULL, NULL, NULL, 'Trigger to edit v_edit_inp_connec view', 'role_epa', false, false, NULL, false);


DELETE FROM inp_typevalue WHERE typevalue='inp_value_opti_valvemode';
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 1, 'EPA TABLES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 2, 'INVENTORY VALUES', NULL);
INSERT INTO inp_typevalue VALUES ('inp_value_opti_valvemode', 3, 'MINCUT RESULTS', NULL);