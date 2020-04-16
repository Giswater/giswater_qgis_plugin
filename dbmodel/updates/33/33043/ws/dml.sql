/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DELETE FROM audit_cat_param_user WHERE id IN 
('inp_options_rtc_coefficient', 'inp_options_use_dma_pattern','inp_iterative_main_function','inp_iterative_parameters');


UPDATE audit_cat_param_user SET
widgetcontrols = '{"enableWhenParent":"[11, 21, 31, 33]"}'
WHERE id = 'inp_options_pattern';

UPDATE audit_cat_param_user SET
dv_parent_id  ='inp_options_valve_mode'
WHERE id = 'inp_options_valve_mode_mincut_result';

UPDATE audit_cat_param_user SET
widgetcontrols = '{"enableWhenParent":"[3,4,5]"}'
WHERE id = 'inp_options_rtc_period_id';

UPDATE audit_cat_param_user SET
dv_isnullvalue = true
WHERE id IN ('inp_options_pattern','inp_options_rtc_period_id');

UPDATE audit_cat_table SET descript='Selector of an alternative result (to compare with other results)', qgis_role_id='role_epa' WHERE id='rpt_selector_hourly';

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('rpt_selector_hourly_compare', 'Hydraulic selector', 'Selector of an alternative result (to compare with other results)', 'role_epa', 0, 'role_epa', false);