/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

-- Suppress NOTICE messages
SET client_min_messages TO WARNING;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(2);

-- Extract and test the "status" field from the function's JSON response when is called from go2epa
SELECT is(
    (gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"z1","fid":227}}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_pg2epa_check_network returns status "Accepted" when is called from go2epa'
);

-- Extract and test the "status" field from the function's JSON response when is called from toolbox
SELECT is(
    (gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"test_20201016"}}}')::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_pg2epa_check_network returns status "Accepted" when is called from toolbox'
);

-- Finish the test
SELECT finish();

ROLLBACK;


