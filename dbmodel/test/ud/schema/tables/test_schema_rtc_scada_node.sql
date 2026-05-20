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
SELECT has_table('rtc_scada_node'::name, 'Table rtc_scada_node should exist');

-- Check columns
SELECT columns_are(
    'rtc_scada_node',
    ARRAY[
        'scada_id', 'node_id'
    ],
    'Table rtc_scada_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('rtc_scada_node', 'scada_id', 'varchar(16)', 'Column scada_id should be varchar(16)');
SELECT col_type_is('rtc_scada_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
