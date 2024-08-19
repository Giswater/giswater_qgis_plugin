/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(5);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_node", "id":"89"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_connec", "id":"3149"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_gully", "id":"30087"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_arc", "id":"204"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid returns status "Accepted"'
);

SELECT is(
    (gw_fct_getinfofromid($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_link", "id":"550"}, "data":{"filterFields":{}, "pageInfo":{}, "addSchema":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfofromid returns status "Accepted"'
);
-- Finish the test
SELECT finish();

ROLLBACK;
