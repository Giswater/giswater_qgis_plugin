/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

--check if table exists
SELECT has_table('archived_rpt_subcatchrunoff_sum'::name, 'Table archived_rpt_subcatchrunoff_sum should exist');

-- check columns names 


SELECT columns_are(
    'audit_check_project',
    ARRAY[
       'id', 'table_id', 'table_host', 'table_dbname', 'table_schema', 'fid', 'criticity', 'enabled', 'message', 'tstamp', 'cur_user', 'observ', 'table_user',
    ],
    'Table audit_check_project should have the correct columns'
);
-- check columns names
SELECT col_type_is('audit_check_project', 'id', 'serial4', 'Column id should be serial4');
SELECT col_type_is('audit_check_project', 'table_id', 'text', 'Column table_id should be text');
SELECT col_type_is('audit_check_project', 'table_host', 'text', 'Column table_host should be text');
SELECT col_type_is('audit_check_project', 'table_dbname', 'text', 'Column table_dbname should be text');
SELECT col_type_is('audit_check_project', 'table_schema', 'text', 'Column table_schema should be text');
SELECT col_type_is('audit_check_project', 'fid', 'int4', 'Column fid should be int4');
SELECT col_type_is('audit_check_project', 'criticity', 'int2', 'Column criticity should be int2');
SELECT col_type_is('audit_check_project', 'enabled', 'bool', 'Column enabled should be bool');
SELECT col_type_is('audit_check_project', 'message', 'text', 'Column message should be text');
SELECT col_type_is('audit_check_project', 'tstamp', 'timestamp', 'Column tstamp should be timestamp DEFAULT now()');
SELECT col_type_is('audit_check_project', 'cur_user', 'text', 'Column cur_user should be text DEFAULT ''"current_user"()''');
SELECT col_type_is('audit_check_project', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('audit_check_project', 'table_user', 'text', 'Column table_user should be text');



--check default values



-- check foreign keys
SELECT has_fk('audit_check_project', 'Table audit_check_project should have foreign keys');

SELECT fk_ok('audit_check_project', 'fid', 'sys_fprocess', 'fid', 'Table should have foreign key from fid to sys_fprocess.fid');

-- check ind
SELECT has_index('audit_check_project', 'id', 'Table audit_check_project should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;