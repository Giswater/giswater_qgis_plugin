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
SELECT has_table('doc_x_link'::name, 'Table doc_x_link should exist');

-- check columns names 


SELECT columns_are(
    'doc_x_link',
    ARRAY[
      'doc_id', 'link_id', 'link_uuid'
    ],
    'Table doc_x_link should have the correct columns'

);
-- check columns names
SELECT col_type_is('doc_x_link', 'doc_id', 'varchar(30)', 'Column doc_id should be varchar(30)');
SELECT col_type_is('doc_x_link', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('doc_x_link', 'link_uuid', 'uuid', 'Column link_uuid should be uuid');





--check default values


-- check foreign keys
SELECT has_fk('doc_x_link', 'Table doc_x_link should have foreign keys');

SELECT fk_ok('doc_x_link','doc_id','doc','id','Table should have foreign key from doc_id to doc.id');
SELECT fk_ok('doc_x_link','link_id','link','link_id','Table should have foreign key from link_id to link.link_id');


-- check indexes
SELECT has_index('doc_x_link', 'doc_x_link_pkey', ARRAY['doc_id', 'link_id'], 'Table should have index on doc_id, link_id');



--check trigger 

--check rule 

SELECT * FROM finish();

ROLLBACK;