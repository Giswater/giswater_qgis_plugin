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
SELECT has_table('inp_conduit'::name, 'Table inp_conduit should exist');

-- Check columns
SELECT columns_are(
    'inp_conduit',
    ARRAY[
        'arc_id', 'barrels', 'culvert', 'kentry', 'kexit', 'kavg',
        'flap', 'q0', 'qmax', 'seepage', 'custom_n'
    ],
    'Table inp_conduit should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_conduit', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('inp_conduit', 'barrels', 'int2', 'Column barrels should be int2');
SELECT col_type_is('inp_conduit', 'culvert', 'varchar(10)', 'Column culvert should be varchar(10)');
SELECT col_type_is('inp_conduit', 'kentry', 'numeric(12,4)', 'Column kentry should be numeric(12,4)');
SELECT col_type_is('inp_conduit', 'kexit', 'numeric(12,4)', 'Column kexit should be numeric(12,4)');
SELECT col_type_is('inp_conduit', 'kavg', 'numeric(12,4)', 'Column kavg should be numeric(12,4)');
SELECT col_type_is('inp_conduit', 'flap', 'varchar(3)', 'Column flap should be varchar(3)');
SELECT col_type_is('inp_conduit', 'q0', 'numeric(12,4)', 'Column q0 should be numeric(12,4)');
SELECT col_type_is('inp_conduit', 'qmax', 'numeric(12,4)', 'Column qmax should be numeric(12,4)');
SELECT col_type_is('inp_conduit', 'seepage', 'numeric(12,4)', 'Column seepage should be numeric(12,4)');
SELECT col_type_is('inp_conduit', 'custom_n', 'numeric(12,4)', 'Column custom_n should be numeric(12,4)');

-- Check foreign keys
SELECT has_fk('inp_conduit', 'Table inp_conduit should have foreign keys');

SELECT fk_ok('inp_conduit', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
