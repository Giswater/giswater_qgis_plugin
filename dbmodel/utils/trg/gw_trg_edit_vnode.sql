/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1126


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_network_features();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_vnode()
  RETURNS trigger AS
$BODY$
DECLARE 

    vnode_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';



-- INSERT
	IF TG_OP = 'INSERT' THEN

	-- link ID

	IF (NEW.vnode_id IS NULL) THEN
		NEW.vnode_id:= (SELECT nextval('vnode_vnode_id_seq'));
	END IF;

		
	 -- Sector ID
            IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1126);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"());
			END IF;
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1126,NEW.vnode_id);          
            END IF;            
        END IF;

        -- Dma ID
            IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1126);  
            END IF;
            NEW.dma_id:= (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"());
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1126,NEW.vnode_id);          
            END IF;            
        END IF;
		
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
		--Exploitation ID
	 IF (NEW.expl_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
                PERFORM audit_function(1110,1126);
            END IF;
            NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
				PERFORM audit_function(2012,1126,NEW.vnode_id);
            END IF;
         END IF;
			
	-- FEATURE INSERT  
  
	INSERT INTO vnode (vnode_id, vnode_type, sector_id, dma_id, state, annotation, the_geom, expl_id)
	VALUES (NEW.vnode_id, 'CUSTOM', NEW.sector_id, NEW.dma_id, NEW.state, NEW.annotation, NEW.the_geom, NEW.expl_id);

	RETURN NEW;


-- UPDATE

    ELSIF TG_OP = 'UPDATE' THEN

		-- The geom
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom) THEN
			NEW.vnode_type='CUSTOM';
		END IF;

		UPDATE vnode
		SET vnode_id=NEW.vnode_id, vnode_type=NEW.vnode_type, sector_id=NEW.sector_id, state=NEW.state, annotation=NEW.annotation, the_geom=NEW.the_geom, expl_id=NEW.expl_id
		WHERE vnode_id=NEW.vnode_id;

		RETURN NEW;

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM vnode WHERE vnode_id=OLD.vnode_id;
		
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_edit_vnode ON "SCHEMA_NAME".v_edit_vnode;
CREATE TRIGGER gw_trg_edit_vnode INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_vnode FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_vnode('vnode');

