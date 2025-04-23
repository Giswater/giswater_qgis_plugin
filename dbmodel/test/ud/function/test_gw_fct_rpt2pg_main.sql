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

INSERT INTO rpt_cat_result (result_id) VALUES('-901');

-- Extract and test the "status" field from the function's JSON response
SELECT is(
    (gw_fct_rpt2pg_main($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "step":1, "resultId":"-901"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_rpt2pg_main -> step1 returns status "Accepted"'
);

SELECT is(
    (gw_fct_rpt2pg_main($${"client":{"device":4, "lang":"", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "step":2, "resultId":"-901"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_rpt2pg_main -> setp2 returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;
