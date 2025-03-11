/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:3306

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_presszone_check_datatype()  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF NEW.presszone_id ~ '^[-]?[0-9]+$' THEN

	ELSE

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3262", "function":"3306","parameters":null}}$$);'; 

	END IF;
	
	RETURN NEW;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


