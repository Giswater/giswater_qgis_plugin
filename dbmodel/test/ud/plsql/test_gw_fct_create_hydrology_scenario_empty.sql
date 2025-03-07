/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(12);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"CURVE_NUMBER", 
    "text":null, "expl":"0", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > CURVE_NUMBER and expl > 0 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"CURVE_NUMBER", 
    "text":null, "expl":"1", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > CURVE_NUMBER and expl > 1 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"CURVE_NUMBER", 
    "text":null, "expl":"2", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > CURVE_NUMBER and expl > 2 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"GREEN_AMPT", 
    "text":null, "expl":"0", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > GREEN_AMPT and expl > 0 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"GREEN_AMPT", 
    "text":null, "expl":"1", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > GREEN_AMPT and expl > 1 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"GREEN_AMPT", 
    "text":null, "expl":"2", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > GREEN_AMPT and expl > 2 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"HORTON", 
    "text":null, "expl":"0", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > HORTON and expl > 0 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"HORTON", 
    "text":null, "expl":"1", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > HORTON and expl > 1 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"HORTON", 
    "text":null, "expl":"2", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > HORTON and expl > 2 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"MODIFIED_HORTON", 
    "text":null, "expl":"0", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > MODIFIED_HORTON and expl > 0 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"MODIFIED_HORTON", 
    "text":null, "expl":"1", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > MODIFIED_HORTON and expl > 1 returns status "Accepted"'
);

SELECT is (
    (gw_fct_create_hydrology_scenario_empty($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"test", "infiltration":"MODIFIED_HORTON", 
    "text":null, "expl":"2", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_hydrology_scenario_empty with infiltration > MODIFIED_HORTON and expl > 2 returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;
