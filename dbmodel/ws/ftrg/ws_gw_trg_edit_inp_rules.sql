/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3058


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_rules() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN

		IF NEW.id IS NULL THEN
			PERFORM setval('inp_rules_id_seq', (SELECT max(id) FROM inp_rules), true);
			NEW.id = (SELECT nextval('inp_rules_id_seq'));
		END IF;
	
		INSERT INTO inp_rules (id, text, active, sector_id) 
		VALUES (NEW.id, NEW.text, NEW.active, NEW.sector_id);
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN
		UPDATE inp_rules SET text=NEW.text, active=NEW.active, sector_id=NEW.sector_id
		WHERE id=OLD.id;
		RETURN NEW;
        
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM inp_rules WHERE id=OLD.id;
		RETURN OLD;
   
	END IF;
       
END;
$$;
  