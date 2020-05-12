/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/10/2019
ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;

INSERT INTO inp_typevalue VALUES ('inp_value_opti_hyd', 'NONE','') ON CONFLICT (typevalue, id) DO NOTHING;

UPDATE audit_cat_param_user SET vdefault='NONE',
dv_querytext = 'SELECT ''NONE'' AS id, '''' AS idval UNION SELECT pattern_id AS id, pattern_id AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL'
WHERE id='inp_options_hydraulics';

UPDATE audit_cat_param_user SET ismandatory='FALSE' 
WHERE id IN ('inp_options_node_id','inp_options_valve_mode_mincut_result','inp_report_file','inp_report_pagesize','inp_times_pattern_start','inp_times_pattern_timestep','inp_times_start_clocktime',
'inp_times_quality_timestep','inp_times_report_start','inp_times_report_timestep','inp_times_rule_timestep','inp_options_rtc_period_id','inp_options_hydraulics_fname','inp_options_rtc_coefficient',
'inp_options_interval_from', 'inp_options_interval_to' );