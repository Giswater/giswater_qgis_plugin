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

-- Check table config_info_layer
SELECT has_table('config_info_layer'::name, 'Table config_info_layer should exist');

-- Check columns
SELECT columns_are(
    'config_info_layer',
    ARRAY[
        'layer_id', 'is_parent', 'tableparent_id', 'is_editable', 'formtemplate', 'headertext', 'orderby', 'tableparentepa_id', 'addparam'
    ],
    'Table config_info_layer should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('config_info_layer', ARRAY['layer_id'], 'Column layer_id should be primary key');

-- Check column types
SELECT col_type_is('config_info_layer', 'layer_id', 'text', 'Column layer_id should be text');
SELECT col_type_is('config_info_layer', 'is_parent', 'boolean', 'Column is_parent should be boolean');
SELECT col_type_is('config_info_layer', 'tableparent_id', 'text', 'Column tableparent_id should be text');
SELECT col_type_is('config_info_layer', 'is_editable', 'boolean', 'Column is_editable should be boolean');
SELECT col_type_is('config_info_layer', 'formtemplate', 'text', 'Column formtemplate should be text');
SELECT col_type_is('config_info_layer', 'headertext', 'text', 'Column headertext should be text');
SELECT col_type_is('config_info_layer', 'orderby', 'integer', 'Column orderby should be integer');
SELECT col_type_is('config_info_layer', 'tableparentepa_id', 'text', 'Column tableparentepa_id should be text');
SELECT col_type_is('config_info_layer', 'addparam', 'json', 'Column addparam should be json');

-- Check foreign keys
SELECT hasnt_fk('config_info_layer', 'Table config_info_layer should have no foreign keys');

-- Check triggers
SELECT has_trigger('config_info_layer', 'gw_trg_typevalue_fk_insert', 'Table should have gw_trg_typevalue_fk_insert trigger');
SELECT has_trigger('config_info_layer', 'gw_trg_typevalue_fk_update', 'Table should have gw_trg_typevalue_fk_update trigger');

-- Check rules

-- Check sequences

-- Check constraints
SELECT col_not_null('config_info_layer', 'layer_id', 'Column layer_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;
