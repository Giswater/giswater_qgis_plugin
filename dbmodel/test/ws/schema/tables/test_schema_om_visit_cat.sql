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

-- Check table om_visit_cat
SELECT has_table('om_visit_cat'::name, 'Table om_visit_cat should exist');

-- Check columns
SELECT columns_are(
    'om_visit_cat',
    ARRAY[
        'id', 'name', 'startdate', 'enddate', 'descript', 'active', 'extusercat_id', 'duration', 'feature_type', 'alias'
    ],
    'Table om_visit_cat should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_visit_cat', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('om_visit_cat', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('om_visit_cat', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('om_visit_cat', 'startdate', 'date', 'Column startdate should be date');
SELECT col_type_is('om_visit_cat', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('om_visit_cat', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('om_visit_cat', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('om_visit_cat', 'extusercat_id', 'integer', 'Column extusercat_id should be integer');
SELECT col_type_is('om_visit_cat', 'duration', 'text', 'Column duration should be text');
SELECT col_type_is('om_visit_cat', 'feature_type', 'text', 'Column feature_type should be text');
SELECT col_type_is('om_visit_cat', 'alias', 'text', 'Column alias should be text');

-- Check default values
SELECT col_default_is('om_visit_cat', 'startdate', 'now()', 'Column startdate should default to now()');
SELECT col_default_is('om_visit_cat', 'active', 'true', 'Column active should default to true');

SELECT * FROM finish();

ROLLBACK; 