/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- Function: SCHEMA_NAME.gw_api_setlot(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_setlot(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setlot(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--new call
SELECT SCHEMA_NAME.gw_api_setlot($${
"client":{"device":3,"infoType":100,"lang":"es"},
"feature":{"featureType":"lot", "tableName":"om_visit_lot", "idName":"id", "id":"1"},
"form":{},
"data":{"fields":{}}}$$)
*/

DECLARE


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
		
	RETURN gw_fct_setlot(p_data);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_setlot(json) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_setlot(json) TO role_basic;

