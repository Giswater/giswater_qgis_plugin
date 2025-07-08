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
SELECT has_table('cat_descenario'::name, 'Table cat_descenario should exist');

-- check columns names 


SELECT columns_are(
    'cat_descenario',
    ARRAY[
       'dscenario_id', '"name"', 'descript', 'parent_id', 'descenario_type', '', 'gactive', 'expl_id', 'log'
    'Table cat_descenario should have the correct columns'
);
-- check columns names
SELECT col_type_is('cat_descenario', 'dscenario_id', 'serial14', 'Column dscenario_id should be serial14');
SELECT col_type_is('cat_descenario', '"name"', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('cat_descenario', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('cat_descenario', 'parent_id', 'int4', 'Column parent_id should be int4');
SELECT col_type_is('cat_descenario', 'descenario_type', 'text', 'Column descenario_type should be text');
SELECT col_type_is('cat_descenario', 'gactive', 'bool', 'Column gactive should be bool');
SELECT col_type_is('cat_descenario', 'expl_id', 'int4', 'Column expl_id should be varchar(30)');
SELECT col_type_is('cat_descenario', 'log', 'text', 'Column log should be text');





--check default values



-- check foreign keys
SELECT has_fk('cat_descenario', 'Table cat_descenario should have foreign keys');

SELECT fk_ok(
  'cat_dscenario', 'expl_id', 'exploitation', 'expl_id', 'Table should have foreign key from expl_id to exploitation.expl_id');

SELECT fk_ok(
  'cat_dscenario', 'parent_id', 'cat_dscenario', 'dscenario_id', 'Table should have foreign key from parent_id to cat_dscenario.dscenario_id');

SELECT fk_ok('cat_descenario', 'expl_id', 'cat_expl', 'id', 'Table should have foreign key from expl_id to cat_expl.id');
-- check ind
SELECT has_index('cat_descenario', '"name"', 'Table cat_descenario should have index on name');
SELECT has_index('cat_descenario', 'descenario_id', 'Table cat_descenario should have index on descenario_id');

--check trigger 
SELECT has_trigger('cat_descenario', 'gw_trg_cat_dscenario ', 'Table cat_descenario should have trigger gw_trg_cat_dscenario');
SELECT has_trigger('cat_descenario', 'gw_trg_typevalue_fk_insert ', 'Table cat_descenario should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('cat_descenario', 'gw_trg_typevalue_fk_update ', 'Table cat_descenario should have trigger gw_trg_typevalue_fk_update');
--check rule


SELECT * FROM finish();

ROLLBACK;