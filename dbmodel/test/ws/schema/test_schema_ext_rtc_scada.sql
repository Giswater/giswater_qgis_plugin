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

-- Check table ext_rtc_scada
SELECT has_table('ext_rtc_scada'::name, 'Table ext_rtc_scada should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_scada',
    ARRAY[
        'scada_id', 'source', 'source_id', 'node_id', 'code', 'type_id', 'class_id',
        'category_id', 'catalog_id', 'descript', 'tagname', 'units'
    ],
    'Table ext_rtc_scada should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_rtc_scada', ARRAY['scada_id'], 'Column scada_id should be primary key');

-- Check column types
SELECT col_type_is('ext_rtc_scada', 'scada_id', 'varchar(30)', 'Column scada_id should be varchar(30)');
SELECT col_type_is('ext_rtc_scada', 'source', 'varchar(30)', 'Column source should be varchar(30)');
SELECT col_type_is('ext_rtc_scada', 'source_id', 'varchar(30)', 'Column source_id should be varchar(30)');
SELECT col_type_is('ext_rtc_scada', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('ext_rtc_scada', 'code', 'varchar(50)', 'Column code should be varchar(50)');
SELECT col_type_is('ext_rtc_scada', 'type_id', 'varchar(50)', 'Column type_id should be varchar(50)');
SELECT col_type_is('ext_rtc_scada', 'class_id', 'varchar(50)', 'Column class_id should be varchar(50)');
SELECT col_type_is('ext_rtc_scada', 'category_id', 'varchar(50)', 'Column category_id should be varchar(50)');
SELECT col_type_is('ext_rtc_scada', 'catalog_id', 'varchar(50)', 'Column catalog_id should be varchar(50)');
SELECT col_type_is('ext_rtc_scada', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ext_rtc_scada', 'tagname', 'text', 'Column tagname should be text');
SELECT col_type_is('ext_rtc_scada', 'units', 'text', 'Column units should be text');

-- Check indexes

-- Check unique constraints
SELECT has_unique('ext_rtc_scada', 'Table ext_rtc_scada should have unique constraint');
SELECT col_is_unique('ext_rtc_scada', ARRAY['source', 'source_id'], 'Column source and source_id should be unique');

-- Check foreign keys
SELECT hasnt_fk('ext_rtc_scada', 'Table ext_rtc_scada should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('ext_rtc_scada', 'scada_id', 'Column scada_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
