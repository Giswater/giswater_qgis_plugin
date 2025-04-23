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

-- Plan for 1 test
SELECT plan(1);

-- Extract and test the "status" field from the function's JSON response
SELECT is (
    (gw_fct_setprofile($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":25831}, "form":{}, "feature":{},
    "data":{"filterFields":{}, "pageInfo":{}, "profile_id":"12", "listArcs":"[159]","initNode":"64", "endNode":"37",
    "linksDistance":1, "scale":{ "eh":1000, "ev":1000}, "title":"null", "date":"16/08/2024"}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_setprofile returns status "Accepted"'
);

-- Finish the test
SELECT finish();

ROLLBACK;