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

-- Check table plan_netscenario_mapzone_graph
SELECT has_table('plan_netscenario_mapzone_graph'::name, 'Table plan_netscenario_mapzone_graph should exist');

-- Check columns
SELECT columns_are(
    'plan_netscenario_mapzone_graph',
    ARRAY[
        'node_id', 'netscenario_id', 'mapzone_id', 'mapzone_type', 'flow_sign'
    ],
    'Table plan_netscenario_mapzone_graph should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('plan_netscenario_mapzone_graph', ARRAY['node_id', 'mapzone_id'], 'Columns node_id and mapzone_id should be primary key');

-- Check column types
SELECT col_type_is('plan_netscenario_mapzone_graph', 'node_id', 'integer', 'Column node_id should be integer');
SELECT col_type_is('plan_netscenario_mapzone_graph', 'netscenario_id', 'integer', 'Column netscenario_id should be integer');
SELECT col_type_is('plan_netscenario_mapzone_graph', 'mapzone_id', 'integer', 'Column mapzone_id should be integer');
SELECT col_type_is('plan_netscenario_mapzone_graph', 'mapzone_type', 'integer', 'Column mapzone_type should be integer');
SELECT col_type_is('plan_netscenario_mapzone_graph', 'flow_sign', 'smallint', 'Column flow_sign should be smallint');

-- Check unique constraints
SELECT col_is_unique('plan_netscenario_mapzone_graph', ARRAY['mapzone_id', 'node_id'], 'Columns mapzone_id and node_id should have a unique constraint');

-- Check constraints
SELECT col_not_null('plan_netscenario_mapzone_graph', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('plan_netscenario_mapzone_graph', 'netscenario_id', 'Column netscenario_id should be NOT NULL');
SELECT col_not_null('plan_netscenario_mapzone_graph', 'mapzone_id', 'Column mapzone_id should be NOT NULL');
SELECT col_not_null('plan_netscenario_mapzone_graph', 'mapzone_type', 'Column mapzone_type should be NOT NULL');

SELECT * FROM finish();

ROLLBACK;