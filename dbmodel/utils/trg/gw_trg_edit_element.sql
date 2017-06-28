
-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_element();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_element()
  RETURNS trigger AS
$BODY$
DECLARE 
	element_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

-- INSERT

	IF TG_OP = 'INSERT' THEN
	
-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_vdefault WHERE "parameter"='verified_vdefault' AND "user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
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
			
--Element ID		
		IF (NEW.element_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_urn(),true);
			NEW.element_id:= (SELECT nextval('urn_id_seq'));
		END IF;

-- FEATURE INSERT      

				INSERT INTO element (element_id, elementcat_id, state, annotation, observ, comment, location_type, workcat_id, buildercat_id, builtdate, ownercat_id, enddate, rotation, link, verified, workcat_id_end, code, 
				the_geom, expl_id)
				VALUES (NEW.element_id, NEW.elementcat_id, NEW.state, NEW.annotation, NEW.observ, NEW.comment, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate, NEW.ownercat_id, NEW.enddate, 
				NEW.rotation, NEW.link, NEW.verified, NEW.workcat_id_end, NEW.code, NEW.the_geom, expl_id_int);
		
	
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN

		UPDATE element
		SET element_id=NEW.element_id, elementcat_id=NEW.elementcat_id, state=NEW.state, annotation=NEW.annotation, observ=NEW.observ, comment=NEW.comment, location_type=NEW.location_type, workcat_id=NEW.workcat_id, 
		buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, ownercat_id=NEW.ownercat_id, enddate=NEW.enddate, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, workcat_id_end=NEW.workcat_id_end, 
		code=NEW.code, the_geom=NEW.the_geom, expl_id=NEW.expl_id
		WHERE element_id=OLD.element_id;

        PERFORM audit_function(2,430); 
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM element WHERE element_id=OLD.element_id;

		PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  

DROP TRIGGER IF EXISTS gw_trg_edit_element ON "SCHEMA_NAME".v_edit_element;
CREATE TRIGGER gw_trg_edit_element INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_element FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_element('element');


