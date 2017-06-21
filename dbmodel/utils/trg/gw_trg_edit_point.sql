
-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_network_features();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_point()
  RETURNS trigger AS
$BODY$
DECLARE 
    point_id_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';


-- INSERT

    -- Control insertions ID
	IF TG_OP = 'INSERT' THEN
    

		--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(125,340);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                --PERFORM audit_function(130,340);
				RETURN NULL; 
            END IF;
					
	-- FEATURE INSERT      
					
			IF (NEW.point_id IS NULL) THEN
			SELECT max(point_id::integer) INTO point_id_seq FROM point WHERE point_id ~ '^\d+$';
			PERFORM setval('point_id_seq',point_id_seq,true);
			NEW.point_id:= (SELECT nextval('point_id_seq'));
			END IF;
			
			
				INSERT INTO point (point_id, point_type,observ,text, link, the_geom, undelete, expl_id )
				VALUES (NEW.point_id, NEW.point_type, NEW.observ, NEW.text, NEW.link, NEW.the_geom, NEW.undelete, expl_id_int);
		
		
			RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


-- MANAGEMENT UPDATE
			UPDATE point
			SET point_id=NEW.point_id, point_type=NEW.point_type, observ=NEW.observ, text=NEW.text, link=NEW.link, the_geom=NEW.the_geom, undelete=NEW.undelete, expl_id=NEW.expl_id
			WHERE point_id=OLD.point_id;			
	
			PERFORM audit_function(2,430); 
			RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN
		
			DELETE FROM point WHERE point_id = OLD.point_id;


		PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_edit_point ON "SCHEMA_NAME".v_edit_point;
CREATE TRIGGER gw_trg_edit_point INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_point FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_point('point');


