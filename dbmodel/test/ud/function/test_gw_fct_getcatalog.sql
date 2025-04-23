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
    "tabName":"data", "editable":"TRUE"}, "feature":{"feature_type":"CONDUIT"}, "data":{"filterFields":{}, "pageInfo":{},
    "fields":{"matcat_id":"", "shape":"", "geom1":""}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getcatalog --> "feature_type":"CONDUIT" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getcatalog($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"upsert_catalog_node",
    "tabName":"data", "editable":"TRUE"}, "feature":{"feature_type":"CIRC_MANHOLE"}, "data":{"filterFields":{}, "pageInfo":{},
    "fields":{"matcat_id":"", "shape":"", "geom1":""}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getcatalog --> "feature_type":"CIRC_MANHOLE" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;