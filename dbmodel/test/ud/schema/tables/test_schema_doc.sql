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
SELECT has_table('doc'::name, 'Table doc should exist');

-- check columns names 


SELECT columns_are(
    'doc',
    ARRAY[
      'id', 'name', 'doc_type', 'path', 'observ', 'date', 'user_name', 'tstamp', 'the_geom', 'code'
    ],
    'Table doc should have the correct columns'

);
-- check columns names
SELECT col_type_is('doc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('doc', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('doc', 'doc_type', 'varchar(30)', 'Column doc_type should be varchar(30)');
SELECT col_type_is('doc', 'path', 'varchar(512)', 'Column path should be varchar(512)');
SELECT col_type_is('doc', 'observ', 'varchar(512)', 'Column observ should be varchar(512)');
SELECT col_type_is('doc', 'date', 'timestamp(6)', 'Column date should be timestamp(6)');
SELECT col_type_is('doc', 'user_name', 'varchar(50)', 'Column user_name should be varchar(50)');
SELECT col_type_is('doc', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('doc', 'the_geom', 'public.geometry(point, 25831)', 'Column the_geom should be public.geometry(point, 25831)');
SELECT col_type_is('doc', 'code', 'varchar(30)', 'Column code should be varchar(30)');




--check default values
SELECT col_has_default('doc', 'date', 'Column date should have default value');
SELECT col_has_default('doc', 'user_name', 'Column user_name should have default value');
SELECT col_has_default('doc', 'tstamp', 'Column tstamp should have default value');

-- check foreign keys

-- check indexes
SELECT has_index('doc', 'doc_pkey', 'Table doc should have index on id');
SELECT has_index('doc', 'name_chk', 'Table doc should have index on name');



--check trigger 
SELECT has_trigger('doc', 'gw_trg_doc', 'Table doc should have trigger gw_trg_doc');
--check rule 

SELECT * FROM finish();

ROLLBACK;