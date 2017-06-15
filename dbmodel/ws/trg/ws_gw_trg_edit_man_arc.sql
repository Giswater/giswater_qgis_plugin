/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc()
  RETURNS trigger AS
$BODY$
DECLARE 

    inp_table varchar;
    man_table varchar;
    v_sql varchar;
    arc_id_seq int8;
	expl_id_int integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	        man_table:= TG_ARGV[0];
	
	
    IF TG_OP = 'INSERT' THEN
    
        -- Arc ID
        IF (NEW.arc_id IS NULL) THEN
            SELECT max(arc_id::integer) INTO arc_id_seq FROM arc WHERE arc_id ~ '^\d+$';
            PERFORM setval('arc_id_seq',arc_id_seq,true);
            NEW.arc_id:= (SELECT nextval('arc_id_seq'));
        END IF;

        -- Arc type
        IF (NEW.cat_arctype_id IS NULL) THEN
            NEW.cat_arctype_id := (SELECT id FROM arc_type WHERE epa_default = 'PIPE');
        END IF;
        
        -- Arc catalog ID
		IF (NEW.arccat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
				RETURN audit_function(145,840); 
			END IF; 
			NEW.arccat_id := (SELECT arccat_id from arc WHERE ST_DWithin(NEW.the_geom, arc.the_geom,0.001) LIMIT 1);
			IF (NEW.arccat_id IS NULL) THEN
				NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
			END IF;       
		END IF;
        
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,340); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,340); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,340); 
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,340); 
            END IF;
        END IF;
	
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT verified_vdefault FROM config);
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;

	    -- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT state_vdefault FROM config);
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

       
        
        -- Set EPA type
        NEW.epa_type = 'PIPE';        
    
        -- FEATURE INSERT
		IF man_table='man_pipe' THEN 
				
				
				-- Workcat_id
				IF (NEW.pipe_workcat_id IS NULL) THEN
					NEW.pipe_workcat_id := (SELECT workcat_vdefault FROM config);
					IF (NEW.pipe_workcat_id IS NULL) THEN
						NEW.pipe_workcat_id := (SELECT id FROM cat_work limit 1);
					END IF;
				END IF;

				-- Builtdate
				IF (NEW.pipe_builtdate IS NULL) THEN
					NEW.pipe_builtdate := (SELECT builtdate_vdefault FROM config);
				END IF;
	
				INSERT INTO arc (arc_id, node_1,node_2, arccat_id, epa_type, sector_id, "state", annotation, observ,"comment",custom_length,dma_id, soilcat_id, category_type, fluid_type, location_type,
					workcat_id, buildercat_id, builtdate,ownercat_id, adress_01,adress_02,adress_03,descript,rotation,link,verified,the_geom,undelete,workcat_id_end,label_x,label_y,label_rotation, 
					publish, inventory, end_date, expl_id)
					VALUES (NEW.arc_id, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.pipe_annotation, NEW.pipe_observ, NEW.pipe_comment, NEW.pipe_custom_length,NEW.dma_id,NEW.pipe_soilcat_id, 
					NEW.pipe_category_type, NEW.pipe_fluid_type, NEW.pipe_location_type, NEW.pipe_workcat_id, NEW.pipe_buildercat_id, NEW.pipe_builtdate,NEW.pipe_ownercat_id, NEW.pipe_adress_01, NEW.pipe_adress_02, NEW.pipe_adress_03, 
					NEW.pipe_descript, NEW.pipe_rotation, NEW.pipe_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.pipe_workcat_id_end, NEW.pipe_label_x,NEW.pipe_label_y,NEW.pipe_label_rotation, 
					NEW.publish, NEW.inventory, NEW.pipe_end_date, expl_id_int);
				
				INSERT INTO man_pipe (arc_id) VALUES (NEW.arc_id);
		
		ELSIF man_table='man_varc' THEN
						
				-- Workcat_id
				IF (NEW.varc_workcat_id IS NULL) THEN
					NEW.varc_workcat_id := (SELECT workcat_vdefault FROM config);
					IF (NEW.varc_workcat_id IS NULL) THEN
						NEW.varc_workcat_id := (SELECT id FROM cat_work limit 1);
					END IF;
				END IF;
				
				-- Builtdate
				IF (NEW.pipe_builtdate IS NULL) THEN
					NEW.pipe_builtdate := (SELECT builtdate_vdefault FROM config);
				END IF;
				
				INSERT INTO arc (arc_id, node_1,node_2, arccat_id, epa_type, sector_id, "state", annotation, observ,"comment",custom_length,dma_id, soilcat_id, category_type, fluid_type, location_type,
					workcat_id, buildercat_id, builtdate,ownercat_id, adress_01,adress_02,adress_03,descript,rotation,link,verified,the_geom,undelete,workcat_id_end,label_x,label_y,label_rotation, 
					publish, inventory, end_date, expl_id)
					VALUES (NEW.arc_id, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW."state", NEW.varc_annotation, NEW.varc_observ, NEW.varc_comment, NEW.varc_custom_length,NEW.dma_id,NEW.varc_soilcat_id, 
					NEW.varc_category_type, NEW.varc_fluid_type, NEW.varc_location_type, NEW.varc_workcat_id, NEW.varc_buildercat_id, NEW.varc_builtdate,NEW.varc_ownercat_id, NEW.varc_adress_01, NEW.varc_adress_02, NEW.varc_adress_03, 
					NEW.varc_descript, NEW.varc_rotation, NEW.varc_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.varc_workcat_id_end, NEW.varc_label_x,NEW.varc_label_y,NEW.varc_label_rotation, 
					NEW.publish, NEW.inventory, NEW.varc_end_date, expl_id_int);
				
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
     
		PERFORM audit_function(1,340); 
        RETURN NEW;
    
    ELSIF TG_OP = 'UPDATE' THEN

    
        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'PIPE') THEN
                inp_table:= 'inp_pipe';            
                v_sql:= 'DELETE FROM '||inp_table||' WHERE arc_id = '||quote_literal(OLD.arc_id);
                EXECUTE v_sql;
            END IF;

            IF (NEW.epa_type = 'PIPE') THEN
                inp_table:= 'inp_pipe';   
                v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
                EXECUTE v_sql;
            END IF;

        END IF;
		
		
		IF man_table='man_pipe' THEN
			UPDATE arc 
			SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.pipe_annotation, "observ"=NEW.pipe_observ, 
				"comment"=NEW.pipe_comment, custom_length=NEW.pipe_custom_length, dma_id=NEW.dma_id, soilcat_id=NEW.pipe_soilcat_id, category_type=NEW.pipe_category_type, fluid_type=NEW.pipe_fluid_type, 
				location_type=NEW.pipe_location_type, workcat_id=NEW.pipe_workcat_id, buildercat_id=NEW.pipe_buildercat_id, builtdate=NEW.pipe_builtdate,
				ownercat_id=NEW.pipe_ownercat_id, adress_01=NEW.pipe_adress_01, adress_02=NEW.pipe_adress_02, adress_03=NEW.pipe_adress_03, descript=NEW.pipe_descript,
				rotation=NEW.pipe_rotation, link=NEW.pipe_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.pipe_workcat_id_end,undelete=NEW.undelete, label_x=NEW.pipe_label_x,
				label_y=NEW.pipe_label_y,label_rotation=NEW.pipe_label_rotation, publish=NEW.publish, inventory=NEW.inventory, end_date=NEW.pipe_end_date
			WHERE arc_id=OLD.arc_id;
			
			UPDATE man_pipe
			SET arc_id=NEW.arc_id
			WHERE arc_id=OLD.arc_id;
			
		ELSIF man_table='man_varc' THEN
			UPDATE arc
			SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW."state", annotation= NEW.varc_annotation, "observ"=NEW.varc_observ, 
				"comment"=NEW.varc_comment, custom_length=NEW.varc_custom_length, dma_id=NEW.dma_id, soilcat_id=NEW.varc_soilcat_id, category_type=NEW.varc_category_type, fluid_type=NEW.varc_fluid_type, 
				location_type=NEW.varc_location_type, workcat_id=NEW.varc_workcat_id, buildercat_id=NEW.varc_buildercat_id, builtdate=NEW.varc_builtdate,
				ownercat_id=NEW.varc_ownercat_id, adress_01=NEW.varc_adress_01, adress_02=NEW.varc_adress_02, adress_03=NEW.varc_adress_03, descript=NEW.varc_descript,
				rotation=NEW.varc_rotation, link=NEW.varc_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.varc_workcat_id_end,undelete=NEW.undelete, label_x=NEW.varc_label_x,
				label_y=NEW.varc_label_y,label_rotation=NEW.varc_label_rotation, publish=NEW.publish, inventory=NEW.inventory, end_date=NEW.varc_end_date
			WHERE arc_id=OLD.arc_id;
			
			UPDATE man_varc
			SET arc_id=NEW.arc_id
			WHERE arc_id=OLD.arc_id;	
			
		END IF;
		
        PERFORM audit_function(2,340); 
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN   
        DELETE FROM arc WHERE arc_id = OLD.arc_id;
        PERFORM audit_function(3,340); 
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
      