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

--check if table exists
SELECT has_table('arc_add'::name, 'Table arc_add should exist');

-- check columns names 


SELECT columns_are(
    'arc_add',
    ARRAY[
        'arc_id', 'result_id', 'max_flow','max_veloc','mfull_flow', 'mfull_depth','manning_veloc', 'manning_flow','dwf_minflow',
         'dwf_maxflow', 'dwf_minvel', 'dwf_maxvel', 'conduit_capacity', 
    ],
    'Table arc_add should have the correct columns'
);
-- check columns names
SELECT col_type_is('arc_add', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('arc_add', 'result_id', 'text', 'Column result_id should be text');
SELECT col_type_is('arc_add', 'max_flow', 'numeric(12, 2)', 'Column max_flow should be numeric(12, 2)');
SELECT col_type_is('arc_add', 'max_veloc', 'numeric(12, 2)', 'Column max_veloc should be numeric(12, 2)');
SELECT col_type_is('arc_add', 'mfull_flow', 'numeric(12, 2)', 'Column mfull_flow should be numeric(12, 2)');
SELECT col_type_is('arc_add', 'mfull_depth', 'numeric(12, 2)', 'Column mfull_depth should be numeric(12, 2)');
SELECT col_type_is('arc_add', 'manning_veloc', 'numeric(12, 3)', 'Column manning_veloc should be numeric(12, 3)');
SELECT col_type_is('arc_add', 'manning_flow', 'numeric(12, 3)', 'Column manning_flow should be numeric(12, 3)');
SELECT col_type_is('arc_add', 'dwf_minflow', 'numeric(12, 3)', 'Column dwf_minflow should be numeric(12, 3)');
SELECT col_type_is('arc_add', 'dwf_maxflow', 'numeric(12, 3)', 'Column dwf_minflow should be numeric(12, 3)');
SELECT col_type_is('arc_add', 'dwf_minvel', 'numeric(12, 3)', 'Column dwf_minvel should be numeric(12, 3)');
SELECT col_type_is('arc_add', 'dwf_maxvel', 'numeric(12, 3)', 'Column dwf_maxvel should be numeric(12, 3)');
SELECT col_type_is('arc_add', 'conduit_capacity', 'float8', 'Column conduit_capacity should be float8');




--check default values


-- check foreign keys
SELECT has_fk('arc_add', 'Table arc_add should have foreign keys');

SELECT fk_ok('arc_add', 'arc_id', 'arc', 'arc_id', 'Table should have foreign key from arc_id to arc.arc_id');


-- check index
SELECT has_index('arc_add', 'arc_id', 'Table arc_add should have index on arc_id');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;