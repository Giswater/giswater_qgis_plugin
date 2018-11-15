/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1330


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_unconnected()
  RETURNS trigger AS
$BODY$
DECLARE 

    man_table varchar;
	expl_id_int integer;
	pond_id_seq int8;
	pool_id_seq int8;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	        man_table:= TG_ARGV[0];
	
	
    IF TG_OP = 'INSERT' THEN
        			
		--Exploitation ID
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                --PERFORM audit_function(1110,1330);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
				expl_id_int := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
            END IF;
			
	    -- State	
		        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
    
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
             --   PERFORM audit_function(1012,1330); 
                RETURN NULL;                         
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"());
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
             --   PERFORM audit_function(1014,1330); 
                RETURN NULL; 
            END IF;
        END IF;
		
        -- FEATURE INSERT

		
		IF man_table='pond' THEN
						
				-- Pond ID
			IF (NEW.pond_id IS NULL) THEN
				SELECT max(pond_id::integer) INTO pond_id_seq FROM pond WHERE pond_id ~ '^\d+$';
				PERFORM setval('pond_id_seq',pond_id_seq,true);
				NEW.pond_id:= (SELECT nextval('pond_id_seq'));
			END IF;		
				
				INSERT INTO pond (pond_id, connec_id, the_geom, expl_id, dma_id, state)
				VALUES (NEW.pond_id, NEW.connec_id, NEW.the_geom, expl_id_int, NEW.dma_id, NEW."state");
		
		ELSIF man_table='pool' THEN
			       			-- Pool ID
			IF (NEW.pool_id IS NULL) THEN
				SELECT max(pool_id::integer) INTO pool_id_seq FROM pool WHERE pool_id ~ '^\d+$';
				PERFORM setval('pool_id_seq',pool_id_seq,true);
				NEW.pool_id:= (SELECT nextval('pool_id_seq'));
			END IF; 
			
				INSERT INTO pool(pool_id, connec_id, the_geom, expl_id,dma_id, state)
				VALUES (NEW.pool_id, NEW.connec_id, NEW.the_geom, expl_id_int, NEW.dma_id, NEW."state");
		
			
		END IF;
		RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

		

						
		IF man_table='pond' THEN
			UPDATE pond
			SET pond_id=NEW.pond_id, connec_id=NEW.connec_id, the_geom=NEW.the_geom, expl_id=NEW.expl_id, dma_id=NEW.dma_id, "state"=NEW."state"
			WHERE pond_id=OLD.pond_id;
		
		ELSIF man_table='pool' THEN
			UPDATE pool
			SET pool_id=NEW.pool_id, connec_id=NEW.connec_id, the_geom=NEW.the_geom, expl_id=NEW.expl_id, dma_id=NEW.dma_id, "state"=NEW."state"
			WHERE pool_id=NEW.pool_id;
		
		END IF;
		
        PERFORM audit_function(2,1302); 
        RETURN NEW;

		 ELSIF TG_OP = 'DELETE' THEN  
			
			IF man_table='pond' THEN
				DELETE FROM pond WHERE pond_id=OLD.pond_id;
			
			ELSIF man_table='pool' THEN
				DELETE FROM pool WHERE pool_id=OLD.pool_id;
			

			END IF;
		
        PERFORM audit_function(3,1302); 
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  


DROP TRIGGER IF EXISTS gw_trg_edit_pond ON "SCHEMA_NAME".v_edit_pond;
CREATE TRIGGER gw_trg_edit_pond INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_pond FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_unconnected('pond');

DROP TRIGGER IF EXISTS gw_trg_edit_pool ON "SCHEMA_NAME".v_edit_pool;
CREATE TRIGGER gw_trg_edit_pool INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_pool FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_unconnected('pool');

      