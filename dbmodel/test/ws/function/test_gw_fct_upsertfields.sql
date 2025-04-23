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

-- Plan for 2 test
SELECT plan(2);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_upsertfields($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"id":"1, 2", "tableName":"plan_netscenario_dma"},
    "data":{"filterFields":{}, "pageInfo":{}, "fields":{"netscenario_id": "1", "dma_id": "2", "dma_name": "dma1-2d", "pattern_id": "PTN-DMA-02-DEF",
    "graphconfig": "{\"use\": [{\"nodeParent\": \"1080\", \"toArc\": [2092]}], \"ignore\": [], \"forceClosed\": []}", "active": "true"}, "force_action":"UPDATE"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_upsertfields --> "tableName":"plan_netscenario_dma" returns status "Accepted"'
);

SELECT is (
    (gw_fct_upsertfields($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"id":"2", "tableName":"inp_dscenario_demand"},
    "data":{"filterFields":{}, "pageInfo":{}, "fields":{"dscenario_id": "1", "feature_type": "NODE", "demand": "8.000000", "pattern_id": "PTN-HYDRANT", "demand_type": "3",
    "source": "NODE 1012"}, "force_action":"UPDATE"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_upsertfields --> "tableName":"inp_dscenario_demand" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;