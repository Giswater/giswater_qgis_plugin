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

SELECT plan(53);

SELECT is (
    (gw_fct_graphanalytics_manage_temporary($${"data":{"action":"CREATE", "fct_name":"DMA", "use_psector":"false"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_manage_temporary (DMA) CREATE with use_psector false returns status "Accepted"'
);

-- Check if temporary tables exist after CREATE
SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_mapzone' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_mapzone table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'temp_pgr_node' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_node table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_arc' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_arc table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_drivingdistance' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_drivingdistance table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_audit_check_data' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_audit_check_data table exists after CREATE'
);

-- Check if temporary views exist after CREATE with use_psector false
SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_arc'),
    'Check if v_temp_arc view exists after CREATE with use_psector false'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_node'),
    'Check if v_temp_node view exists after CREATE with use_psector false'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_connec'),
    'Check if v_temp_connec view exists after CREATE with use_psector false'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_gully'),
    'Check if v_temp_gully view exists after CREATE with use_psector false'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_link_connec'),
    'Check if v_temp_link_connec view exists after CREATE with use_psector false'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_link_gully'),
    'Check if v_temp_link_gully view exists after CREATE with use_psector false'
);


-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_graphanalytics_manage_temporary($${"data":{"action":"DROP", "fct_name":"DMA"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_manage_temporary (DMA) DROP returns status "Accepted"'
);

-- Check if temporary tables exist after DROP
SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_mapzone' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_mapzone table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_node' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_node table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_arc' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_arc table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_drivingdistance' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_drivingdistance table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_audit_check_data' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_audit_check_data table does not exist after DROP'
);

-- Check if temporary views exist after DROP
SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_arc'),
    'Check if v_temp_arc view does not exist after DROP'
);


SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_node'),
    'Check if v_temp_node view does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_connec'),
    'Check if v_temp_connec view does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_gully'),
    'Check if v_temp_gully view does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_link_connec'),
    'Check if v_temp_link_connec view does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_link_gully'),
    'Check if v_temp_link_gully view does not exist after DROP'
);


SELECT is (
    (gw_fct_graphanalytics_manage_temporary($${"data":{"action":"CREATE", "fct_name":"DMA", "use_psector":"true"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_manage_temporary (DMA) CREATE with use_psector true returns status "Accepted"'
);

-- Check if temporary tables exist after CREATE
SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_mapzone' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_mapzone table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'temp_pgr_node' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_node table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_arc' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_arc table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_drivingdistance' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_drivingdistance table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_audit_check_data' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_audit_check_data table exists after CREATE'
);

-- Check if temporary views exist after CREATE with use_psector true
SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_arc'),
    'Check if v_temp_arc view exists after CREATE with use_psector true'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_node'),
    'Check if v_temp_node view exists after CREATE with use_psector true'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_connec'),
    'Check if v_temp_connec view exists after CREATE with use_psector true'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_gully'),
    'Check if v_temp_gully view exists after CREATE with use_psector true'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_link_connec'),
    'Check if v_temp_link_connec view exists after CREATE with use_psector true'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_link_gully'),
    'Check if v_temp_link_gully view exists after CREATE with use_psector true'
);

SELECT is (
    (gw_fct_graphanalytics_manage_temporary($${"data":{"action":"CREATE", "fct_name":"MINSECTOR", "use_psector":"true"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_manage_temporary (MINSECTOR) CREATE with use_psector true returns status "Accepted"'
);

-- Check if extra temporary tables exist after CREATE
SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_connectedcomponents' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_connectedcomponents table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_minsector_graph' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_minsector_graph table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_minsector' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_minsector table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_minsector_mincut' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_minsector_mincut table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_node_mincut' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_node_mincut table exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_arc_mincut' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_arc_mincut table exists after CREATE'
);

-- Check if extra temporary views exist after CREATE
SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_pgr_minsector_old'),
    'Check if v_temp_pgr_minsector_old view exists after CREATE'
);

SELECT ok(
    EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_minsector_mincut'),
    'Check if v_temp_minsector_mincut view exists after CREATE'
);

SELECT is (
    (gw_fct_graphanalytics_manage_temporary($${"data":{"action":"DROP", "fct_name":"MINSECTOR"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_manage_temporary (MINSECTOR) DROP returns status "Accepted"'
);

-- Check if extra temporary tables exist after DROP
SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_connectedcomponents' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_connectedcomponents table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_minsector_graph' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_minsector_graph table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_minsector' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_minsector table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_minsector_mincut' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_minsector_mincut table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_node_mincut' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_node_mincut table does not exist after DROP'
);

SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE table_name = 'temp_pgr_arc_mincut' AND table_type = 'LOCAL TEMPORARY'),
    'Check if temp_pgr_arc_mincut table does not exist after DROP'
);

-- Check if extra temporary views exist after DROP
SELECT ok(
    NOT EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'v_temp_pgr_minsector_old'),
    'Check if v_temp_pgr_minsector_old view does not exist after DROP'
);

-- Finish the test
SELECT finish();

ROLLBACK;