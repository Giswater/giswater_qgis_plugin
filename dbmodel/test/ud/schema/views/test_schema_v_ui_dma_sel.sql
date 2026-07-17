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

-- Check view v_ui_dma_sel
SELECT has_view('v_ui_dma_sel'::name, 'View v_ui_dma_sel should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_dma_sel',
    ARRAY[
        'dma_id', 'code', 'name', 'descript', 'active', 'dma_type',
        'expl_id', 'sector_id', 'muni_id', 'avg_press', 'pattern_id', 'effc',
        'graphconfig', 'stylesheet', 'lock_level', 'link', 'addparam', 'created_at',
        'created_by', 'updated_at', 'updated_by'
    ],
    'View v_ui_dma_sel should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_dma_sel', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('v_ui_dma_sel', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('v_ui_dma_sel', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('v_ui_dma_sel', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('v_ui_dma_sel', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('v_ui_dma_sel', 'dma_type', 'varchar(100)', 'Column dma_type should be varchar(100)');
SELECT col_type_is('v_ui_dma_sel', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('v_ui_dma_sel', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('v_ui_dma_sel', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('v_ui_dma_sel', 'avg_press', 'numeric(12,2)', 'Column avg_press should be numeric(12,2)');
SELECT col_type_is('v_ui_dma_sel', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('v_ui_dma_sel', 'effc', 'int4', 'Column effc should be int4');
SELECT col_type_is('v_ui_dma_sel', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('v_ui_dma_sel', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('v_ui_dma_sel', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('v_ui_dma_sel', 'link', 'text', 'Column link should be text');
SELECT col_type_is('v_ui_dma_sel', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('v_ui_dma_sel', 'created_at', 'timestamp without time zone', 'Column created_at should be timestamp without time zone');
SELECT col_type_is('v_ui_dma_sel', 'created_by', 'text', 'Column created_by should be text');
SELECT col_type_is('v_ui_dma_sel', 'updated_at', 'timestamp without time zone', 'Column updated_at should be timestamp without time zone');
SELECT col_type_is('v_ui_dma_sel', 'updated_by', 'text', 'Column updated_by should be text');

SELECT * FROM finish();

ROLLBACK;
