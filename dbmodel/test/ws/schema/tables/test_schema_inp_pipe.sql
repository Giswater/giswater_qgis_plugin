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

-- Check table inp_pipe
SELECT has_table('inp_pipe'::name, 'Table inp_pipe should exist');

-- Check columns
SELECT columns_are(
    'inp_pipe',
    ARRAY[
        'arc_id', 'minorloss', 'status', 'custom_roughness', 'custom_dint', 'reactionparam', 'reactionvalue',
        'bulk_coeff', 'wall_coeff'
    ],
    'Table inp_pipe should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_pipe', ARRAY['arc_id'], 'Column arc_id should be primary key');

-- Check column types
SELECT col_type_is('inp_pipe', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('inp_pipe', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('inp_pipe', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_pipe', 'custom_roughness', 'numeric(12,4)', 'Column custom_roughness should be numeric(12,4)');
SELECT col_type_is('inp_pipe', 'custom_dint', 'numeric(12,3)', 'Column custom_dint should be numeric(12,3)');
SELECT col_type_is('inp_pipe', 'reactionparam', 'varchar(30)', 'Column reactionparam should be varchar(30)');
SELECT col_type_is('inp_pipe', 'reactionvalue', 'varchar(30)', 'Column reactionvalue should be varchar(30)');
SELECT col_type_is('inp_pipe', 'bulk_coeff', 'double precision', 'Column bulk_coeff should be double precision');
SELECT col_type_is('inp_pipe', 'wall_coeff', 'double precision', 'Column wall_coeff should be double precision');

-- Check foreign keys
SELECT has_fk('inp_pipe', 'Table inp_pipe should have foreign keys');
SELECT fk_ok('inp_pipe', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');

-- Check triggers
SELECT has_trigger('inp_pipe', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_pipe', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_pipe', 'arc_id', 'Column arc_id should be NOT NULL');
SELECT col_has_default('inp_pipe', 'minorloss', 'Column minorloss should have default value');
SELECT col_has_check('inp_pipe', 'status', 'Column status should have a check constraint');

SELECT * FROM finish();

ROLLBACK;