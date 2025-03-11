/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(5);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_repair_node_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
    "parameters":{"node":"1039", "action":"DELETE", "targetNode":null, "dx":null, "dy":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_repair_node_duplicated --> action : DELETE returns status "Accepted"'
);

SELECT is(
    (gw_fct_repair_node_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
    "parameters":{"node":"1039", "action":"DOWNGRADE", "targetNode":null, "dx":null, "dy":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_repair_node_duplicated --> action : DOWNGRADE returns status "Accepted"'
);

SELECT is(
    (gw_fct_repair_node_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
    "parameters":{"node":"1039", "action":"MOVE-LOSE-TOPO", "targetNode":null, "dx":null, "dy":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_repair_node_duplicated --> action : MOVE-LOSE-TOPO returns status "Accepted"'
);

SELECT is(
    (gw_fct_repair_node_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
    "parameters":{"node":"1039", "action":"MOVE-KEEP-TOPO", "targetNode":null, "dx":null, "dy":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_repair_node_duplicated --> action : MOVE-KEEP-TOPO returns status "Accepted"'
);

SELECT is(
    (gw_fct_repair_node_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
    "parameters":{"node":"1039", "action":"MOVE-GET-TOPO", "targetNode":null, "dx":null, "dy":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_repair_node_duplicated --> action : MOVE-GET-TOPO returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
