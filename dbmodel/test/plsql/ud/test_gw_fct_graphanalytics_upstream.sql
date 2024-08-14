/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(2);

SELECT is (
    (gw_fct_graphanalytics_upstream($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "feature":{"id":["20607"]},"data":{}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_upstream returns status "Accepted"'
)

SELECT is (
    (gw_fct_graphanalytics_upstream($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "feature":{},"data":{"coordinates":{"xcoord":419278.0533606678,"ycoord":4576625.482073168,
    "zoomRatio":437.2725774103561}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_upstream with coordinates returns status "Accepted"'
)

-- Finish the test
SELECT finish();

ROLLBACK;
