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

-- Check view ve_dma
SELECT has_view('ve_dma'::name, 'View ve_dma should exist');

-- Check view columns
SELECT columns_are(
    've_dma',
    ARRAY[
        'dma_id', 'code', 'name', 'descript', 'active', 'dma_type',
        'expl_id', 'sector_id', 'muni_id', 'avg_press', 'pattern_id', 'effc',
        'graphconfig', 'stylesheet', 'lock_level', 'link', 'the_geom', 'addparam',
        'created_at', 'created_by', 'updated_at', 'updated_by'
    ],
    'View ve_dma should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_dma', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('ve_dma', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_dma', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_dma', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_dma', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_dma', 'dma_type', 'varchar(32)', 'Column dma_type should be varchar(32)');
SELECT col_type_is('ve_dma', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_dma', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_dma', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_dma', 'avg_press', 'numeric(12,2)', 'Column avg_press should be numeric(12,2)');
SELECT col_type_is('ve_dma', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ve_dma', 'effc', 'int4', 'Column effc should be int4');
SELECT col_type_is('ve_dma', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('ve_dma', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_dma', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_dma', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ve_dma', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('ve_dma', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_dma', 'created_at', 'timestamp without time zone', 'Column created_at should be timestamp without time zone');
SELECT col_type_is('ve_dma', 'created_by', 'text', 'Column created_by should be text');
SELECT col_type_is('ve_dma', 'updated_at', 'timestamp without time zone', 'Column updated_at should be timestamp without time zone');
SELECT col_type_is('ve_dma', 'updated_by', 'text', 'Column updated_by should be text');

SELECT * FROM finish();

ROLLBACK;
