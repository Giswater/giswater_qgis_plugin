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

SELECT plan(6);

SELECT is(
    (gw_fct_setcheckdatabase($${"client":{"device":4, "lang":"es_ES", "version":"4.0.002", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"tab_data_om_check": true}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcheckdatabase (tab_data_om_check) returns status "Accepted"'
);

SELECT is(
    (gw_fct_setcheckdatabase($${"client":{"device":4, "lang":"es_ES", "version":"4.0.002", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"tab_data_graph_check": true}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcheckdatabase (tab_data_graph_check) returns status "Accepted"'
);

SELECT is(
    (gw_fct_setcheckdatabase($${"client":{"device":4, "lang":"es_ES", "version":"4.0.002", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"tab_data_epa_check": true}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcheckdatabase (tab_data_epa_check) returns status "Accepted"'
);

SELECT is(
    (gw_fct_setcheckdatabase($${"client":{"device":4, "lang":"es_ES", "version":"4.0.002", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"tab_data_plan_check": true}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcheckdatabase (tab_data_plan_check) returns status "Accepted"'
);

SELECT is(
    (gw_fct_setcheckdatabase($${"client":{"device":4, "lang":"es_ES", "version":"4.0.002", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"tab_data_admin_check": true}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcheckdatabase (tab_data_admin_check) returns status "Accepted"'
);

SELECT is(
    (gw_fct_setcheckdatabase($${"client":{"device":4, "lang":"es_ES", "version":"4.0.002", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"tab_data_verified_exceptions": true, "tab_data_om_check": true, "tab_data_graph_check": true, "tab_data_epa_check": true, "tab_data_plan_check": true, "tab_data_admin_check": true}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setcheckdatabase (all tabs) returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;