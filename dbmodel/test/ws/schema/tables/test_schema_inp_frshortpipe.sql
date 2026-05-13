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
SELECT has_table('inp_frshortpipe'::name, 'Table inp_frshortpipe should exist');

-- Check columns
SELECT columns_are(
    'inp_frshortpipe',
    ARRAY[
        'element_id', 'minorloss', 'status', 'bulk_coeff', 'wall_coeff', 'custom_dint'
    ],
    'Table inp_frshortpipe should have the correct columns'
);

-- Check column types
SELECT col_type_is('inp_frshortpipe', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('inp_frshortpipe', 'minorloss', 'numeric(12,6)', 'Column minorloss should be numeric(12,6)');
SELECT col_type_is('inp_frshortpipe', 'status', 'varchar(12)', 'Column status should be varchar(12)');
SELECT col_type_is('inp_frshortpipe', 'bulk_coeff', 'float8', 'Column bulk_coeff should be float8');
SELECT col_type_is('inp_frshortpipe', 'wall_coeff', 'float8', 'Column wall_coeff should be float8');
SELECT col_type_is('inp_frshortpipe', 'custom_dint', 'int4', 'Column custom_dint should be int4');

-- Check foreign keys
SELECT has_fk('inp_frshortpipe', 'Table inp_frshortpipe should have foreign keys');

SELECT fk_ok('inp_frshortpipe', 'element_id', 'element', 'element_id', 'FK element_id → element.element_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
