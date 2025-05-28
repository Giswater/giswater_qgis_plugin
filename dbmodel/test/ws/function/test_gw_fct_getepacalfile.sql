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

SELECT plan(1);

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
SELECT is(
    (gw_fct_getepacalfile($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831},
"data":{"type":"pressure", "resultType":"dint", "resultValue":0.22, "inputFile":"file_name", "outputFile":"out_file_name", "dscenarioId":"2", "resultId":"test1", "nodeId":"1001", "pressure":"34", "duration":"3600", "Accuaracy":"1", "trials":"30"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_getepacalfile returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;

