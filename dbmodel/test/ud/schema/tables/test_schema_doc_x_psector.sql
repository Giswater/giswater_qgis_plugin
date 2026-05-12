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
SELECT has_table('doc_x_psector'::name, 'Table doc_x_psector should exist');

-- check columns names 


SELECT columns_are(
    'doc_x_psector',
    ARRAY[
      'doc_id', 'psector_id'
    ],
    'Table doc_x_psector should have the correct columns'

);
-- check columns names
SELECT col_type_is('doc_x_psector', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_psector', 'psector_id', 'int4', 'Column psector_id should be int4');





--check default values


-- check foreign keys
SELECT has_fk('doc_x_psector', 'Table doc_x_psector should have foreign keys');

SELECT fk_ok('doc_x_psector', 'doc_id','doc','id','Table should have foreign key from doc_id to doc.id');
SELECT fk_ok('doc_x_psector','psector_id','plan_psector','psector_id', 'Table should have foreign key from psector_id to plan_psector.psector_id');

-- check indexes
SELECT has_index('doc_x_psector', 'doc_x_psector_pkey', ARRAY['doc_id', 'psector_id'], 'Table should have index on doc_id, psector_id');


--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;