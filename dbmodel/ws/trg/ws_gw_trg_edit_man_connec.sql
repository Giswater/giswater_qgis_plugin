/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1316

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_connec()
  RETURNS trigger AS
$BODY$

DECLARE 
    v_sql varchar;
    v_sql2 varchar;
	man_table varchar;
	new_man_table varchar;
	old_man_table varchar;
    connec_id_seq int8;
	code_autofill_bool boolean;
	man_table_2 varchar;
	rec Record;
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
	man_table_2:=man_table;
	
		--Get data from config table
	SELECT * INTO rec FROM config;	
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- connec ID
        IF (NEW.connec_id IS NULL) THEN
           -- PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.connec_id:= (SELECT nextval('urn_id_seq'));
        END IF;

        -- connec Catalog ID
        IF (NEW.connecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
				RETURN ' Please fill the table of cat_connec at least with one value';
			END IF;
			NEW.connecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='connecat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.connecat_id IS NULL) THEN
				PERFORM audit_function(1086,1316);
			END IF;				
			IF (NEW.connecat_id NOT IN (select cat_connec.id FROM cat_connec JOIN connec_type ON cat_connec.connectype_id=connec_type.id WHERE connec_type.man_table=man_table_2)) THEN 
				PERFORM audit_function(1088,1316);
			END IF;
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                PERFORM audit_function(1008,1316); 
                RETURN NULL;                     
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                PERFORM audit_function(1010,1316); 
                RETURN NULL;                     
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                PERFORM audit_function(1012,1316); 
                RETURN NULL;                         
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                PERFORM audit_function(1014,1316); 
                RETURN NULL;                     
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
	
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1316);
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
		
		--SELECT code_autofill INTO code_autofill_bool FROM connec_type WHERE id=NEW.connec_type;
		 
		
        -- FEATURE INSERT
		IF man_table='man_greentap' THEN

			-- Workcat_id
			IF (NEW.gr_workcat_id IS NULL) THEN
				NEW.gr_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.gr_workcat_id IS NULL) THEN
					NEW.gr_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;
			
			--Builtdate
				IF (NEW.gr_builtdate IS NULL) THEN
					NEW.gr_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;

		--Copy id to code field
			IF (NEW.gr_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.gr_code=NEW.connec_id;
			END IF;
				
		  INSERT INTO connec (connec_id, code, elevation, "depth",connecat_id,  sector_id, customer_code,  "state", state_type, annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id,		  function_type, category_type, fluid_type, location_type, 
		  workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode, descript, rotation,verified, the_geom, undelete, label_x,label_y,label_rotation,
		  expl_id, publish, inventory,num_value, connec_length, arc_id) 
		  VALUES (NEW.connec_id, NEW.gr_code, NEW.gr_elevation, NEW.gr_depth, NEW.connecat_id, NEW.sector_id, NEW.gr_customer_code,  NEW."state", NEW.state_type, NEW.gr_annotation, 
		  NEW.gr_observ, NEW.gr_comment, NEW.dma_id, NEW.presszonecat_id, NEW.gr_soilcat_id, NEW.gr_function_type, NEW.gr_category_type, NEW.gr_fluid_type, 
		  NEW.gr_location_type, NEW.gr_workcat_id, NEW.gr_workcat_id_end,
		  NEW.gr_buildercat_id, NEW.gr_builtdate, NEW.gr_enddate, NEW.gr_ownercat_id, NEW.gr_streetaxis2_id, NEW.gr_postnumber, NEW.gr_postnumber2, 
		  NEW.gr_muni_id, NEW.gr_streetaxis_id, NEW.gr_postcode, 
		  NEW.gr_descript, NEW.gr_rotation, NEW.verified, NEW.the_geom,NEW.undelete,NEW.gr_label_x,NEW.gr_label_y,NEW.gr_label_rotation, 
		  NEW.expl_id, NEW.publish, NEW.inventory, NEW.gr_num_value, NEW.gr_connec_length, NEW.arc_id);
		  
		  INSERT INTO man_greentap (connec_id, linked_connec) VALUES(NEW.connec_id, NEW.gr_linked_connec); 
		  
		ELSIF man_table='man_fountain' THEN
					
			-- Workcat_id
			IF (NEW.fo_workcat_id IS NULL) THEN
				NEW.fo_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.fo_workcat_id IS NULL) THEN
					NEW.fo_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;
			
			--Builtdate
				IF (NEW.fo_builtdate IS NULL) THEN
					NEW.fo_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
		--Copy id to code field
			IF (NEW.fo_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.fo_code=NEW.connec_id;
			END IF;
			
		  INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id,customer_code,  "state", state_type, annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, 
		  workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, 
		  expl_id, publish, inventory,num_value, connec_length, arc_id) 
		  VALUES (NEW.connec_id, NEW.fo_code, NEW.fo_elevation, NEW.fo_depth, NEW.connecat_id, NEW.sector_id, NEW.fo_customer_code, NEW."state", NEW.state_type, NEW.fo_annotation, 
		  NEW.fo_observ, NEW.fo_comment, NEW.dma_id, NEW.presszonecat_id, NEW.fo_soilcat_id, NEW.fo_function_type, NEW.fo_category_type, NEW.fo_fluid_type, NEW.fo_location_type, NEW.fo_workcat_id, 
		  NEW.fo_workcat_id_end, NEW.fo_buildercat_id, NEW.fo_builtdate, NEW.fo_enddate, NEW.fo_ownercat_id, NEW.fo_streetaxis2_id, NEW.fo_postnumber, 
		  NEW.fo_postnumber2, NEW.fo_muni_id, NEW.fo_streetaxis_id, NEW.fo_postcode, 
		  NEW.fo_descript, NEW.fo_rotation, NEW.verified, NEW.the_geom, NEW.undelete, NEW.fo_label_x,NEW.fo_label_y,NEW.fo_label_rotation, 
		  NEW.expl_id, NEW.publish, NEW.inventory, NEW.fo_num_value, NEW.fo_connec_length, NEW.arc_id);
		  
		 
		 IF (rec.insert_double_geometry IS TRUE) THEN
			IF (NEW.fo_pol_id IS NULL) THEN
					NEW.fo_pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
				
				INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name,  chlorinator, arq_patrimony, pol_id) 
				VALUES (NEW.connec_id, NEW.fo_linked_connec, NEW.fo_vmax, NEW.fo_vtotal,NEW.fo_container_number, NEW.fo_pump_number, NEW.fo_power, NEW.fo_regulation_tank, NEW.fo_name, 
				NEW.fo_chlorinator, NEW.fo_arq_patrimony, NEW.fo_pol_id);
				
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.fo_pol_id,(SELECT ST_Envelope(ST_Buffer(connec.the_geom,rec.buffer_value)) from "SCHEMA_NAME".connec where connec_id=NEW.connec_id));
			ELSE
				INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name, chlorinator, arq_patrimony, pol_id) 
				VALUES (NEW.connec_id, NEW.fo_linked_connec, NEW.fo_vmax, NEW.fo_vtotal,NEW.fo_container_number, NEW.fo_pump_number, NEW.fo_power, NEW.fo_regulation_tank, NEW.fo_name, 
				NEW.fo_chlorinator, NEW.fo_arq_patrimony, NEW.fo_pol_id);
			END IF;
		 
		ELSIF man_table='man_fountain_pol' THEN
							
					-- Workcat_id
					IF (NEW.fo_workcat_id IS NULL) THEN
						NEW.fo_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
						IF (NEW.fo_workcat_id IS NULL) THEN
							NEW.fo_workcat_id := (SELECT id FROM cat_work limit 1);
						END IF;
					END IF;
					
					--Builtdate
						IF (NEW.fo_builtdate IS NULL) THEN
							NEW.fo_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
						END IF;
				--Copy id to code field
					IF (NEW.fo_code IS NULL AND code_autofill_bool IS TRUE) THEN 
						NEW.fo_code=NEW.connec_id;
					END IF;
					 		 
				 IF (rec.insert_double_geometry IS TRUE) THEN
					IF (NEW.fo_pol_id IS NULL) THEN
						NEW.fo_pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
					
					INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name, chlorinator, arq_patrimony, pol_id) 
					VALUES (NEW.connec_id, NEW.fo_linked_connec, NEW.fo_vmax, NEW.fo_vtotal,NEW.fo_container_number, NEW.fo_pump_number, NEW.fo_power, NEW.fo_regulation_tank, NEW.fo_name, 
					NEW.fo_chlorinator, NEW.fo_arq_patrimony, NEW.fo_pol_id);
				 
					INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.fo_pol_id,NEW.the_geom);
					
				
				INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id,customer_code,  "state", state_type, annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, 
				  workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, 
				  expl_id, publish, inventory,num_value, connec_length, arc_id) 
				  VALUES (NEW.connec_id, NEW.fo_code, NEW.fo_elevation, NEW.fo_depth, NEW.connecat_id, NEW.sector_id, NEW.fo_customer_code, NEW."state", NEW.state_type, NEW.fo_annotation, 
				  NEW.fo_observ, NEW.fo_comment, NEW.dma_id, NEW.presszonecat_id, NEW.fo_soilcat_id, NEW.fo_function_type, NEW.fo_category_type, NEW.fo_fluid_type, NEW.fo_location_type, NEW.fo_workcat_id, 
				  NEW.fo_workcat_id_end, NEW.fo_buildercat_id, NEW.fo_builtdate, NEW.fo_enddate, NEW.fo_ownercat_id, NEW.fo_streetaxis2_id, NEW.fo_postcode,
				  NEW.fo_postnumber2, NEW.fo_muni_id, NEW.fo_streetaxis_id, NEW.fo_postnumber, 
				  NEW.fo_descript, NEW.fo_rotation, NEW.verified, (SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.fo_pol_id), NEW.undelete, NEW.fo_label_x,NEW.fo_label_y,NEW.fo_label_rotation, 
				  NEW.expl_id, NEW.publish, NEW.inventory, NEW.fo_num_value, NEW.fo_connec_length, NEW.arc_id);
				  
				END IF;
			
		ELSIF man_table='man_tap' THEN
					
			-- Workcat_id
			IF (NEW.tp_workcat_id IS NULL) THEN
				NEW.tp_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.tp_workcat_id IS NULL) THEN
					NEW.tp_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
				IF (NEW.tp_builtdate IS NULL) THEN
					NEW.tp_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;

			--Copy id to code field
			IF (NEW.tp_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.tp_code=NEW.connec_id;
			END IF;
				
		  INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id, customer_code,  "state", state_type, annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, 
		  location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode,descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, 
		  expl_id, publish, inventory,num_value, connec_length, arc_id) 
		  VALUES (NEW.connec_id, NEW.tp_code, NEW.tp_elevation, NEW.tp_depth, NEW.connecat_id, NEW.sector_id, NEW.tp_customer_code, NEW."state", NEW.state_type, NEW.tp_annotation, NEW.tp_observ, 
		  NEW.tp_comment, NEW.dma_id, NEW.presszonecat_id, NEW.tp_soilcat_id, NEW.tp_function_type, NEW.tp_category_type, NEW.tp_fluid_type, NEW.tp_location_type, NEW.tp_workcat_id, NEW.tp_workcat_id_end, NEW.tp_buildercat_id,
		  NEW.tp_builtdate, NEW.tp_enddate, NEW.tp_ownercat_id, NEW.tp_streetaxis2_id, NEW.tp_postnumber, NEW.tp_postnumber2, NEW.tp_muni_id, NEW.tp_streetaxis_id, NEW.tp_postcode, NEW.tp_descript, NEW.tp_rotation, 
		  NEW.verified, NEW.the_geom, NEW.undelete, NEW.tp_label_x,NEW.tp_label_y,NEW.tp_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.tp_num_value, NEW.tp_connec_length, NEW.arc_id);
		  
		  INSERT INTO man_tap(connec_id, linked_connec, cat_valve, drain_diam, drain_exit, drain_gully, drain_distance, arq_patrimony, com_state) 
		  VALUES (NEW.connec_id,  NEW.tp_linked_connec, NEW.tp_cat_valve,  NEW.tp_drain_diam, NEW.tp_drain_exit,  NEW.tp_drain_gully, NEW.tp_drain_distance, NEW.tp_arq_patrimony, NEW.tp_com_state);
		  
		ELSIF man_table='man_wjoin' THEN  

			-- Workcat_id
			IF (NEW.wj_workcat_id IS NULL) THEN
				NEW.wj_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.wj_workcat_id IS NULL) THEN
					NEW.wj_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
				IF (NEW.wj_builtdate IS NULL) THEN
					NEW.wj_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
	
		--Copy id to code field
			IF (NEW.wj_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wj_code=NEW.connec_id;
			END IF;
			
		  INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id, customer_code,   "state", state_type, annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, 
		  location_type, workcat_id, workcat_id_end, buildercat_id, builtdate,enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode, descript,rotation,verified, the_geom,undelete, label_x,label_y,label_rotation,
		  expl_id, publish, inventory, num_value, connec_length, arc_id) 
		  VALUES (NEW.connec_id, NEW.wj_code, NEW.wj_elevation, NEW.wj_depth, NEW.connecat_id, NEW.sector_id, NEW.wj_customer_code,  NEW."state", NEW.state_type, NEW.wj_annotation, NEW.wj_observ, 
		  NEW.wj_comment, NEW.dma_id,NEW.presszonecat_id, NEW.wj_soilcat_id, NEW.wj_function_type, NEW.wj_category_type, NEW.wj_fluid_type, NEW.wj_location_type, NEW.wj_workcat_id, NEW.wj_workcat_id_end, NEW.wj_buildercat_id, 
		  NEW.wj_builtdate, NEW.wj_enddate, NEW.wj_ownercat_id, NEW.wj_streetaxis2_id, NEW.wj_postnumber, NEW.wj_postnumber2, NEW.wj_muni_id, NEW.wj_streetaxis_id, NEW.wj_postcode, NEW.wj_descript, NEW.wj_rotation,  NEW.verified, 
		  NEW.the_geom, NEW.undelete, NEW.wj_label_x,NEW.wj_label_y,NEW.wj_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.wj_num_value, NEW.wj_connec_length, NEW.arc_id); 
		 
		 INSERT INTO man_wjoin (connec_id, top_floor, cat_valve) 
		 VALUES (NEW.connec_id, NEW.wj_top_floor, NEW.wj_cat_valve);
		 
		END IF;		 
		RETURN NEW;

	
	ELSIF TG_OP = 'UPDATE' THEN


    -- UPDATE management values
		/*IF (NEW.connec_type <> OLD.connec_type) THEN 
			new_man_table:= (SELECT connec_type.man_table FROM connec_type WHERE connec_type.id = NEW.connec_type);
			old_man_table:= (SELECT connec_type.man_table FROM connec_type WHERE connec_type.id = OLD.connec_type);
			IF new_man_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||old_man_table||' WHERE connec_id= '||quote_literal(OLD.connec_id);
				EXECUTE v_sql;
				v_sql2:= 'INSERT INTO '||new_man_table||' (connec_id) VALUES ('||quote_literal(NEW.connec_id)||')';
				EXECUTE v_sql2;
			END IF;
		END IF;
*/
            
		-- MANAGEMENT UPDATE	

       -- UPDATE geom/dma/sector/expl_id
        IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)THEN   
		UPDATE connec SET the_geom=NEW.the_geom;
		NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
		NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
		NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);         			
        END IF;

         -- Looking for state control
        IF (NEW.state != OLD.state) THEN   
		PERFORM gw_fct_state_control('CONNEC', NEW.connec_id, NEW.state, TG_OP);	
 	END IF;
		
        IF man_table ='man_greentap' THEN
			UPDATE connec 
			SET code=NEW.gr_code, elevation=NEW.gr_elevation, "depth"=NEW.gr_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.gr_customer_code,
			"state"=NEW."state", state_type=NEW.state_type, annotation=NEW.gr_annotation, observ=NEW.gr_observ, "comment"=NEW.gr_comment, rotation=NEW.gr_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id,
			soilcat_id=NEW.gr_soilcat_id, function_type=NEW.gr_function_type, category_type=NEW.gr_category_type, fluid_type=NEW.gr_fluid_type, location_type=NEW.gr_location_type, workcat_id=NEW.gr_workcat_id, 
			workcat_id_end=NEW.gr_workcat_id_end, buildercat_id=NEW.gr_buildercat_id, builtdate=NEW.gr_builtdate, enddate=NEW.gr_enddate, ownercat_id=NEW.gr_ownercat_id, streetaxis2_id=NEW.gr_streetaxis2_id, 
			postnumber=NEW.gr_postnumber, postnumber2=NEW.gr_postnumber2, muni_id=NEW.gr_muni_id, streetaxis_id=NEW.gr_streetaxis_id, postcode=NEW.gr_postcode, descript=NEW.gr_descript, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.gr_label_x,label_y=NEW.gr_label_y, label_rotation=NEW.gr_label_rotation,
			 publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.gr_num_value, connec_length=NEW.gr_connec_length, arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
			
            UPDATE man_greentap 
			SET linked_connec=NEW.gr_linked_connec
			WHERE connec_id=OLD.connec_id;
			
        ELSIF man_table ='man_wjoin' THEN
			UPDATE connec 
			SET code=NEW.wj_code, elevation=NEW.wj_elevation, "depth"=NEW.wj_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.wj_customer_code,
			"state"=NEW."state", state_type=NEW.state_type, annotation=NEW.wj_annotation, observ=NEW.wj_observ, "comment"=NEW.wj_comment, rotation=NEW.wj_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id,
			soilcat_id=NEW.wj_soilcat_id, category_type=NEW.wj_category_type, fluid_type=NEW.wj_fluid_type, location_type=NEW.wj_location_type, workcat_id=NEW.wj_workcat_id, workcat_id_end=NEW.wj_workcat_id_end,
			buildercat_id=NEW.wj_buildercat_id, builtdate=NEW.wj_builtdate,enddate=NEW.wj_enddate, ownercat_id=NEW.wj_ownercat_id, streetaxis2_id=NEW.wj_streetaxis2_id, 
			postnumber=NEW.wj_postnumber, postnumber2=NEW.wj_postnumber2, muni_id=NEW.wj_muni_id, 
			streetaxis_id=NEW.wj_streetaxis_id, postcode=NEW.wj_postcode, descript=NEW.wj_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.wj_label_x,label_y=NEW.wj_label_y, 
			label_rotation=NEW.wj_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.wj_num_value, connec_length=NEW.wj_connec_length, arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
		
            UPDATE man_wjoin 
			SET top_floor=NEW.wj_top_floor,cat_valve=NEW.wj_cat_valve
			WHERE connec_id=OLD.connec_id;
			
		ELSIF man_table ='man_tap' THEN
			UPDATE connec 
			SET code=NEW.tp_code, elevation=NEW.tp_elevation, "depth"=NEW.tp_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.tp_customer_code, 
			"state"=NEW."state", state_type=NEW.state_type, annotation=NEW.tp_annotation, observ=NEW.tp_observ, "comment"=NEW.tp_comment, rotation=NEW.tp_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.tp_soilcat_id, 
			function_type=NEW.tp_function_type, category_type=NEW.tp_category_type, fluid_type=NEW.tp_fluid_type, location_type=NEW.tp_location_type, workcat_id=NEW.tp_workcat_id, workcat_id_end=NEW.tp_workcat_id_end, 
			buildercat_id=NEW.tp_buildercat_id, builtdate=NEW.tp_builtdate, enddate=NEW.tp_enddate, ownercat_id=NEW.tp_ownercat_id, streetaxis2_id=NEW.tp_streetaxis2_id, 
			postnumber=NEW.tp_postnumber, postnumber2=NEW.tp_postnumber2, muni_id=NEW.tp_muni_id, 
			streetaxis_id=NEW.tp_streetaxis_id, postcode=NEW.tp_postcode, descript=NEW.tp_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.tp_label_x,
			label_y=NEW.tp_label_y, label_rotation=NEW.tp_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.tp_num_value, connec_length=NEW.tp_connec_length, arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
			
            UPDATE man_tap 
			SET linked_connec=NEW.tp_linked_connec, drain_diam=NEW.tp_drain_diam,drain_exit=NEW.tp_drain_exit,drain_gully=NEW.tp_drain_gully,drain_distance=NEW.tp_drain_distance,
			arq_patrimony=NEW.tp_arq_patrimony, com_state=NEW.tp_com_state
			WHERE connec_id=OLD.connec_id;
			
        ELSIF man_table ='man_fountain' THEN
            UPDATE connec 
			SET code=NEW.fo_code, elevation=NEW.fo_elevation, "depth"=NEW.fo_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.fo_customer_code, 
			"state"=NEW."state", state_type=NEW.state_type, annotation=NEW.fo_annotation, observ=NEW.fo_observ, "comment"=NEW.fo_comment, rotation=NEW.fo_rotation,dma_id=NEW.dma_id, 
			presszonecat_id=NEW.presszonecat_id,soilcat_id=NEW.fo_soilcat_id, function_type=NEW.fo_function_type, category_type=NEW.fo_category_type, fluid_type=NEW.fo_fluid_type, location_type=NEW.fo_location_type, 
			workcat_id=NEW.fo_workcat_id, buildercat_id=NEW.fo_buildercat_id, builtdate=NEW.fo_builtdate,ownercat_id=NEW.fo_ownercat_id, streetaxis2_id=NEW.fo_streetaxis2_id, postnumber=NEW.fo_postnumber,
			postnumber2=NEW.fo_postnumber2, muni_id=NEW.fo_muni_id, streetaxis_id=NEW.fo_streetaxis_id, postcode=NEW.fo_postcode, descript=NEW.fo_descript, verified=NEW.verified, 
			undelete=NEW.undelete, workcat_id_end=NEW.fo_workcat_id_end, label_x=NEW.fo_label_x,label_y=NEW.fo_label_y, label_rotation=NEW.fo_label_rotation, 
		    publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.fo_enddate, expl_id=NEW.expl_id, num_value=NEW.fo_num_value, connec_length=NEW.fo_connec_length, arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
			
			UPDATE man_fountain 
			SET vmax=NEW.fo_vmax,vtotal=NEW.fo_vtotal,container_number=NEW.fo_container_number,pump_number=NEW.fo_pump_number,power=NEW.fo_power,
			regulation_tank=NEW.fo_regulation_tank,name=NEW.fo_name,chlorinator=NEW.fo_chlorinator, linked_connec=NEW.fo_linked_connec, arq_patrimony=NEW.fo_arq_patrimony,
			pol_id=NEW.fo_pol_id
			WHERE connec_id=OLD.connec_id;

        ELSIF man_table ='man_fountain_pol' THEN
            UPDATE connec 
			SET code=NEW.fo_code, elevation=NEW.fo_elevation, "depth"=NEW.fo_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.fo_customer_code, 
			"state"=NEW."state", state_type=NEW.state_type, annotation=NEW.fo_annotation, observ=NEW.fo_observ, "comment"=NEW.fo_comment, rotation=NEW.fo_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id,
			soilcat_id=NEW.fo_soilcat_id, function_type=NEW.fo_function_type, category_type=NEW.fo_category_type, fluid_type=NEW.fo_fluid_type, location_type=NEW.fo_location_type, workcat_id=NEW.fo_workcat_id,
			buildercat_id=NEW.fo_buildercat_id, builtdate=NEW.fo_builtdate,ownercat_id=NEW.fo_ownercat_id, streetaxis2_id=NEW.fo_streetaxis2_id, postnumber=NEW.fo_postnumber,
			postnumber2=NEW.fo_postnumber2, muni_id=NEW.fo_muni_id, streetaxis_id=NEW.fo_streetaxis_id, postcode=NEW.fo_postcode, descript=NEW.fo_descript, verified=NEW.verified, 
			undelete=NEW.undelete, workcat_id_end=NEW.fo_workcat_id_end, label_x=NEW.fo_label_x,label_y=NEW.fo_label_y, label_rotation=NEW.fo_label_rotation, 
		    publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.fo_enddate, expl_id=NEW.expl_id, num_value=NEW.fo_num_value, connec_length=NEW.fo_connec_length, arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
			
			UPDATE man_fountain 
			SET vmax=NEW.fo_vmax,vtotal=NEW.fo_vtotal,container_number=NEW.fo_container_number,pump_number=NEW.fo_pump_number,power=NEW.fo_power,
			regulation_tank=NEW.fo_regulation_tank,name=NEW.fo_name,chlorinator=NEW.fo_chlorinator, linked_connec=NEW.fo_linked_connec, arq_patrimony=NEW.fo_arq_patrimony,
			pol_id=NEW.fo_pol_id
			WHERE connec_id=OLD.connec_id;			
			
		IF (NEW.fo_pol_id IS NULL) THEN
				UPDATE man_fountain 
				SET vmax=NEW.fo_vmax,vtotal=NEW.fo_vtotal,container_number=NEW.fo_container_number,pump_number=NEW.fo_pump_number,power=NEW.fo_power,
				regulation_tank=NEW.fo_regulation_tank,name=NEW.fo_name,chlorinator=NEW.fo_chlorinator, linked_connec=NEW.fo_linked_connec, arq_patrimony=NEW.fo_arq_patrimony,
				pol_id=NEW.fo_pol_id
				WHERE connec_id=OLD.connec_id;	
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.fo_pol_id;
		ELSE
				UPDATE man_fountain 
				SET vmax=NEW.fo_vmax,vtotal=NEW.fo_vtotal,container_number=NEW.fo_container_number,pump_number=NEW.fo_pump_number,power=NEW.fo_power,
				regulation_tank=NEW.fo_regulation_tank,name=NEW.fo_name,chlorinator=NEW.fo_chlorinator, linked_connec=NEW.fo_linked_connec, arq_patrimony=NEW.fo_arq_patrimony,
				pol_id=NEW.fo_pol_id
				WHERE connec_id=OLD.connec_id;	
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.fo_pol_id
				WHERE pol_id=OLD.fo_pol_id;
		END IF;
			
			
		END IF;

        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN
	
		PERFORM gw_fct_check_delete(OLD.connec_id, 'CONNEC');
	
		IF man_table ='man_fountain'  THEN
					IF OLD.fo_pol_id IS NOT NULL THEN
						DELETE FROM polygon WHERE pol_id = OLD.fo_pol_id;
						DELETE FROM connec WHERE connec_id = OLD.connec_id;
					ELSE
					    DELETE FROM connec WHERE connec_id = OLD.connec_id;
					END IF;		
        RETURN NULL;
   
    

END IF;
END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_man_greentap ON "SCHEMA_NAME".v_edit_man_greentap;
CREATE TRIGGER gw_trg_edit_man_greentap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_greentap FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_greentap');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjoin ON "SCHEMA_NAME".v_edit_man_wjoin;
CREATE TRIGGER gw_trg_edit_man_wjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjoin FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_wjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tap ON "SCHEMA_NAME".v_edit_man_tap;
CREATE TRIGGER gw_trg_edit_man_tap INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tap FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_tap');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain ON "SCHEMA_NAME".v_edit_man_fountain;
CREATE TRIGGER gw_trg_edit_man_fountain INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_fountain FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_fountain');

DROP TRIGGER IF EXISTS gw_trg_edit_man_fountain_pol ON "SCHEMA_NAME".v_edit_man_fountain_pol;
CREATE TRIGGER gw_trg_edit_man_fountain_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_fountain_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_connec('man_fountain_pol');