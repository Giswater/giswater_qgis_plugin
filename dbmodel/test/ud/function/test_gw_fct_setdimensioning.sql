/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setdimensioning($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"tableName":"v_edit_dimensions", "id":"6"}, "data":{"filterFields":{}, "pageInfo":{},
    "fields":{"x_symbol":"1", "distance":"1", "direction_arrow":"False","state":"1","expl_id":"2","feature_type":"ARC"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setdimensioning returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;