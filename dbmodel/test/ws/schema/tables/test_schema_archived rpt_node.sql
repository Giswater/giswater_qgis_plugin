*
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
SELECT has_table('archived_rpt_node'::name, 'Table archived_rpt_node should exist');

-- check columns names 


SELECT columns_are(
    'archived_rpt_node',
    ARRAY[
        'id', 'result_id', 'node_id','resultdate','resulttime', 'flooding', '"depth"', 'head', 'inflow', 
    ],
    'Table archived_rpt_node should have the correct columns'
);
-- check columns names
SELECT col_type_is('archived_rpt_node', 'id', 'serial14', 'Column id should be serial14');
SELECT col_type_is('archived_rpt_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('archived_rpt_node', 'resultdate', 'varchar(16)', 'Column resultdate should be varchar(16)');
SELECT col_type_is('archived_rpt_node', 'resulttime', 'varchar(12)', 'Column resulttime should be varchar(12)');
SELECT col_type_is('archived_rpt_node', 'flooding', 'float8', 'Column flooding should be float8');
SELECT col_type_is('archived_rpt_node', 'depth', 'float8', 'Column depth should be float8');
SELECT col_type_is('archived_rpt_node', 'head', 'float8', 'Column head should be float8');
SELECT col_type_is('archived_rpt_node', 'inflow', 'numeric(12, 4)', 'Column inflow should be numeric(12, 4)');



--check default values



-- check foreign keys


-- check index
SELECT has_index('archived_rpt_node', 'id', 'Table archived_rpt_node should have index on id');

--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;