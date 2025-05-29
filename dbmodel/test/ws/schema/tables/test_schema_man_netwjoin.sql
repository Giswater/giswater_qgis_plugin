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

-- Check table man_netwjoin
SELECT has_table('man_netwjoin'::name, 'Table man_netwjoin should exist');

-- Check columns
SELECT columns_are(
    'man_netwjoin',
    ARRAY[
        'node_id', 'customer_code', 'top_floor', 'wjoin_type'
    ],
    'Table man_netwjoin should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_netwjoin', ARRAY['node_id'], 'Column node_id should be primary key');

-- Check column types
SELECT col_type_is('man_netwjoin', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_netwjoin', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');
SELECT col_type_is('man_netwjoin', 'top_floor', 'integer', 'Column top_floor should be integer');
SELECT col_type_is('man_netwjoin', 'wjoin_type', 'text', 'Column wjoin_type should be text');

-- Check not null constraints
SELECT col_not_null('man_netwjoin', 'node_id', 'Column node_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_netwjoin', 'node_id', 'node', 'node_id', 'FK node_id should reference node.node_id');

SELECT * FROM finish();

ROLLBACK;