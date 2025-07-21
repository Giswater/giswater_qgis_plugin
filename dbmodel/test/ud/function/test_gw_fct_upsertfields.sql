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

-- Plan for 2 test
SELECT plan(2);

-- Create roles for testing
CREATE USER plan_user;
GRANT role_plan to plan_user;

CREATE USER epa_user;
GRANT role_epa to epa_user;

CREATE USER edit_user;
GRANT role_edit to edit_user;

CREATE USER om_user;
GRANT role_om to om_user;

CREATE USER basic_user;
GRANT role_basic to basic_user;

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_upsertfields($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"id":"1",
    "tableName":"v_edit_cat_hydrology"},"data":{"filterFields":{}, "pageInfo":{}, "fields":{"infiltration": "GREEN_AMPT"}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_upsertfields --> "tableName":"v_edit_cat_hydrology" returns status "Accepted"'
);

SELECT is (
    (gw_fct_upsertfields($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{"id":"1",
    "tableName":"v_edit_drainzone"}, "data":{"filterFields":{}, "pageInfo":{}, "fields":{"drainzone_id": "1",
    "expl_id": "{0}", "name": "2"}, "force_action":"UPDATE"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_upsertfields --> "tableName":"v_edit_drainzone" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;