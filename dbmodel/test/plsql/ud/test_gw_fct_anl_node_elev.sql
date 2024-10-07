/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(5);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_anl_node_elev($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, 
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_elev with tablename > v_edit_node returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_node_elev($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_junction", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, 
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_elev with tablename > v_edit_inp_junction returns status "Accepted"'
);


SELECT is (
    (gw_fct_anl_node_elev($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_netgully", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, 
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_elev with tablename > v_edit_inp_netgully returns status "Accepted"'
);


SELECT is (
    (gw_fct_anl_node_elev($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_outfall", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, 
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_elev with tablename > v_edit_inp_outfall returns status "Accepted"'
);


SELECT is (
    (gw_fct_anl_node_elev($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{"tableName":"v_edit_inp_storage", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, 
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_elev with tablename > v_edit_inp_storage returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;