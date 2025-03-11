/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(6);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, 
    "expl":"0", "active":"false"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dwf_scenario_empty with expl > 0 and active > false returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, 
    "expl":"1", "active":"false"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dwf_scenario_empty with expl > 1 and active > false returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, 
    "expl":"2", "active":"false"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dwf_scenario_empty with expl > 2 and active > false returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, 
    "expl":"0", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dwf_scenario_empty with expl > 0 and active > true returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, 
    "expl":"1", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dwf_scenario_empty with expl > 1 and active > true returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_dwf_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, 
    "expl":"2", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dwf_scenario_empty with expl > 2 and active > true returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;