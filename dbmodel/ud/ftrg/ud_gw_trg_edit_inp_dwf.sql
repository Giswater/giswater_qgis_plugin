/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3036

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_dwf()  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN

		INSERT INTO inp_dwf (node_id, value, pat1, pat2, pat3, pat4, dwfscenario_id)
		VALUES (NEW.node_id, NEW.value, NEW.pat1, NEW.pat2, NEW.pat3, NEW.pat4, NEW.dwfscenario_id);

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	
		UPDATE inp_dwf 
		SET node_id=NEW.node_id, value=NEW.value, pat1=NEW.pat1, pat2=NEW.pat2, pat3=NEW.pat3, pat4=NEW.pat4, dwfscenario_id = NEW.dwfscenario_id
		WHERE id=NEW.id;
		
		RETURN NEW;
		
    ELSIF TG_OP = 'DELETE' THEN  
	 
		DELETE FROM inp_dwf WHERE id = OLD.id;		
		RETURN NULL;
     
	END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


