/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue VALUES ('inp_value_demandtype','1','ESTIMATED');
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype','2','CRM PERIOD');
--INSERT INTO inp_typevalue VALUES ('inp_value_demandtype','3','CRM INTERVAL');

INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','11','UNIQUE ESTIMATED', null,'{"DemandType":1}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','12','DMA ESTIMATED', null,'{"DemandType":1}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','13','NODE ESTIMATED', null,'{"DemandType":1}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','14','CONNEC ESTIMATED', null,'{"DemandType":1}');
--INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','21','NODE MINC PERIOD', null,'{"DemandType":2}');
--INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','22','NODE MAXC PERIOD', null,'{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','23','DMA PERIOD', null,'{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','24','NODE PERIOD', null,'{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','25','DMA INTERVAL', null,'{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','26','NODE PERIOD-DMA INTERVAL',null  ,'{"DemandType":2}');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','27','CONNEC PERIOD',null  ,'{"DemandType":2}');
--INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','31','DMA-NODE INTERVAL', null ,'{"DemandType":3}');
--INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','32','DMA-CONNEC INTERVAL', null ,'{"DemandType":3}');


UPDATE audit_cat_param_user SET isenabled=false WHERE id='inp_options_rtc_enabled';
UPDATE audit_cat_param_user SET isenabled=false WHERE id='inp_options_rtc_coefficient';
UPDATE audit_cat_param_user SET isenabled=false WHERE id='inp_options_use_dma_pattern';


UPDATE audit_cat_param_user SET label='UNIQUE ESTIMATED pattern:', dv_querytext='SELECT pattern_id AS id, pattern_id AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL '
								,layout_id = 2, layout_order = 3, layoutname='grl_general_2', dv_isnullvalue=TRUE, 
								dv_parent_id='inp_options_patternmethod', editability='{"trueWhenParentIn":[1]}'								
								WHERE id='inp_options_pattern';

UPDATE audit_cat_param_user SET label='CRM PERIOD value:',  dv_isnullvalue=true,
								layout_id = 2, layout_order = 2, layoutname='grl_general_2', idval=null,
								dv_parent_id='inp_options_demandtype', editability='{"trueWhenParentIn":[2]}'
								WHERE id='inp_options_rtc_period_id';

UPDATE audit_cat_param_user SET layout_order = 5 WHERE id='inp_options_units';

UPDATE audit_cat_param_user SET label='Headloss formula:', layout_order = 5 WHERE id='inp_options_headloss';

UPDATE audit_cat_param_user SET layout_order = 6 WHERE id='inp_options_demand_multiplier';
								
UPDATE audit_cat_param_user SET layout_id=17 WHERE formname='epaoptions' AND layout_id=13;
UPDATE audit_cat_param_user SET layout_id=18 WHERE formname='epaoptions' AND layout_id=14;
UPDATE audit_cat_param_user SET layout_id=13 WHERE formname='epaoptions' AND layout_id=11;
UPDATE audit_cat_param_user SET layout_id=14 WHERE formname='epaoptions' AND layout_id=12;

UPDATE audit_cat_param_user SET layout_id=1, layout_order = 4, vdefault=1, layoutname='grl_general_1', idval=null WHERE id='inp_options_valve_mode';
UPDATE audit_cat_param_user SET layout_id=2, layout_order = 4, layoutname='grl_general_2',editability='{"trueWhenParentIn":[3]}' WHERE id='inp_options_valve_mode_mincut_result';

UPDATE audit_cat_param_user SET layout_id=3, layout_order = 9, label='MINCUT RESULTS id:', layoutname='grl_hyd_3' WHERE id='inp_options_quality_mode';
UPDATE audit_cat_param_user SET layout_id=3, layout_order = 10, layoutname='grl_hyd_3' WHERE id='inp_options_tolerance';

UPDATE audit_cat_param_user SET layout_id=4, layout_order = 9, layoutname='grl_hyd_4' WHERE id='inp_options_node_id';
UPDATE audit_cat_param_user SET layout_id=4, layout_order = 10, layoutname='grl_hyd_4' WHERE id='inp_options_diffusivity';


UPDATE audit_cat_param_user SET label='Dscenario overwrites demand:', layout_id = 2, layout_order = 6, layoutname='grl_general_2', idval=null WHERE id='inp_options_overwritedemands';

UPDATE audit_cat_param_user SET id='inp_iterative_main_function', label = 'Iterative function:', 
								layout_id = 15, layout_order=1, layoutname=null, idval=null, isenabled=FALSE, dv_isnullvalue=TRUE, ismandatory=true,
								dv_querytext='SELECT id, idval FROM inp_typevalue WHERE typevalue=''inp_iterative_function''',
								epaversion='{"from":"2.0.12", "to":null, "language":"english"}'
								WHERE id='inp_other_recursive_function';

DELETE FROM audit_cat_param_user WHERE id='inp_recursive_function'; -- delete parameter never used
								
INSERT INTO audit_cat_param_user VALUES ('inp_iterative_parameters', 'epaoptions', 'Parameters to work with iterative functions', 'role_epa',
			NULL, null, 'Iterative parameters:', NULL, 
			NULL, false, 16, 1, 'ws', false, NULL, NULL, NULL, false, 'string', 'text', TRUE, NULL, '{"nodesCoupleCapacity":{"lpsDemand":16.6, "mcaMinPress":15, "minDiameter":75.6}}',
			null,NULL, NULL, TRUE, TRUE, NULL, NULL, false,'{"from":"2.0.12", "to":null, "language":"english"}');			
									
INSERT INTO audit_cat_param_user VALUES ('inp_options_demandtype', 'epaoptions', 'Demand type to use on EPANET simulation', 'role_epa', NULL, NULL, 'Demand type:', 
			'SELECT id,idval FROM inp_typevalue WHERE  typevalue=''inp_value_demandtype''', NULL, true, 1, 2, 'ws', TRUE, NULL, NULL, NULL, FALSE, NULL, 'combo', true, 
			NULL, '1', 'grl_general_1', NULL, TRUE, TRUE, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
						
INSERT INTO audit_cat_param_user VALUES ('inp_options_patternmethod', 'epaoptions', 'Pattern method used on EPANET simulation', 'role_epa', NULL, NULL, 'Pattern method:', 
			'SELECT id,idval FROM inp_typevalue WHERE  typevalue=''inp_value_patternmethod''', 'inp_options_demandtype', true, 1, 3, 'ws', FALSE, ' AND addparam->>''DemandType''=', NULL, NULL, FALSE, NULL, 'combo', true, 
			NULL, '11', 'grl_general_1', NULL, TRUE, TRUE, TRUE, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
			
INSERT INTO audit_cat_param_user VALUES ('inp_options_interval_from', 'epaoptions', 'CRM interval used on EPANET simulation', 'role_epa', NULL, NULL, 'From CRM interval:', 
			NULL, NULL, FALSE, 13, 6, 'ws', FALSE, NULL, NULL, NULL, FALSE, 'float', 'text', true,
			NULL, NULL, 'grl_date_13', NULL, NULL, NULL, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
			
INSERT INTO audit_cat_param_user VALUES ('inp_options_interval_to', 'epaoptions', 'CRM interval used on EPANET simulation', 'role_epa', NULL, NULL, 'To CRM interval:', 
			NULL, NULL, FALSE, 14, 6, 'ws', FALSE, NULL, NULL, NULL, FALSE, 'float', 'text', true,
			NULL, NULL, 'grl_date_14', NULL, NULL, NULL, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');	


UPDATE cat_feature SET child_layer='ve_node_throttlevalve' WHERE id='THROTTLE-VALVE';
UPDATE cat_feature SET child_layer='ve_node_valveregister' WHERE id='VALVE-REGISTER';
UPDATE cat_feature SET child_layer='ve_node_waterconnection' WHERE id='WATER-CONNECTION';
UPDATE cat_feature SET child_layer='ve_node_flcontrvalve' WHERE id='FL-CONTR.VALVE';
UPDATE cat_feature SET child_layer='ve_node_prbkvalve' WHERE id='PR-BREAK.VALVE';
UPDATE cat_feature SET child_layer='ve_node_airvalve' WHERE id='AIR-VALVE';
UPDATE cat_feature SET child_layer='ve_node_bypassregister' WHERE id='BYPASS-REGISTER';
UPDATE cat_feature SET child_layer='ve_node_checkvalve' WHERE id='CHECK-VALVE';
UPDATE cat_feature SET child_layer='ve_node_controlregister' WHERE id='CONTROL-REGISTER';
UPDATE cat_feature SET child_layer='ve_node_genpurpvalve' WHERE id='GEN-PURP.VALVE';
UPDATE cat_feature SET child_layer='ve_node_greenvalve' WHERE id='GREEN-VALVE';
UPDATE cat_feature SET child_layer='ve_node_outfallvalve' WHERE id='OUTFALL-VALVE';
UPDATE cat_feature SET child_layer='ve_node_greenvalve' WHERE id='PR-REDUC.VALVE';
UPDATE cat_feature SET child_layer='ve_node_prsustavalve' WHERE id='PR-SUSTA.VALVE';
UPDATE cat_feature SET child_layer='ve_node_pressuremeter' WHERE id='PRESSURE-METER';
UPDATE cat_feature SET child_layer='ve_node_shutoffvalve' WHERE id='SHUTOFF-VALVE';