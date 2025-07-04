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
SELECT has_table('archived_rpt_inp_raingage'::name, 'Table archived_rpt_inp_raingage should exist');

 
-- Check columns
SELECT columns_are(
    'archived_rpt_inp_raingage',
    ARRAY[
        'id', 'result_id', 'rg_id', 'form_type', 'intvl', 'scf', 'rgage_type', 'timser_id', 'fname', 'sta',
        'units', 'the_geom', 'expl_id', 'muni_id'
    ],
    'Table archived_rpt_inp_raingage should have the correct columns'
);
 
-- Check primary key
SELECT col_is_pk('archived_rpt_inp_raingage', 'id', 'Column id should be primary key');

 
-- Check column types
SELECT col_type_is('archived_rpt_inp_raingage', 'id','bigserial', 'Column id should be bigserial');
SELECT col_type_is('archived_rpt_inp_raingage', 'result_id','varchar(30)','Column result_id should be varchar(30)');
SELECT col_type_is('archived_rpt_inp_raingage', 'rg_id','varchar(16)', 'Column rg_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_raingage', 'form_type','varchar(12)','Column form_type should be varchar(12)');
SELECT col_type_is('archived_rpt_inp_raingage', 'intvl','varchar(10)', 'Column intvl should be varchar(10)');
SELECT col_type_is('archived_rpt_inp_raingage', 'scf','numeric(12,4)','Column scf should be numeric(12,4)');
SELECT col_type_is('archived_rpt_inp_raingage', 'rgage_type','varchar(18)','Column rgage_type should be varchar(18)');
SELECT col_type_is('archived_rpt_inp_raingage', 'timser_id', 'varchar(16)','Column timser_id should be varchar(16)');
SELECT col_type_is('archived_rpt_inp_raingage', 'fname','varchar(254)','Column fname should be varchar(254)');
SELECT col_type_is('archived_rpt_inp_raingage', 'sta', 'varchar(12)','Column sta should be varchar(12)');
SELECT col_type_is('archived_rpt_inp_raingage', 'units','varchar(3)','Column units should be varchar(3)');
SELECT col_type_is('archived_rpt_inp_raingage', 'the_geom','geometry(Point,25831)','Column the_geom should be geometry(Point,25831)');
SELECT col_type_is('archived_rpt_inp_raingage', 'expl_id','integer','Column expl_id should be integer');
SELECT col_type_is('archived_rpt_inp_raingage', 'muni_id','integer','Column muni_id should be integer');

-- Check default values
SELECT col_has_default('archived_rpt_inp_raingage', 'scf', 'Column scf should have default value');
 
 
-- Check indexes
SELECT has_index('archived_rpt_inp_raingage', 'id', 'Table should have index on id');
 
 
-- Finish
SELECT * FROM finish();
 
ROLLBACK;