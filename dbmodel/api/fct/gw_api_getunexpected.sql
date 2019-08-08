/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getunexpected(p_data json)
  RETURNS json AS
  
$BODY$
/*
-- unexpected first call
SELECT SCHEMA_NAME.gw_api_getunexpected($${"client":{"device":3,"infoType":100,"lang":"es"},"form":{},"data":{"relatedFeature":{"type":"arc", "id":"2074"},"fields":{},"pageInfo":null}}$$)
*/

BEGIN

	RETURN SCHEMA_NAME.gw_api_get_visit(2, p_data);	

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
