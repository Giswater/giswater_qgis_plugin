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

SELECT plan(3);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_duplicate_dwf_scenario($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", 
    "idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, "expl":"0", 
    "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dwf_scenario with expl > 0 returns status "Accepted"'
);

SELECT is (
    (gw_fct_duplicate_dwf_scenario($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", 
    "idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, "expl":"1", 
    "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dwf_scenario with expl > 1 returns status "Accepted"'
);


SELECT is (
    (gw_fct_duplicate_dwf_scenario($${"client":{"device":4, "lang":"nl_NL", "infoType":1, "epsg":25831}, 
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", 
    "idval":"test", "startdate":"2024/10/07", "enddate":"2024/10/07", "observ":null, "expl":"2", 
    "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_dwf_scenario with expl > 2 returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;
