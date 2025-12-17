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

-- Check table inp_dscenario_shortpipe
SELECT has_table('inp_dscenario_shortpipe'::name, 'Table inp_dscenario_shortpipe should exist');

-- Check columns
SELECT columns_are(
    'inp_dscenario_shortpipe',
    ARRAY[
        'dscenario_id', 'node_id', 'minorloss', 'status', 'bulk_coeff', 'wall_coeff', 'to_arc'
    ],
    'Table inp_dscenario_shortpipe should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('inp_dscenario_shortpipe', ARRAY['node_id', 'dscenario_id'], 'Columns node_id, dscenario_id should be primary key');

-- Check column types
SELECT col_type_is('inp_dscenario_shortpipe', 'dscenario_id', 'integer', 'Column dscenario_id should be integer');
SELECT col_type_is('inp_dscenario_shortpipe', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('inp_dscenario_shortpipe', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('inp_dscenario_shortpipe', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_dscenario_shortpipe', 'bulk_coeff', 'double precision', 'Column bulk_coeff should be double precision');
SELECT col_type_is('inp_dscenario_shortpipe', 'wall_coeff', 'double precision', 'Column wall_coeff should be double precision');
SELECT col_type_is('inp_dscenario_shortpipe', 'to_arc', 'integer', 'Column to_arc should be integer');

-- Check foreign keys
SELECT has_fk('inp_dscenario_shortpipe', 'Table inp_dscenario_shortpipe should have foreign keys');
SELECT fk_ok('inp_dscenario_shortpipe', 'dscenario_id', 'cat_dscenario', 'dscenario_id', 'FK dscenario_id should reference cat_dscenario.dscenario_id');
SELECT fk_ok('inp_dscenario_shortpipe', 'node_id', 'inp_shortpipe', 'node_id', 'FK node_id should reference inp_shortpipe.node_id');

-- Check triggers
SELECT has_trigger('inp_dscenario_shortpipe', 'gw_trg_typevalue_fk_insert', 'Trigger gw_trg_typevalue_fk_insert should exist');
SELECT has_trigger('inp_dscenario_shortpipe', 'gw_trg_typevalue_fk_update', 'Trigger gw_trg_typevalue_fk_update should exist');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('inp_dscenario_shortpipe', 'dscenario_id', 'Column dscenario_id should be NOT NULL');
SELECT col_not_null('inp_dscenario_shortpipe', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_has_check('inp_dscenario_shortpipe', 'status', 'Column status should have a check constraint');

SELECT * FROM finish();

ROLLBACK;