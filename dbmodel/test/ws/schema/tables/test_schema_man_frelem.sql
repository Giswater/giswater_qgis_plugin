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

-- Check table man_frelem
SELECT has_table('man_frelem'::name, 'Table man_frelem should exist');

-- Check columns
SELECT columns_are(
    'man_frelem',
    ARRAY[
        'element_id',
        'node_id',
        'order_id',
        'to_arc',
        'flwreg_length'
    ],
    'Table man_frelem should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('man_frelem', ARRAY['element_id'], 'Column element_id should be primary key');

-- Check column types
SELECT col_type_is('man_frelem', 'element_id', 'integer', 'Column element_id should be integer');
SELECT col_type_is('man_frelem', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('man_frelem', 'order_id', 'numeric', 'Column order_id should be numeric');
SELECT col_type_is('man_frelem', 'to_arc', 'integer', 'Column to_arc should be integer');
SELECT col_type_is('man_frelem', 'flwreg_length', 'numeric', 'Column flwreg_length should be numeric');

-- Check not null constraints
SELECT col_not_null('man_frelem', 'element_id', 'Column element_id should be NOT NULL');

-- Check foreign keys
SELECT fk_ok('man_frelem', 'element_id', 'element', 'element_id', 'FK element_id should reference element.element_id');
SELECT fk_ok('man_frelem', 'to_arc', 'arc', 'arc_id', 'FK to_arc should reference arc.arc_id');

SELECT * FROM finish();

ROLLBACK;