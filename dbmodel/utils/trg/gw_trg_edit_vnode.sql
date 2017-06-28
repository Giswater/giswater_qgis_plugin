
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
				PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				NEW.vnode_id:= (SELECT nextval('urn_id_seq'));
			END IF;
				
	        -- Sector ID

            IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,380);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,380);          
            END IF;            
        END IF;
		
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_vdefault WHERE "parameter"='state_vdefault' AND "user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
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
					

				INSERT INTO vnode (vnode_id, userdefined_pos, vnode_type, sector_id, state, annotation, the_geom, expl_id)
				VALUES (NEW.vnode_id, NEW.userdefined_pos, NEW.vnode_type, NEW.sector_id, NEW.state, NEW.annotation, NEW.the_geom, expl_id_int);
				
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


			UPDATE vnode
			SET vnode_id=NEW.vnode_id, userdefined_pos=NEW.userdefined_pos, vnode_type=NEW.vnode_type, sector_id=NEW.sector_id, state=NEW.state, annotation=NEW.annotation, the_geom=NEW.the_geom, expl_id=NEW.expl_id
			WHERE vnode_id=NEW.vnode_id;


			PERFORM audit_function(2,430); 
			RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM vnode WHERE vnode_id=OLD.vnode_id;
		

		
		PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  
DROP TRIGGER IF EXISTS gw_trg_edit_vnode ON "SCHEMA_NAME".v_edit_vnode;
CREATE TRIGGER gw_trg_edit_vnode INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_vnode FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_vnode('vnode');

