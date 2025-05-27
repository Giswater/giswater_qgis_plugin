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

-- Plan for 11 test
SELECT plan(11);

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

SET role basic_user;

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Failed',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_arc returns status "Failed" for basic user'
);

SET role om_user;

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_arc returns status "Accepted" for om user'
);

SET role edit_user;

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_arc returns status "Accepted" for edit user'
);

SET role epa_user;

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_arc returns status "Accepted" for epa user'
);

SET role plan_user;

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_arc returns status "Accepted" for plan user'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_conduit", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_inp_conduit returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_orifice", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_inp_orifice returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_outlet", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_inp_outlet returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_pump", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_inp_pump returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_virtual", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_inp_virtual returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831},
    "form":{}, "feature":{"tableName":"v_edit_inp_weir", "featureType":"ARC", "id":[]}, "data":{"filterFields":{},
    "pageInfo":{}, "selectionMode":"wholeSelection","parameters":{"arcSearchNodes":"0.5"},
    "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_no_startend_node with tablename > v_edit_inp_weir returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
