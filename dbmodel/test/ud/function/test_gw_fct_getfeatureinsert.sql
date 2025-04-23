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


-- Plan for 5 test
SELECT plan(5);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_node_jump"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419046.708686649, "y1":4576502.898385038}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert -> ve_node_jump returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_connec_connec"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419084.29857150157, "y1":4576491.071025222}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert -> ve_connec_connec returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_gully_gully"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419072.55354624306, "y1":4576497.782468226}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert -> ve_gully_gully returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"ve_arc_varc"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":419100.726, "y1":4576521.49, "x2":419063.514, "y2":4576505.57}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert -> ve_arc_varc returns status "Accepted"'
);

SELECT is (
    (gw_fct_getfeatureinsert($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_link"}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic",
    "coordinates":{"x1":418889.8779684811, "y1":4576511.2800332215, "x2":418914.19046890794,
    "y2":4576511.80856584}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getfeatureinsert -> v_edit_link returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
