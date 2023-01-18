/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO config_report
(id, alias, query_text, vdefault, filterparam, sys_role, descript, active)
VALUES(902, 'DB Activity', 'SELECT date, user_name, count, action  FROM audit.v_log_ws', 
'{"orderBy":"1", "orderType": "DESC", "filterSign":"> now() - INTERVAL", "vDefault":"60 days"}'::json,
'[{"columnname":"date", "label":"Fecha:", "widgettype":"combo","datatype":"text","layoutorder":1,
"dvquerytext":"Select id, idval FROM om_typevalue WHERE typevalue = ''custom_report_update_db'' ORDER BY addparam->>''orderby''", "filterSign":"> now() - INTERVAL"}]'::json,
'role_master', NULL, true);


CREATE OR REPLACE VIEW audit.v_log_ws AS
SELECT user_name,  count (*) , action, date FROM 
(SELECT user_name, substring(query,0,30)  as action, (substring(date_trunc('day',(tstamp))::text,0,12))::date AS date from audit.log
where schema = 'ws')a
group by user_name, date, action
ORDER BY date desc;

GRANT ALL ON TABLE audit.v_log_ws TO role_master;


CREATE OR REPLACE VIEW audit.v_log_ud AS
SELECT user_name,  count (*) , action, date FROM 
(SELECT user_name, substring(query,0,30)  as action, (substring(date_trunc('day',(tstamp))::text,0,12))::date AS date from audit.log
where schema = 'ud')a
group by user_name, date, action
ORDER BY date desc;

GRANT ALL ON TABLE audit.v_log_ud TO role_master;




