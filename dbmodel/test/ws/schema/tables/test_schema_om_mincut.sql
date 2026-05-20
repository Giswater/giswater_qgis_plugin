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
SELECT has_table('om_mincut'::name, 'Table om_mincut should exist');

-- Check columns
SELECT columns_are(
    'om_mincut',
    ARRAY[
        'id', 'work_order', 'mincut_state', 'mincut_class', 'mincut_type', 'received_date',
        'expl_id', 'macroexpl_id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber',
        'anl_cause', 'anl_tstamp', 'anl_user', 'anl_descript', 'anl_feature_id', 'anl_feature_type',
        'anl_the_geom', 'forecast_start', 'forecast_end', 'assigned_to', 'exec_start', 'exec_end',
        'exec_user', 'exec_descript', 'exec_the_geom', 'exec_from_plot', 'exec_depth', 'exec_appropiate',
        'notified', 'output', 'modification_date', 'chlorine', 'turbidity', 'minsector_id',
        'reagent_lot', 'equipment_code', 'polygon_the_geom', 'modification_user', 'shutoff_required'
    ],
    'Table om_mincut should have the correct columns'
);

-- Check column types
SELECT col_type_is('om_mincut', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('om_mincut', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('om_mincut', 'mincut_state', 'int2', 'Column mincut_state should be int2');
SELECT col_type_is('om_mincut', 'mincut_class', 'int2', 'Column mincut_class should be int2');
SELECT col_type_is('om_mincut', 'mincut_type', 'varchar(30)', 'Column mincut_type should be varchar(30)');
SELECT col_type_is('om_mincut', 'received_date', 'date', 'Column received_date should be date');
SELECT col_type_is('om_mincut', 'expl_id', 'int4', 'Column expl_id should be int4');
SELECT col_type_is('om_mincut', 'macroexpl_id', 'int4', 'Column macroexpl_id should be int4');
SELECT col_type_is('om_mincut', 'muni_id', 'int4', 'Column muni_id should be int4');
SELECT col_type_is('om_mincut', 'postcode', 'varchar(16)', 'Column postcode should be varchar(16)');
SELECT col_type_is('om_mincut', 'streetaxis_id', 'varchar(250)', 'Column streetaxis_id should be varchar(250)');
SELECT col_type_is('om_mincut', 'postnumber', 'varchar(16)', 'Column postnumber should be varchar(16)');
SELECT col_type_is('om_mincut', 'anl_cause', 'varchar(30)', 'Column anl_cause should be varchar(30)');
SELECT col_type_is('om_mincut', 'anl_tstamp', 'timestamp without time zone', 'Column anl_tstamp should be timestamp without time zone');
SELECT col_type_is('om_mincut', 'anl_user', 'varchar(30)', 'Column anl_user should be varchar(30)');
SELECT col_type_is('om_mincut', 'anl_descript', 'text', 'Column anl_descript should be text');
SELECT col_type_is('om_mincut', 'anl_feature_id', 'int4', 'Column anl_feature_id should be int4');
SELECT col_type_is('om_mincut', 'anl_feature_type', 'varchar(16)', 'Column anl_feature_type should be varchar(16)');
SELECT col_type_is('om_mincut', 'anl_the_geom', 'geometry(point, SRID_VALUE)', 'Column anl_the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('om_mincut', 'forecast_start', 'timestamp without time zone', 'Column forecast_start should be timestamp without time zone');
SELECT col_type_is('om_mincut', 'forecast_end', 'timestamp without time zone', 'Column forecast_end should be timestamp without time zone');
SELECT col_type_is('om_mincut', 'assigned_to', 'varchar(50)', 'Column assigned_to should be varchar(50)');
SELECT col_type_is('om_mincut', 'exec_start', 'timestamp without time zone', 'Column exec_start should be timestamp without time zone');
SELECT col_type_is('om_mincut', 'exec_end', 'timestamp without time zone', 'Column exec_end should be timestamp without time zone');
SELECT col_type_is('om_mincut', 'exec_user', 'varchar(30)', 'Column exec_user should be varchar(30)');
SELECT col_type_is('om_mincut', 'exec_descript', 'text', 'Column exec_descript should be text');
SELECT col_type_is('om_mincut', 'exec_the_geom', 'geometry(point, SRID_VALUE)', 'Column exec_the_geom should be geometry(point, SRID_VALUE)');
SELECT col_type_is('om_mincut', 'exec_from_plot', 'float8', 'Column exec_from_plot should be float8');
SELECT col_type_is('om_mincut', 'exec_depth', 'float8', 'Column exec_depth should be float8');
SELECT col_type_is('om_mincut', 'exec_appropiate', 'bool', 'Column exec_appropiate should be bool');
SELECT col_type_is('om_mincut', 'notified', 'json', 'Column notified should be json');
SELECT col_type_is('om_mincut', 'output', 'json', 'Column output should be json');
SELECT col_type_is('om_mincut', 'modification_date', 'timestamp without time zone', 'Column modification_date should be timestamp without time zone');
SELECT col_type_is('om_mincut', 'chlorine', 'varchar(30)', 'Column chlorine should be varchar(30)');
SELECT col_type_is('om_mincut', 'turbidity', 'varchar(30)', 'Column turbidity should be varchar(30)');
SELECT col_type_is('om_mincut', 'minsector_id', 'int4', 'Column minsector_id should be int4');
SELECT col_type_is('om_mincut', 'reagent_lot', 'varchar(100)', 'Column reagent_lot should be varchar(100)');
SELECT col_type_is('om_mincut', 'equipment_code', 'varchar(50)', 'Column equipment_code should be varchar(50)');
SELECT col_type_is('om_mincut', 'polygon_the_geom', 'geometry(multipolygon, SRID_VALUE)', 'Column polygon_the_geom should be geometry(multipolygon, SRID_VALUE)');
SELECT col_type_is('om_mincut', 'modification_user', 'varchar(50)', 'Column modification_user should be varchar(50)');
SELECT col_type_is('om_mincut', 'shutoff_required', 'bool', 'Column shutoff_required should be bool');

-- Check foreign keys
SELECT has_fk('om_mincut', 'Table om_mincut should have foreign keys');

SELECT fk_ok('om_mincut', 'assigned_to', 'cat_users', 'id', 'FK assigned_to → cat_users.id');
SELECT fk_ok('om_mincut', 'anl_feature_type', 'sys_feature_type', 'id', 'FK anl_feature_type → sys_feature_type.id');
SELECT fk_ok('om_mincut', 'mincut_type', 'om_mincut_cat_type', 'id', 'FK mincut_type → om_mincut_cat_type.id');
SELECT fk_ok('om_mincut', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id → exploitation.expl_id');
SELECT fk_ok('om_mincut', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id → ext_municipality.muni_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
