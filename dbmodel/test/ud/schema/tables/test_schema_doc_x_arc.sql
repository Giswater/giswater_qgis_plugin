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
SELECT has_table('doc_x_arc'::name, 'Table doc_x_arc should exist');

-- check columns names 


SELECT columns_are(
    'doc_x_arc',
    ARRAY[
      'doc_id', 'arc_id', 'arc_uuid'
    ],
    'Table doc_x_arc should have the correct columns'

);
-- check columns names
SELECT col_type_is('doc_x_arc', 'doc_id', 'integer', 'Column doc_id should be integer');
SELECT col_type_is('doc_x_arc', 'arc_id', 'int4', 'Column arc_id should be varchar(30)');
SELECT col_type_is('doc_x_arc', 'arc_uuid', 'uuid', 'Column arc_uuid should be uuid');





--check default values


-- check foreign keys
SELECT fk_ok('doc_x_arc','arc_id','arc','arc_id','Table should have foreign key from arc_id to arc.arc_id');
SELECT fk_ok('doc_x_arc', 'doc_id','doc','id', 'Table should have foreign key from doc_id to doc.id');

-- check indexes
SELECT has_index('doc_x_arc', 'doc_x_arc_pkey', ARRAY['doc_id','arc_id'], 'Table doc_x_arc should have index on doc_id, arc_id');



--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;