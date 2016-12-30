/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/




CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_arc() RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    man_table varchar;
    new_man_table varchar;
    old_man_table varchar;
    v_sql varchar;
    v_sql2 varchar;
    man_table_2 varchar;
    arc_id_seq int8;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
	man_table_2:=man_table;

    IF TG_OP = 'INSERT' THEN   
		-- Arc ID
        IF (NEW.arc_id IS NULL) THEN
            SELECT max(arc_id) INTO arc_id_seq FROM arc WHERE arc_id ~ '^\d+$';
            PERFORM setval('arc_id_seq',arc_id_seq,true);
            NEW.arc_id:= (SELECT nextval('arc_id_seq'));
        END IF;

         -- Arc type
        IF (NEW.arc_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM arc_type) = 0) THEN
                RETURN audit_function(140,840);  
            END IF;
            NEW.arc_type:= (SELECT id FROM arc_type WHERE arc_type.man_table=man_table_2 LIMIT 1);   
        END IF;

         -- Epa type
        IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM arc_type WHERE arc_type.id=NEW.arc_type)::text;   
		END IF;
        
        -- Arc catalog ID
        IF (NEW.arccat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_arc) = 0) THEN
                RETURN audit_function(145,840); 
            END IF; 
        END IF;
        
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,840); 
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,840); 
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,840); 
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,840); 
            END IF;
        END IF;
    
        -- FEATURE INSERT
        
		
		IF man_table='man_conduit' THEN
			INSERT INTO arc (arc_id, node_1, node_2, y1, y2, arc_type, arccat_id, epa_type, sector_id, "state", annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, category_type, fluid_type,
			location_type, workcat_id, buildercat_id, builtdate, ownercat_id, adress_01, adress_02, adress_03, descript, est_y1, est_y2, rotation, link, verified, the_geom,workcat_id_end,undelete,label_x,label_y, 
			label_rotation) 
			VALUES (NEW.arc_id, null, null, NEW.conduit_y1, NEW.conduit_y2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.conduit_state, NEW.conduit_annotation, NEW.conduit_observ, NEW.conduit_comment, 
			NEW.conduit_inverted_slope, NEW.conduit_custom_length, NEW.dma_id, NEW.conduit_soilcat_id, NEW.conduit_category_type, NEW.conduit_fluid_type, NEW.conduit_location_type, NEW.conduit_workcat_id,
			NEW.conduit_buildercat_id, NEW.conduit_builtdate, NEW.conduit_ownercat_id, NEW.conduit_adress_01, NEW.conduit_adress_02, NEW.conduit_adress_03, NEW.conduit_descript, NEW.conduit_est_y1, NEW.conduit_est_y2,
			NEW.conduit_rotation, NEW.conduit_link, NEW.verified, NEW.the_geom,NEW.conduit_workcat_id_end,NEW.undelete,NEW.conduit_label_x,NEW.conduit_label_y, NEW.conduit_label_rotation);
			
			INSERT INTO man_conduit (arc_id,add_info) VALUES (NEW.arc_id, NEW.conduit_add_info);
		
		ELSIF man_table='man_siphon' THEN
			INSERT INTO arc (arc_id, node_1, node_2, y1, y2, arc_type, arccat_id, epa_type, sector_id, "state", annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, category_type, 
			fluid_type, location_type, workcat_id, buildercat_id, builtdate, ownercat_id, adress_01, adress_02, adress_03, descript, est_y1, est_y2, rotation, link, verified, the_geom,workcat_id_end,undelete,
			label_x,label_y, label_rotation) 
			VALUES (NEW.arc_id, null, null, NEW.siphon_y1, NEW.siphon_y2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.siphon_state, NEW.siphon_annotation, NEW.siphon_observ, NEW.siphon_comment,
			NEW.siphon_inverted_slope, NEW.siphon_custom_length, NEW.dma_id, NEW.siphon_soilcat_id, NEW.siphon_category_type, NEW.siphon_fluid_type, NEW.siphon_location_type, NEW.siphon_workcat_id,
			NEW.siphon_buildercat_id, NEW.siphon_builtdate, NEW.siphon_ownercat_id, NEW.siphon_adress_01, NEW.siphon_adress_02, NEW.siphon_adress_03, NEW.siphon_descript, NEW.siphon_est_y1, NEW.siphon_est_y2, 
			NEW.siphon_rotation, NEW.siphon_link, NEW.verified, NEW.the_geom,NEW.siphon_workcat_id_end,NEW.undelete,NEW.siphon_label_x,NEW.siphon_label_y, NEW.siphon_label_rotation);
			
			INSERT INTO man_siphon (arc_id,add_info, security_bar,steps,siphon_name) VALUES (NEW.arc_id, NEW.siphon_add_info, NEW.siphon_security_bar, NEW.siphon_steps,NEW.siphon_name);
			
		ELSIF man_table='man_waccel' THEN
			INSERT INTO arc (arc_id, node_1, node_2, y1, y2, arc_type, arccat_id, epa_type, sector_id, "state", annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, category_type, 
			fluid_type, location_type, workcat_id, buildercat_id, builtdate, ownercat_id, adress_01, adress_02, adress_03, descript, est_y1, est_y2, rotation, link, verified, the_geom,workcat_id_end,undelete,
			label_x,label_y, label_rotation)
			VALUES (NEW.arc_id, null, null, NEW.waccel_y1, NEW.waccel_y2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.waccel_state, NEW.waccel_annotation, NEW.waccel_observ, NEW.waccel_comment,
			NEW.waccel_inverted_slope, NEW.waccel_custom_length, NEW.dma_id, NEW.waccel_soilcat_id, NEW.waccel_category_type, NEW.waccel_fluid_type, NEW.waccel_location_type, NEW.waccel_workcat_id, 
			NEW.waccel_buildercat_id, NEW.waccel_builtdate, NEW.waccel_ownercat_id, NEW.waccel_adress_01, NEW.waccel_adress_02, NEW.waccel_adress_03, NEW.waccel_descript, NEW.waccel_est_y1, NEW.waccel_est_y2, 
			NEW.waccel_rotation, NEW.waccel_link, NEW.verified, NEW.the_geom,NEW.waccel_workcat_id_end,NEW.undelete,NEW.waccel_label_x,NEW.waccel_label_y, NEW.waccel_label_rotation);
			
			INSERT INTO man_waccel (arc_id, add_info, sander_length,sander_depth,security_bar,steps,prot_surface,waccel_name) 
			VALUES (NEW.arc_id, NEW.waccel_add_info, NEW.waccel_sander_length, NEW.waccel_sander_depth,NEW.waccel_security_bar, NEW.waccel_steps,NEW.waccel_prot_surface,NEW.waccel_name);
			
		ELSIF man_table='man_varc' THEN
			INSERT INTO arc (arc_id, node_1, node_2, y1, y2, arc_type, arccat_id, epa_type, sector_id, "state", annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, category_type, 
			fluid_type, location_type, workcat_id, buildercat_id, builtdate, ownercat_id, adress_01, adress_02, adress_03, descript, est_y1, est_y2, rotation, link, verified, the_geom,workcat_id_end,undelete,
			label_x,label_y, label_rotation) 
			VALUES (NEW.arc_id, null, null, NEW.varc_y1, NEW.varc_y2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.varc_state, NEW.varc_annotation, NEW.varc_observ, NEW.varc_comment, 
			NEW.varc_inverted_slope, NEW.varc_custom_length, NEW.dma_id, NEW.varc_soilcat_id, NEW.varc_category_type, NEW.varc_fluid_type, NEW.varc_location_type, NEW.varc_workcat_id, NEW.varc_buildercat_id, 
			NEW.varc_builtdate, NEW.varc_ownercat_id, NEW.varc_adress_01, NEW.varc_adress_02, NEW.varc_adress_03, NEW.varc_descript, NEW.varc_est_y1, NEW.varc_est_y2, NEW.varc_rotation, NEW.varc_link, 
			NEW.verified, NEW.the_geom,NEW.varc_workcat_id_end,NEW.undelete,NEW.varc_label_x,NEW.varc_label_y, NEW.varc_label_rotation);
			
			INSERT INTO man_varc (arc_id, add_info) VALUES (NEW.arc_id, NEW.varc_add_info);
			
		END IF;
						
						
        -- EPA INSERT
        IF (NEW.epa_type = 'CONDUIT') THEN 
            inp_table:= 'inp_conduit';
        ELSIF (NEW.epa_type = 'PUMP') THEN 
            inp_table:= 'inp_pump';
		ELSIF (NEW.epa_type = 'ORIFICE') THEN 
			inp_table:= 'inp_orifice';
		ELSIF (NEW.epa_type = 'WEIR') THEN 
            inp_table:= 'inp_weir';
		ELSIF (NEW.epa_type = 'OUTLET') THEN 
            inp_table:= 'inp_outlet';
        END IF;
        v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
        EXECUTE v_sql;
        
		RETURN NEW;
           
    ELSIF TG_OP = 'UPDATE' THEN

        IF (NEW.epa_type <> OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'CONDUIT') THEN 
            inp_table:= 'inp_conduit';
			ELSIF (OLD.epa_type = 'PUMP') THEN 
            inp_table:= 'inp_pump';
			ELSIF (OLD.epa_type = 'ORIFICE') THEN 
			inp_table:= 'inp_orifice';
			ELSIF (OLD.epa_type = 'WEIR') THEN 
            inp_table:= 'inp_weir';
			ELSIF (OLD.epa_type = 'OUTLET') THEN 
            inp_table:= 'inp_outlet';
			END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE arc_id = '||quote_literal(OLD.arc_id);
            EXECUTE v_sql;

			IF (NEW.epa_type = 'CONDUIT') THEN 
            inp_table:= 'inp_conduit';
			ELSIF (NEW.epa_type = 'PUMP') THEN 
			inp_table:= 'inp_pump';
			ELSIF (NEW.epa_type = 'ORIFICE') THEN 
			inp_table:= 'inp_orifice';
			ELSIF (NEW.epa_type = 'WEIR') THEN 
            inp_table:= 'inp_weir';
			ELSIF (NEW.epa_type = 'OUTLET') THEN 
            inp_table:= 'inp_outlet';
			END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
            EXECUTE v_sql;

        END IF;

     -- UPDATE management values
	IF (NEW.arc_type <> OLD.arc_type) THEN 
		new_man_table:= (SELECT arc_type.man_table FROM arc_type WHERE arc_type.id = NEW.arc_type);
		old_man_table:= (SELECT arc_type.man_table FROM arc_type WHERE arc_type.id = OLD.arc_type);
		IF new_man_table IS NOT NULL THEN
			v_sql:= 'DELETE FROM '||old_man_table||' WHERE arc_id= '||quote_literal(OLD.arc_id);
			EXECUTE v_sql;
			v_sql2:= 'INSERT INTO '||new_man_table||' (arc_id) VALUES ('||quote_literal(NEW.arc_id)||')';
			EXECUTE v_sql2;
		END IF;
	END IF;
    
       
		IF man_table='man_conduit' THEN
			UPDATE arc 
			SET arc_id=NEW.arc_id, y1=NEW.conduit_y1, y2=NEW.conduit_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.conduit_state, 
			annotation= NEW.conduit_annotation, "observ"=NEW.conduit_observ,"comment"=NEW.conduit_comment, inverted_slope=NEW.conduit_inverted_slope, custom_length=NEW.conduit_custom_length, dma_id=NEW.dma_id, 
			soilcat_id=NEW.conduit_soilcat_id, category_type=NEW.conduit_category_type, fluid_type=NEW.conduit_fluid_type,location_type=NEW.conduit_location_type, workcat_id=NEW.conduit_workcat_id, 
			buildercat_id=NEW.conduit_buildercat_id, builtdate=NEW.conduit_builtdate,ownercat_id=NEW.conduit_ownercat_id, adress_01=NEW.conduit_adress_01, adress_02=NEW.conduit_adress_02, 
			adress_03=NEW.conduit_adress_03, descript=NEW.conduit_descript,rotation=NEW.conduit_rotation, link=NEW.conduit_link, est_y1=NEW.conduit_est_y1, est_y2=NEW.conduit_est_y2, verified=NEW.verified, 
			the_geom=NEW.the_geom, undelete=NEW.undelete,label_x=NEW.conduit_label_x,label_y=NEW.conduit_label_y, label_rotation=NEW.conduit_label_rotation,workcat_id_end=NEW.conduit_workcat_id_end
			WHERE arc_id=OLD.arc_id;		
		
		
			UPDATE man_conduit SET arc_id=NEW.arc_id, add_info=NEW.conduit_add_info
			WHERE arc_id=OLD.arc_id;
		
		ELSIF man_table='man_siphon' THEN			
			UPDATE arc 
			SET arc_id=NEW.arc_id, y1=NEW.siphon_y1, y2=NEW.siphon_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.siphon_state, 
			annotation= NEW.siphon_annotation, "observ"=NEW.siphon_observ,"comment"=NEW.siphon_comment, inverted_slope=NEW.siphon_inverted_slope, custom_length=NEW.siphon_custom_length, dma_id=NEW.dma_id, 
			soilcat_id=NEW.siphon_soilcat_id, category_type=NEW.siphon_category_type, fluid_type=NEW.siphon_fluid_type,location_type=NEW.siphon_location_type, workcat_id=NEW.siphon_workcat_id, 
			buildercat_id=NEW.siphon_buildercat_id, builtdate=NEW.siphon_builtdate,ownercat_id=NEW.siphon_ownercat_id, adress_01=NEW.siphon_adress_01, adress_02=NEW.siphon_adress_02, adress_03=NEW.siphon_adress_03, 
			descript=NEW.siphon_descript,rotation=NEW.siphon_rotation, link=NEW.siphon_link, est_y1=NEW.siphon_est_y1, est_y2=NEW.siphon_est_y2, verified=NEW.verified, the_geom=NEW.the_geom, undelete=NEW.undelete,
			label_x=NEW.siphon_label_x,label_y=NEW.siphon_label_y, label_rotation=NEW.siphon_label_rotation,workcat_id_end=NEW.siphon_workcat_id_end
			WHERE arc_id=OLD.arc_id;		
			
			UPDATE man_siphon SET arc_id=NEW.arc_id,add_info=NEW.siphon_add_info,security_bar=NEW.siphon_security_bar, steps=NEW.siphon_steps,siphon_name=NEW.siphon_name
			WHERE arc_id=OLD.arc_id;
		
		ELSIF man_table='man_waccel' THEN
			UPDATE arc 
			SET arc_id=NEW.arc_id, y1=NEW.waccel_y1, y2=NEW.waccel_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.waccel_state, 
			annotation= NEW.waccel_annotation, "observ"=NEW.waccel_observ,"comment"=NEW.waccel_comment, inverted_slope=NEW.waccel_inverted_slope, custom_length=NEW.waccel_custom_length, dma_id=NEW.dma_id, 
			soilcat_id=NEW.waccel_soilcat_id, category_type=NEW.waccel_category_type, fluid_type=NEW.waccel_fluid_type,location_type=NEW.waccel_location_type, workcat_id=NEW.waccel_workcat_id, 
			buildercat_id=NEW.waccel_buildercat_id, builtdate=NEW.waccel_builtdate,ownercat_id=NEW.waccel_ownercat_id, adress_01=NEW.waccel_adress_01, adress_02=NEW.waccel_adress_02, adress_03=NEW.waccel_adress_03, 
			descript=NEW.waccel_descript,rotation=NEW.waccel_rotation, link=NEW.waccel_link, est_y1=NEW.waccel_est_y1, est_y2=NEW.waccel_est_y2, verified=NEW.verified, the_geom=NEW.the_geom, 
			undelete=NEW.undelete,label_x=NEW.waccel_label_x,label_y=NEW.waccel_label_y, label_rotation=NEW.waccel_label_rotation,workcat_id_end=NEW.waccel_workcat_id_end
			WHERE arc_id=OLD.arc_id;	
			
			UPDATE man_waccel SET arc_id=NEW.arc_id,add_info=NEW.waccel_add_info, sander_length=NEW.waccel_sander_length, sander_depth=NEW.waccel_sander_depth,security_bar=NEW.waccel_security_bar,
			steps=NEW.waccel_steps,prot_surface=NEW.waccel_prot_surface,waccel_name=NEW.waccel_name
			WHERE arc_id=OLD.arc_id;
		
		ELSIF man_table='man_varc' THEN
			UPDATE arc 
			SET arc_id=NEW.arc_id, y1=NEW.varc_y1, y2=NEW.varc_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.varc_state, 
			annotation= NEW.varc_annotation, "observ"=NEW.varc_observ,"comment"=NEW.varc_comment, inverted_slope=NEW.varc_inverted_slope, custom_length=NEW.varc_custom_length, dma_id=NEW.dma_id, 
			soilcat_id=NEW.varc_soilcat_id, category_type=NEW.varc_category_type, fluid_type=NEW.varc_fluid_type,location_type=NEW.varc_location_type, workcat_id=NEW.varc_workcat_id, 
			buildercat_id=NEW.varc_buildercat_id, builtdate=NEW.varc_builtdate,ownercat_id=NEW.varc_ownercat_id, adress_01=NEW.varc_adress_01, adress_02=NEW.varc_adress_02, adress_03=NEW.varc_adress_03, 
			descript=NEW.varc_descript,rotation=NEW.varc_rotation, link=NEW.varc_link, est_y1=NEW.varc_est_y1, est_y2=NEW.varc_est_y2, verified=NEW.verified, the_geom=NEW.the_geom, undelete=NEW.undelete,
			label_x=NEW.varc_label_x,label_y=NEW.varc_label_y, label_rotation=NEW.varc_label_rotation,workcat_id_end=NEW.varc_workcat_id_end
			WHERE arc_id=OLD.arc_id;		
			
			UPDATE man_conduit SET arc_id=NEW.arc_id, add_info=NEW.varc_add_info
			WHERE arc_id=OLD.arc_id;
		
		END IF;
		
		PERFORM audit_function (2,840);
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM arc WHERE arc_id = OLD.arc_id;

		PERFORM audit_function (3,840);
        RETURN NULL;
     
     END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




DROP TRIGGER IF EXISTS gw_trg_edit_man_conduit ON "SCHEMA_NAME".v_edit_man_conduit;
CREATE TRIGGER gw_trg_edit_man_conduit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_conduit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_conduit');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_siphon ON "SCHEMA_NAME".v_edit_man_siphon;
CREATE TRIGGER gw_trg_edit_man_siphon INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_siphon FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_siphon');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_waccel ON "SCHEMA_NAME".v_edit_man_waccel;
CREATE TRIGGER gw_trg_edit_man_waccel INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waccel FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_waccel'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_varc ON "SCHEMA_NAME".v_edit_man_varc;
CREATE TRIGGER gw_trg_edit_man_varc INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_varc FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_arc('man_varc'); 
      