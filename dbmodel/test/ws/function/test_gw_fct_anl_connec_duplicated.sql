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

SELECT plan(4);

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
