/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(7);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_node returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_junction", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_inp_junction returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_pump", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_inp_pump returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_reservoir", "featureType":"NODE", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_inp_reservoir returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_shortpipe", "featureType":"NODE", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_inp_shortpipe returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_tank", "featureType":"NODE", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_inp_tank returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_tcandidate($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_valve", "featureType":"NODE", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_tcandidate --> tableName : v_edit_inp_valve returns status "Accepted"'
);
-- Finish the test
SELECT finish();

ROLLBACK;
