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

-- Check table sector
SELECT has_table('sector'::name, 'Table sector should exist');

-- Check columns
SELECT columns_are(
    'sector',
    ARRAY[
        'sector_id', 'code', 'name', 'descript', 'sector_type', 'muni_id', 'expl_id', 'macrosector_id',
        'graphconfig', 'stylesheet', 'parent_id', 'pattern_id', 'avg_press', 'link', 'lock_level',
        'active', 'the_geom', 'created_at', 'created_by', 'updated_at', 'updated_by', 'addparam'
    ],
    'Table sector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('sector', ARRAY['sector_id'], 'Column sector_id should be primary key');

-- Check column types
SELECT col_type_is('sector', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('sector', 'code', 'text', 'Column code should be text');
SELECT col_type_is('sector', 'name', 'character varying(50)', 'Column name should be character varying(50)');
SELECT col_type_is('sector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('sector', 'sector_type', 'character varying(16)', 'Column sector_type should be character varying(16)');
SELECT col_type_is('sector', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('sector', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('sector', 'macrosector_id', 'integer', 'Column macrosector_id should be integer');
SELECT col_type_is('sector', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('sector', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('sector', 'parent_id', 'integer', 'Column parent_id should be integer');
SELECT col_type_is('sector', 'pattern_id', 'character varying(20)', 'Column pattern_id should be character varying(20)');
SELECT col_type_is('sector', 'avg_press', 'double precision', 'Column avg_press should be double precision');
SELECT col_type_is('sector', 'link', 'text', 'Column link should be text');
SELECT col_type_is('sector', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('sector', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('sector', 'the_geom', 'geometry(MultiPolygon,SRID_VALUE)', 'Column the_geom should be geometry(MultiPolygon,SRID_VALUE)');
SELECT col_type_is('sector', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('sector', 'created_by', 'character varying(50)', 'Column created_by should be character varying(50)');
SELECT col_type_is('sector', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('sector', 'updated_by', 'character varying(50)', 'Column updated_by should be character varying(50)');

-- Check default values
SELECT col_default_is('sector', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('sector', 'created_at', 'now()', 'Column created_at should default to now()');
SELECT col_default_is('sector', 'created_by', 'CURRENT_USER', 'Column created_by should default to CURRENT_USER');

-- Check constraints
SELECT col_not_null('sector', 'sector_id', 'Column sector_id should be NOT NULL');
SELECT col_not_null('sector', 'name', 'Column name should be NOT NULL');

-- Check foreign keys
SELECT has_fk('sector', 'Table sector should have foreign keys');
SELECT fk_ok('sector', 'macrosector_id', 'macrosector', 'macrosector_id', 'FK macrosector_id should reference macrosector.macrosector_id');
SELECT fk_ok('sector', 'parent_id', 'sector', 'sector_id', 'FK parent_id should reference sector.sector_id');
SELECT fk_ok('sector', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK pattern_id should reference inp_pattern.pattern_id');

-- Check triggers
SELECT has_trigger('sector', 'gw_trg_typevalue_fk_insert', 'Table sector should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('sector', 'gw_trg_typevalue_fk_update', 'Table sector should have gw_trg_typevalue_fk_update trigger');


SELECT * FROM finish();

ROLLBACK;