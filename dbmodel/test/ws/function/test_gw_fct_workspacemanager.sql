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

-- Plan for 7 test
SELECT plan(7);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "action":"INFO", "id":"1"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"INFO" returns status "Accepted"'
);

SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "action":"CREATE", "name":"test1", "descript":null, "private":"False"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"CREATE" returns status "Accepted"'
);

SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "action":"CURRENT", "id": "1"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"CURRENT" returns status "Accepted"'
);

SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "action":"TOGGLE", "id": "1"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"TOGGLE" returns status "Accepted"'
);

SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "action":"UPDATE", "name":"test1_0", "descript":null,
    "private":"True", "id": "1"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"UPDATE" returns status "Accepted"'
);

SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "action":"DELETE", "id": "1"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"DELETE" returns status "Accepted"'
);

SELECT is (
    (gw_fct_workspacemanager($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "action":"CHECK"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_workspacemanager --> "action":"CHECK" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;