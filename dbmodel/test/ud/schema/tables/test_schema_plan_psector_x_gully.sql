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
SELECT has_table('plan_psector_x_gully'::name, 'Table plan_psector_x_gully should exist');

-- Check columns
SELECT columns_are(
    'plan_psector_x_gully',
    ARRAY[
        'id', 'gully_id', 'arc_id', 'psector_id', 'state', 'doable',
        'descript', '_link_geom_', '_userdefined_geom_', 'link_id', 'insert_tstamp', 'insert_user',
        'addparam', 'archived'
    ],
    'Table plan_psector_x_gully should have the correct columns'
);

-- Check column types
SELECT col_type_is('plan_psector_x_gully', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('plan_psector_x_gully', 'gully_id', 'int4', 'Column gully_id should be int4');
SELECT col_type_is('plan_psector_x_gully', 'arc_id', 'int4', 'Column arc_id should be int4');
SELECT col_type_is('plan_psector_x_gully', 'psector_id', 'int4', 'Column psector_id should be int4');
SELECT col_type_is('plan_psector_x_gully', 'state', 'int2', 'Column state should be int2');
SELECT col_type_is('plan_psector_x_gully', 'doable', 'bool', 'Column doable should be bool');
SELECT col_type_is('plan_psector_x_gully', 'descript', 'varchar(254)', 'Column descript should be varchar(254)');
SELECT col_type_is('plan_psector_x_gully', '_link_geom_', 'geometry(linestring, SRID_VALUE)', 'Column _link_geom_ should be geometry(linestring, SRID_VALUE)');
SELECT col_type_is('plan_psector_x_gully', '_userdefined_geom_', 'bool', 'Column _userdefined_geom_ should be bool');
SELECT col_type_is('plan_psector_x_gully', 'link_id', 'int4', 'Column link_id should be int4');
SELECT col_type_is('plan_psector_x_gully', 'insert_tstamp', 'timestamp without time zone', 'Column insert_tstamp should be timestamp without time zone');
SELECT col_type_is('plan_psector_x_gully', 'insert_user', 'text', 'Column insert_user should be text');
SELECT col_type_is('plan_psector_x_gully', 'addparam', 'json', 'Column addparam should be json');
SELECT col_type_is('plan_psector_x_gully', 'archived', 'bool', 'Column archived should be bool');

-- Check foreign keys
SELECT has_fk('plan_psector_x_gully', 'Table plan_psector_x_gully should have foreign keys');

SELECT fk_ok('plan_psector_x_gully', 'psector_id', 'plan_psector', 'psector_id', 'FK psector_id → plan_psector.psector_id');
SELECT fk_ok('plan_psector_x_gully', 'arc_id', 'arc', 'arc_id', 'FK arc_id → arc.arc_id');
SELECT fk_ok('plan_psector_x_gully', 'gully_id', 'gully', 'gully_id', 'FK gully_id → gully.gully_id');
SELECT fk_ok('plan_psector_x_gully', 'link_id', 'link', 'link_id', 'FK link_id → link.link_id');

-- Finish
SELECT * FROM finish();

ROLLBACK;
