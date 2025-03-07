/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 4 test
SELECT plan(4);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setsearch($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"tabName":"network"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "searchType":"arc", "net_type":{"id":"v_edit_arc", "name":"Arcs"},
    "net_code":{"text":"100011 : CC040"}, "addSchema":"NULL"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setsearch --> tabName":"network" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setsearch($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"tabName":"workcat"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "workcat_search":{"text":"work1"}, "addSchema":"NULL"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setsearch --> tabName":"workcat" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setsearch($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"tabName":"psector"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "psector_expl":{"id":"1", "name":"expl_01"},
    "psector_search":{"text":"ACT_01_F0"}, "addSchema":"NULL"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setsearch --> tabName":"psector" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setsearch($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"tabName":"visit"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "visit_search":{"text":"1"}, "addSchema":"NULL"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setsearch --> tabName":"visit" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;