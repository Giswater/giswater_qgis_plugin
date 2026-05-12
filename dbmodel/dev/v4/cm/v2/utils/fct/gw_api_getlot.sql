/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- Function: SCHEMA_NAME.gw_api_getlot(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_getlot(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getlot(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- calling form
SELECT SCHEMA_NAME.gw_api_getlot($${"client":{"device":3,"infoType":100,"lang":"es"}, "feature":{"tableName":"om_visit_lot", "idName":"id", "id":"1"}}$$)
*/

DECLARE


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
		
	RETURN gw_fct_getlot(p_data);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_getlot(json) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_getlot(json) TO role_basic;

