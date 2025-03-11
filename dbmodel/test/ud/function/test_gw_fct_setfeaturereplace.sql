/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- Plan for 1 test
SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_setfeaturereplace($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{"type":"arc"},
    "data":{"filterFields":{}, "pageInfo":{}, "old_feature_id":"154", "feature_type_new":"WACCEL", "featurecat_id":"WACCEL-CC020",
    "workcat_id_end":"work1", "enddate":"2024-08-27", "keep_elements":"False", "keep_epa_values":"True", "keep_asset_id":"True"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setfeaturereplace returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
