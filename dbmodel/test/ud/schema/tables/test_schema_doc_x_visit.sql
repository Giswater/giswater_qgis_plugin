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
SELECT has_table('doc_x_visit'::name, 'Table doc_x_visit should exist');

-- check columns names 


SELECT columns_are(
    'doc_x_visit',
    ARRAY[
      'doc_id', 'visit_id'
    ],
    'Table doc_x_visit should have the correct columns'

);
-- check columns names
SELECT col_type_is('doc_x_visit', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_visit', 'visit_id', 'int4', 'Column visit_id should be int4');





--check default values


-- check foreign keys
SELECT has_fk('doc_x_visit', 'Table doc_x_visit should have foreign keys');

SELECT fk_ok('doc_x_visit','doc_id','doc','id','Table should have foreign key from doc_id to doc.id');
SELECT fk_ok('doc_x_visit','visit_id','om_visit','id','Table should have foreign key from visit_id to om_visit.id');
-- check indexes
SELECT has_index('doc_x_visit', 'doc_x_visit_pkey', ARRAY['doc_id', 'visit_id'], 'Table should have index on doc_id, visit_id');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;