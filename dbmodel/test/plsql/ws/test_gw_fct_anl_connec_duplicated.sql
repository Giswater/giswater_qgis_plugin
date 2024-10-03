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
    (gw_fct_anl_connec_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"tableName":"v_edit_connec"},
    "data":{"selectionMode":"wholeSelection", "parameters":{"connecTolerance":10}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_connec_duplicated -> wholeSelection returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_connec_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"tableName":"v_edit_connec",
    "id":[3101, 3102]}, "data":{"selectionMode":"previousSelection", "parameters":{"connecTolerance":10}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_connec_duplicated -> previousSelection returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_connec_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_connec", "featureType":"CONNEC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{"connecTolerance":"0.01"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_connec_duplicated with aux_params and tableName : v_edit_connec returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_connec_duplicated($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_inp_connec", "featureType":"CONNEC", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{"connecTolerance":"0.01"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_connec_duplicated with aux_params and tableName : v_edit_inp_connec returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;
