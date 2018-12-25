/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODI: 1122


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_unconnected();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_samplepoint()
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
                PERFORM audit_function(1110,1122);
				RETURN NULL;				
            END IF;
            expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
            IF (expl_id_int IS NULL) THEN
                expl_id_int := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
                RETURN audit_function(2012,1122,NEW.sample_id);  
            END IF;
			
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1122);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1122,NEW.sample_id);  
            END IF;            
        END IF;
		
--Samplepoint ID
		IF (NEW.sample_id IS NULL) THEN
			SELECT max(sample_id::integer) INTO sample_id_seq FROM samplepoint WHERE sample_id ~ '^\d+$';
			PERFORM setval('sample_id_seq',sample_id_seq,true);
			NEW.sample_id:= (SELECT nextval('sample_id_seq'));
		END IF;		
		
-- FEATURE INSERT      
		
				INSERT INTO samplepoint (sample_id, code, lab_code, feature_id, featurecat_id, dma_id, "state", builtdate, enddate, workcat_id, 
				workcat_id_end, rotation, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, place_name, cabinet, observations, 
				the_geom, expl_id, verified)
				VALUES (NEW.sample_id, NEW.code, NEW.lab_code, NEW.feature_id, NEW.featurecat_id,  NEW.dma_id, NEW."state", NEW.builtdate, 
				NEW.enddate, NEW.workcat_id, NEW.workcat_id_end, NEW.rotation, NEW.muni_id, NEW.postcode, NEW.streetaxis_id, NEW.postnumber, NEW.postcomplement, NEW.streetaxis2_id,
				NEW.postnumber2, NEW.postcomplement2, NEW.place_name, NEW.cabinet, NEW.observations, NEW.the_geom, expl_id_int, NEW.verified);
	
		RETURN NEW;
						

-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN

			UPDATE samplepoint 
			SET sample_id=NEW.sample_id,  code=NEW.code,lab_code=NEW.lab_code,  feature_id=NEW.feature_id, featurecat_id=NEW.featurecat_id, 
			dma_id=NEW.dma_id,"state"=NEW."state", rotation=NEW.rotation, builtdate=NEW.builtdate, enddate=NEW.enddate, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, 
			muni_id=NEW.muni_id, postcode=NEW.postcode, streetaxis_id=NEW.streetaxis_id, postnumber=NEW.postnumber, postcomplement=NEW.postcomplement, streetaxis2_id=NEW.streetaxis2_id, 
			postnumber2=NEW.postnumber2, postcomplement2=NEW.postcomplement2, place_name=NEW.place_name, cabinet=NEW.cabinet, observations=NEW.observations, 
			the_geom=NEW.the_geom, expl_id=NEW.expl_id, verified=NEW.verified
			WHERE sample_id=NEW.sample_id;

        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM samplepoint WHERE sample_id=OLD.sample_id;
		

		
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
