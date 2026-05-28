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

-- Check table
SELECT has_table('ext_hydrometer'::name, 'Table ext_hydrometer should exist');

-- Check columns
SELECT columns_are(
    'ext_hydrometer',
    ARRAY[
        'hydrometer_id', 'code', 'customer_name', 'id_number',
        'start_date', 'hydro_number', 'identif', 'state_id', 'expl_id', 'hydro_customer_code',
        'plot_code', 'priority_id', 'catalog_id', 'category_id', 'wmeter_number', 'muni_id',
        'address1_1', 'address1_2', 'address1_3', 'address2_1', 'address2_2', 'address2_3',
        'assessed_volume', 'wmeter_builtdate', 'end_date', 'update_date', 'shutdown_date', 'is_waterbal',
        'link', 'customer_code'
    ],
    'Table ext_hydrometer should have the correct columns'
);

-- Check column types
SELECT col_type_is('ext_hydrometer', 'hydrometer_id', 'int4', 'Column hydrometer_id should be int4');
SELECT col_type_is('ext_hydrometer', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_hydrometer', 'customer_name', 'text', 'Column customer_name should be text');
SELECT col_type_is('ext_hydrometer', 'id_number', 'text', 'Column id_number should be text');
SELECT col_type_is('ext_hydrometer', 'start_date', 'date', 'Column start_date should be date');
SELECT col_type_is('ext_hydrometer', 'hydro_number', 'text', 'Column hydro_number should be text');
SELECT col_type_is('ext_hydrometer', 'identif', 'text', 'Column identif should be text');
SELECT col_type_is('ext_hydrometer', 'state_id', 'int2', 'Column state_id should be int2');
SELECT col_type_is('ext_hydrometer', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ext_hydrometer', 'hydro_customer_code', 'varchar(30)', 'Column hydro_customer_code should be varchar(30)');
SELECT col_type_is('ext_hydrometer', 'plot_code', 'varchar(100)', 'Column plot_code should be varchar(100)');
SELECT col_type_is('ext_hydrometer', 'priority_id', 'int4', 'Column priority_id should be int4');
SELECT col_type_is('ext_hydrometer', 'catalog_id', 'int4', 'Column catalog_id should be int4');
SELECT col_type_is('ext_hydrometer', 'category_id', 'int4', 'Column category_id should be int4');
SELECT col_type_is('ext_hydrometer', 'wmeter_number', 'int4', 'Column wmeter_number should be int4');
SELECT col_type_is('ext_hydrometer', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ext_hydrometer', 'address1_1', 'text', 'Column address1_1 should be text');
SELECT col_type_is('ext_hydrometer', 'address1_2', 'text', 'Column address1_2 should be text');
SELECT col_type_is('ext_hydrometer', 'address1_3', 'text', 'Column address1_3 should be text');
SELECT col_type_is('ext_hydrometer', 'address2_1', 'text', 'Column address2_1 should be text');
SELECT col_type_is('ext_hydrometer', 'address2_2', 'text', 'Column address2_2 should be text');
SELECT col_type_is('ext_hydrometer', 'address2_3', 'text', 'Column address2_3 should be text');
SELECT col_type_is('ext_hydrometer', 'assessed_volume', 'float8', 'Column assessed_volume should be float8');
SELECT col_type_is('ext_hydrometer', 'wmeter_builtdate', 'date', 'Column wmeter_builtdate should be date');
SELECT col_type_is('ext_hydrometer', 'end_date', 'date', 'Column end_date should be date');
SELECT col_type_is('ext_hydrometer', 'update_date', 'date', 'Column update_date should be date');
SELECT col_type_is('ext_hydrometer', 'shutdown_date', 'date', 'Column shutdown_date should be date');
SELECT col_type_is('ext_hydrometer', 'is_waterbal', 'bool', 'Column is_waterbal should be bool');
SELECT col_type_is('ext_hydrometer', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ext_hydrometer', 'customer_code', 'varchar(30)', 'Column customer_code should be varchar(30)');

-- Finish
SELECT * FROM finish();

ROLLBACK;
