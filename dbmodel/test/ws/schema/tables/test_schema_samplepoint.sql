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

-- Check table samplepoint
SELECT has_table('samplepoint'::name, 'Table samplepoint should exist');

-- Check columns
SELECT columns_are(
    'samplepoint',
    ARRAY[
        'sample_id', 'code', 'lab_code', 'feature_id', 'featurecat_id', 'dma_id', 'presszone_id', 'state', 'builtdate', 'enddate',
        'workcat_id', 'workcat_id_end', 'rotation', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement',
        'streetaxis2_id', 'postnumber2', 'postcomplement2', 'place_name', 'cabinet', 'observations', 'verified', 'the_geom',
        'expl_id', 'tstamp', 'link', 'district_id', 'sector_id'
    ],
    'Table samplepoint should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('samplepoint', ARRAY['sample_id'], 'Column sample_id should be primary key');

-- Check column types
SELECT col_type_is('samplepoint', 'sample_id', 'character varying(16)', 'Column sample_id should be character varying(16)');
SELECT col_type_is('samplepoint', 'code', 'text', 'Column code should be text');
SELECT col_type_is('samplepoint', 'lab_code', 'character varying(30)', 'Column lab_code should be character varying(30)');
SELECT col_type_is('samplepoint', 'feature_id', 'character varying(16)', 'Column feature_id should be character varying(16)');
SELECT col_type_is('samplepoint', 'featurecat_id', 'character varying(30)', 'Column featurecat_id should be character varying(30)');
SELECT col_type_is('samplepoint', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('samplepoint', 'presszone_id', 'integer', 'Column presszone_id should be integer');
SELECT col_type_is('samplepoint', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('samplepoint', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('samplepoint', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('samplepoint', 'workcat_id', 'character varying(255)', 'Column workcat_id should be character varying(255)');
SELECT col_type_is('samplepoint', 'workcat_id_end', 'character varying(255)', 'Column workcat_id_end should be character varying(255)');
SELECT col_type_is('samplepoint', 'rotation', 'numeric(12,3)', 'Column rotation should be numeric(12,3)');
SELECT col_type_is('samplepoint', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('samplepoint', 'postcode', 'character varying(16)', 'Column postcode should be character varying(16)');
SELECT col_type_is('samplepoint', 'streetaxis_id', 'character varying(16)', 'Column streetaxis_id should be character varying(16)');
SELECT col_type_is('samplepoint', 'postnumber', 'integer', 'Column postnumber should be integer');
SELECT col_type_is('samplepoint', 'postcomplement', 'character varying(100)', 'Column postcomplement should be character varying(100)');
SELECT col_type_is('samplepoint', 'streetaxis2_id', 'character varying(16)', 'Column streetaxis2_id should be character varying(16)');
SELECT col_type_is('samplepoint', 'postnumber2', 'integer', 'Column postnumber2 should be integer');
SELECT col_type_is('samplepoint', 'postcomplement2', 'character varying(100)', 'Column postcomplement2 should be character varying(100)');
SELECT col_type_is('samplepoint', 'place_name', 'character varying(254)', 'Column place_name should be character varying(254)');
SELECT col_type_is('samplepoint', 'cabinet', 'character varying(150)', 'Column cabinet should be character varying(150)');
SELECT col_type_is('samplepoint', 'observations', 'character varying(254)', 'Column observations should be character varying(254)');
SELECT col_type_is('samplepoint', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('samplepoint', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('samplepoint', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('samplepoint', 'tstamp', 'timestamp without time zone', 'Column tstamp should be timestamp without time zone');
SELECT col_type_is('samplepoint', 'link', 'character varying(512)', 'Column link should be character varying(512)');
SELECT col_type_is('samplepoint', 'district_id', 'integer', 'Column district_id should be integer');
SELECT col_type_is('samplepoint', 'sector_id', 'integer', 'Column sector_id should be integer');

-- Check default values
SELECT col_default_is('samplepoint', 'sector_id', '0', 'Column sector_id should default to 0');
SELECT col_default_is('samplepoint', 'tstamp', 'now()', 'Column tstamp should default to now()');

-- Check constraints
SELECT col_not_null('samplepoint', 'sample_id', 'Column sample_id should be NOT NULL');
SELECT col_not_null('samplepoint', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('samplepoint', 'expl_id', 'Column expl_id should be NOT NULL');
SELECT col_not_null('samplepoint', 'sector_id', 'Column sector_id should be NOT NULL');

-- Check foreign keys
SELECT has_fk('samplepoint', 'Table samplepoint should have foreign keys');
SELECT fk_ok('samplepoint', 'district_id', 'ext_district', 'district_id', 'FK district_id should reference ext_district.district_id');
SELECT fk_ok('samplepoint', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('samplepoint', 'featurecat_id', 'cat_feature', 'id', 'FK featurecat_id should reference cat_feature.id');
SELECT fk_ok('samplepoint', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality.muni_id');
SELECT fk_ok('samplepoint', 'presszone_id', 'presszone', 'presszone_id', 'FK presszone_id should reference presszone.presszone_id');
SELECT fk_ok('samplepoint', 'sector_id', 'sector', 'sector_id', 'FK sector_id should reference sector.sector_id');
SELECT fk_ok('samplepoint', 'state', 'value_state', 'id', 'FK state should reference value_state.id');
SELECT fk_ok('samplepoint', 'dma_id', 'dma', 'dma_id', 'FK dma_id should reference dma.dma_id');
SELECT fk_ok('samplepoint', 'workcat_id', 'cat_work', 'id', 'FK workcat_id should reference cat_work.id');
SELECT fk_ok('samplepoint', 'workcat_id_end', 'cat_work', 'id', 'FK workcat_id_end should reference cat_work.id');

-- Check indexes
SELECT has_index('samplepoint', 'samplepoint_muni', 'Index samplepoint_muni should exist');

SELECT * FROM finish();

ROLLBACK;