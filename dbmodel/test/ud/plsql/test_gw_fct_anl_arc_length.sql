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
SELECT is (
    (gw_fct_anl_arc_length($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
    "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[132,133]},
    "data":{"selectionMode":"previousSelection","parameters":{"arcLength":"3"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_length -> previousSelection returns status "Accepted"'
);


SELECT is (
    (gw_fct_anl_arc_length($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},
    "feature":{"tableName":"v_edit_arc", "featureType":"ARC", "id":[]},
    "data":{"selectionMode":"wholeSelection","parameters":{"arcLength":"3"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_anl_arc_length -> wholeSelection returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;
