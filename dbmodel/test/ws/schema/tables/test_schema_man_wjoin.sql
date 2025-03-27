/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table man_wjoin
SELECT has_table('man_wjoin'::name, 'Table man_wjoin should exist');

-- Check columns
SELECT columns_are(
    'man_wjoin',
    ARRAY[
        'connec_id', 'top_floor', 'wjoin_type'
    ],
    'Table man_wjoin should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_wjoin', ARRAY['connec_id'], 'Column connec_id should be primary key');

-- Check column types
SELECT col_type_is('man_wjoin', 'connec_id', 'varchar(16)', 'Column connec_id should be varchar(16)');
SELECT col_type_is('man_wjoin', 'top_floor', 'integer', 'Column top_floor should be integer');
SELECT col_type_is('man_wjoin', 'wjoin_type', 'text', 'Column wjoin_type should be text');

-- Check foreign keys
SELECT has_fk('man_wjoin', 'Table man_wjoin should have foreign keys');
SELECT fk_ok('man_wjoin', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');

-- Check constraints
SELECT col_not_null('man_wjoin', 'connec_id', 'Column connec_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 