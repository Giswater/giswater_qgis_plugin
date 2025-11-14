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

-- Check table ext_rtc_hydrometer
SELECT has_table('ext_rtc_hydrometer'::name, 'Table ext_rtc_hydrometer should exist');

-- Check columns
SELECT columns_are(
    'ext_rtc_hydrometer',
    ARRAY[
        'hydrometer_id', 'code', 'customer_name', 'address', 'house_number', 'id_number', 'start_date', 'hydro_number',
        'identif', 'state_id', 'expl_id', 'hydrometer_customer_code', 'plot_code', 'priority_id',
        'catalog_id', 'category_id', 'crm_number', 'muni_id', 'address1', 'address2', 'address3', 'address2_1',
        'address2_2', 'address2_3', 'm3_volume', 'hydro_man_date', 'end_date', 'update_date', 'shutdown_date', 'is_waterbal', 'link'
    ],
    'Table ext_rtc_hydrometer should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('ext_rtc_hydrometer', ARRAY['hydrometer_id'], 'Column hydrometer_id should be primary key');

-- Check column types
SELECT col_type_is('ext_rtc_hydrometer', 'hydrometer_id', 'integer', 'Column hydrometer_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'customer_name', 'text', 'Column customer_name should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'address', 'text', 'Column address should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'house_number', 'text', 'Column house_number should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'id_number', 'text', 'Column id_number should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'start_date', 'date', 'Column start_date should be date');
SELECT col_type_is('ext_rtc_hydrometer', 'hydro_number', 'text', 'Column hydro_number should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'identif', 'text', 'Column identif should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'state_id', 'smallint', 'Column state_id should be smallint');
SELECT col_type_is('ext_rtc_hydrometer', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'hydrometer_customer_code', 'varchar(30)', 'Column hydrometer_customer_code should be varchar(30)');
SELECT col_type_is('ext_rtc_hydrometer', 'plot_code', 'varchar(100)', 'Column plot_code should be varchar(100)');
SELECT col_type_is('ext_rtc_hydrometer', 'priority_id', 'integer', 'Column priority_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'catalog_id', 'integer', 'Column catalog_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'category_id', 'integer', 'Column category_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'crm_number', 'integer', 'Column crm_number should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('ext_rtc_hydrometer', 'address1', 'text', 'Column address1 should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'address2', 'text', 'Column address2 should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'address3', 'text', 'Column address3 should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'address2_1', 'text', 'Column address2_1 should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'address2_2', 'text', 'Column address2_2 should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'address2_3', 'text', 'Column address2_3 should be text');
SELECT col_type_is('ext_rtc_hydrometer', 'm3_volume', 'double precision', 'Column m3_volume should be double precision');
SELECT col_type_is('ext_rtc_hydrometer', 'hydro_man_date', 'date', 'Column hydro_man_date should be date');
SELECT col_type_is('ext_rtc_hydrometer', 'end_date', 'date', 'Column end_date should be date');
SELECT col_type_is('ext_rtc_hydrometer', 'update_date', 'date', 'Column update_date should be date');
SELECT col_type_is('ext_rtc_hydrometer', 'shutdown_date', 'date', 'Column shutdown_date should be date');
SELECT col_type_is('ext_rtc_hydrometer', 'is_waterbal', 'boolean', 'Column is_waterbal should be boolean');
SELECT col_type_is('ext_rtc_hydrometer', 'link', 'text', 'Column link should be text');

-- Check foreign keys
SELECT hasnt_fk('ext_rtc_hydrometer', 'Table ext_rtc_hydrometer should have no foreign keys');

-- Check triggers

-- Check rules

-- Check sequences
SELECT has_sequence('ext_rtc_hydrometer_hydrometer_id_seq', 'Sequence ext_rtc_hydrometer_hydrometer_id_seq should exist');

-- Check constraints
SELECT col_not_null('ext_rtc_hydrometer', 'hydrometer_id', 'Column hydrometer_id should be NOT NULL');
SELECT col_default_is('ext_rtc_hydrometer', 'is_waterbal', 'true', 'Column is_waterbal should default to true');

SELECT * FROM finish();

ROLLBACK;
