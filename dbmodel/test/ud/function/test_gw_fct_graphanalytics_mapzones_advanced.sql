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

SELECT plan(12);

-- Create roles for testing
CREATE USER plan_user;
GRANT role_plan to plan_user;

CREATE USER epa_user;
GRANT role_epa to epa_user;

CREATE USER edit_user;
GRANT role_edit to edit_user;

CREATE USER om_user;
GRANT role_om to om_user;

CREATE USER basic_user;
GRANT role_basic to basic_user;

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"graphClass":"DRAINZONE", "exploitation":"1", "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, 
    "usePlanPsector":"false", "commitChanges":"false", "valueForDisconnected":null, "updateMapZone":"0", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 1 and updateMapZone > 0 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
    "parameters":{"graphClass":"DRAINZONE", "exploitation":"1", "floodOnlyMapzone":null, 
    "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"1", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 1 and updateMapZone > 1 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"1", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"2", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 1 and updateMapZone > 2 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"1", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"6", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 1 and updateMapZone > 6 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"2", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"0", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 2 and updateMapZone > 0 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"2", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"1", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 2 and updateMapZone > 1 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"2", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"2", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 2 and updateMapZone > 2 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"2", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"6", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 2 and updateMapZone > 6 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"0", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"0", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 0 and updateMapZone > 0 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"0", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"1", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 0 and updateMapZone > 1 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"0", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"2", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 0 and updateMapZone > 2 returns status "Accepted"'
);

SELECT is(
    (gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, "form":{}, 
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"DRAINZONE", "exploitation":"0", 
    "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "commitChanges":"false", 
    "valueForDisconnected":null, "updateMapZone":"6", "geomParamUpdate":null}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_mapzones_advanced with exploitation > 0 and updateMapZone > 6 returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
