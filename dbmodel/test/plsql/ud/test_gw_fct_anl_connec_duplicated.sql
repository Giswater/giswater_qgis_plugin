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
SELECT is (
    (gw_fct_anl_connec_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "feature":{"tableName":"v_edit_connec"}, "data":{"selectionMode":"wholeSelection",
    "parameters":{"connecTolerance":10}, "parameters":{}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_connec_duplicated -> wholeSelection returns status "Accepted"'
);

SELECT is (
    (gw_fct_anl_connec_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "feature":{"tableName":"v_edit_connec", "id":[3101, 3102]}, "data":{"selectionMode":"previousSelection",
    "parameters":{"connecTolerance":10}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_connec_duplicated -> previousSelection returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;
