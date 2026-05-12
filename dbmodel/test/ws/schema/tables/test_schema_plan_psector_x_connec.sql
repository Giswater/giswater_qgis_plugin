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

-- Check table plan_psector_x_connec
SELECT has_table('plan_psector_x_connec'::name, 'Table plan_psector_x_connec should exist');

-- Check columns
SELECT columns_are(
    'plan_psector_x_connec',
    ARRAY[
        'id', 'connec_id', 'arc_id', 'psector_id', 'state', 'doable', 'descript', '_link_geom_',
        '_userdefined_geom_', 'link_id', 'insert_tstamp', 'insert_user', 'addparam', 'archived'
    ],
    'Table plan_psector_x_connec should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_psector_x_connec', ARRAY['id'], 'Column id should be primary key');

-- Check column types
SELECT col_type_is('plan_psector_x_connec', 'id', 'integer', 'Column id should be integer');
SELECT col_type_is('plan_psector_x_connec', 'connec_id', 'integer', 'Column connec_id should be integer');
SELECT col_type_is('plan_psector_x_connec', 'arc_id', 'integer', 'Column arc_id should be integer');
SELECT col_type_is('plan_psector_x_connec', 'psector_id', 'integer', 'Column psector_id should be integer');
SELECT col_type_is('plan_psector_x_connec', 'state', 'smallint', 'Column state should be smallint');
SELECT col_type_is('plan_psector_x_connec', 'doable', 'boolean', 'Column doable should be boolean');
SELECT col_type_is('plan_psector_x_connec', 'descript', 'character varying(254)', 'Column descript should be character varying(254)');
SELECT col_type_is('plan_psector_x_connec', '_link_geom_', 'geometry(LineString,25831)', 'Column _link_geom_ should be geometry(LineString,25831)');
SELECT col_type_is('plan_psector_x_connec', '_userdefined_geom_', 'boolean', 'Column _userdefined_geom_ should be boolean');
SELECT col_type_is('plan_psector_x_connec', 'link_id', 'integer', 'Column link_id should be integer');
SELECT col_type_is('plan_psector_x_connec', 'insert_tstamp', 'timestamp without time zone', 'Column insert_tstamp should be timestamp without time zone');
SELECT col_type_is('plan_psector_x_connec', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('plan_psector_x_connec', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('plan_psector_x_connec', 'archived', 'boolean', 'Column archived should be boolean');

-- Check default values
SELECT col_has_default('plan_psector_x_connec', 'id', 'Column id should have a default value');
SELECT col_has_default('plan_psector_x_connec', 'insert_tstamp', 'Column insert_tstamp should have a default value');
SELECT col_default_is('plan_psector_x_connec', 'insert_user', 'CURRENT_USER', 'Default value for insert_user should be CURRENT_USER');

-- Check foreign keys
SELECT has_fk('plan_psector_x_connec', 'Table plan_psector_x_connec should have foreign keys');
SELECT fk_ok('plan_psector_x_connec', 'arc_id', 'arc', 'arc_id', 'FK arc_id should reference arc.arc_id');
SELECT fk_ok('plan_psector_x_connec', 'connec_id', 'connec', 'connec_id', 'FK connec_id should reference connec.connec_id');
SELECT fk_ok('plan_psector_x_connec', 'link_id', 'link', 'link_id', 'FK link_id should reference link.link_id');
SELECT fk_ok('plan_psector_x_connec', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id should reference plan_psector.psector_id');

-- Check constraints
SELECT col_not_null('plan_psector_x_connec', 'id', 'Column id should be NOT NULL');
SELECT col_not_null('plan_psector_x_connec', 'connec_id', 'Column connec_id should be NOT NULL');
SELECT col_not_null('plan_psector_x_connec', 'psector_id', 'Column psector_id should be NOT NULL');
SELECT col_not_null('plan_psector_x_connec', 'state', 'Column state should be NOT NULL');
SELECT col_not_null('plan_psector_x_connec', 'doable', 'Column doable should be NOT NULL');
SELECT col_has_check('plan_psector_x_connec', 'state', 'Column state should have a check constraint');

-- Check unique constraints
SELECT col_is_unique('plan_psector_x_connec', ARRAY['connec_id', 'psector_id', 'state'], 'Columns connec_id, psector_id, and state should be unique together');

-- Check indexes
SELECT has_index('plan_psector_x_connec', 'plan_psector_x_connec_arc_id', 'Table should have index on arc_id');
SELECT has_index('plan_psector_x_connec', 'plan_psector_x_connec_connec_id', 'Table should have index on connec_id');
SELECT has_index('plan_psector_x_connec', 'plan_psector_x_connec_psector_id', 'Table should have index on psector_id');
SELECT has_index('plan_psector_x_connec', 'plan_psector_x_connec_state', 'Table should have index on state');

-- Check triggers
SELECT has_trigger('plan_psector_x_connec', 'gw_trg_plan_psector_delete_connec', 'Table should have trigger gw_trg_plan_psector_delete_connec');
SELECT has_trigger('plan_psector_x_connec', 'gw_trg_plan_psector_link', 'Table should have trigger gw_trg_plan_psector_link');
SELECT has_trigger('plan_psector_x_connec', 'gw_trg_plan_psector_x_connec', 'Table should have trigger gw_trg_plan_psector_x_connec');
SELECT has_trigger('plan_psector_x_connec', 'gw_trg_plan_psector_x_connec_geom', 'Table should have trigger gw_trg_plan_psector_x_connec_geom');

SELECT * FROM finish();

ROLLBACK;