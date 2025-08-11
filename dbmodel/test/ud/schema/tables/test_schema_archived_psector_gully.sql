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
SELECT has_table('archived_psector_gully'::name, 'Table archived_psector_gully should exist');

-- Check columns
SELECT columns_are(
    'archived_psector_gully',
    ARRAY[
        'id', 'psector_id', 'psector_state', 'doable', 'psector_arc_id', 'link_id', 'link_the_geom',
        'audit_tstamp', 'audit_user', 'action', 'gully_id', 'code', 'top_elev', 'ymax', 'sandbox',
        'matcat_id', 'gully_type', 'gullycat_id', 'units', 'groove', 'siphon', 'connec_length',
        'connec_depth', 'arc_id', '_pol_id_', 'sector_id', 'state', 'state_type', 'annotation',
        'observ', 'comment', 'dma_id', 'soilcat_id', 'function_type', 'category_type', 'fluid_type',
        'location_type', 'workcat_id', 'workcat_id_end', 'builtdate', 'enddate', 'ownercat_id',
        'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'postcomplement', 'streetaxis2_id',
        'postnumber2', 'postcomplement2', 'descript', 'link', 'verified', 'rotation', 'the_geom',
        'label_x', 'label_y', 'label_rotation', 'publish', 'inventory', 'uncertain', 'expl_id',
        'num_value', 'feature_type', 'tstamp', 'pjoint_type', 'pjoint_id', 'lastupdate',
        'lastupdate_user', 'insert_user', 'district_id', 'workcat_id_plan', 'asset_id',
        'connec_y2', 'gullycat2_id', 'epa_type', 'groove_height', 'groove_length',
        'units_placement', 'drainzone_id', 'adate', 'adescript', 'siphon_type', 'odorflap',
        'placement_type', 'access_type', 'label_quadrant', 'minsector_id', 'dwfzone_id', 'datasource', 'omunit_id', 'lock_level', 'length',
        'width', 'expl_visibility'
    ],
    'Table archived_psector_gully should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('archived_psector_gully', 'id', 'Column id should be primary key');


-- Check check types
SELECT col_type_is('archived_psector_gully', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('archived_psector_gully', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('archived_psector_gully', 'psector_state', 'int2', 'Column psector_state should be int2');
SELECT col_type_is('archived_psector_gully', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('archived_psector_gully', 'psector_arc_id', 'varchar(16)', 'Column psector_arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('archived_psector_gully', 'link_the_geom', 'geometry(LineString,25831)', 'Column link_the_geom should be geometry(LineString,25831)');
SELECT col_type_is('archived_psector_gully', 'audit_tstamp', 'timestamp', 'Column audit_tstamp should be timestamp');
SELECT col_type_is('archived_psector_gully', 'audit_user', 'text', 'Column audit_user should be text');
SELECT col_type_is('archived_psector_gully', 'action', 'varchar(16)', 'Column action should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'gully_id', 'integer', 'Column gully_id should be integer');
SELECT col_type_is('archived_psector_gully', 'code', 'text', 'Column code should be text');
SELECT col_type_is('archived_psector_gully', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('archived_psector_gully', 'ymax', 'numeric(12,4)', 'Column ymax should be numeric(12,4)');
SELECT col_type_is('archived_psector_gully', 'sandbox', 'numeric(12,4)', 'Column sandbox should be numeric(12,4)');
SELECT col_type_is('archived_psector_gully', 'matcat_id', 'varchar(18)', 'Column matcat_id should be varchar(18)');
SELECT col_type_is('archived_psector_gully', 'gully_type', 'varchar(30)', 'Column gully_type should be varchar(30)');
SELECT col_type_is('archived_psector_gully', 'gullycat_id', 'varchar(30)', 'Column gullycat_id should be varchar(30)');
SELECT col_type_is('archived_psector_gully', 'units', 'numeric(12,2)', 'Column units should be numeric(12,2)');
SELECT col_type_is('archived_psector_gully', 'groove', 'bool', 'Column groove should be bool');
SELECT col_type_is('archived_psector_gully', 'siphon', 'bool', 'Column siphon should be bool');
SELECT col_type_is('archived_psector_gully', 'connec_length', 'numeric(12,3)', 'Column connec_length should be numeric(12,3)');
SELECT col_type_is('archived_psector_gully', 'connec_depth', 'numeric(12,3)', 'Column connec_depth should be numeric(12,3)');
SELECT col_type_is('archived_psector_gully', 'arc_id', 'varchar(16)', 'Column arc_id should be varchar(16)');
SELECT col_type_is('archived_psector_gully', '_pol_id_', 'varchar(16)', 'Column _pol_id_ should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'sector_id', 'integer', 'Column sector_id should be integer');
SELECT col_type_is('archived_psector_gully', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('archived_psector_gully', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('archived_psector_gully', 'annotation', 'text', 'Column annotation should be text');
SELECT col_type_is('archived_psector_gully', 'observ', 'text', 'Column observ should be text');
SELECT col_type_is('archived_psector_gully', 'comment', 'text', 'Column comment should be text');
SELECT col_type_is('archived_psector_gully', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('archived_psector_gully', 'soilcat_id', 'varchar(16)', 'Column soilcat_id should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'fluid_type', 'varchar(50)', 'Column fluid_type should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'workcat_id', 'varchar(255)', 'Column workcat_id should be varchar(255)');
SELECT col_type_is('archived_psector_gully', 'workcat_id_end', 'varchar(255)', 'Column workcat_id_end should be varchar(255)');
SELECT col_type_is('archived_psector_gully', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('archived_psector_gully', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('archived_psector_gully', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('archived_psector_gully', 'muni_id', 'integer', 'Column muni_id should be integer');
SELECT col_type_is('archived_psector_gully', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'streetaxis_id', 'varchar(16)', 'Column streetaxis_id should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'postnumber', 'integer', 'Column postnumber should be integer');
SELECT col_type_is('archived_psector_gully', 'postcomplement', 'varchar(100)', 'Column postcomplement should be varchar(100)');
SELECT col_type_is('archived_psector_gully', 'streetaxis2_id', 'varchar(16)', 'Column streetaxis2_id should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'postnumber2', 'integer', 'Column postnumber2 should be integer');
SELECT col_type_is('archived_psector_gully', 'postcomplement2', 'varchar(100)', 'Column postcomplement2 should be varchar(100)');
SELECT col_type_is('archived_psector_gully', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('archived_psector_gully', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('archived_psector_gully', 'verified', 'integer', 'Column verified should be integer');
SELECT col_type_is('archived_psector_gully', 'rotation', 'numeric(6,3)', 'Column rotation should be numeric(6,3)');
SELECT col_type_is('archived_psector_gully', 'the_geom', 'geometry(Point,25831)', 'Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_psector_gully', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('archived_psector_gully', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('archived_psector_gully', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('archived_psector_gully', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('archived_psector_gully', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('archived_psector_gully', 'uncertain', 'bool', 'Column uncertain should be bool');
SELECT col_type_is('archived_psector_gully', 'expl_id', 'integer', 'Column expl_id should be integer');
SELECT col_type_is('archived_psector_gully', 'num_value', 'numeric(12,3)', 'Column num_value should be numeric(12,3)');
SELECT col_type_is('archived_psector_gully', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('archived_psector_gully', 'pjoint_type', 'varchar(16)', 'Column pjoint_type should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'pjoint_id', 'integer', 'Column pjoint_id should be integer');
SELECT col_type_is('archived_psector_gully', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('archived_psector_gully', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'district_id', 'integer', 'Column district_id should be integer');
SELECT col_type_is('archived_psector_gully', 'workcat_id_plan', 'varchar(255)', 'Column workcat_id_plan should be varchar(255)');
SELECT col_type_is('archived_psector_gully', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'connec_y2', 'numeric(12,3)', 'Column connec_y2 should be numeric(12,3)');
SELECT col_type_is('archived_psector_gully', 'gullycat2_id', 'text', 'Column gullycat2_id should be text');
SELECT col_type_is('archived_psector_gully', 'epa_type', 'varchar(16)', 'Column epa_type should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'groove_height', 'float8', 'Column groove_height should be float8');
SELECT col_type_is('archived_psector_gully', 'groove_length', 'float8', 'Column groove_length should be float8');
SELECT col_type_is('archived_psector_gully', 'units_placement', 'varchar(16)', 'Column units_placement should be varchar(16)');
SELECT col_type_is('archived_psector_gully', 'drainzone_id', 'integer', 'Column drainzone_id should be integer');
SELECT col_type_is('archived_psector_gully', 'adate', 'text', 'Column adate should be text');
SELECT col_type_is('archived_psector_gully', 'adescript', 'text', 'Column adescript should be text');
SELECT col_type_is('archived_psector_gully', 'siphon_type', 'text', 'Column siphon_type should be text');
SELECT col_type_is('archived_psector_gully', 'odorflap', 'text', 'Column odorflap should be text');
SELECT col_type_is('archived_psector_gully', 'placement_type', 'varchar(50)', 'Column placement_type should be varchar(50)');
SELECT col_type_is('archived_psector_gully', 'access_type', 'text', 'Column access_type should be text');
SELECT col_type_is('archived_psector_gully', 'label_quadrant', 'varchar(12)', 'Column label_quadrant should be varchar(12)');
SELECT col_type_is('archived_psector_gully', 'minsector_id', 'integer', 'Column minsector_id should be integer');
SELECT col_type_is('archived_psector_gully', 'dwfzone_id', 'integer', 'Column dwfzone_id should be integer');
SELECT col_type_is('archived_psector_gully', 'datasource', 'integer', 'Column datasource should be integer');
SELECT col_type_is('archived_psector_gully', 'omunit_id', 'integer', 'Column omunit_id should be integer');
SELECT col_type_is('archived_psector_gully', 'lock_level', 'integer', 'Column lock_level should be integer');
SELECT col_type_is('archived_psector_gully', 'length', 'numeric(12,3)', 'Column length should be numeric(12,3)');
SELECT col_type_is('archived_psector_gully', 'width', 'numeric(12,3)', 'Column width should be numeric(12,3)');
SELECT col_type_is('archived_psector_gully', 'expl_visibility', 'integer[]', 'Column expl_visibility should be integer[]');

-- Check default values
SELECT col_has_default('archived_psector_gully', 'id', 'Column id should have default value');
SELECT col_has_default('archived_psector_gully', 'audit_tstamp', 'Column audit_tstamp should have default value');
SELECT col_has_default('archived_psector_gully', 'audit_user', 'Column audit_user should have default value');

-- Check foreign keys

-- Check indexes
SELECT has_index('archived_psector_gully', 'audit_psector_gully_traceability_pkey', ARRAY['id'], 'Table should have index on id');

-- Check triggers
SELECT has_trigger('archived_psector_gully', 'gw_trg_typevalue_fk_insert', 'Table should have trigger gw_trg_typevalue_fk_insert');
SELECT has_trigger('archived_psector_gully', 'gw_trg_typevalue_fk_update', 'Table should have trigger gw_trg_typevalue_fk_update');

-- Check rules

-- Finish
SELECT * FROM finish();

ROLLBACK;