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
    (gw_fct_getinfoplan($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"tabName":"tab_plan"},
    "feature":{"featureType":"arc", "tableName":"ve_arc_conduit", "idName":"arc_id", "id":"157"}, "data":{"filterFields":{},
    "pageInfo":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getinfoplan returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
