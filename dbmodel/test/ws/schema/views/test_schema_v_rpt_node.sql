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

-- Check view v_rpt_node
SELECT has_view('v_rpt_node'::name, 'View v_rpt_node should exist');

-- Check view columns
SELECT columns_are(
    'v_rpt_node',
    ARRAY[
        'id', 'node_id', 'node_type', 'sector_id', 'nodecat_id', 'result_id',
        'flow_units', 'top_elev', 'demand', 'head', 'press', 'quality_units',
        'quality', 'time', 'the_geom'
    ],
    'View v_rpt_node should have the correct columns'
);

-- Check column types
SELECT col_type_is('v_rpt_node', 'id', 'int4', 'Column id should be int4');
SELECT col_type_is('v_rpt_node', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('v_rpt_node', 'node_type', 'varchar(30)', 'Column node_type should be varchar(30)');
SELECT col_type_is('v_rpt_node', 'sector_id', 'int4', 'Column sector_id should be int4');
SELECT col_type_is('v_rpt_node', 'nodecat_id', 'varchar(30)', 'Column nodecat_id should be varchar(30)');
SELECT col_type_is('v_rpt_node', 'result_id', 'varchar(30)', 'Column result_id should be varchar(30)');
SELECT col_type_is('v_rpt_node', 'flow_units', 'text', 'Column flow_units should be text');
SELECT col_type_is('v_rpt_node', 'top_elev', 'numeric', 'Column top_elev should be numeric');
SELECT col_type_is('v_rpt_node', 'demand', 'numeric', 'Column demand should be numeric');
SELECT col_type_is('v_rpt_node', 'head', 'numeric', 'Column head should be numeric');
SELECT col_type_is('v_rpt_node', 'press', 'numeric', 'Column press should be numeric');
SELECT col_type_is('v_rpt_node', 'quality_units', 'text', 'Column quality_units should be text');
SELECT col_type_is('v_rpt_node', 'quality', 'numeric(12,4)', 'Column quality should be numeric(12,4)');
SELECT col_type_is('v_rpt_node', 'time', 'timestamp without time zone', 'Column time should be timestamp without time zone');
SELECT col_type_is('v_rpt_node', 'the_geom', 'geometry(point, SRID_VALUE)', 'Column the_geom should be geometry(point, SRID_VALUE)');

SELECT * FROM finish();

ROLLBACK;
