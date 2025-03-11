/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 2 test
SELECT plan(8);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_anl_arc_duplicated($${"client": {"device": 4, "infoType": 1, "lang": "ES"},
    "form": {}, "feature": {"tableName": "v_edit_arc", "id": []}, "data": { "filterFields": {}, "pageInfo": {},
    "selectionMode": "wholeSelection", "parameters": {"checkType": "finalNodes"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated -> wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client": {"device": 4, "infoType": 1, "lang": "ES"},
    "form": {}, "feature": {"tableName": "v_edit_arc", "id": [2001, 2002]}, "data": {"filterFields": {}, "pageInfo": {},
    "selectionMode": "previousSelection","parameters": {"checkType": "finalNodes"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated -> previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]},
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with aux_params, tableName : v_edit_arc, and checkType : finalNodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with aux_params, tableName : v_edit_inp_pipe, and checkType : finalNodes status returns "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{"checkType":"finalNodes"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with aux_params, tableName : v_edit_inp_virtualpump, and checkType : finalNodes returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with aux_params, tableName : v_edit_arc, and checkType : geometry returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with aux_params, tableName : v_edit_inp_pipe, and checkType : geometry status returns "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"checkType":"geometry"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated with aux_params, tableName : v_edit_inp_virtualpump, and checkType : geometry returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;
