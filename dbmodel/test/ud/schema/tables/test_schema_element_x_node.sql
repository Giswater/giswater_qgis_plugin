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
SELECT has_table('element_x_node'::name, 'Table element_x_node should exist');

-- check columns names 


SELECT columns_are(
    'element_x_node',
    ARRAY[
      'element_id', 'node_id', 'node_uuid'
    ],
    'Table element_x_node should have the correct columns'

);
-- check columns names
SELECT col_type_is('element_x_node', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('element_x_node', 'node_id', 'int4', 'Column node_id should be int4');
SELECT col_type_is('element_x_node', 'node_uuid', 'uuid', 'Column node_uuid should be uuid');




--check default values


-- check foreign keys
SELECT has_fk('element_x_node', 'Table element_x_node should have foreign keys');

SELECT fk_ok('element_x_node','element_id','element','element_id','Table should have foreign key from element_id to element.element_id');
SELECT fk_ok('element_x_node','node_id','node','node_id','Table should have foreign key from node_id to node.node_id');



-- check indexes
SELECT has_index('element_x_node', 'element_x_node_pkey', 'Table element_x_node should have index on element_id, node_id');


--check trigger 


--check rule 

SELECT * FROM finish();

ROLLBACK;