/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- Function: SCHEMA_NAME.gw_api_setvehicleload(json)

-- DROP FUNCTION SCHEMA_NAME.gw_api_setvehicleload(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setvehicleload(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_api_setvehicleload($${"client":{"device":3,"infoType":0,"lang":"es"},"form":{},"feature":{},"data":{"fields":{"vehicle_id":"2","load":"1234","hash":"5de7a2e92995b7455a7fe3c7","photo_url":"https:\/\/bmaps.bgeo.es\/dev\/demo\/external.image.php?img="},"deviceTrace":{"xcoord":null,"ycoord":null,"compass":null},"pageInfo":null}}$$) AS result

*/

DECLARE
	

BEGIN

   	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
		
	RETURN gw_fct_setvehicleload(p_data);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_setvehicleload(json) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_api_setvehicleload(json) TO role_basic;
