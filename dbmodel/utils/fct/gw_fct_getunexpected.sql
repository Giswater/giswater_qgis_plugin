/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2876

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getunexpected(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getunexpected(p_data json)
  RETURNS json AS
  
$BODY$
/*
-- unexpected first call
SELECT SCHEMA_NAME.gw_fct_getunexpected($${"client":{"device":4,"infoType":1,"lang":"es"},
"form":{},"data":{"relatedFeature":{"type":"arc", "id":"2074"},"fields":{},"pageInfo":null}}$$)
*/

BEGIN

	RETURN SCHEMA_NAME.gw_fct_getvisit_main(2, p_data);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
