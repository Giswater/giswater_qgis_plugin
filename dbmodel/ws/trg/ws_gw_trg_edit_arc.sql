/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_arc()
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
			NEW.arccat_id:= (SELECT "value" FROM config_vdefault WHERE "parameter"='arccat_vdefault' AND "user"="current_user"());
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
		
	    -- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_vdefault WHERE "parameter"='state_vdefault' AND "user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
		-- Workcat_id
        IF (NEW.workcat_id IS NULL) THEN
            NEW.workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
            IF (NEW.workcat_id IS NULL) THEN
                NEW.workcat_id := (SELECT id FROM cat_work limit 1);
            END IF;
        END IF;
		
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_vdefault WHERE "parameter"='verified_vdefault' AND "user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
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
		
		-- Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
		END IF;  
		
        -- Set EPA type
       NEW.epa_type = 'PIPE';        
    
        -- FEATURE INSERT
    		INSERT INTO arc (arc_id, node_1,node_2, arccat_id, epa_type, sector_id, "state", annotation, observ,"comment",custom_length,dma_id, soilcat_id, category_type, fluid_type, location_type,
					workcat_id, buildercat_id, builtdate,ownercat_id, adress_01,adress_02,adress_03,descript,rotation,link,verified,the_geom,undelete,workcat_id_end,label_x,label_y,label_rotation, 
					publish, inventory, end_date, expl_id)
					VALUES (NEW.arc_id, null, null, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.annotation, NEW.observ, NEW."comment", NEW.custom_length,NEW.dma_id,NEW.soilcat_id, 
					NEW.category_type, NEW.fluid_type, NEW.location_type, NEW.workcat_id, NEW.buildercat_id, NEW.builtdate,NEW.ownercat_id, NEW.adress_01, NEW.adress_02, NEW.adress_03, 
					NEW.descript, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.workcat_id_end, NEW.label_x,NEW.label_y,NEW.label_rotation, 
					NEW.publish, NEW.inventory, NEW.end_date, expl_id_int);

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
    
UPDATE arc 
			SET arc_id=NEW.arc_id, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation= NEW.annotation, "observ"=NEW.observ, 
				"comment"=NEW.comment, custom_length=NEW.custom_length, dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, category_type=NEW.category_type, fluid_type=NEW.fluid_type, 
				location_type=NEW.location_type, workcat_id=NEW.workcat_id, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate,
				ownercat_id=NEW.ownercat_id, adress_01=NEW.adress_01, adress_02=NEW.adress_02, adress_03=NEW.adress_03, descript=NEW.descript,
				rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.workcat_id_end,undelete=NEW.undelete, label_x=NEW.label_x,
				label_y=NEW.label_y,label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, end_date=NEW.end_date
			WHERE arc_id=OLD.arc_id;

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
  

DROP TRIGGER IF EXISTS gw_trg_edit_arc ON "SCHEMA_NAME".v_edit_arc;
CREATE TRIGGER gw_trg_edit_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();

/*
DROP TRIGGER IF EXISTS gw_trg_edit_plan_arc ON "SCHEMA_NAME".v_edit_plan_arc;
CREATE TRIGGER gw_trg_edit_plan_arc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_plan_arc
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_arc();
*/

      