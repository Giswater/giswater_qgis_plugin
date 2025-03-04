/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- Function: SCHEMA_NAME.gw_api_getvisitmanager(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_getvisitmanager(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getvisitmanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- calling button from feature
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3,"infoType":100,"lang":"es"},
"form":{},
"data":{"relatedFeature":{"type":"arc", "idName":"arc_id", "id":"2074"},"fields":{},"pageInfo":null}}$$)


-- calling without previous info
--new call
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3,"infoType":100,"lang":"es"},
"form":{},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_api_getvisitmanager($${"client":{"device":3,"infoType":100,"lang":"es"},
     "feature":{"featureType":"visit","tableName":"v_visit_lot_user","idName":"user_id","id":"xtorret"},"form":{"tabData":{"active":false},"tabLots":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
       "data":{"relatedFeature":{"type":"arc", "id":"2079"},"fields":{"user_id":"xtorret","date":"2019-01-28","team_id":"1","vehicle_id":"3"},"pageInfo":null}}$$) AS result


-- change from tab data to tab files (upserting data on tabData)
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3,"infoType":100,"lang":"es"},
"feature":{"featureType":"visit","tableName":"v_visit_lot_user","idName":"user_id","id":"xtorret"},
"form":{"tabData":{"active":false}, "tabLots":{"active":true},"navigation":{"currentActiveTab":"tabData"}},
"data":{"fields":{"user_id":"xtorret","team_id":1,"vehicle_id":1,"date":"2019-01-01"}}}$$)

--tab activelots
SELECT SCHEMA_NAME.gw_api_getvisitmanager($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},
"form":{"tabData":{"active":false}, "tabLots":{"active":true}}, "navigation":{"currentActiveTab":"tabLots"}, 
"data":{"filterFields":{"limit":10},
	"pageInfo":{"currentPage":1}
	}}$$)

*/

DECLARE



BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
		
	RETURN gw_fct_getvisitmanager(p_data);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_getvisitmanager(json) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_getvisitmanager(json) TO role_basic;

