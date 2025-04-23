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

SELECT plan(14);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"allValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_node and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_junction", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"allValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_junction and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_netgully", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"allValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_netgully and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_outfall", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"allValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_outfall and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_storage", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"allValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_storage and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_node and updateValues > nullValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_junction", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_junction and updateValues > nullValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_netgully", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_netgully and updateValues > nullValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_outfall", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_outfall and updateValues > nullValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_storage", "featureType":"NODE", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > NODE and tablename > v_edit_inp_storage and updateValues > nullValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_gully", "featureType":"GULLY", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > GULLY and tablename > v_edit_gully and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_gully", "featureType":"GULLY", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > GULLY and tablename > v_edit_gully and updateValues > nullValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_gully", "featureType":"GULLY", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > GULLY and tablename > v_edit_inp_gully and updateValues > allValues returns status "Accepted"'
);

SELECT is (
    (gw_fct_setelevfromdem($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_gully", "featureType":"GULLY", "id":[]}, 
    "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
    "parameters":{"updateValues":"nullValues"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setelevfromdem with featuretype > GULLY and tablename > v_edit_inp_gully and updateValues > nullValues returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;