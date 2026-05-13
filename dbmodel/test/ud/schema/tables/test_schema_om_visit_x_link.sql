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
SELECT has_table('om_visit_x_link'::name, 'Table om_visit_x_link should exist');

-- Check columns
SELECT columns_are(
    'om_visit_x_link',
    ARRAY[
        'id', 'visit_id', 'link_id', 'is_last', 'link_uuid'
    ],
    'Table om_visit_x_link should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_visit_x_link', 'id', 'int8', 'Column id should be int8');
SELECT col_type_is('om_visit_x_link', 'visit_id', 'int8', 'Column visit_id should be int8');
SELECT col_type_is('om_visit_x_link', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('om_visit_x_link', 'is_last', 'bool', 'Column is_last should be bool');
SELECT col_type_is('om_visit_x_link', 'link_uuid', 'uuid', 'Column link_uuid should be uuid');

-- Check foreign keys
SELECT has_fk('om_visit_x_link', 'Table om_visit_x_link should have foreign keys');

SELECT fk_ok('om_visit_x_link', 'visit_id', 'om_visit', 'id', 'FK visit_id → om_visit.id');
SELECT fk_ok('om_visit_x_link', 'link_id', 'link', 'link_id', 'FK link_id → link.link_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
