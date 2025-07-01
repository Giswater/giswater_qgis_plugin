/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- Function: SCHEMA_NAME.gw_api_setvisitmanager(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_setvisitmanager(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setvisitmanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

--ONLY UPDATE ARE POSSIBLE. 
SELECT "SCHEMA_NAME".gw_api_setvisitmanager($${"client":{"device":3, "infoType":100, "lang":"ES"}, 
"feature":{"featureType":"visit", "tableName":"ve_visit_user_manager", "idName":"id"}, 
"data":{"fields":{"user_id":"geoadmin", "team_id":"4", "lot_id":"1"},
"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)
*/

DECLARE

	

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
		
	RETURN gw_fct_setvisitmanager(p_data);
      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_setvisitmanager(json) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_setvisitmanager(json) TO role_basic;
