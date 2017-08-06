/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- An audit history is important on most tables. Provide an audit trigger that logs to
-- a dedicated audit table for the major relations.
-- This code is generic and not depend on application roles or structures. Is based on:
--   http://wiki.postgresql.org/wiki/Audit_trigger_91plus

-- Enable extension hstore
SET search_path = pg_catalog, public;
CREATE EXTENSION IF NOT EXISTS hstore;

-- Create schema for auditing
--CREATE SCHEMA IF NOT EXISTS SCHEMA_NAME;
--REVOKE ALL ON SCHEMA SCHEMA_NAME FROM public;
--COMMENT ON SCHEMA SCHEMA_NAME IS 'Out-of-table audit/history logging tables and trigger functions';

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
CREATE TABLE IF NOT EXISTS SCHEMA_NAME.log_actions (
    id bigserial PRIMARY KEY,
    tstamp_tx TIMESTAMP WITH TIME ZONE NOT NULL,    
    SCHEMA_NAME text not null,
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


REVOKE ALL ON SCHEMA_NAME.log_actions FROM public;

COMMENT ON TABLE SCHEMA_NAME.log_actions IS 'History of auditable actions on audited tables, from SCHEMA_NAME.gw_trg_if_modified_func()';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.id IS 'Unique identifier for each auditable event';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.SCHEMA_NAME IS 'Database schema audited table for this event is in';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.table_name IS 'Non-schema-qualified table name of table event occured in';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.relid IS 'Table OID. Changes with drop/create. Get with ''tablename''::regclass';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.user_name IS 'Login / session user whose statement caused the audited event';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.addr IS 'IP address of client that issued query. Null for unix domain socket.';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.transaction_id IS 'Identifier of transaction that made the change. May wrap, but unique paired with tstamp_tx.';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.tstamp_tx IS 'Transaction start timestamp for tx in which audited event occurred';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.action IS 'Action type; I = insert, D = delete, U = update, T = truncate';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.query IS 'Top-level query that caused this auditable event. May be more than one statement.';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.row_data IS 'Record value. Null for statement-level trigger. For INSERT this is the new tuple. For DELETE and UPDATE it is the old tuple.';
COMMENT ON COLUMN SCHEMA_NAME.log_actions.changed_fields IS 'New values of fields changed by UPDATE. Null except for row-level UPDATE events.';

DROP INDEX IF EXISTS SCHEMA_NAME.log_actions_relid_idx;
DROP INDEX IF EXISTS SCHEMA_NAME.log_actions_action_idx;
CREATE INDEX log_actions_relid_idx ON SCHEMA_NAME.log_actions(relid);
CREATE INDEX log_actions_action_idx ON SCHEMA_NAME.log_actions(action);


DROP VIEW IF EXISTS SCHEMA_NAME.v_audit;
CREATE VIEW SCHEMA_NAME.v_audit AS 
SELECT log_actions.tstamp_tx, table_name, action, query, row_data, changed_fields
FROM SCHEMA_NAME.log_actions
ORDER BY log_actions.tstamp_tx DESC;  
  

  

