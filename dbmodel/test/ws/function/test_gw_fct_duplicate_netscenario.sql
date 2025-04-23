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

SELECT plan(2);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_duplicate_netscenario($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "name":"netscenario",
    "descript":null, "parent":null, "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_netscenario with active : true returns status "Accepted"'
);

SELECT is(
    (gw_fct_duplicate_netscenario($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "name":"netscenario",
    "descript":null, "parent":null, "active":"false"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_netscenario with active : false returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
