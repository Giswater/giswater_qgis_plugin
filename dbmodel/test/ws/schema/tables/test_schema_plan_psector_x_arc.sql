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

-- Check table plan_psector_x_arc
SELECT has_table('plan_psector_x_arc'::name, 'Table plan_psector_x_arc should exist');

-- Check columns
SELECT columns_are(
    'plan_psector_x_arc',
    ARRAY[
        'id', 'arc_id', 'psector_id', 'state', 'doable', 'descript', 'addparam',
        'insert_tstamp', 'insert_user', 'archived'
    ],
    'Table plan_psector_x_arc should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_psector_x_arc', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('plan_psector_x_arc', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('plan_psector_x_arc', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('plan_psector_x_arc', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('plan_psector_x_arc', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('plan_psector_x_arc', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('plan_psector_x_arc', 'descript', 'character varying(254)', 'Column descript should be character varying(254)');
SELECT col_type_is('plan_psector_x_arc', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('plan_psector_x_arc', 'insert_tstamp', 'timestamp without time zone', 'Column insert_tstamp should be timestamp without time zone');
SELECT col_type_is('plan_psector_x_arc', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('plan_psector_x_arc', 'archived', 'boolean', 'Column archived should be boolean');

-- Check default values
SELECT col_has_default('plan_psector_x_arc', 'id', 'Column id should have a default value');
SELECT col_has_default('plan_psector_x_arc', 'insert_tstamp', 'Column insert_tstamp should have a default value');
SELECT col_default_is('plan_psector_x_arc', 'insert_user', 'CURRENT_USER', 'Default value for insert_user should be CURRENT_USER');

-- Check foreign keys
SELECT has_fk('plan_psector_x_arc', 'Table plan_psector_x_arc should have foreign keys');
SELECT fk_ok('plan_psector_x_arc', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');
SELECT fk_ok('plan_psector_x_arc', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id should reference plan_psector.psector_id');

-- Check constraints
SELECT col_not_null('plan_psector_x_arc', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('plan_psector_x_arc', 'arc_id', 'Column arc_id should be NOT NULL');
SELECT col_not_null('plan_psector_x_arc', 'psector_id', 'Column psector_id should be NOT NULL');
SELECT col_not_null('plan_psector_x_arc', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('plan_psector_x_arc', 'doable', 'Column doable should be NOT NULL');
SELECT col_has_check('plan_psector_x_arc', 'state', 'Column state should have a check constraint');

-- Check unique constraints
SELECT col_is_unique('plan_psector_x_arc', ARRAY['arc_id', 'psector_id'], 'Columns arc_id and psector_id should be unique together');

-- Check indexes
SELECT has_index('plan_psector_x_arc', 'plan_psector_x_arc_arc_id', 'Table should have index on arc_id');
SELECT has_index('plan_psector_x_arc', 'plan_psector_x_arc_psector_id', 'Table should have index on psector_id');
SELECT has_index('plan_psector_x_arc', 'plan_psector_x_arc_state', 'Table should have index on state');

-- Check triggers
SELECT has_trigger('plan_psector_x_arc', 'gw_trg_plan_psector_delete_arc', 'Table should have trigger gw_trg_plan_psector_delete_arc');
SELECT has_trigger('plan_psector_x_arc', 'gw_trg_plan_psector_x_arc', 'Table should have trigger gw_trg_plan_psector_x_arc');
SELECT has_trigger('plan_psector_x_arc', 'gw_trg_plan_psector_x_arc_geom', 'Table should have trigger gw_trg_plan_psector_x_arc_geom');

SELECT * FROM finish();

ROLLBACK;