/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--7/11/2019
UPDATE config_param_system SET parameter='crm_daily_script_folderpath' WHERE parameter='crm_dailyscript_folderpath';

SELECT setval('config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);
INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
VALUES ('python_folderpath','c:/program files/qgis 3.4/apps/Python37','text', 'crm', 'Folder to path for python')
ON CONFLICT (parameter) DO NOTHING;


UPDATE audit_cat_function SET function_name='gw_trg_cat_feature'
WHERE id=2758;

--update audit_cat_param_user with cat_feature vdefaults
UDPATE cat_feature SET id=id;
