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

-- Plan for 9 test
SELECT plan(9);

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
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_node", "id":"89"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_node returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_connec", "id":"3149"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_connec returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_gully", "id":"30087"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_gully returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_arc", "id":"204"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_arc returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_link", "id":"550"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_link returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_drainzone", "id": "0"}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_drainzone with id returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_drainzone"}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_drainzone returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"inp_dscenario_outfall", "id": "1, 18888"},
    "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> inp_dscenario_outfall returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_cat_dscenario", "id":"1"}, "data":{"filterFields":{}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid tableName --> v_edit_cat_dscenario returns status "Accepted"'
);

-- Finish the test
SELECT * FROM finish();

ROLLBACK;
