
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
					RETURN audit_function(125,430);
				END IF;
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					RETURN audit_function(130,430);  
				END IF;            
			END IF;
					
	-- FEATURE INSERT      
	
			IF (NEW.id IS NULL) THEN
			SELECT max(id::integer) INTO om_visit_id_seq FROM om_visit;
			PERFORM setval('om_visit_id_seq',om_visit_id_seq,true);
			NEW.id:= (SELECT nextval('om_visit_id_seq'));
			END IF;
			
			
			INSERT INTO  om_visit (id, startdate, enddate, user_name, the_geom, webclient_id, expl_id)
			VALUES (NEW.id, NEW.startdate, NEW.enddate, NEW.user_name, NEW.the_geom, NEW.webclient_id, NEW.expl_id);
			
			RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


-- MANAGEMENT UPDATE
			UPDATE om_visit
			SET id=NEW.id, startdate=NEW.startdate, enddate=NEW.enddate, user_name=NEW.user_name, the_geom=NEW.the_geom, webclient_id=NEW.webclient_id, expl_id=NEW.expl_id
			WHERE id = OLD.id;
			
			PERFORM audit_function(2,430); 
			RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN
	
			DELETE FROM om_visit WHERE id = OLD.id;
		

		PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_edit_om_visit ON "SCHEMA_NAME".v_edit_om_visit;
CREATE TRIGGER gw_trg_edit_om_visit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_om_visit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_om_visit('om_visit');



