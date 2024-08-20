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
SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setchangefeaturetype($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"type":"node"}, "data":{"filterFields":{}, "pageInfo":{}, "feature_id":"100029", "feature_type_new":"JUMP",
    "featurecat_id":"CHAMBER-01"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setchangefeaturetype returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;