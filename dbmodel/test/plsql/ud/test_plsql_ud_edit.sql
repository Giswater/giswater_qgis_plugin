/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- gw_fct_setarcfusion


-- gw_fct_setarcdivide


-- gw_fct_setlinktonetwork
SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["10117","10118"]},"data":{"feature_type":"CONNEC", "forcedArcs":["2001","2002"]}}$$);

SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["30012"]},"data":{"feature_type":"CONNEC"}}$$);

SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["30014"]},"data":{"feature_type":"GULLY"}}$$);
