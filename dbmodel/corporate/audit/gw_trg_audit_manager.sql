/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_audit_manager() RETURNS TRIGGER AS $body$
DECLARE
    
BEGIN

--	Set search path to local schema
	SET search_path = SCHEMA_NAME, public;
	
	FOR table_record IN SELECT * FROM audit_cat_table WHERE isaudit  IS TRUE
	LOOP 
		DELETE FROM audit.log WHERE interval (now()-tstamp) > table_record.keepauditdays
	END LOOP;	


END;
$body$
LANGUAGE plpgsql;

