/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 4 test
SELECT plan(4);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_getselectors($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"currentTab":"tab_psector"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "filterText":"", "addSchema":"NULL"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getselectors --> "currentTab":"tab_psector" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getselectors($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"currentTab":"tab_dscenario"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "filterText":"", "addSchema":"NULL"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getselectors --> "currentTab":"tab_dscenario" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getselectors($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"currentTab":"None"}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "filterText":""}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getselectors --> "currentTab":"None" returns status "Accepted"'
);

SELECT is (
    (gw_fct_getselectors($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"selector_basic", "tabName":"tab_psector", "id":1, "isAlone":"False",
    "disableParent":"False", "value":"True"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getselectors --> "tabName":"tab_psector" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;