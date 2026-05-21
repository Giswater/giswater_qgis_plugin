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
SELECT has_table('inp_pipe'::name, 'Table inp_pipe should exist');

-- Check columns
SELECT columns_are(
    'inp_pipe',
    ARRAY[
        'arc_id', 'minorloss', 'status', 'custom_roughness', 'custom_dint', 'reactionparam',
        'reactionvalue', 'bulk_coeff', 'wall_coeff'
    ],
    'Table inp_pipe should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_pipe', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('inp_pipe', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('inp_pipe', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_pipe', 'custom_roughness', 'numeric(12,4)', 'Column custom_roughness should be numeric(12,4)');
SELECT col_type_is('inp_pipe', 'custom_dint', 'numeric(12,3)', 'Column custom_dint should be numeric(12,3)');
SELECT col_type_is('inp_pipe', 'reactionparam', 'varchar(30)', 'Column reactionparam should be varchar(30)');
SELECT col_type_is('inp_pipe', 'reactionvalue', 'varchar(30)', 'Column reactionvalue should be varchar(30)');
SELECT col_type_is('inp_pipe', 'bulk_coeff', 'float8', 'Column bulk_coeff should be float8');
SELECT col_type_is('inp_pipe', 'wall_coeff', 'float8', 'Column wall_coeff should be float8');

-- Check foreign keys
SELECT has_fk('inp_pipe', 'Table inp_pipe should have foreign keys');

SELECT fk_ok('inp_pipe', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
