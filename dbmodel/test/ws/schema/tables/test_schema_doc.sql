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

-- Check table doc
SELECT has_table('doc'::name, 'Table doc should exist');

-- Check columns
SELECT columns_are(
    'doc',
    ARRAY[
        'id', 'name', 'doc_type', 'path', 'observ', 'date', 'user_name', 'tstamp', 'the_geom', 'code'
    ],
    'Table doc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('doc', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('doc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('doc', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('doc', 'doc_type', 'varchar(30)', 'Column doc_type should be varchar(30)');
SELECT col_type_is('doc', 'path', 'varchar(512)', 'Column path should be varchar(512)');
SELECT col_type_is('doc', 'observ', 'varchar(512)', 'Column observ should be varchar(512)');
SELECT col_type_is('doc', 'date', 'timestamp(6)', 'Column date should be timestamp');
SELECT col_type_is('doc', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('doc', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('doc', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('doc', 'code', 'varchar(30)', 'Column code should be varchar(30)');

-- Check foreign keys

-- Check triggers
SELECT has_trigger('doc', 'gw_trg_doc', 'Table should have gw_trg_doc trigger');

-- Check rules

-- Check sequences
SELECT has_sequence('doc_seq', 'Sequence doc_seq should exist');

-- Check constraints
SELECT col_not_null('doc', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('doc', 'name', 'Column name should be NOT NULL');
SELECT col_not_null('doc', 'doc_type', 'Column doc_type should be NOT NULL');
SELECT col_not_null('doc', 'path', 'Column path should be NOT NULL');

SELECT col_default_is('doc', 'id', 'nextval(''doc_seq''::regclass)', 'Column id should default to nextval');
SELECT col_default_is('doc', 'date', 'now()', 'Column date should default to now()');
SELECT col_default_is('doc', 'user_name', 'USER', 'Column user_name should default to USER');
SELECT col_default_is('doc', 'tstamp', 'now()', 'Column tstamp should default to now()');


SELECT * FROM finish();

ROLLBACK;
