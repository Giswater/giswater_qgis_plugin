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

-- Check view ve_minsector_mincut
SELECT has_view('ve_minsector_mincut'::name, 'View ve_minsector_mincut should exist');

-- Check view columns
SELECT columns_are(
    've_minsector_mincut',
    ARRAY[
        'minsector_id', 'dma_id', 'dqa_id', 'presszone_id', 'expl_id', 'sector_id',
        'muni_id', 'supplyzone_id', 'num_border', 'num_connec', 'num_hydro', 'length',
        'the_geom'
    ],
    'View ve_minsector_mincut should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_minsector_mincut', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('ve_minsector_mincut', 'dma_id', 'int4[]', 'Column dma_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'dqa_id', 'int4[]', 'Column dqa_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'presszone_id', 'int4[]', 'Column presszone_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'sector_id', 'int4[]', 'Column sector_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'muni_id', 'int4[]', 'Column muni_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'supplyzone_id', 'int4[]', 'Column supplyzone_id should be int4[]');
SELECT col_type_is('ve_minsector_mincut', 'num_border', 'int8', 'Column num_border should be int8');
SELECT col_type_is('ve_minsector_mincut', 'num_connec', 'int8', 'Column num_connec should be int8');
SELECT col_type_is('ve_minsector_mincut', 'num_hydro', 'int8', 'Column num_hydro should be int8');
SELECT col_type_is('ve_minsector_mincut', 'length', 'numeric', 'Column length should be numeric');
SELECT col_type_is('ve_minsector_mincut', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
