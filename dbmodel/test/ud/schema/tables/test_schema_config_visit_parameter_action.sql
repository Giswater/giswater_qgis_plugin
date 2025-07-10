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
SELECT has_table('config_visit_parameter_action'::name, 'Table config_visit_parameter_action should exist');

-- check columns names 


SELECT columns_are(
    'config_visit_parameter_action',
    ARRAY[
     'parameter_id1', 'parameter_id1', 'action_type', 'action_value', 'active'
    ],
    'Table config_visit_parameter_action should have the correct columns'

);

-- check columns names

            SELECT col_type_is('config_visit_parameter_action', 'parameter_id1', 'varchar(50)', 'Column parameter_id1 should be varchar(50)');
            SELECT col_type_is('config_visit_parameter_action', 'parameter_id2', 'varchar(50)', 'Column parameter_id2 should be varchar(50)');
            SELECT col_type_is('config_visit_parameter_action', 'action_type', 'int4', 'Column action_type should be int4');
            SELECT col_type_is('config_visit_parameter_action', 'action_value', 'text', 'Column action_value should be text');
            SELECT col_type_is('config_visit_parameter_action', 'active', 'bool', 'Column active should be bool');


--check default values


-- check foreign keys
SELECT has_fk('config_visit_parameter_action', 'Table config_visit_parameter_action should have foreign keys');

SELECT fk_ok('config_visit_parameter_action','parameter_id1','config_visit_parameter','id','Table should have foreign key from parameter_id1 to config_visit_parameter.id');
SELECT fk_ok('config_visit_parameter_action','parameter_id2','config_visit_parameter','id','Table should have foreign key from parameter_id2 to config_visit_parameter.id');

-- check indexes
SELECT has_index('config_visit_parameter_action', 'action_type', 'Table config_visit_parameter_action should have index on action_type');
SELECT has_index('config_visit_parameter_action', 'parameter_id1', 'Table config_visit_parameter_action should have index on parameter_id1');
SELECT has_index('config_visit_parameter_action', 'parameter_id2', 'Table config_visit_parameter_action should have index on parameter_id2');




--check trigger 
SELECT has_trigger('config_visit_parameter_action', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('config_visit_parameter_action', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

--check rule

SELECT * FROM finish();

ROLLBACK;