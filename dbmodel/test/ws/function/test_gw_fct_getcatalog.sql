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

-- Plan for 2 test
SELECT plan(2);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_getcatalog($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"upsert_catalog_arc",
    "tabName":"data", "editable":"TRUE"}, "feature":{"feature_type":"PIPE"}, "data":{"filterFields":{}, "pageInfo":{},
    "fields":{"matcat_id":"", "pnom":"", "dnom":""}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getcatalog returns status "Accepted"'
);

SELECT is (
    (gw_fct_getcatalog($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831},
    "form":{"formName":"new_workcat", "tabName":"data", "editable":"TRUE"}, "feature":{"tableName":"ve_node_shutoff_valve",
    "featureId":"1088", "feature_type":"SHUTOFF_VALVE"}, "data":{"filterFields":{}, "pageInfo":{},
    "coordinates":{"x1": 419179.4317495035, "y1": 4576762.208694622}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getcatalog with coordinates returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;