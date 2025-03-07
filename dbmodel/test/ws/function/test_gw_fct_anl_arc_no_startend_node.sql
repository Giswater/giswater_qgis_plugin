/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(4);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{"tableName":"v_edit_arc",
    "featureType":"ARC"}, "data":{"parameters":{"arcSearchNodes":"0.1"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with aux_params and tableName : v_edit_arc returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_pipe", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with aux_params and tableName : v_edit_inp_pipe returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_virtualpump", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with aux_params and tableName : v_edit_inp_virtualpump returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
