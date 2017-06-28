
-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_dimensions();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dimensions()
  RETURNS trigger AS
$BODY$
DECLARE 
dimensions_id_seq integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||',public';



-- INSERT


	IF TG_OP = 'INSERT' THEN
	
	
	        -- dimension_id
        IF (NEW.id IS NULL) THEN
            SELECT max(id) INTO dimensions_id_seq FROM dimensions;
            PERFORM setval('dimensions_id_seq',dimensions_id_seq,true);
            NEW.id:= (SELECT nextval('dimensions_id_seq'));
        END IF;
		
            --distance
       IF (NEW.distance IS NULL) THEN
            NEW.distance:= ((SELECT ST_Length(NEW.the_geom) FROM dimensions) LIMIT 1);
        END IF;
		
-- FEATURE INSERT      


		
				INSERT INTO dimensions (id, distance, depth, the_geom, x_label, y_label, rotation_label, offset_label, direction_arrow, x_symbol, y_symbol, feature_id, feature_type)
				VALUES (NEW.id, NEW.distance, NEW.depth, NEW.the_geom, NEW.x_label, NEW.y_label, NEW.rotation_label, NEW.offset_label, NEW.direction_arrow, NEW.x_symbol, NEW.y_symbol, NEW.feature_id, NEW.feature_type);
	
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN

			UPDATE dimensions
			SET id=NEW.id, distance=NEW.distance, depth=NEW.depth, the_geom=NEW.the_geom, x_label=NEW.x_label, y_label=NEW.y_label, rotation_label=NEW.rotation_label, offset_label=NEW.offset_label, 
			direction_arrow=NEW.direction_arrow, x_symbol=NEW.x_symbol, y_symbol=NEW.y_symbol, feature_id=NEW.feature_id, feature_type=NEW.feature_type
			WHERE id=NEW.id;
        --PERFORM audit_function(2,430); 
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM dimensions 
		WHERE id=OLD.id;
				
		--PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

DROP TRIGGER IF EXISTS gw_trg_edit_dimensions ON "SCHEMA_NAME".v_edit_dimensions;
CREATE TRIGGER gw_trg_edit_dimensions INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_dimensions FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_dimensions('dimensions');
