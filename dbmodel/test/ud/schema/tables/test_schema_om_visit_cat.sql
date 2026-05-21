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
SELECT has_table('om_visit_cat'::name, 'Table om_visit_cat should exist');

-- Check columns
SELECT columns_are(
    'om_visit_cat',
    ARRAY[
        'id', 'name', 'startdate', 'enddate', 'descript', 'active',
        'extusercat_id', 'duration', 'feature_type', 'alias'
    ],
    'Table om_visit_cat should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_cat', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('om_visit_cat', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('om_visit_cat', 'startdate', 'date', 'Column startdate should be date');
SELECT col_type_is('om_visit_cat', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('om_visit_cat', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_visit_cat', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('om_visit_cat', 'extusercat_id', 'int4', 'Column extusercat_id should be int4');
SELECT col_type_is('om_visit_cat', 'duration', 'text', 'Column duration should be text');
SELECT col_type_is('om_visit_cat', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('om_visit_cat', 'alias', 'text', 'Column alias should be text');

-- Finish
SELECT * FROM finish();

ROLLBACK;
