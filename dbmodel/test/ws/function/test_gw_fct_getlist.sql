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

-- Plan for 8 test
SELECT plan(8);

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
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{},
    "data":{"tableName":"tbl_inp_dscenario_junction", "filterFields":{"node_id":{"value":"1071","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tabName":"epa" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{},
    "data":{"tableName":"tbl_element_x_node", "filterFields":{"node_id":{"value":"1071","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tabName":"elements" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{},
    "data":{"tableName":"tbl_event_x_node", "filterFields":{"node_id":{"value":"1071","filterSign":"="},
    "parameter_type":{"value":"INCIDENCE","filterSign":"ILIKE"}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tabName":"tab_event" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{},
    "data":{"tableName":"tbl_doc_x_node", "filterFields":{"node_id":{"value":"1071","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tabName":"documents" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"tableName":"v_ui_plan_netscenario", "filterFields":{"limit": -1, "name": {"filterSign":"ILIKE", "value":""}, "active": {"filterSign":"=", "value":"true"}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"v_ui_plan_netscenario" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"tableName":"ve_cat_dscenario", "filterFields":{"limit": -1, "name": {"filterSign":"ILIKE", "value":""}, "active": {"filterSign":"=", "value":"true"}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"ve_cat_dscenario" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"tableName":"v_ui_workspace", "filterFields":{"limit": -1, "name": {"filterSign":"ILIKE", "value":""}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"v_ui_workspace" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"tableName":"v_ui_rpt_cat_result", "filterFields":{"limit": -1, "result_id": {"filterSign":"ILIKE", "value":"1"}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"v_ui_rpt_cat_result" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;