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

-- Check view ve_dqa
SELECT has_view('ve_dqa'::name, 'View ve_dqa should exist');

-- Check view columns
SELECT columns_are(
    've_dqa',
    ARRAY[
        'dqa_id', 'code', 'name', 'descript', 'active', 'dqa_type',
        'macrodqa_id', 'expl_id', 'sector_id', 'muni_id', 'avg_press', 'pattern_id',
        'graphconfig', 'stylesheet', 'lock_level', 'link', 'addparam', 'created_at',
        'created_by', 'updated_at', 'updated_by', 'the_geom'
    ],
    'View ve_dqa should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_dqa', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('ve_dqa', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_dqa', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_dqa', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_dqa', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_dqa', 'dqa_type', 'varchar(16)', 'Column dqa_type should be varchar(16)');
SELECT col_type_is('ve_dqa', 'macrodqa_id', 'int4', 'Column macrodqa_id should be int4');
SELECT col_type_is('ve_dqa', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_dqa', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_dqa', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_dqa', 'avg_press', 'float8', 'Column avg_press should be float8');
SELECT col_type_is('ve_dqa', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('ve_dqa', 'graphconfig', 'text', 'Column graphconfig should be text');
SELECT col_type_is('ve_dqa', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_dqa', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_dqa', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ve_dqa', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_dqa', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('ve_dqa', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('ve_dqa', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('ve_dqa', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('ve_dqa', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
