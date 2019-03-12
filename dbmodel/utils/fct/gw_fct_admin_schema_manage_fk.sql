/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


-- Function: SCHEMA_NAME.gw_fct_admin_schema_manage_fk(json)

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_manage_fk(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_fk($${
"client":{"lang":"ES"}, 
"data":{"action":"DROP"}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_schema_manage_fk($${
"client":{"lang":"ES"}, 
"data":{"action":"ADD"}}$$)

*/

DECLARE
	v_schemaname text;
	v_tablerecord record;
	v_query_text text;
	v_action text;
	v_return json;
	v_36 integer=0;
	v_37 integer=0;
BEGIN



RETURN v_return;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
