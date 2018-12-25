/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1118


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_network_features();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_om_visit()
  RETURNS trigger AS
$BODY$
DECLARE 

		om_visit_id_seq int8;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';


-- INSERT

    -- Control insertions ID
	IF TG_OP = 'INSERT' THEN
    

	--Exploitation ID
		IF (NEW.expl_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
					RETURN audit_function(1110,1118);
				END IF;
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
				END IF;
				IF (NEW.expl_id IS NULL) THEN
					RETURN audit_function(2012,1118,NEW.id);  
				END IF;            
			END IF;
					
	-- FEATURE INSERT      
	
			IF (NEW.id IS NULL) THEN
			SELECT max(id::integer) INTO om_visit_id_seq FROM om_visit;
			PERFORM setval('om_visit_id_seq',om_visit_id_seq,true);
			NEW.id:= (SELECT nextval('om_visit_id_seq'));
			END IF;
			
			
			INSERT INTO  om_visit (id, startdate, enddate, user_name, the_geom, webclient_id, expl_id,ext_code)
			VALUES (NEW.id, NEW.startdate, NEW.enddate, NEW.user_name, NEW.the_geom, NEW.webclient_id, NEW.expl_id,NEW.ext_code);
			
			RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


-- MANAGEMENT UPDATE
			UPDATE om_visit
			SET id=NEW.id, startdate=NEW.startdate, enddate=NEW.enddate, user_name=NEW.user_name, the_geom=NEW.the_geom, webclient_id=NEW.webclient_id, expl_id=NEW.expl_id, ext_code=NEW.ext_code
			WHERE id = OLD.id;
			
			RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN
	
			DELETE FROM om_visit WHERE id = OLD.id;
		

        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  



