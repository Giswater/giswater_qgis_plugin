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
SELECT has_table('config_typevalue'::name, 'Table config_typevalue should exist');

-- check columns names 


SELECT columns_are(
    'config_typevalue',
    ARRAY[
     'typevalue', 'id', 'idval', 'camelstyle', 'addparam'
    ],
    'Table config_typevalue should have the correct columns'

);
-- check columns names

SELECT col_type_is('config_typevalue', 'typevalue', 'varchar(50)', 'Column typevalue should be varchar(50)');
SELECT col_type_is('config_typevalue', 'id', 'varchar(100)', 'Column id should be varchar(100)');
SELECT col_type_is('config_typevalue', 'idval', 'varchar(100)', 'Column idval should be varchar(100)');
SELECT col_type_is('config_typevalue', 'camelstyle', 'text', 'Column camelstyle should be text');
SELECT col_type_is('config_typevalue', 'addparam', 'json', 'Column addparam should be json');

--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_typevalue', 'config_typevalue_pkey', ARRAY['typevalue','id'], 'Table config_typevalue should have index on typevalue, id');

--check trigger 
SELECT has_trigger('config_typevalue', 'gw_trg_typevalue_config_fk', 'Table config_typevalue should have trigger gw_trg_typevalue_config_fk');
--check rule 

SELECT * FROM finish();

ROLLBACK;