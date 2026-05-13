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

-- Check table
SELECT has_table('man_samplepoint'::name, 'Table man_samplepoint should exist');

-- Check columns
SELECT columns_are(
    'man_samplepoint',
    ARRAY[
        'connec_id', 'lab_code', 'place_name', 'cabinet'
    ],
    'Table man_samplepoint should have the correct columns'
);

-- Check column types
SELECT col_type_is('man_samplepoint', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('man_samplepoint', 'lab_code', 'varchar(30)', 'Column lab_code should be varchar(30)');
SELECT col_type_is('man_samplepoint', 'place_name', 'varchar(254)', 'Column place_name should be varchar(254)');
SELECT col_type_is('man_samplepoint', 'cabinet', 'varchar(150)', 'Column cabinet should be varchar(150)');

-- Check foreign keys
SELECT has_fk('man_samplepoint', 'Table man_samplepoint should have foreign keys');

SELECT fk_ok('man_samplepoint', 'connec_id', 'connec', 'connec_id', 'FK connec_id → connec.connec_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
