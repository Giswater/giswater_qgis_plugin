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

-- Check view ve_macrodqa
SELECT has_view('ve_macrodqa'::name, 'View ve_macrodqa should exist');

-- Check view columns
SELECT columns_are(
    've_macrodqa',
    ARRAY[
        'macrodqa_id', 'code', 'name', 'descript', 'active', 'expl_id',
        'sector_id', 'muni_id', 'stylesheet', 'lock_level', 'link', 'addparam',
        'created_at', 'created_by', 'updated_at', 'updated_by', 'the_geom'
    ],
    'View ve_macrodqa should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_macrodqa', 'macrodqa_id', 'int4', 'Column macrodqa_id should be int4');
SELECT col_type_is('ve_macrodqa', 'code', 'varchar(100)', 'Column code should be varchar(100)');
SELECT col_type_is('ve_macrodqa', 'name', 'varchar(100)', 'Column name should be varchar(100)');
SELECT col_type_is('ve_macrodqa', 'descript', 'varchar(255)', 'Column descript should be varchar(255)');
SELECT col_type_is('ve_macrodqa', 'active', 'bool', 'Column active should be bool');
SELECT col_type_is('ve_macrodqa', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_macrodqa', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_macrodqa', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_macrodqa', 'stylesheet', 'text', 'Column stylesheet should be text');
SELECT col_type_is('ve_macrodqa', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_macrodqa', 'link', 'text', 'Column link should be text');
SELECT col_type_is('ve_macrodqa', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_macrodqa', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('ve_macrodqa', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('ve_macrodqa', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('ve_macrodqa', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('ve_macrodqa', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
