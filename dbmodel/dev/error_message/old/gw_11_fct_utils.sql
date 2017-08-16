/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- An audit history is important on most tables. Provide an audit trigger that logs to
-- a dedicated audit table for the major relations.
-- This code is generic and not depend on application roles or structures. Is based on:
--   http://wiki.postgresql.org/wiki/Audit_trigger_91plus



  
DROP TABLE IF EXISTS SCHEMA_NAME.log_code CASCADE;  
CREATE TABLE SCHEMA_NAME.log_code (
    id integer PRIMARY KEY,
    message text,
    log_level int2 CHECK (log_level IN (0,1,2,3)) DEFAULT 1,
    show_user boolean DEFAULT 'True',
    context text DEFAULT 'generic'
);
COMMENT ON TABLE SCHEMA_NAME.log_code IS 'Catalog of errors';
COMMENT ON COLUMN SCHEMA_NAME.log_code.id IS 'Error code';
COMMENT ON COLUMN SCHEMA_NAME.log_code.message IS 'Error message (already i18n)';
COMMENT ON COLUMN SCHEMA_NAME.log_code.log_level IS 'Log level of this error. { INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3 }';
COMMENT ON COLUMN SCHEMA_NAME.log_code.show_user IS 'If True, a message will be shown to the user';
COMMENT ON COLUMN SCHEMA_NAME.log_code.context IS 'Error context or observations. It can be: generic, ws, ud, function_name...';


-- Catalog of auditable functions
DROP TABLE IF EXISTS SCHEMA_NAME.log_function CASCADE; 
CREATE TABLE SCHEMA_NAME.log_function (
    id int4 PRIMARY KEY,
    name text NOT NULL,
    context text,
    input_params json, 
    return_type text
);
COMMENT ON TABLE SCHEMA_NAME.log_function IS 'Catalog of auditable functions';
COMMENT ON COLUMN SCHEMA_NAME.log_function.id IS 'Unique identifier of the function';
COMMENT ON COLUMN SCHEMA_NAME.log_function.name IS 'Name of the function';
COMMENT ON COLUMN SCHEMA_NAME.log_function.context IS 'ud, ws, utils,...';
COMMENT ON COLUMN SCHEMA_NAME.log_function.input_params IS 'Input parameters';
COMMENT ON COLUMN SCHEMA_NAME.log_function.return_type IS 'Function return type';


DROP TABLE IF EXISTS SCHEMA_NAME.log_detail CASCADE; 
CREATE TABLE IF NOT EXISTS SCHEMA_NAME.log_detail (
    id bigserial PRIMARY KEY,
    tstamp TIMESTAMP NOT NULL DEFAULT date_trunc('second', current_timestamp), 
    log_code_id integer NOT NULL,
    log_function_id int4,
    query text,
    user_name text,
    addr inet,
    debug_info text
);
COMMENT ON COLUMN SCHEMA_NAME.log_detail.id IS 'Unique identifier for each auditable event';
COMMENT ON COLUMN SCHEMA_NAME.log_detail.tstamp IS 'Timestamp in which audited event occurred';;
COMMENT ON COLUMN SCHEMA_NAME.log_detail.log_code_id IS 'Log code values. Check table log_code';
COMMENT ON COLUMN SCHEMA_NAME.log_detail.log_function_id IS 'Executed function name';
COMMENT ON COLUMN SCHEMA_NAME.log_detail.query IS 'Top-level query that caused this auditable event. May be more than one statement';
COMMENT ON COLUMN SCHEMA_NAME.log_detail.user_name IS 'Login / session user whose statement caused the audited event';
COMMENT ON COLUMN SCHEMA_NAME.log_detail.addr IS 'IP address of client that issued query. Null for unix domain socket';
COMMENT ON COLUMN SCHEMA_NAME.log_detail.debug_info IS 'Optional information. Recommended for debug purposes';


ALTER TABLE SCHEMA_NAME.log_detail ADD FOREIGN KEY ("log_code_id") 
REFERENCES SCHEMA_NAME.log_code ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE SCHEMA_NAME.log_detail ADD FOREIGN KEY ("log_function_id") 
REFERENCES SCHEMA_NAME.log_function ("id") ON DELETE CASCADE ON UPDATE CASCADE;


DROP VIEW IF EXISTS SCHEMA_NAME.v_audit_functions;
CREATE VIEW SCHEMA_NAME.v_audit_functions AS 
SELECT tstamp, log_code.id, log_code.message, log_code.log_level, log_code.show_user, user_name, addr, debug_info
FROM SCHEMA_NAME.log_detail INNER JOIN SCHEMA_NAME.log_code ON log_detail.log_code_id = log_code.id
ORDER BY log_detail.id DESC;


