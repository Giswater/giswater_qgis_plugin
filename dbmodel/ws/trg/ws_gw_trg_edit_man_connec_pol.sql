/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 2460


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_connec_pol();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_connec_pol() RETURNS trigger AS
$BODY$

DECLARE 
    man_table varchar;
	rec record;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	man_table:= TG_ARGV[0];
		
	--Get data from config table
	SELECT * INTO rec FROM config;	
	
	-- INSERT
	IF TG_OP = 'INSERT' THEN
	
		-- Pol ID	
		IF (NEW.pol_id IS NULL) THEN
			NEW.pol_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		-- Node ID	
		IF (NEW.connec_id IS NULL) THEN
			NEW.connec_id:= (SELECT connec_id FROM v_edit_connec WHERE ST_DWithin(NEW.the_geom, v_edit_connec.the_geom,0.001) LIMIT 1);
			IF (NEW.connec_id IS NULL) THEN
				RETURN audit_function(2094,2460);
			END IF;
		END IF;
		
		IF (SELECT connec_id FROM man_fountain WHERE connec_id=NEW.connec_id) IS NULL THEN
				RETURN audit_function(2096,2460);
		END IF;
		
		-- Insert into polygon table
		INSERT INTO polygon (pol_id, sys_type, the_geom) VALUES (NEW.pol_id, 'FOUNTAIN', NEW.the_geom);
		
		-- Update man table
		UPDATE man_fountain SET pol_id=NEW.pol_id WHERE connec_id=NEW.connec_id;
		
		RETURN NEW;
		
    
	-- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN
	
		UPDATE polygon SET pol_id=NEW.pol_id, the_geom=NEW.the_geom WHERE pol_id=OLD.pol_id;
		
		IF (NEW.connec_id != OLD.connec_id) THEN
			IF (SELECT connec_id FROM man_fountain WHERE connec_id=NEW.connec_id) iS NULL THEN
					RETURN audit_function(2098,2460);
			END IF;
			UPDATE man_fountain SET pol_id=NULL WHERE connec_id=OLD.connec_id;
			UPDATE man_fountain SET pol_id=NEW.pol_id WHERE connec_id=NEW.connec_id;
		
		END IF;
		
		RETURN NEW;
    
	-- DELETE
    ELSIF TG_OP = 'DELETE' THEN
	
		UPDATE man_fountain SET pol_id=NULL WHERE connec_id=OLD.connec_id;
		DELETE FROM polygon WHERE pol_id=OLD.pol_id;
				
		RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain_pol ON "SCHEMA_NAME".v_edit_man_fountain_pol;
CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_fountain_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec_pol('man_fountain_pol');
