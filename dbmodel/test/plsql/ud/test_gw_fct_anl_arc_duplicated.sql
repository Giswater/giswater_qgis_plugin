/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 2 test
SELECT plan(2);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "form":{},"feature":{"tableName":"v_edit_arc", "id":[]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"wholeSelection", "parameters":{"checkType":"finalNodes"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated -> wholeSelection returns status "Accepted"'
);

SELECT is(
    (gw_fct_anl_arc_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "form":{},"feature":{"tableName":"v_edit_arc", "id":[132,133]}, "data":{"filterFields":{}, "pageInfo":{},
    "selectionMode":"previousSelection", "parameters":{"checkType":"finalNodes"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_duplicated -> previousSelection returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
