-- An audit history is important on most tables. Provide an audit trigger that logs to
-- a dedicated audit table for the major relations.
-- This code is generic and not depend on application roles or structures. Is based on:
--   http://wiki.postgresql.org/wiki/Audit_trigger_91plus

-- Enable extension hstore
SET search_path = pg_catalog, public;
CREATE EXTENSION IF NOT EXISTS hstore;

-- Create schema for auditing
CREATE SCHEMA IF NOT EXISTS SCHEMA_NAME_audit;
REVOKE ALL ON SCHEMA SCHEMA_NAME_audit FROM public;
COMMENT ON SCHEMA SCHEMA_NAME_audit IS 'Out-of-table audit/history logging tables and trigger functions';

--
-- Audited data. Lots of information is available, it's just a matter of how much
-- you really want to record. See:
--   http://www.postgresql.org/docs/9.1/static/functions-info.html
--
-- Remember, every column you add takes up more audit table space and slows audit inserts.
--
-- Every index you add has a big impact too, so avoid adding indexes to the
-- audit table unless you REALLY need them. The hstore GIST indexes are
-- particularly expensive.
--
-- It is sometimes worth copying the audit table, or a coarse subset of it that
-- you're interested in, into a temporary table where you CREATE any useful
-- indexes and do your analysis.
--
CREATE TABLE IF NOT EXISTS SCHEMA_NAME_audit.log_actions (
    id bigserial PRIMARY KEY,
    tstamp_tx TIMESTAMP WITH TIME ZONE NOT NULL,    
    schema_name text not null,
    table_name text not null,
    relid oid not null,
    user_name text,
    addr inet,
    transaction_id bigint,
    action TEXT NOT NULL CHECK (action IN ('I','D','U','T')),
    query text,
    row_data hstore,
    changed_fields hstore
);

REVOKE ALL ON SCHEMA_NAME_audit.log_actions FROM public;

COMMENT ON TABLE SCHEMA_NAME_audit.log_actions IS 'History of auditable actions on audited tables, from SCHEMA_NAME_audit.if_modified_func()';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.id IS 'Unique identifier for each auditable event';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.schema_name IS 'Database schema audited table for this event is in';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.table_name IS 'Non-schema-qualified table name of table event occured in';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.relid IS 'Table OID. Changes with drop/create. Get with ''tablename''::regclass';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.user_name IS 'Login / session user whose statement caused the audited event';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.addr IS 'IP address of client that issued query. Null for unix domain socket.';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.transaction_id IS 'Identifier of transaction that made the change. May wrap, but unique paired with tstamp_tx.';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.tstamp_tx IS 'Transaction start timestamp for tx in which audited event occurred';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.action IS 'Action type; I = insert, D = delete, U = update, T = truncate';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.query IS 'Top-level query that caused this auditable event. May be more than one statement.';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.row_data IS 'Record value. Null for statement-level trigger. For INSERT this is the new tuple. For DELETE and UPDATE it is the old tuple.';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_actions.changed_fields IS 'New values of fields changed by UPDATE. Null except for row-level UPDATE events.';

DROP INDEX IF EXISTS SCHEMA_NAME_audit.log_actions_relid_idx;
DROP INDEX IF EXISTS SCHEMA_NAME_audit.log_actions_action_idx;
CREATE INDEX log_actions_relid_idx ON SCHEMA_NAME_audit.log_actions(relid);
CREATE INDEX log_actions_action_idx ON SCHEMA_NAME_audit.log_actions(action);


DROP VIEW IF EXISTS SCHEMA_NAME_audit.v_audit;
CREATE VIEW SCHEMA_NAME_audit.v_audit AS 
SELECT log_actions.tstamp_tx, table_name, action, query, row_data, changed_fields
FROM SCHEMA_NAME_audit.log_actions
ORDER BY log_actions.tstamp_tx DESC;  
  

  
DROP TABLE IF EXISTS SCHEMA_NAME_audit.log_code CASCADE;  
CREATE TABLE SCHEMA_NAME_audit.log_code (
    id integer PRIMARY KEY,
    message text,
    log_level int2 CHECK (log_level IN (0,1,2,3)) DEFAULT 1,
    show_user boolean DEFAULT 'True',
    context text DEFAULT 'generic'
);
COMMENT ON TABLE SCHEMA_NAME_audit.log_code IS 'Catalog of errors';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_code.id IS 'Error code';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_code.message IS 'Error message (already i18n)';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_code.log_level IS 'Log level of this error. { INFO = 0, WARNING = 1, CRITICAL = 2, SUCCESS = 3 }';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_code.show_user IS 'If True, a message will be shown to the user';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_code.context IS 'Error context or observations. It can be: generic, ws, ud, function_name...';


-- Catalog of auditable functions
DROP TABLE IF EXISTS SCHEMA_NAME_audit.log_function CASCADE; 
CREATE TABLE SCHEMA_NAME_audit.log_function (
    id int4 PRIMARY KEY,
    name text NOT NULL,
    context text,
    input_params json, 
    return_type text
);
COMMENT ON TABLE SCHEMA_NAME_audit.log_function IS 'Catalog of auditable functions';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_function.id IS 'Unique identifier of the function';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_function.name IS 'Name of the function';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_function.context IS 'ud, ws, utils,...';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_function.input_params IS 'Input parameters';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_function.return_type IS 'Function return type';


DROP TABLE IF EXISTS SCHEMA_NAME_audit.log_detail CASCADE; 
CREATE TABLE IF NOT EXISTS SCHEMA_NAME_audit.log_detail (
    id bigserial PRIMARY KEY,
    tstamp TIMESTAMP NOT NULL DEFAULT date_trunc('second', current_timestamp), 
    log_code_id integer NOT NULL,
    log_function_id int4,
    query text,
    user_name text,
    addr inet,
    debug_info text COLLATE
);
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.id IS 'Unique identifier for each auditable event';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.tstamp IS 'Timestamp in which audited event occurred';;
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.log_code_id IS 'Log code values. Check table log_code';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.log_function_id IS 'Executed function name';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.query IS 'Top-level query that caused this auditable event. May be more than one statement';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.user_name IS 'Login / session user whose statement caused the audited event';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.addr IS 'IP address of client that issued query. Null for unix domain socket';
COMMENT ON COLUMN SCHEMA_NAME_audit.log_detail.debug_info IS 'Optional information. Recommended for debug purposes';


ALTER TABLE SCHEMA_NAME_audit.log_detail ADD FOREIGN KEY ("log_code_id") 
REFERENCES SCHEMA_NAME_audit.log_code ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE SCHEMA_NAME_audit.log_detail ADD FOREIGN KEY ("log_function_id") 
REFERENCES SCHEMA_NAME_audit.log_function ("id") ON DELETE CASCADE ON UPDATE CASCADE;


DROP VIEW IF EXISTS SCHEMA_NAME_audit.v_audit_functions;
CREATE VIEW SCHEMA_NAME_audit.v_audit_functions AS 
SELECT tstamp, log_code.id, log_code.message, log_code.log_level, log_code.show_user, user_name, addr, debug_info
FROM SCHEMA_NAME_audit.log_detail INNER JOIN SCHEMA_NAME_audit.log_code ON log_detail.log_code_id = log_code.id
ORDER BY log_detail.id DESC;

