/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(3);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_manage_dscenario_values($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"1",
    "action":"DELETE-COPY", "copyFrom":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_manage_dscenario_values --> action : DELETE-COPY returns status "Accepted"'
);

SELECT is(
    (gw_fct_manage_dscenario_values($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"1",
    "action":"KEEP-COPY", "copyFrom":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_manage_dscenario_values --> action : KEEP-COPY returns status "Accepted"'
);

SELECT is(
    (gw_fct_manage_dscenario_values($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"target":"1",
    "action":"DELETE-ONLY", "copyFrom":"1"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_manage_dscenario_values --> action : DELETE-ONLY returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
