/*
This file is part of Giswater
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
    "feature":{"id":"132", "tableName":"ve_arc_pipe", "featureType":"arc" }, "data":{"filterFields":{},
    "pageInfo":{}, "fields":{"code": "134"}, "reload":"", "afterInsert":"False"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setfields --> "tableName":"ve_arc_pipe" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setfields($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{},
    "feature":{"id":"PUMP_01", "tableName":"v_edit_inp_curve" }, "data":{"filterFields":{}, "pageInfo":{},
    "fields":{"curve_type": "PUMP", "descript": "null", "expl_id": null}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setfields --> "tableName":"v_edit_inp_curve" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
