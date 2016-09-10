/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- An audit history is important on most tables. Provide an audit trigger that logs to
-- a dedicated audit table for the major relations.
-- This code is generic and not depend on application roles or structures. Is based on:
--   http://wiki.postgresql.org/wiki/Audit_trigger_91plus



DROP VIEW IF EXISTS SCHEMA_NAME.v_audit_functions;
CREATE VIEW SCHEMA_NAME.v_audit_functions AS 
SELECT tstamp, audit_cat_error.id, audit_cat_error.error_message, audit_cat_error.hint_message, audit_cat_error.log_level, audit_cat_error.show_user, user_name, addr, debug_info
FROM SCHEMA_NAME.audit_function_actions INNER JOIN SCHEMA_NAME.audit_cat_error ON audit_function_actions.audit_cat_error_id = audit_cat_error.id
ORDER BY audit_function_actions.id DESC;

