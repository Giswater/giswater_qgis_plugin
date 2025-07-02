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

SELECT is(
    (gw_fct_get_dialog($${"client": {"cur_user": "postgres", "device": 4, "lang": "es_ES", "infoType": 1, "epsg": "25831"},
    "form": {"formName": "generic", "formType": "link_to_connec"}, "feature": {}, "data": {"filterFields": {}, "pageInfo": {}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_get_dialog (link_to_connec) returns status "Accepted"'
);


-- Finish the test
SELECT finish();

ROLLBACK;