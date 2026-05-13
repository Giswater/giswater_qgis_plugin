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

-- Check view ve_sector
SELECT has_view('ve_sector'::name, 'View ve_sector should exist');

-- Check view columns
SELECT columns_are(
    've_sector',
    ARRAY[
        'sector_id', 'code', 'name', 'descript', 'active', 'sector_type',
        'macrosector_id', 'expl_id', 'muni_id', 'avg_press', 'pattern_id', 'graphconfig',
        'stylesheet', 'lock_level', 'link', 'addparam', 'created_at', 'created_by',
        'updated_at', 'updated_by', 'the_geom'
    ],
    'View ve_sector should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_sector', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('ve_sector', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_sector', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_sector', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_sector', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_sector', 'sector_type', 'varchar(16)', 'Column sector_type should be varchar(16)');
SELECT col_type_is('ve_sector', 'macrosector_id', 'int4', 'Column macrosector_id should be int4');
SELECT col_type_is('ve_sector', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_sector', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_sector', 'avg_press', 'float8', 'Column avg_press should be float8');
SELECT col_type_is('ve_sector', 'pattern_id', 'varchar(20)', 'Column pattern_id should be varchar(20)');
SELECT col_type_is('ve_sector', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('ve_sector', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_sector', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_sector', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ve_sector', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_sector', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('ve_sector', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('ve_sector', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('ve_sector', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('ve_sector', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
