/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION PARENT_SCHEMA.gw_fct_audit_manager() RETURNS integer AS $body$
DECLARE
      table_record record;

BEGIN

--	Set search path to local schema
	SET search_path = "PARENT_SCHEMA", public;

	FOR table_record IN SELECT * FROM sys_table WHERE isaudit  IS TRUE
	LOOP
		DELETE FROM audit.log WHERE schema = 'PARENT_SCHEMA' and (date (now())- date (tstamp)) > table_record.keepauditdays and table_name =table_record.id;
	END LOOP;

RETURN 0;

END;
$body$
LANGUAGE plpgsql;

