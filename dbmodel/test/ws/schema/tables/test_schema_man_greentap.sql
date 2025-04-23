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

-- Check table man_greentap
SELECT has_table('man_greentap'::name, 'Table man_greentap should exist');

-- Check columns
SELECT columns_are(
    'man_greentap',
    ARRAY[
        'connec_id', 'linked_connec', 'greentap_type'
    ],
    'Table man_greentap should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_greentap', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('man_greentap', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('man_greentap', 'linked_connec', 'varchar(16)', 'Column linked_connec should be varchar(16)');
SELECT col_type_is('man_greentap', 'greentap_type', 'text', 'Column greentap_type should be text');

-- Check not null constraints
SELECT col_not_null('man_greentap', 'connec_id', 'Column connec_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_greentap', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');
SELECT fk_ok('man_greentap', 'linked_connec', 'connec', 'connec_id', 'FK linked_connec should reference connec.connec_id');

SELECT * FROM finish();

ROLLBACK; 