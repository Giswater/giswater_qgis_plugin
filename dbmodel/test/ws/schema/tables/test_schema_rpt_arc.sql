/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table rpt_arc
SELECT has_table('rpt_arc'::name, 'Table rpt_arc should exist');

-- Check columns
SELECT columns_are(
    'rpt_arc',
    ARRAY[
        'id', 'result_id', 'arc_id', 'length', 'diameter', 'flow', 'vel', 'headloss', 
        'setting', 'reaction', 'ffactor', 'other', 'time', 'status'
    ],
    'Table rpt_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('rpt_arc', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('rpt_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('rpt_arc', 'result_id', 'character varying(30)', 'Column result_id should be character varying(30)');
SELECT col_type_is('rpt_arc', 'arc_id', 'character varying(16)', 'Column arc_id should be character varying(16)');
SELECT col_type_is('rpt_arc', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('rpt_arc', 'diameter', 'numeric', 'Column diameter should be numeric');
SELECT col_type_is('rpt_arc', 'flow', 'numeric', 'Column flow should be numeric');
SELECT col_type_is('rpt_arc', 'vel', 'numeric', 'Column vel should be numeric');
SELECT col_type_is('rpt_arc', 'headloss', 'numeric', 'Column headloss should be numeric');
SELECT col_type_is('rpt_arc', 'setting', 'numeric', 'Column setting should be numeric');
SELECT col_type_is('rpt_arc', 'reaction', 'numeric', 'Column reaction should be numeric');
SELECT col_type_is('rpt_arc', 'ffactor', 'numeric', 'Column ffactor should be numeric');
SELECT col_type_is('rpt_arc', 'other', 'character varying(100)', 'Column other should be character varying(100)');
SELECT col_type_is('rpt_arc', 'time', 'character varying(100)', 'Column time should be character varying(100)');
SELECT col_type_is('rpt_arc', 'status', 'character varying(16)', 'Column status should be character varying(16)');

-- Check default values
SELECT col_has_default('rpt_arc', 'id', 'Column id should have a default value');

-- Check constraints
SELECT col_not_null('rpt_arc', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('rpt_arc', 'result_id', 'Column result_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('rpt_arc', 'Table rpt_arc should have foreign keys');
SELECT fk_ok('rpt_arc', 'result_id', 'rpt_cat_result', 'result_id', 'FK result_id should reference rpt_cat_result.result_id');

-- Check indexes
SELECT has_index('rpt_arc', 'rpt_arc_arc_id', 'Table should have index on arc_id');
SELECT has_index('rpt_arc', 'rpt_arc_result_id', 'Table should have index on result_id');

SELECT * FROM finish();

ROLLBACK; 