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
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_node", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_node and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_junction", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_junction and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_pump", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_pump and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_reservoir", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_reservoir and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_shortpipe", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_shortpipe and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_tank", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_tank and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_valve", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_valve and selectionMode : wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_node", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_node and selectionMode : previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_junction", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_junction and selectionMode : previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_pump", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_pump and selectionMode : previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_reservoir", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_reservoir and selectionMode : previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_shortpipe", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_shortpipe and selectionMode : previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_tank", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_tank and selectionMode : previousSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_node_orphan($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_inp_valve", "featureType":"NODE", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection","parameters":{}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_node_orphan --> tableName : ve_inp_valve and selectionMode : previousSelection returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
