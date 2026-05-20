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
SELECT has_table('dqa'::name, 'Table dqa should exist');

-- Check columns
SELECT columns_are(
    'dqa',
    ARRAY[
        'dqa_id', 'code', 'name', 'descript', 'dqa_type', 'muni_id',
        'expl_id', 'sector_id', 'macrodqa_id', 'pattern_id', 'link', 'graphconfig',
        'stylesheet', 'avg_press', 'lock_level', 'active', 'the_geom', 'created_at',
        'created_by', 'updated_at', 'updated_by', 'addparam'
    ],
    'Table dqa should have the correct columns'
);

-- Check column types
SELECT col_type_is('dqa', 'dqa_id', 'int4', 'Column dqa_id should be int4');
SELECT col_type_is('dqa', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('dqa', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('dqa', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('dqa', 'dqa_type', 'varchar(16)', 'Column dqa_type should be varchar(16)');
SELECT col_type_is('dqa', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('dqa', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('dqa', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('dqa', 'macrodqa_id', 'int4', 'Column macrodqa_id should be int4');
SELECT col_type_is('dqa', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('dqa', 'link', 'text', 'Column link should be text');
SELECT col_type_is('dqa', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('dqa', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('dqa', 'avg_press', 'float8', 'Column avg_press should be float8');
SELECT col_type_is('dqa', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('dqa', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('dqa', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('dqa', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('dqa', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('dqa', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('dqa', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('dqa', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT has_fk('dqa', 'Table dqa should have foreign keys');

SELECT fk_ok('dqa', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id → inp_pattern.pattern_id');
SELECT fk_ok('dqa', 'macrodqa_id', 'macrodqa', 'macrodqa_id', 'FK macrodqa_id → macrodqa.macrodqa_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
