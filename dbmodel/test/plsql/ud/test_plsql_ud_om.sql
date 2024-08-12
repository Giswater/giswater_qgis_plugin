/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- gw_fct_graphanalytics_upstream
SELECT gw_fct_graphanalytics_upstream($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["20607"]},"data":{}}$$);
SELECT gw_fct_graphanalytics_upstream($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"coordinates":{"xcoord":419278.0533606678,"ycoord":4576625.482073168,"zoomRatio":437.2725774103561}}}$$)


-- gw_fct_graphanalytics_downstrea
SELECT SCHEMA_NAME.gw_fct_graphanalytics_downstream($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["20607"]},"data":{}}$$);
SELECT SCHEMA_NAME.gw_fct_graphanalytics_downstream($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{ "coordinates":{"xcoord":419277.7306855297,"ycoord":4576625.674511955, "zoomRatio":3565.9967217571534}}}$$)

