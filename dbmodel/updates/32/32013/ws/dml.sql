/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO inp_typevalue VALUES ('inp_value_demandtype','1','NODE ESTIMATED');
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype','2','CRM PERIOD');
INSERT INTO inp_typevalue VALUES ('inp_value_demandtype','3','CRM INTERVAL');


INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','11','ESTIMATED UNIQUE', '1');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','12','ESTIMATED DMA', '1');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','13','ESTIMATED NODE', '1');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','21','MIN PERIOD VALUE', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','22','MAX PERIOD VALUE', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','23','HYDRO PERIOD', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','24','DMA INTERVAL', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','25','HYDRO-DMA HYBRID', '2');
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','31','HYDRO-DMA INTERVAL', '3');

UPDATE audit_cat_param_user SET isenabled=false WHERE id='inp_options_rtc_enabled';
UPDATE audit_cat_param_user SET isenabled=false WHERE id='inp_options_rtc_coefficient';
UPDATE audit_cat_param_user SET isenabled=false WHERE id='inp_options_use_dma_pattern';


UPDATE audit_cat_param_user SET label='Estimated unique pattern:', dv_querytext='SELECT pattern_id AS id, pattern_id AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL '
								,layout_id = 9, layout_order = 1, layoutname='grl_crm_9', dv_parent_id='inp_options_demandtype', dv_isnullvalue=TRUE, editability='{"trueWhenParentIn":[1]}'								
								WHERE id='inp_options_pattern';
UPDATE audit_cat_param_user SET label='CRM period:',  layout_id = 10, layout_order = 1, layoutname='grl_crm_10',	dv_parent_id='inp_options_demandtype', editability='{"trueWhenParentIn":[2]}'
								WHERE id='inp_options_rtc_period_id';
UPDATE audit_cat_param_user SET label='Overwrite demands:', layout_id = 2, layout_order = 3, layoutname='grl_general_2' WHERE id='inp_options_overwritedemands';
UPDATE audit_cat_param_user SET layout_order = 3 WHERE id='inp_options_demand_multiplier';

INSERT INTO audit_cat_param_user VALUES ('inp_options_demandtype', 'epaoptions', 'Demand type to use on EPANET simulation', 'role_epa', NULL, NULL, 'Demand type:', 
			'SELECT id,idval FROM inp_typevalue WHERE  typevalue=''inp_value_demandtype''', NULL, true, 1, 2, 'ws', TRUE, NULL, NULL, NULL, FALSE, NULL, 'combo', true, 
			NULL, '1', 'grl_general_1', NULL, TRUE, TRUE, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
INSERT INTO audit_cat_param_user VALUES ('inp_options_patternmethod', 'epaoptions', 'Pattern method used on EPANET simulation', 'role_epa', NULL, NULL, 'Pattern method:', 
			'SELECT id,idval FROM inp_typevalue WHERE  typevalue=''inp_value_patternmethod''', 'inp_options_demandtype', true, 2, 2, 'ws', FALSE, ' AND descript = ', NULL, NULL, FALSE, NULL, 'combo', true, 
			NULL, '1', 'grl_general_2', NULL, TRUE, TRUE, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
INSERT INTO audit_cat_param_user VALUES ('inp_options_interval_from', 'epaoptions', 'CRM interval used on EPANET simulation', 'role_epa', NULL, NULL, 'From CRM interval:', 
			NULL, NULL, FALSE, 9, 2, 'ws', FALSE, NULL, NULL, NULL, FALSE, 'float', 'text', true,
			NULL, NULL, 'grl_crm_9', NULL, NULL, NULL, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');
INSERT INTO audit_cat_param_user VALUES ('inp_options_interval_to', 'epaoptions', 'CRM interval used on EPANET simulation', 'role_epa', NULL, NULL, 'To CRM interval:', 
			NULL, NULL, FALSE, 10, 2, 'ws', FALSE, NULL, NULL, NULL, FALSE, 'float', 'text', true,
			NULL, NULL, 'grl_crm_10', NULL, NULL, NULL, NULL, NULL, NULL, FALSE, '{"from":"2.0.12", "to":null, "language":"english"}');	
			
		
			