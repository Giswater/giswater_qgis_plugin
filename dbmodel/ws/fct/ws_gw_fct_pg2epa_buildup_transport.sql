/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2800

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_buildup_transport(p_result text)
RETURNS integer 
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"resultId":"t12", "useNetworkGeom":"false"}}$$)
*/

DECLARE


BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	
    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
