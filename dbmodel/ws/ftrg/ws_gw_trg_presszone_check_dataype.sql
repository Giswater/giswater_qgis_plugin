/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:3306

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_presszone_check_datatype()  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF NEW.presszone_id ~ '^[0-9]+$' THEN

	ELSE
		RAISE EXCEPTION 'The proposed id for mapzone need to be integer';

	END IF;
	
	RETURN NEW;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


