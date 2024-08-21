/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 7 test
SELECT plan(7);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"", "tabName":"epa",
    "widgetname":"tab_epa_tbl_inp_junction", "formtype":"form_feature"}, "feature":{"tableName":"tbl_inp_dscenario_junction",
    "idName":"node_id", "id":"74"}, "data":{"filterFields":{"node_id":{"value":"74","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"tbl_inp_dscenario_junction" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"", "tabName":"connections",
    "widgetname":"tab_connections_tbl_downstream", "formtype":"form_feature"}, "feature":{"tableName":"tbl_connection_downstream",
    "idName":"node_id", "id":"74"}, "data":{"filterFields":{"node_id":{"value":"74","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"tbl_connection_downstream" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"", "tabName":"elements",
    "widgetname":"tab_elements_tbl_elements", "formtype":"form_feature"}, "feature":{"tableName":"tbl_element_x_node",
    "idName":"node_id", "id":"74"}, "data":{"filterFields":{"node_id":{"value":"74","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"tbl_element_x_node" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"", "tabName":"event",
    "widgetname":"tab_event_tbl_event_cf", "formtype":"form_feature"}, "feature":{"tableName":"tbl_event_x_node", "idName":"node_id",
    "id":"74"}, "data":{"filterFields":{"node_id":{"value":"74","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"tbl_event_x_node" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"", "tabName":"documents",
    "widgetname":"tab_documents_tbl_documents", "formtype":"form_feature"}, "feature":{"tableName":"tbl_doc_x_node", "idName":"node_id",
    "id":"74"}, "data":{"filterFields":{"node_id":{"value":"74","filterSign":"="}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"tbl_doc_x_node" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_cat_hydrology"}, "data":{"filterFields":{"limit": -1, "name":
    {"filterSign":"ILIKE", "value":""}, "active": {"filterSign":"=", "value":"true"}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"v_edit_cat_hydrology" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"tableName":"cat_work"},
    "data":{"filterFields":{"limit": -1, "id": {"filterSign":"ILIKE", "value":""}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"cat_work" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getlist($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_ui_rpt_cat_result"},
    "data":{"filterFields":{"limit": -1, "result_id": {"filterSign":"ILIKE", "value":"1"}}, "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getlist --> "tableName":"v_ui_rpt_cat_result" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;