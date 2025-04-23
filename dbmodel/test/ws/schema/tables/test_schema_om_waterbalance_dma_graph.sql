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

-- Check table om_waterbalance_dma_graph
SELECT has_table('om_waterbalance_dma_graph'::name, 'Table om_waterbalance_dma_graph should exist');

-- Check columns
SELECT columns_are(
    'om_waterbalance_dma_graph',
    ARRAY[
        'node_id', 'dma_id', 'flow_sign'
    ],
    'Table om_waterbalance_dma_graph should have the correct columns'
);

-- Check primary key
SELECT col_is_pk('om_waterbalance_dma_graph', ARRAY['node_id', 'dma_id'], 'Columns node_id and dma_id should be primary key');

-- Check column types
SELECT col_type_is('om_waterbalance_dma_graph', 'node_id', 'varchar(16)', 'Column node_id should be varchar(16)');
SELECT col_type_is('om_waterbalance_dma_graph', 'dma_id', 'integer', 'Column dma_id should be integer');
SELECT col_type_is('om_waterbalance_dma_graph', 'flow_sign', 'smallint', 'Column flow_sign should be smallint');

-- Check unique constraints
SELECT col_is_unique('om_waterbalance_dma_graph', ARRAY['dma_id', 'node_id'], 'Columns dma_id and node_id should have a unique constraint');

-- Check foreign keys
SELECT has_fk('om_waterbalance_dma_graph', 'Table om_waterbalance_dma_graph should have foreign keys');
SELECT fk_ok('om_waterbalance_dma_graph', 'dma_id', 'dma', 'dma_id', 'FK dma_id should reference dma.dma_id');

-- Check constraints
SELECT col_not_null('om_waterbalance_dma_graph', 'node_id', 'Column node_id should be NOT NULL');
SELECT col_not_null('om_waterbalance_dma_graph', 'dma_id', 'Column dma_id should be NOT NULL');

SELECT * FROM finish();

ROLLBACK; 