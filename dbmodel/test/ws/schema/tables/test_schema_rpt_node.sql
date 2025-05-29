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

-- Check table rpt_node
SELECT has_table('rpt_node'::name, 'Table rpt_node should exist');

-- Check columns
SELECT columns_are(
    'rpt_node',
    ARRAY[
        'id', 'result_id', 'node_id', 'top_elev', 'demand', 'head', 'press', 'other', 'time', 'quality'
    ],
    'Table rpt_node should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rpt_node', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('rpt_node', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('rpt_node', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('rpt_node', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('rpt_node', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('rpt_node', 'demand', 'numeric', 'Column demand should be numeric');
SELECT col_type_is('rpt_node', 'head', 'numeric', 'Column head should be numeric');
SELECT col_type_is('rpt_node', 'press', 'numeric', 'Column press should be numeric');
SELECT col_type_is('rpt_node', 'other', 'character varying(100)', 'Column other should be character varying(100)');
SELECT col_type_is('rpt_node', 'time', 'character varying(100)', 'Column time should be character varying(100)');
SELECT col_type_is('rpt_node', 'quality', 'numeric(12,4)', 'Column quality should be numeric(12,4)');

-- Check default values
SELECT col_has_default('rpt_node', 'id', 'Column id should have a default value');

-- Check constraints
SELECT col_not_null('rpt_node', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('rpt_node', 'result_id', 'Column result_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('rpt_node', 'Table rpt_node should have foreign keys');
SELECT fk_ok('rpt_node', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id should reference rpt_cat_result.result_id');

SELECT * FROM finish();

ROLLBACK;