/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 3124

CREATE OR REPLACE FUNCTION ud_sample.gw_trg_edit_inp_treatment()
  RETURNS trigger AS
$BODY$
DECLARE 

BEGIN

	--Get schema name
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	IF TG_OP = 'INSERT' THEN
				
		INSERT INTO inp_treatment (node_id, poll_id, function)
		VALUES (NEW.node_id, NEW.poll_id, NEW.function);
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE inp_treatment SET node_id=NEW.node_id, poll_id=NEW.poll_id, function=NEW.function 
		WHERE node_id=OLD.node_id AND poll_id = OLD.poll_id;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM inp_treatment WHERE node_id=OLD.node_id AND poll_id = OLD.poll_id;

		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
