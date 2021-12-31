/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
INSERT INTO sys_fprocess(fid, fprocess_name, project_type, parameters, source) 
VALUES (432, 'Check node ''T candidate'' with wrong topology','ws', null, null) ON CONFLICT (fid) DO NOTHING;

--2021/12/30
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'checkData', 'NONE'::text) WHERE parameter = 'utils_grafanalytics_status';

--2021/12/31
UPDATE config_function SET style = 
'{"style": {"point": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]},
"line": {"style": "categorized", "field": "descript", "transparency": 0.5, "width": 2.5, "values": [{"id": "Disconnected", "color": [255,124,64]}, {"id": "Conflict", "color": [14,206,253]}]}}}'
WHERE id = 2710; 


UPDATE sys_param_user SET formname  ='hidden' WHERE id IN('inp_options_demandtype','inp_options_rtc_period_id');
UPDATE sys_param_user SET dv_parent_id = null, dv_querytext_filterc = null WHERE id ='inp_options_patternmethod';

UPDATE inp_typevalue SET addparam=null where typevalue = 'inp_value_patternmethod'

ALTER TABLE inp_typevalue DISABLE TRIGGER gw_trg_typevalue_config_fk;
DELETE FROM inp_typevalue where typevalue = 'inp_value_patternmethod' and id::integer > 20;

UPDATE inp_typevalue SET id = '14' WHERE id = '13' AND  typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET id = '13' WHERE id = '12' AND  typevalue = 'inp_value_patternmethod';
INSERT INTO inp_typevalue VALUES ('inp_value_patternmethod','12','SECTOR PATTERN');
UPDATE inp_typevalue SET idval = 'DEFAULT PATTERN' WHERE id = '11' AND  typevalue = 'inp_value_patternmethod';
UPDATE inp_typevalue SET idval = 'FEATURE PATTERN' WHERE id = '14' AND  typevalue = 'inp_value_patternmethod';
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;

UPDATE inp_typevalue SET idval = 'CONNEC (ALL NODARCS)' WHERE typevalue = 'inp_options_networkmode' AND id  ='4';
UPDATE inp_typevalue SET idval = 'NODE (BASIC NODARCS)' WHERE typevalue = 'inp_options_networkmode' AND id  ='1';

UPDATE sys_param_user SET label= 'Default pattern:' WHERE id = 'inp_options_pattern';