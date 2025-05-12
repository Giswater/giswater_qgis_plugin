/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
BEGIN;

SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Table existence
SELECT has_table('minsector_mincut'::name, 'Table minsector_mincut should exist');

-- Columns check (order matters)
SELECT columns_are(
    'minsector_mincut',
    ARRAY[
        'minsector_id', 'minsectors'
    ],
    'Table minsector_mincut should have the correct columns'
);

-- PK
SELECT col_is_pk('minsector_mincut', 'minsector_id', 'Column minsector_id should be primary key');

-- Types
SELECT col_type_is('minsector_mincut', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('minsector_mincut', 'minsectors', 'integer[]', 'Column minsectors should be integer[]');

-- No FKs
SELECT hasnt_fk('minsector_mincut', 'Table minsector_mincut should have no foreign keys');

SELECT * FROM finish();

ROLLBACK;
