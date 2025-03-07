/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 2 test
SELECT plan(2);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_setfields($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"id":"100019", "tableName":"ve_node_jump", "featureType":"node" },
    "data":{"filterFields":{}, "pageInfo":{}, "fields":{"nodecat_id": "JUMP-01",
    "workcat_id": "work2"}, "reload":"", "afterInsert":"False"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setfields --> "tableName":"ve_node_jump" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setfields($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"id":"T10-5m", "tableName":"v_edit_inp_timeseries" }, "data":{"filterFields":{}, "pageInfo":{},
    "fields":{"expl_id": 1, "timser_type": "Rainfall", "times_type": "RELATIVE", "descript":
    "null", "fname": "null"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setfields --> "tableName":"v_edit_inp_timeseries" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
