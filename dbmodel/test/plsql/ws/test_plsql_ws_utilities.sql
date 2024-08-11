/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- gw_fct_anl_arc_duplicated
SELECT gw_fct_anl_arc_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"tableName":"v_edit_arc", "id":[]}, "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{"checkType":"finalNodes"}}}$$)::JSON

SELECT gw_fct_anl_arc_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"tableName":"v_edit_arc", "id":[2001,2002]}, "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection",
"parameters":{"checkType":"finalNodes"}}}$$)::JSON

-- gw_fct_anl_arc_length
SELECT gw_fct_anl_arc_length($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},"feature":{"tableName":"v_edit_arc", 
"featureType":"ARC", "id":[2001,2002]}, "data":{"selectionMode":"previousSelection","parameters":{"arcLength":"3"}}}$$)::JSON

SELECT gw_fct_anl_arc_length($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{"tableName":"v_edit_arc", 
"featureType":"ARC", "id":[]}, "data":{"selectionMode":"wholeSelection","parameters":{"arcLength":"3"}}}$$)::JSON

-- gw_fct_anl_arc_no_startend_node
SELECT ws36012.gw_fct_anl_arc_no_startend_node($${"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{"tableName":"v_edit_arc", 
"featureType":"ARC"}, "data":{"parameters":{"arcSearchNodes":"0.1"}}}$$)::text

-- gw_fct_anl_arc_same_startend
SELECT gw_fct_anl_arc_same_startend($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_arc", "id":[2001,2002]}, "data":{"selectionMode":"previousSelection","parameters":{}}}$$);

SELECT gw_fct_anl_arc_same_startend($${"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"tableName":"v_edit_arc"}, "data":{"selectionMode":"wholeSelection","parameters":{}}}$$);

-- gw_fct_anl_connec_duplicated
SELECT gw_fct_anl_connec_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"tableName":"v_edit_connec"}, 
"data":{"selectionMode":"wholeSelection", "parameters":{"connecTolerance":10}, "parameters":{}}}$$);

SELECT gw_fct_anl_connec_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"tableName":"v_edit_connec", 
"id":[3101, 3102]}, "data":{"selectionMode":"previousSelection", "parameters":{"connecTolerance":10}, "parameters":{}}}$$);