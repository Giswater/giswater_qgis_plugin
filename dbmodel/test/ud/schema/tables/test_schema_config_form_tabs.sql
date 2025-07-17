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
SELECT has_table('config_form_tabs'::name, 'Table config_form_tabs should exist');

-- check columns names 


SELECT columns_are(
    'config_form_tabs',
    ARRAY[
      'formname', 'tabname', 'label', 'tooltip', 'sys_role', 'tabfunction', 'tabactions', 'orderby', 'device'
    ],
    'Table config_form_tabs should have the correct columns'

);
-- check columns names
SELECT col_type_is('config_form_tabs', 'formname', 'varchar(50)', 'Column formname should be varchar(50)');
SELECT col_type_is('config_form_tabs', 'tabname', 'text', 'Column tabname should be text');
SELECT col_type_is('config_form_tabs', 'label', 'text', 'Column label should be text');
SELECT col_type_is('config_form_tabs', 'tooltip', 'text', 'Column tooltip should be text');
SELECT col_type_is('config_form_tabs', 'sys_role', 'text', 'Column sys_role should be text');
SELECT col_type_is('config_form_tabs', 'tabfunction', 'json', 'Column tabfunction should be json');
SELECT col_type_is('config_form_tabs', 'tabactions', 'json', 'Column tabactions should be json');
SELECT col_type_is('config_form_tabs', 'orderby', 'int4', 'Column orderby should be int4');
SELECT col_type_is('config_form_tabs', 'device', '_int4', 'Column device should be _int4');


--check default values


-- check foreign keys


-- check indexes
SELECT has_index('config_form_tabs', 'formname', 'Table config_form_tabs should have index on formname');
SELECT has_index('config_form_tabs', 'tabname', 'Table config_form_tabs should have index on tabname');



--check trigger 
SELECT has_trigger('config_form_tabs', 'gw_trg_typevalue_fk_insert', 'Table config_form_tabs should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('config_form_tabs', 'gw_trg_typevalue_fk_update', 'Table config_form_tabs should have trigger gw_trg_typevalue_fk_update');
--check rule 

SELECT * FROM finish();

ROLLBACK;