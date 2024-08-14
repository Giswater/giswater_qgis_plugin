/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(2);

SELECT is (
    (gw_fct_graphanalytics_downstream($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "feature":{"id":["20607"]},"data":{}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_downstream returns status "Accepted"'
)

SELECT is (
    (SELECT gw_fct_graphanalytics_downstream($${"client":{"device":4, "infoType":1, "lang":"ES"},
    "feature":{},"data":{ "coordinates":{"xcoord":419277.7306855297,"ycoord":4576625.674511955,
    "zoomRatio":3565.9967217571534}}}$$)::JSON)->>'status',
    'Accepted',
    'Check if gw_fct_graphanalytics_downstream with coordinates returns status "Accepted"'
)

-- Finish the test
SELECT finish();

ROLLBACK;
