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
SELECT has_table('om_visit_x_connec'::name, 'Table om_visit_x_connec should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_connec',
    ARRAY[
        'id', 'visit_id', 'connec_id', 'is_last', 'connec_uuid'
    ],
    'Table om_visit_x_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_x_connec', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit_x_connec', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('om_visit_x_connec', 'connec_id', 'int4', 'Column connec_id should be int4');
SELECT col_type_is('om_visit_x_connec', 'is_last', 'bool', 'Column is_last should be bool');
SELECT col_type_is('om_visit_x_connec', 'connec_uuid', 'uuid', 'Column connec_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('om_visit_x_connec', 'Table om_visit_x_connec should have foreign keys');

SELECT fk_ok('om_visit_x_connec', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');
SELECT fk_ok('om_visit_x_connec', 'connec_id', 'connec', 'connec_id', 'FK connec_id → connec.connec_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
