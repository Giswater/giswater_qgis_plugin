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

-- Check view ve_link_connec
SELECT has_view('ve_link_connec'::name, 'View ve_link_connec should exist');

-- Check view columns
SELECT columns_are(
    've_link_connec',
    ARRAY[
        'link_id', 'code', 'sys_code', 'top_elev1', 'y1', 'elevation1',
        'exit_id', 'exit_type', 'top_elev2', 'y2', 'elevation2', 'feature_type',
        'feature_id', 'link_type', 'sys_type', 'linkcat_id', 'state', 'state_type',
        'expl_id', 'macroexpl_id', 'muni_id', 'sector_id', 'macrosector_id', 'sector_type',
        'drainzone_id', 'drainzone_type', 'drainzone_outfall', 'dwfzone_id', 'dwfzone_type', 'dwfzone_outfall',
        'omzone_id', 'macroomzone_id', 'dma_id', 'location_type', 'fluid_type', 'custom_length',
        'gis_length', 'sys_slope', 'annotation', 'observ', 'comment', 'descript',
        'link', 'num_value', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate',
        'brand_id', 'model_id', 'private_linkcat_id', 'verified', 'uncertain', 'userdefined_geom',
        'datasource', 'is_operative', 'sector_style', 'omzone_style', 'drainzone_style', 'dwfzone_style',
        'lock_level', 'expl_visibility', 'created_at', 'created_by', 'updated_at', 'updated_by',
        'the_geom'
    ],
    'View ve_link_connec should have the correct columns'
);

-- Check column types
SELECT col_type_is('ve_link_connec', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('ve_link_connec', 'code', 'text', 'Column code should be text');
SELECT col_type_is('ve_link_connec', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('ve_link_connec', 'top_elev1', 'float8', 'Column top_elev1 should be float8');
SELECT col_type_is('ve_link_connec', 'y1', 'numeric(12,4)', 'Column y1 should be numeric(12,4)');
SELECT col_type_is('ve_link_connec', 'elevation1', 'float8', 'Column elevation1 should be float8');
SELECT col_type_is('ve_link_connec', 'exit_id', 'int4', 'Column exit_id should be int4');
SELECT col_type_is('ve_link_connec', 'exit_type', 'varchar(16)', 'Column exit_type should be varchar(16)');
SELECT col_type_is('ve_link_connec', 'top_elev2', 'float8', 'Column top_elev2 should be float8');
SELECT col_type_is('ve_link_connec', 'y2', 'numeric(12,4)', 'Column y2 should be numeric(12,4)');
SELECT col_type_is('ve_link_connec', 'elevation2', 'float8', 'Column elevation2 should be float8');
SELECT col_type_is('ve_link_connec', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('ve_link_connec', 'feature_id', 'int4', 'Column feature_id should be int4');
SELECT col_type_is('ve_link_connec', 'link_type', 'varchar(30)', 'Column link_type should be varchar(30)');
SELECT col_type_is('ve_link_connec', 'sys_type', 'varchar(30)', 'Column sys_type should be varchar(30)');
SELECT col_type_is('ve_link_connec', 'linkcat_id', 'varchar(30)', 'Column linkcat_id should be varchar(30)');
SELECT col_type_is('ve_link_connec', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('ve_link_connec', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('ve_link_connec', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('ve_link_connec', 'macroexpl_id', 'int4', 'Column macroexpl_id should be int4');
SELECT col_type_is('ve_link_connec', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('ve_link_connec', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('ve_link_connec', 'macrosector_id', 'int4', 'Column macrosector_id should be int4');
SELECT col_type_is('ve_link_connec', 'sector_type', 'varchar(16)', 'Column sector_type should be varchar(16)');
SELECT col_type_is('ve_link_connec', 'drainzone_id', 'int4', 'Column drainzone_id should be int4');
SELECT col_type_is('ve_link_connec', 'drainzone_type', 'varchar(16)', 'Column drainzone_type should be varchar(16)');
SELECT col_type_is('ve_link_connec', 'drainzone_outfall', 'int4[]', 'Column drainzone_outfall should be int4[]');
SELECT col_type_is('ve_link_connec', 'dwfzone_id', 'int4', 'Column dwfzone_id should be int4');
SELECT col_type_is('ve_link_connec', 'dwfzone_type', 'varchar(16)', 'Column dwfzone_type should be varchar(16)');
SELECT col_type_is('ve_link_connec', 'dwfzone_outfall', 'int4[]', 'Column dwfzone_outfall should be int4[]');
SELECT col_type_is('ve_link_connec', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('ve_link_connec', 'macroomzone_id', 'int4', 'Column macroomzone_id should be int4');
SELECT col_type_is('ve_link_connec', 'dma_id', 'int4', 'Column dma_id should be int4');
SELECT col_type_is('ve_link_connec', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('ve_link_connec', 'fluid_type', 'int4', 'Column fluid_type should be int4');
SELECT col_type_is('ve_link_connec', 'custom_length', 'numeric(12,2)', 'Column custom_length should be numeric(12,2)');
SELECT col_type_is('ve_link_connec', 'gis_length', 'numeric(12,3)', 'Column gis_length should be numeric(12,3)');
SELECT col_type_is('ve_link_connec', 'sys_slope', 'numeric(12,3)', 'Column sys_slope should be numeric(12,3)');
SELECT col_type_is('ve_link_connec', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('ve_link_connec', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('ve_link_connec', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('ve_link_connec', 'descript', 'varchar(254)', 'Column descript should be varchar(254)');
SELECT col_type_is('ve_link_connec', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('ve_link_connec', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('ve_link_connec', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('ve_link_connec', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('ve_link_connec', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('ve_link_connec', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('ve_link_connec', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('ve_link_connec', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('ve_link_connec', 'private_linkcat_id', 'varchar(30)', 'Column private_linkcat_id should be varchar(30)');
SELECT col_type_is('ve_link_connec', 'verified', 'int2', 'Column verified should be int2');
SELECT col_type_is('ve_link_connec', 'uncertain', 'bool', 'Column uncertain should be bool');
SELECT col_type_is('ve_link_connec', 'userdefined_geom', 'bool', 'Column userdefined_geom should be bool');
SELECT col_type_is('ve_link_connec', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('ve_link_connec', 'is_operative', 'bool', 'Column is_operative should be bool');
SELECT col_type_is('ve_link_connec', 'sector_style', 'text', 'Column sector_style should be text');
SELECT col_type_is('ve_link_connec', 'omzone_style', 'text', 'Column omzone_style should be text');
SELECT col_type_is('ve_link_connec', 'drainzone_style', 'text', 'Column drainzone_style should be text');
SELECT col_type_is('ve_link_connec', 'dwfzone_style', 'text', 'Column dwfzone_style should be text');
SELECT col_type_is('ve_link_connec', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('ve_link_connec', 'expl_visibility', 'int2[]', 'Column expl_visibility should be int2[]');
SELECT col_type_is('ve_link_connec', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('ve_link_connec', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('ve_link_connec', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('ve_link_connec', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('ve_link_connec', 'the_geom', 'geometry(linestring, SRID_VALUE)', 'Column the_geom should be geometry(linestring, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
