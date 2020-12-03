/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_manager() RETURNS integer AS $body$
DECLARE
      table_record record;    

BEGIN

--	Set search path to local schema
	SET search_path = SCHEMA_NAME, public;
	
	FOR table_record IN SELECT * FROM sys_table WHERE isaudit  IS TRUE
	LOOP 
		DELETE FROM audit.log WHERE (date (now())- date (tstamp)) > table_record.keepauditdays;
	END LOOP;	

RETURN 0;

END;
$body$
LANGUAGE plpgsql;

