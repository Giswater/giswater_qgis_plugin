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

-- Check table om_mincut
SELECT has_table('om_mincut'::name, 'Table om_mincut should exist');

-- Check columns
SELECT columns_are(
    'om_mincut',
    ARRAY[
        'id', 'work_order', 'mincut_state', 'mincut_class', 'mincut_type', 'received_date', 'expl_id',
        'macroexpl_id', 'muni_id', 'postcode', 'streetaxis_id', 'postnumber', 'anl_cause', 'anl_tstamp',
        'anl_user', 'anl_descript', 'anl_feature_id', 'anl_feature_type', 'anl_the_geom', 'forecast_start',
        'forecast_end', 'assigned_to', 'exec_start', 'exec_end', 'exec_user', 'exec_descript',
        'exec_the_geom', 'exec_from_plot', 'exec_depth', 'exec_appropiate', 'notified', 'output',
        'modification_date', 'chlorine', 'turbidity', 'minsector_id', 'reagent_lot', 'equipment_code', 'polygon_the_geom'
    ],
    'Table om_mincut should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_mincut', ARRAY['id'], 'Column id should be primary key');

-- Check column types and defaults
SELECT col_type_is('om_mincut', 'id', 'integer', 'Column id should be integer');
SELECT col_has_default('om_mincut', 'id', 'Column id should have a default value');
SELECT col_type_is('om_mincut', 'work_order', 'varchar(50)', 'Column work_order should be varchar(50)');
SELECT col_type_is('om_mincut', 'mincut_state', 'smallint', 'Column mincut_state should be smallint');
SELECT col_type_is('om_mincut', 'mincut_class', 'smallint', 'Column mincut_class should be smallint');
SELECT col_type_is('om_mincut', 'mincut_type', 'varchar(30)', 'Column mincut_type should be varchar(30)');
SELECT col_type_is('om_mincut', 'anl_tstamp', 'timestamp without time zone', 'Column anl_tstamp should be timestamp');
SELECT col_default_is('om_mincut', 'anl_tstamp', 'now()', 'Column anl_tstamp should default to now()');
SELECT col_type_is('om_mincut', 'notified', 'json', 'Column notified should be json');
SELECT col_type_is('om_mincut', 'output', 'json', 'Column output should be json');
SELECT col_type_is('om_mincut', 'reagent_lot', 'varchar(100)', 'Column reagent_lot should be varchar(100)');
SELECT col_type_is('om_mincut', 'equipment_code', 'varchar(50)', 'Column equipment_code should be varchar(50)');

-- Check foreign keys
SELECT has_fk('om_mincut', 'Table om_mincut should have foreign keys');
SELECT fk_ok('om_mincut', 'assigned_to', 'cat_users', 'id', 'FK assigned_to should reference cat_users.id');
SELECT fk_ok('om_mincut', 'expl_id', 'exploitation', 'expl_id', 'FK expl_id should reference exploitation.expl_id');
SELECT fk_ok('om_mincut', 'anl_feature_type', 'sys_feature_type', 'id', 'FK anl_feature_type should reference sys_feature_type.id');
SELECT fk_ok('om_mincut', 'mincut_type', 'om_mincut_cat_type', 'id', 'FK mincut_type should reference om_mincut_cat_type.id');
SELECT fk_ok('om_mincut', 'muni_id', 'ext_municipality', 'muni_id', 'FK muni_id should reference ext_municipality.muni_id');

-- Check triggers
SELECT has_trigger('om_mincut', 'gw_trg_mincut', 'Table should have gw_trg_mincut trigger');
SELECT has_trigger('om_mincut', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('om_mincut', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

SELECT * FROM finish();

ROLLBACK; 