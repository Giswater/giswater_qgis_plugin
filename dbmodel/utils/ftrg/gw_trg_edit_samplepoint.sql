/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODI: 1122

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_samplepoint()
RETURNS trigger AS
$BODY$
DECLARE 

v_expl_id_int integer;
v_sample_id_seq int8;
v_count integer;
v_projectype text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	v_projectype = (SELECT project_type FROM sys_version LIMIT 1);

	-- INSERT
	IF TG_OP = 'INSERT' THEN

		--Samplepoint
		IF (NEW.sample_id IS NULL) THEN
			SELECT max(sample_id::integer) INTO v_sample_id_seq FROM samplepoint WHERE sample_id ~ '^\d+$';
			PERFORM setval('samplepoint_id_seq',v_sample_id_seq,true);
			NEW.sample_id:= (SELECT nextval('samplepoint_id_seq'));
		END IF;		

		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"1110", "function":"1302","debug_msg":null}}$$);';
			END IF;
			
			-- getting value default
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			
			-- getting value from geometry of mapzone
			IF (NEW.expl_id IS NULL) THEN
				SELECT count(*)into v_count FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) AND active IS TRUE;
				IF v_count = 1 THEN
					NEW.expl_id = (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) AND active IS TRUE LIMIT 1);
				ELSE
					NEW.expl_id =(SELECT expl_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, v_promixity_buffer) 
					order by ST_Distance (NEW.the_geom, v_edit_arc.the_geom) LIMIT 1);
				END IF;	
			END IF;
			
			-- control error when no value
			IF (NEW.expl_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2012", "function":"1302","debug_msg":"'||NEW.arc_id::text||'"}}$$);';
			END IF;            
		END IF;
	
		-- Dma ID
		IF (NEW.dma_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2012", "function":"1122","debug_msg":null}}$$);';
			END IF;
			NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_dma_vdefault' AND "cur_user"="current_user"());
			END IF; 
		END IF;
				
		IF v_projectype = 'WS' THEN
			INSERT INTO samplepoint (sample_id, code, lab_code, feature_id, featurecat_id, dma_id, presszone_id, "state", builtdate, enddate,
			workcat_id, workcat_id_end, rotation, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, place_name, cabinet, 
			observations, the_geom, expl_id, verified)
			VALUES (NEW.sample_id, NEW.code, NEW.lab_code, NEW.feature_id, NEW.featurecat_id,  NEW.dma_id, NEW.presszone_id, NEW."state", NEW.builtdate,
			NEW.enddate, NEW.workcat_id, NEW.workcat_id_end, NEW.rotation, NEW.muni_id, NEW.postcode, NEW.streetaxis_id, NEW.postnumber, NEW.postcomplement, NEW.streetaxis2_id,
			NEW.postnumber2, NEW.postcomplement2, NEW.place_name, NEW.cabinet, NEW.observations, NEW.the_geom, NEW.expl_id, NEW.verified);
		ELSE

			INSERT INTO samplepoint (sample_id, code, lab_code, feature_id, featurecat_id, dma_id, "state", builtdate, enddate,
			workcat_id, workcat_id_end, rotation, muni_id, postcode, streetaxis_id, postnumber, postcomplement, streetaxis2_id, postnumber2, postcomplement2, place_name, cabinet, 
			observations, the_geom, expl_id, verified)
			VALUES (NEW.sample_id, NEW.code, NEW.lab_code, NEW.feature_id, NEW.featurecat_id,  NEW.dma_id, NEW."state", NEW.builtdate,
			NEW.enddate, NEW.workcat_id, NEW.workcat_id_end, NEW.rotation, NEW.muni_id, NEW.postcode, NEW.streetaxis_id, NEW.postnumber, NEW.postcomplement, NEW.streetaxis2_id,
			NEW.postnumber2, NEW.postcomplement2, NEW.place_name, NEW.cabinet, NEW.observations, NEW.the_geom, NEW.expl_id, NEW.verified);

		END IF;

		RETURN NEW;	
						
	-- UPDATE
	ELSIF TG_OP = 'UPDATE' THEN

		IF v_projectype = 'WS' THEN
			UPDATE samplepoint 
			SET sample_id=NEW.sample_id,  code=NEW.code,lab_code=NEW.lab_code,  feature_id=NEW.feature_id, featurecat_id=NEW.featurecat_id, dma_id=NEW.dma_id, 
			presszone_id=NEW.presszone_id,"state"=NEW."state", rotation=NEW.rotation, builtdate=NEW.builtdate, enddate=NEW.enddate,
			workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, muni_id=NEW.muni_id, postcode=NEW.postcode, streetaxis_id=NEW.streetaxis_id, 
			postnumber=NEW.postnumber, postcomplement=NEW.postcomplement, streetaxis2_id=NEW.streetaxis2_id, postnumber2=NEW.postnumber2, postcomplement2=NEW.postcomplement2,
			place_name=NEW.place_name, cabinet=NEW.cabinet, observations=NEW.observations, the_geom=NEW.the_geom, expl_id=NEW.expl_id, verified=NEW.verified
			WHERE sample_id=NEW.sample_id;
		ELSE
			UPDATE samplepoint 
			SET sample_id=NEW.sample_id,  code=NEW.code,lab_code=NEW.lab_code,  feature_id=NEW.feature_id, featurecat_id=NEW.featurecat_id, dma_id=NEW.dma_id, 
			"state"=NEW."state", rotation=NEW.rotation, builtdate=NEW.builtdate, enddate=NEW.enddate,
			workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, muni_id=NEW.muni_id, postcode=NEW.postcode, streetaxis_id=NEW.streetaxis_id, 
			postnumber=NEW.postnumber, postcomplement=NEW.postcomplement, streetaxis2_id=NEW.streetaxis2_id, postnumber2=NEW.postnumber2, postcomplement2=NEW.postcomplement2,
			place_name=NEW.place_name, cabinet=NEW.cabinet, observations=NEW.observations, the_geom=NEW.the_geom, expl_id=NEW.expl_id, verified=NEW.verified
			WHERE sample_id=NEW.sample_id;
		END IF;

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
  