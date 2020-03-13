/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/13
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_param_system", "column":"layout_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"audit_cat_param_user", "column":"layout_id"}}$$);


INSERT INTO config_param_system (parameter, value, context, descript, label, isenabled, project_type, datatype, widgettype, ismandatory, isdeprecated, standardvalue) 
VALUES ('sys_transaction_db', '{"status":false, "server":""}', 'system', 'Parameteres for use an additional database to scape transtaction logics of PostgreSQL in order to audit processes step by step', 
'Additional transactional database:', TRUE, 'utils', 'json', 'linetext', false, false, 'false') 
ON CONFLICT (parameter) DO NOTHING;