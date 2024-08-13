/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
BEGIN;

SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT plan(1);
SELECT ok(1=1, 'One equals one');

-- TODO
-- gw_fct_setlinktonetwork
-- SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
-- "feature":{"id":["3201","3200"]},"data":{"feature_type":"CONNEC", "forcedArcs":["2001","2002"]}}$$);

-- SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
-- "feature":{"id":["100013"]},"data":{"feature_type":"CONNEC"}}$$);

-- SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
-- "feature":{"id":["100014"]},"data":{"feature_type":"GULLY"}}$$);



-- Finish the test
SELECT finish();

ROLLBACK;
