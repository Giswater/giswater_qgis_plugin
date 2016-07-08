/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE VIEW SCHEMA_NAME.v_ui_audit_node AS 
SELECT 
id,
tstamp_tx,
schema_name,
table_name,
relid oid,
user_name,
addr inet,
transaction_id,
action
query,
row_data,
changed_fields 
FROM SCHEMA_NAME.log_actions
WHERE table_name = 'node'::text
ORDER BY tstamp_tx DESC;


CREATE VIEW SCHEMA_NAME.v_ui_audit_arc AS 
SELECT 
id,
tstamp_tx,
schema_name,
table_name,
relid oid,
user_name,
addr inet,
transaction_id,
action
query,
row_data,
changed_fields 
FROM SCHEMA_NAME.log_actions
WHERE table_name = 'arc'::text
ORDER BY tstamp_tx DESC;


CREATE VIEW SCHEMA_NAME.v_ui_audit_connec AS 
SELECT 
id,
tstamp_tx,
schema_name,
table_name,
relid oid,
user_name,
addr inet,
transaction_id,
action
query,
row_data,
changed_fields 
FROM SCHEMA_NAME.log_actions
WHERE table_name = 'connec'::text
ORDER BY tstamp_tx DESC;


CREATE VIEW SCHEMA_NAME.v_ui_audit_element AS 
SELECT 
id,
tstamp_tx,
schema_name,
table_name,
relid oid,
user_name,
addr inet,
transaction_id,
action
query,
row_data,
changed_fields 
FROM SCHEMA_NAME.log_actions
WHERE table_name = 'element'::text
ORDER BY tstamp_tx DESC;




