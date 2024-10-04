/*
This file is part of Giswater 3
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
    (gw_fct_create_dscenario_from_crm($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":null, "descript":null, "exploitation":"0",
    "period":"5", "pattern":"1", "demandUnits":"LPS"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_crm with exploitation 0 returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_from_crm($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":null, "descript":null, "exploitation":"1",
    "period":"5", "pattern":"1", "demandUnits":"LPS"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_crm with exploitation 1 returns status "Accepted"'
);

SELECT is(
    (gw_fct_create_dscenario_from_crm($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831}, "form":{},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":null, "descript":null, "exploitation":"2",
    "period":"5", "pattern":"1", "demandUnits":"LPS"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_create_dscenario_from_crm with exploitation 2 returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
