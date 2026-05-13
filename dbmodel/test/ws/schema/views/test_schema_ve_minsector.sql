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

-- Check view ve_minsector
SELECT has_view('ve_minsector'::name, 'View ve_minsector should exist');

-- Check view columns
SELECT columns_are(
    've_minsector',
    ARRAY[
        'minsector_id', 'code', 'dma_id', 'dqa_id', 'presszone_id', 'supplyzone_id',
        'expl_id', 'num_border', 'num_connec', 'num_hydro', 'length', 'descript',
        'addparam', 'the_geom'
    ],
    'View ve_minsector should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_minsector', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('ve_minsector', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ve_minsector', 'dma_id', 'int4[]', 'Column dma_id should be int4[]');
SELECT col_type_is('ve_minsector', 'dqa_id', 'int4[]', 'Column dqa_id should be int4[]');
SELECT col_type_is('ve_minsector', 'presszone_id', 'int4[]', 'Column presszone_id should be int4[]');
SELECT col_type_is('ve_minsector', 'supplyzone_id', 'int4[]', 'Column supplyzone_id should be int4[]');
SELECT col_type_is('ve_minsector', 'expl_id', 'int4[]', 'Column expl_id should be int4[]');
SELECT col_type_is('ve_minsector', 'num_border', 'int4', 'Column num_border should be int4');
SELECT col_type_is('ve_minsector', 'num_connec', 'int4', 'Column num_connec should be int4');
SELECT col_type_is('ve_minsector', 'num_hydro', 'int4', 'Column num_hydro should be int4');
SELECT col_type_is('ve_minsector', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('ve_minsector', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('ve_minsector', 'addparam', 'text', 'Column addparam should be text');
SELECT col_type_is('ve_minsector', 'the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column the_geom should be geometry(multipolygon, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
