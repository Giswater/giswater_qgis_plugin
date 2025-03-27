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

-- Check table dqa
SELECT has_table('dqa'::name, 'Table dqa should exist');

-- Check columns
SELECT columns_are(
    'dqa',
    ARRAY[
        'dqa_id', 'name', 'dqa_type', 'muni_id', 'expl_id', 'sector_id', 'macrodqa_id', 'descript', 'the_geom', 'pattern_id', 'link', 'graphconfig', 'stylesheet', 'active', 'tstamp', 'insert_user', 'lastupdate', 'lastupdate_user', 'avg_press', 'lock_level'
    ],
    'Table dqa should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('dqa', ARRAY['dqa_id'], 'Column dqa_id should be primary key');

-- Check column types
SELECT col_type_is('dqa', 'dqa_id', 'integer', 'Column dqa_id should be integer');
SELECT col_type_is('dqa', 'name', 'varchar(30)', 'Column name should be varchar(30)');
SELECT col_type_is('dqa', 'dqa_type', 'varchar(16)', 'Column dqa_type should be varchar(16)');
SELECT col_type_is('dqa', 'muni_id', '_int4', 'Column muni_id should be _int4');
SELECT col_type_is('dqa', 'expl_id', '_int4', 'Column expl_id should be _int4');
SELECT col_type_is('dqa', 'sector_id', '_int4', 'Column sector_id should be _int4');
SELECT col_type_is('dqa', 'macrodqa_id', 'integer', 'Column macrodqa_id should be integer');
SELECT col_type_is('dqa', 'descript', 'text', 'Column descript should be text');
SELECT col_type_is('dqa', 'the_geom', 'geometry(MultiPolygon,25831)', 'Column the_geom should be geometry(MultiPolygon,25831)');
SELECT col_type_is('dqa', 'pattern_id', 'varchar(16)', 'Column pattern_id should be varchar(16)');
SELECT col_type_is('dqa', 'link', 'text', 'Column link should be text');
SELECT col_type_is('dqa', 'graphconfig', 'json', 'Column graphconfig should be json');
SELECT col_type_is('dqa', 'stylesheet', 'json', 'Column stylesheet should be json');
SELECT col_type_is('dqa', 'active', 'boolean', 'Column active should be boolean');
SELECT col_type_is('dqa', 'tstamp', 'timestamp', 'Column tstamp should be timestamp');
SELECT col_type_is('dqa', 'insert_user', 'varchar(50)', 'Column insert_user should be varchar(50)');
SELECT col_type_is('dqa', 'lastupdate', 'timestamp', 'Column lastupdate should be timestamp');
SELECT col_type_is('dqa', 'lastupdate_user', 'varchar(50)', 'Column lastupdate_user should be varchar(50)');
SELECT col_type_is('dqa', 'avg_press', 'double precision', 'Column avg_press should be double precision');
SELECT col_type_is('dqa', 'lock_level', 'integer', 'Column lock_level should be integer');

-- Check foreign keys
SELECT has_fk('dqa', 'Table dqa should have foreign keys');
SELECT fk_ok('dqa', 'macrodqa_id', 'macrodqa', 'macrodqa_id', 'FK dqa_macrodqa_id_fkey should exist');
SELECT fk_ok('dqa', 'pattern_id', 'inp_pattern', 'pattern_id', 'FK dqa_pattern_id_fkey should exist');

-- Check triggers
SELECT has_trigger('dqa', 'gw_trg_edit_controls', 'Table should have gw_trg_edit_controls trigger');
SELECT has_trigger('dqa', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('dqa', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules
SELECT has_rule('dqa', 'dqa_conflict', 'Table should have dqa_conflict rule');
SELECT has_rule('dqa', 'dqa_del_conflict', 'Table should have dqa_del_conflict rule');
SELECT has_rule('dqa', 'dqa_del_undefined', 'Table should have dqa_del_undefined rule');
SELECT has_rule('dqa', 'dqa_undefined', 'Table should have dqa_undefined rule');

-- Check sequences
SELECT has_sequence('dqa_dqa_id_seq', 'Sequence dqa_dqa_id_seq should exist');

-- Check constraints
SELECT col_default_is('dqa', 'active', true, 'Column active should have default value');
SELECT col_default_is('dqa', 'tstamp', 'now()', 'Column tstamp should have default value');
SELECT col_default_is('dqa', 'insert_user', 'CURRENT_USER', 'Column insert_user should have default value');

SELECT * FROM finish();

ROLLBACK;
