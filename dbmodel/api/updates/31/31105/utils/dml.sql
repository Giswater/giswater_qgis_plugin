/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- 2018/11/21
UPDATE config_web_fields SET widgetfunction='gw_fct_updateprint' WHERE table_id='F32' and name='composer';
UPDATE config_web_fields SET widgetfunction='gw_fct_updateprint' WHERE table_id='F32' and name='scale';

-- 2018/11/29
SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript)  VALUES ('api_search_samplepoint', '{"sys_table_id":"samplepoint", "sys_id_field":"id", "sys_search_field":"code", "alias":"Punt de mostreig", "cat_field":"lab_code", "orderby":"7"}', 'text', 'api_search_network', NULL);
