/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 5 test
SELECT plan(5);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_node_netinit"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419152.47163126303, "y1":4576500.64140685}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_connec_connec"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419142.6486930272, "y1":4576490.66726112}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_gully_gully"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419140.5345625553, "y1":4576523.964816052}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_arc_varc"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":418889.8779684811, "y1":4576511.2800332215,
    "x2":418914.19046890794, "y2":4576511.80856584}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_link"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":418889.8779684811, "y1":4576511.2800332215, "x2":418914.19046890794,
    "y2":4576511.80856584}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
