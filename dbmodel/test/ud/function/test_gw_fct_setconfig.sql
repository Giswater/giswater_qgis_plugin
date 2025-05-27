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
    (gw_fct_setconfig($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"epaoptions"},
    "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "fields":[]}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setconfig --> "formName":"epaoptions" returns status "Accepted"'
);

SELECT is (
    (gw_fct_setconfig($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{"formName":"config"}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "fields":[{"widget_type": "combo", "widget": "basic_search_exploitation_vdefault",
    "value": "2", "isChecked": "True", "chk": "chk_basic_search_exploitation_vdefault"}]}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setconfig --> "formName":"config" returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;