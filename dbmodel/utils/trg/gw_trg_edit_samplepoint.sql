
-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_unconnected();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_unconnected()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;
    sample_id_seq int8;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';



-- INSERT


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

--Samplepoint ID
		IF (NEW.sample_id IS NULL) THEN
			SELECT max(sample_id::integer) INTO sample_id_seq FROM samplepoint WHERE sample_id ~ '^\d+$';
			PERFORM setval('sample_id_seq',sample_id_seq,true);
			NEW.sample_id:= (SELECT nextval('sample_id_seq'));
		END IF;		
		
-- FEATURE INSERT      
		
				INSERT INTO samplepoint (sample_id, state, rotation, code_lab, element_type, workcat_id, workcat_id_end, street1, street2, place, element_code, cabinet, dma_id2, observations, the_geom, expl_id)
				VALUES (NEW.sample_id, NEW.state, NEW.rotation, NEW.code_lab, NEW.element_type, NEW.workcat_id, NEW.workcat_id_end, NEW.street1, NEW.street2, NEW.place, NEW.element_code,
				NEW.cabinet, NEW.dma_id2, NEW.observations, NEW.the_geom, expl_id_int);
	
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN

			UPDATE samplepoint 
			SET sample_id=NEW.sample_id, state=NEW.state, rotation=NEW.rotation, code_lab=NEW.code_lab, element_type=NEW.element_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, street1=NEW.street1, 
			street2=NEW.street2, place=NEW.place, element_code=NEW.element_code, cabinet=NEW.cabinet, dma_id2=NEW.dma_id2, observations=NEW.observations, the_geom=NEW.the_geom, expl_id=NEW.expl_id
			WHERE sample_id=NEW.sample_id;

        PERFORM audit_function(2,430); 
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM samplepoint WHERE sample_id=OLD.sample_id;
		

		
		PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

DROP TRIGGER IF EXISTS gw_trg_edit_samplepoint ON "SCHEMA_NAME".v_edit_samplepoint;
CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_samplepoint FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_unconnected('samplepoint');

