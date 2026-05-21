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
SELECT has_table('minsector'::name, 'Table minsector should exist');

-- Check columns
SELECT columns_are(
    'minsector',
    ARRAY[
        'minsector_id', 'dma_id', 'dqa_id', 'presszone_id', 'expl_id', 'the_geom',
        'num_border', 'num_connec', 'num_hydro', 'length', 'addparam', 'code',
        'descript', 'sector_id', 'muni_id', 'supplyzone_id'
    ],
    'Table minsector should have the correct columns'
);

-- Check column types
SELECT col_type_is('minsector', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('minsector', 'dma_id', 'int4[]', 'Column dma_id should be int4[]');
SELECT col_type_is('minsector', 'dqa_id', 'int4[]', 'Column dqa_id should be int4[]');
SELECT col_type_is('minsector', 'presszone_id', 'int4[]', 'Column presszone_id should be int4[]');
SELECT col_type_is('minsector', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('minsector', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('minsector', 'num_border', 'int4', 'Column num_border should be int4');
SELECT col_type_is('minsector', 'num_connec', 'int4', 'Column num_connec should be int4');
SELECT col_type_is('minsector', 'num_hydro', 'int4', 'Column num_hydro should be int4');
SELECT col_type_is('minsector', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('minsector', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('minsector', 'code', 'text', 'Column code should be text');
SELECT col_type_is('minsector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('minsector', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('minsector', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('minsector', 'supplyzone_id', 'int4[]', 'Column supplyzone_id should be int4[]');

-- Finish
SELECT * FROM finish();

ROLLBACK;
