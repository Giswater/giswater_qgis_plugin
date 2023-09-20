/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3276


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_transects() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 
v_table text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
   v_table = TG_ARGV[0];

	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN
		
		INSERT INTO inp_transects_value (tsect_id, text) 
		VALUES (NEW.tsect_id, NEW.text);
		
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		
		UPDATE inp_transects_value SET tsect_id=NEW.tsect_id, text=NEW.text
		WHERE id=OLD.id;
		

		RETURN NEW;
        
	ELSIF TG_OP = 'DELETE' THEN
	
		DELETE FROM inp_transects_value WHERE id=OLD.id;

		RETURN OLD;
   
	END IF;
       
END;
$$;
 