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

-- Check view v_ui_element
SELECT has_view('v_ui_element'::name, 'View v_ui_element should exist');

-- Check view columns
SELECT columns_are(
    'v_ui_element',
    ARRAY[
        'element_id', 'code', 'sys_code', 'top_elev', 'feature_type', 'feature_class',
        'element_type', 'elementcat_id', 'num_elements', 'state', 'state_type', 'expl_id',
        'muni_id', 'sector_id', 'omzone_id', 'function_type', 'category_type', 'location_type',
        'observ', 'comment', 'link', 'workcat_id', 'workcat_id_end', 'builtdate',
        'enddate', 'ownercat_id', 'brand_id', 'model_id', 'serial_number', 'asset_id',
        'verified', 'datasource', 'label_x', 'label_y', 'rotation', 'label_rotation',
        'inventory', 'publish', 'trace_featuregeom', 'lock_level', 'expl_visibility', 'created_at',
        'created_by', 'updated_at', 'updated_by', 'the_geom'
    ],
    'View v_ui_element should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_ui_element', 'element_id', 'int4', 'Column element_id should be int4');
SELECT col_type_is('v_ui_element', 'code', 'text', 'Column code should be text');
SELECT col_type_is('v_ui_element', 'sys_code', 'text', 'Column sys_code should be text');
SELECT col_type_is('v_ui_element', 'top_elev', 'numeric(12,4)', 'Column top_elev should be numeric(12,4)');
SELECT col_type_is('v_ui_element', 'feature_type', 'varchar(16)', 'Column feature_type should be varchar(16)');
SELECT col_type_is('v_ui_element', 'feature_class', 'varchar(30)', 'Column feature_class should be varchar(30)');
SELECT col_type_is('v_ui_element', 'element_type', 'varchar(30)', 'Column element_type should be varchar(30)');
SELECT col_type_is('v_ui_element', 'elementcat_id', 'varchar(30)', 'Column elementcat_id should be varchar(30)');
SELECT col_type_is('v_ui_element', 'num_elements', 'int4', 'Column num_elements should be int4');
SELECT col_type_is('v_ui_element', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('v_ui_element', 'state_type', 'int2', 'Column state_type should be int2');
SELECT col_type_is('v_ui_element', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('v_ui_element', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('v_ui_element', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_ui_element', 'omzone_id', 'int4', 'Column omzone_id should be int4');
SELECT col_type_is('v_ui_element', 'function_type', 'varchar(50)', 'Column function_type should be varchar(50)');
SELECT col_type_is('v_ui_element', 'category_type', 'varchar(50)', 'Column category_type should be varchar(50)');
SELECT col_type_is('v_ui_element', 'location_type', 'varchar(50)', 'Column location_type should be varchar(50)');
SELECT col_type_is('v_ui_element', 'observ', 'varchar(254)', 'Column observ should be varchar(254)');
SELECT col_type_is('v_ui_element', 'comment', 'varchar(254)', 'Column comment should be varchar(254)');
SELECT col_type_is('v_ui_element', 'link', 'varchar(512)', 'Column link should be varchar(512)');
SELECT col_type_is('v_ui_element', 'workcat_id', 'varchar(30)', 'Column workcat_id should be varchar(30)');
SELECT col_type_is('v_ui_element', 'workcat_id_end', 'varchar(30)', 'Column workcat_id_end should be varchar(30)');
SELECT col_type_is('v_ui_element', 'builtdate', 'date', 'Column builtdate should be date');
SELECT col_type_is('v_ui_element', 'enddate', 'date', 'Column enddate should be date');
SELECT col_type_is('v_ui_element', 'ownercat_id', 'varchar(30)', 'Column ownercat_id should be varchar(30)');
SELECT col_type_is('v_ui_element', 'brand_id', 'varchar(50)', 'Column brand_id should be varchar(50)');
SELECT col_type_is('v_ui_element', 'model_id', 'varchar(50)', 'Column model_id should be varchar(50)');
SELECT col_type_is('v_ui_element', 'serial_number', 'varchar(30)', 'Column serial_number should be varchar(30)');
SELECT col_type_is('v_ui_element', 'asset_id', 'varchar(50)', 'Column asset_id should be varchar(50)');
SELECT col_type_is('v_ui_element', 'verified', 'int4', 'Column verified should be int4');
SELECT col_type_is('v_ui_element', 'datasource', 'int4', 'Column datasource should be int4');
SELECT col_type_is('v_ui_element', 'label_x', 'varchar(30)', 'Column label_x should be varchar(30)');
SELECT col_type_is('v_ui_element', 'label_y', 'varchar(30)', 'Column label_y should be varchar(30)');
SELECT col_type_is('v_ui_element', 'rotation', 'numeric(6,3)', 'Column rotation should be numeric(6,3)');
SELECT col_type_is('v_ui_element', 'label_rotation', 'numeric(6,3)', 'Column label_rotation should be numeric(6,3)');
SELECT col_type_is('v_ui_element', 'inventory', 'bool', 'Column inventory should be bool');
SELECT col_type_is('v_ui_element', 'publish', 'bool', 'Column publish should be bool');
SELECT col_type_is('v_ui_element', 'trace_featuregeom', 'bool', 'Column trace_featuregeom should be bool');
SELECT col_type_is('v_ui_element', 'lock_level', 'int4', 'Column lock_level should be int4');
SELECT col_type_is('v_ui_element', 'expl_visibility', 'int2[]', 'Column expl_visibility should be int2[]');
SELECT col_type_is('v_ui_element', 'created_at', 'timestamp with time zone', 'Column created_at should be timestamp with time zone');
SELECT col_type_is('v_ui_element', 'created_by', 'varchar(50)', 'Column created_by should be varchar(50)');
SELECT col_type_is('v_ui_element', 'updated_at', 'timestamp with time zone', 'Column updated_at should be timestamp with time zone');
SELECT col_type_is('v_ui_element', 'updated_by', 'varchar(50)', 'Column updated_by should be varchar(50)');
SELECT col_type_is('v_ui_element', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
