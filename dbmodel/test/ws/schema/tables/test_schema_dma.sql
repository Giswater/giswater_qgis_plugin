/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT * FROM no_plan();

-- Check table dma
SELECT has_table('dma'::name, 'Table dma should exist');

-- Check columns
SELECT columns_are(
    'dma',
    ARRAY[
        'dma_id', 'name', 'dma_type', 'muni_id', 'expl_id', 'sector_id', 'macrodma_id', 'descript', 'the_geom', 'minc',
        'maxc', 'effc', 'pattern_id', 'link', 'graphconfig', 'stylesheet', 'active', 'avg_press', 'tstamp', 'insert_user',
        'lastupdate', 'lastupdate_user', 'lock_level'
    ],
    'Table dma should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('dma', ARRAY['dma_id'], 'Column dma_id should be primary key');

-- Check column types
SELECT col_type_is('dma', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('dma', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('dma', 'dma_type', 'varchar(16)', 'Column dma_type should be varchar(16)');
SELECT col_type_is('dma', 'muni_id', 'integer[]', 'Column muni_id should be integer[]');
SELECT col_type_is('dma', 'expl_id', 'integer[]', 'Column expl_id should be integer[]');
SELECT col_type_is('dma', 'sector_id', 'integer[]', 'Column sector_id should be integer[]');
SELECT col_type_is('dma', 'macrodma_id', 'integer', 'Column macrodma_id should be integer');
SELECT col_type_is('dma', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('dma', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('dma', 'minc', 'double precision', 'Column minc should be double precision');
SELECT col_type_is('dma', 'maxc', 'double precision', 'Column maxc should be double precision');
SELECT col_type_is('dma', 'effc', 'double precision', 'Column effc should be double precision');
SELECT col_type_is('dma', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('dma', 'link', 'text', 'Column link should be text');
SELECT col_type_is('dma', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('dma', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('dma', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('dma', 'avg_press', 'numeric', 'Column avg_press should be numeric');
SELECT col_type_is('dma', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('dma', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('dma', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('dma', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('dma', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check foreign keys
SELECT has_fk('dma', 'Table dma should have foreign keys');
SELECT fk_ok('dma', 'macrodma_id', 'macrodma', 'macrodma_id', 'FK dma_macrodma_id_fkey should exist');
SELECT fk_ok('dma', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK dma_pattern_id_fkey should exist');

-- Check triggers
SELECT has_trigger('dma', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('dma', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules
SELECT has_rule('dma', 'dma_conflict', 'Table should have dma_conflict rule');
SELECT has_rule('dma', 'dma_del_conflict', 'Table should have dma_del_conflict rule');
SELECT has_rule('dma', 'dma_del_undefined', 'Table should have dma_del_undefined rule');
SELECT has_rule('dma', 'dma_undefined', 'Table should have dma_undefined rule');

-- Check sequences
SELECT has_sequence('dma_dma_id_seq', 'Sequence dma_dma_id_seq should exist'); -- Todo: rename to dma_id_seq

-- Check constraints
SELECT col_default_is('dma', 'active', 'true', 'Column active should default to true');
SELECT col_default_is('dma', 'tstamp', 'now()', 'Column tstamp should default to now()');
SELECT col_default_is('dma', 'insert_user', 'CURRENT_USER', 'Column insert_user should default to CURRENT_USER');

SELECT * FROM finish();

ROLLBACK;
