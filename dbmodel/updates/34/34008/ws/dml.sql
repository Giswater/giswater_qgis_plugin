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
VALUES ('rpt_selector_hourly_compare', 'Hydraulic selector', 'Selector of an alternative result (to compare with other results)', 'role_epa', 0, 'role_epa', false)
ON CONFLICT (id) DO NOTHING;


UPDATE config_param_system SET value =
'{"table":"om_mincut", "table_id":"id", "selector":"selector_mincut_result", "selector_id":"result_id", "label":"id, ''('', CASE WHEN work_order IS NULL THEN ''N/I'' ELSE work_order END, '') on '', forecast_start::date, '' at '', forecast_start::time, ''H-'', forecast_end::time,''H''", "query_filter":" AND id > 0 "}'
WHERE parameter = 'api_selector_mincut';


UPDATE config_param_system SET value =
'{"table":"exploitation", "selector":"selector_expl", "table_id":"expl_id",  "selector_id":"expl_id",  "label":"expl_id, '' - '', name, '' '', CASE WHEN descript IS NULL THEN '''' ELSE concat('' - '', descript) END", "query_filter":" AND expl_id > 0 "}'
WHERE  parameter = 'api_selector_exploitation';

UPDATE audit_cat_param_user SET widgetcontrols = null, placeholder='24' WHERE id = 'inp_times_duration';

UPDATE sys_csv2pg_config SET 
target = '{Node Results, MINIMUM Node, MAXIMUM Node, AVERAGE Node, DIFFERENTIAL Node}'
WHERE pg2csvcat_id = 11 AND tablename = 'rpt_node';

UPDATE sys_csv2pg_config SET 
target = '{Link Results, MINIMUM Link, MAXIMUM Link, AVERAGE Link, DIFFERENTIAL Link}'
WHERE pg2csvcat_id = 11 AND tablename = 'rpt_arc';


--29/04/2020
UPDATE sys_feature_cat set epa_default = 'JUNCTION' WHERE id IN ('JUNCTION', 'EXPANSIONTANK', 'FLEXUNION', 'METER', 'HYDRANT','MANHOLE', 'WATERWELL','REGISTER', 'NETWJOIN','SOURCE','REDUCTION', 'NETSAMPLEPOINT', 'NETELEMENT');
UPDATE sys_feature_cat set epa_default = 'TANK' WHERE id IN ('TANK');
UPDATE sys_feature_cat set epa_default = 'RESERVOIR' WHERE id IN ('WTP');
UPDATE sys_feature_cat set epa_default = 'VALVE' WHERE id IN ('VALVE');
UPDATE sys_feature_cat set epa_default = 'SHORTPIPE' WHERE id IN ('FILTER');
UPDATE sys_feature_cat set epa_default = 'PUMP' WHERE id IN ('PUMP');
UPDATE sys_feature_cat set epa_default = 'PIPE' WHERE id IN ('PIPE', 'VARC');