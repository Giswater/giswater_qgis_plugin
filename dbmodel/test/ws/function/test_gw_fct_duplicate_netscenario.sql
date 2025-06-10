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

INSERT INTO plan_netscenario (netscenario_id, "name", descript, parent_id, netscenario_type, active, expl_id, log)
VALUES(1, 'netscenario1', 'netscenario1', NULL, 'DMA', true, NULL, NULL);

INSERT INTO plan_netscenario (netscenario_id, "name", descript, parent_id, netscenario_type, active, expl_id, log)
VALUES(2, 'netscenario2', 'netscenario2', NULL, 'PRESSZONE', true, NULL, NULL);

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_duplicate_netscenario($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"1", "name":"netscenario-copied-1",
    "descript":"descript-copied-1", "parent":"1", "active":"true"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_netscenario with active : true returns status "Accepted"'
);

SELECT is(
    (gw_fct_duplicate_netscenario($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":25831},
    "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"copyFrom":"2", "name":"netscenario-copied-2",
    "descript":"descript-copied-2", "parent":"2", "active":"false"}, "aux_params":null}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_duplicate_netscenario with active : false returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
