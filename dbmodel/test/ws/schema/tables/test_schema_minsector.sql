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

-- Check table minsector
SELECT has_table('minsector'::name, 'Table minsector should exist');

-- Check columns
SELECT columns_are(
    'minsector',
    ARRAY[
        'minsector_id', 'dma_id', 'dqa_id', 'presszone_id', 'expl_id', 'the_geom', 'num_border',
        'num_connec', 'num_hydro', 'length', 'addparam', 'code', 'descript', 'sector_id', 'muni_id'
    ],
    'Table minsector should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('minsector', ARRAY['minsector_id'], 'Column minsector_id should be primary key');

-- Check column types
SELECT col_type_is('minsector', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('minsector', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('minsector', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('minsector', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('minsector', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('minsector', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('minsector', 'num_border', 'integer', 'Column num_border should be integer');
SELECT col_type_is('minsector', 'num_connec', 'integer', 'Column num_connec should be integer');
SELECT col_type_is('minsector', 'num_hydro', 'integer', 'Column num_hydro should be integer');
SELECT col_type_is('minsector', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('minsector', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('minsector', 'code', 'text', 'Column code should be text');
SELECT col_type_is('minsector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('minsector', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('minsector', 'muni_id', 'integer', 'Column muni_id should be integer');

-- Check foreign keys
SELECT has_fk('minsector', 'Table minsector should have foreign keys');
SELECT fk_ok('minsector', 'dma_id', 'dma', 'dma_id', 'FK dma_id should reference dma.dma_id');
SELECT fk_ok('minsector', 'dqa_id', 'dqa', 'dqa_id', 'FK dqa_id should reference dqa.dqa_id');
SELECT fk_ok('minsector', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('minsector', 'presszone_id', 'presszone', 'presszone_id', 'FK presszone_id should reference presszone.presszone_id');
SELECT fk_ok('minsector', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality.muni_id');

SELECT * FROM finish();

ROLLBACK; 