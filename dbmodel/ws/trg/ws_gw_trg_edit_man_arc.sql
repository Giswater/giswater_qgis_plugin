/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1314

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc()
  RETURNS trigger AS
$BODY$
DECLARE 

    inp_table varchar;
    man_table varchar;
    v_sql varchar;
    arc_id_seq int8;
	code_autofill_bool boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	        man_table:= TG_ARGV[0];
	
	
    IF TG_OP = 'INSERT' THEN
    
        -- Arc ID
        IF (NEW.arc_id IS NULL) THEN
           -- PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.arc_id:= (SELECT nextval('urn_id_seq'));
        END IF;

        
        -- Arc catalog ID
		IF (NEW.arccat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
				RETURN audit_function(1020,1314); 
			END IF; 
			NEW.arccat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='arccat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.arccat_id IS NULL) THEN
			NEW.arccat_id := (SELECT arccat_id from arc WHERE ST_DWithin(NEW.the_geom, arc.the_geom,0.001) LIMIT 1);
			IF (NEW.arccat_id IS NULL) THEN
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
			END IF;       
		END IF;
		END IF;
        
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1314); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1314); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1314); 
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1314); 
            END IF;
        END IF;
	
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;

		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 		
			
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1314);
				END IF;		
			END IF;
		END IF;

		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"());
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
					PERFORM audit_function(2024,1212);
				END IF;
			END IF;

       SELECT code_autofill INTO code_autofill_bool FROM arc JOIN cat_arc ON cat_arc.id =arc.arccat_id JOIN arc_type ON arc_type.id=cat_arc.arctype_id WHERE cat_arc.id=NEW.arccat_id;
	           
        -- Set EPA type
        NEW.epa_type = 'PIPE';        
    
        -- FEATURE INSERT
		IF man_table='man_pipe' THEN 
				
				
				-- Workcat_id
				IF (NEW.pi_workcat_id IS NULL) THEN
					NEW.pi_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					IF (NEW.pi_workcat_id IS NULL) THEN
						NEW.pi_workcat_id := (SELECT id FROM cat_work limit 1);
					END IF;
				END IF;

				-- Builtdate
				IF (NEW.pi_builtdate IS NULL) THEN
					NEW.pi_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
				
		--Copy id to code field	
				IF (NEW.pi_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.pi_code=NEW.arc_id;
			END IF;
			
				INSERT INTO arc (arc_id, code, node_1,node_2, arccat_id, epa_type, sector_id, "state", state_type, annotation, observ,"comment",custom_length,dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type,
					workcat_id, workcat_id_end, buildercat_id, builtdate,enddate, ownercat_id, muni_id,streetaxis_id,streetaxis_02_id,postcode, postnumber, postnumber_02,descript,verified,the_geom,undelete,label_x,label_y,label_rotation, 
					publish, inventory, expl_id,num_value)
					VALUES (NEW.arc_id, NEW.pi_code, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.state_type, NEW.pi_annotation, NEW.pi_observ, NEW.pi_comment, NEW.pi_custom_length,NEW.dma_id,NEW. presszonecat_id, 
					NEW.pi_soilcat_id, NEW.pi_function_type, NEW.pi_category_type, NEW.pi_fluid_type, NEW.pi_location_type, NEW.pi_workcat_id, NEW.pi_workcat_id_end, NEW.pi_buildercat_id, NEW.pi_builtdate,
					NEW.pi_enddate, NEW.pi_ownercat_id, NEW.pi_muni_id, NEW.pi_streetaxis_id, NEW.pi_streetaxis_02_id,NEW.pi_postcode, NEW.pi_postnumber, NEW.pi_postnumber_02,NEW.pi_descript, NEW.verified, NEW.the_geom,NEW.undelete, 
					NEW.pi_label_x,NEW.pi_label_y,NEW.pi_label_rotation, NEW.publish, NEW.inventory, NEW.expl_id, NEW.pi_num_value);
				
				INSERT INTO man_pipe (arc_id) VALUES (NEW.arc_id);
			RETURN NEW;				
			
		ELSIF man_table='man_varc' THEN
						
				-- Workcat_id
				IF (NEW.va_workcat_id IS NULL) THEN
					NEW.va_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					IF (NEW.va_workcat_id IS NULL) THEN
						NEW.va_workcat_id := (SELECT id FROM cat_work limit 1);
					END IF;
				END IF;
				
				-- Builtdate
				IF (NEW.va_builtdate IS NULL) THEN
					NEW.va_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;

				--Copy id to code field	
				IF (NEW.va_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.va_code=NEW.arc_id;
			END IF;
			
				INSERT INTO arc (arc_id, code, node_1,node_2, arccat_id, epa_type, sector_id, "state", state_type, annotation, observ,"comment",custom_length,dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type,
					workcat_id, workcat_id_end, buildercat_id, builtdate,enddate, ownercat_id, muni_id,streetaxis_id,streetaxis_02_id,postcode,postnumber,postnumber_02,descript,verified,the_geom,undelete,label_x,label_y,label_rotation, 
					publish, inventory, expl_id, num_value)
					VALUES (NEW.arc_id, NEW.va_code, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state",NEW.state_type, NEW.va_annotation, NEW.va_observ, NEW.va_comment, NEW.va_custom_length,NEW.dma_id,NEW. presszonecat_id, 
					NEW.va_soilcat_id, NEW.va_function_type, NEW.va_category_type, NEW.va_fluid_type, NEW.va_location_type, NEW.va_workcat_id, NEW.va_workcat_id_end, NEW.va_buildercat_id, NEW.va_builtdate,
					NEW.va_enddate, NEW.va_ownercat_id, NEW.va_muni_id, NEW.va_streetaxis_id, NEW.va_streetaxis_02_id,NEW.va_postcode,NEW.va_postnumber,NEW.va_postnumber_02, NEW.va_descript,  NEW.verified, NEW.the_geom,NEW.undelete, 
					NEW.va_label_x,NEW.va_label_y,NEW.va_label_rotation, NEW.publish, NEW.inventory, NEW.expl_id, NEW.va_num_value);
				
					INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
					
		END IF;
		RETURN NEW;
		
        -- EPA INSERT
        IF (NEW.epa_type = 'PIPE') THEN 
            inp_table:= 'inp_pipe';
            v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
            EXECUTE v_sql;
        END IF;

        -- MAN INSERT      
        man_table := (SELECT arc_type.man_table FROM arc_type JOIN cat_arc ON (((arc_type.id)::text = (cat_arc.arctype_id)::text)) WHERE cat_arc.id=NEW.arccat_id);
        IF man_table IS NOT NULL THEN
            v_sql:= 'INSERT INTO '||man_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';    
            EXECUTE v_sql;
        END IF;
     
        RETURN NEW;
    
    ELSIF TG_OP = 'UPDATE' THEN
	
		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE arc SET state=NEW.state WHERE arc_id = OLD.arc_id;
		END IF;
			
		-- The geom
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
			UPDATE arc SET the_geom=NEW.the_geom WHERE arc_id = OLD.arc_id;
		END IF;
			

    
		
		
		IF man_table='man_pipe' THEN
			UPDATE arc 
			SET code=NEW.pi_code, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,  state_type=NEW.state_type, annotation= NEW.pi_annotation, "observ"=NEW.pi_observ, 
				"comment"=NEW.pi_comment, custom_length=NEW.pi_custom_length, dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.pi_soilcat_id, function_type=NEW.pi_function_type,
				category_type=NEW.pi_category_type, fluid_type=NEW.pi_fluid_type, location_type=NEW.pi_location_type, workcat_id=NEW.pi_workcat_id, workcat_id_end=NEW.pi_workcat_id_end, 
				buildercat_id=NEW.pi_buildercat_id, builtdate=NEW.pi_builtdate, enddate=NEW.pi_enddate, ownercat_id=NEW.pi_ownercat_id, muni_id=NEW.pi_muni_id, streetaxis_id=NEW.pi_streetaxis_id, 
				streetaxis_02_id=NEW.pi_streetaxis_02_id,postcode=NEW.pi_postcode, postnumber=NEW.pi_postnumber, postnumber_02=NEW.pi_postnumber_02,descript=NEW.pi_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.pi_label_x,
				label_y=NEW.pi_label_y,label_rotation=NEW.pi_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id,num_value=NEW.pi_num_value
			WHERE arc_id=OLD.arc_id;

			
		ELSIF man_table='man_varc' THEN
			UPDATE arc
			SET code=NEW.va_code, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id,  state_type=NEW.state_type, annotation= NEW.va_annotation, "observ"=NEW.va_observ, 
				"comment"=NEW.va_comment, custom_length=NEW.va_custom_length, dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.va_soilcat_id, function_type=NEW.va_function_type,
				category_type=NEW.va_category_type, fluid_type=NEW.va_fluid_type, location_type=NEW.va_location_type, workcat_id=NEW.va_workcat_id, workcat_id_end=NEW.va_workcat_id_end, 
				buildercat_id=NEW.va_buildercat_id, builtdate=NEW.va_builtdate, enddate=NEW.va_enddate, ownercat_id=NEW.va_ownercat_id, muni_id=NEW.va_muni_id, streetaxis_id=NEW.va_streetaxis_id, 
				streetaxis_02_id=NEW.va_streetaxis_02_id,postcode=NEW.va_postcode, postnumber=NEW.va_postnumber, postnumber_02=NEW.va_postnumber_02, descript=NEW.va_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.va_label_x,
				label_y=NEW.va_label_y,label_rotation=NEW.va_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.va_num_value
			WHERE arc_id=OLD.arc_id;
			

			
		END IF;
		
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN 
	 
		PERFORM gw_fct_check_delete(OLD.arc_id, 'ARC');
	 
        DELETE FROM arc WHERE arc_id = OLD.arc_id;
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

DROP TRIGGER IF EXISTS gw_trg_edit_man_pipe ON "SCHEMA_NAME".v_edit_man_pipe;
CREATE TRIGGER gw_trg_edit_man_pipe INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pipe FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_pipe');

DROP TRIGGER IF EXISTS gw_trg_edit_man_varc ON "SCHEMA_NAME".v_edit_man_varc;
CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_varc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_varc');
      