/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1110



-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_dimensions();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_dimensions()
  RETURNS trigger AS
$BODY$
DECLARE 
dimensions_id_seq integer;
expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||',public';



-- INSERT


	IF TG_OP = 'INSERT' THEN
	
		
		--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(1012,1110);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
				RETURN NULL; 
            END IF;

	    -- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := '1';
            END IF;
        END IF;
		
	
	        -- dimension_id
        IF (NEW.id IS NULL) THEN
            SELECT max(id) INTO dimensions_id_seq FROM dimensions;
            PERFORM setval('dimensions_id_seq',dimensions_id_seq,true);
            NEW.id:= (SELECT nextval('dimensions_id_seq'));
        END IF;
		
            --distance
       IF (NEW.distance IS NULL) THEN
            NEW.distance= ST_Length(NEW.the_geom);
        END IF;
		
-- FEATURE INSERT      


		
				INSERT INTO dimensions (id, distance, depth, the_geom, x_label, y_label, rotation_label, offset_label, direction_arrow, x_symbol, y_symbol, feature_id, feature_type, state, expl_id)
				VALUES (NEW.id, NEW.distance, NEW.depth, NEW.the_geom, NEW.x_label, NEW.y_label, NEW.rotation_label, NEW.offset_label, NEW.direction_arrow, NEW.x_symbol, NEW.y_symbol, NEW.feature_id, NEW.feature_type, NEW.state,expl_id_int);
	
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN

			UPDATE dimensions
			SET id=NEW.id, distance=NEW.distance, depth=NEW.depth, the_geom=NEW.the_geom, x_label=NEW.x_label, y_label=NEW.y_label, rotation_label=NEW.rotation_label, offset_label=NEW.offset_label, 
			direction_arrow=NEW.direction_arrow, x_symbol=NEW.x_symbol, y_symbol=NEW.y_symbol, feature_id=NEW.feature_id, feature_type=NEW.feature_type, expl_id=NEW.expl_id
			WHERE id=NEW.id;
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM dimensions 
		WHERE id=OLD.id;
				
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 