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

SELECT plan(3);

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
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_node_t"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419209.60503196524, "y1":4576503.357122214}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_connec_greentap"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":418890.368, "y1":4576699.522}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

-- TODO: Add test for gw_fct_getfeatureinsert ve_arc_pipe
-- SELECT is (
--     (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
--     "feature":{"tableName":"ve_arc_pipe"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
--     "coordinates":{"x1":419148.4628078682, "y1":4576733.636729475, "x2":419159.9655259207,
--     "y2":4576733.757810717}}}$$)::JSON)->>'status',
--     'Accepted',
--     'Check if gw_fct_getfeatureinsert returns status "Accepted"'
-- );

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_link"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419148.4628078682, "y1":4576733.636729475, "x2":419159.9655259207,
    "y2":4576733.757810717}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
