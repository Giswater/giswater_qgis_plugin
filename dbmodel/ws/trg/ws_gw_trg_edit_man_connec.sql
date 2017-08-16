/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



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
	expl_id_int integer;
	code_autofill_bool boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- connec ID
        IF (NEW.connec_id IS NULL) THEN
            PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.connec_id:= (SELECT nextval('urn_id_seq'));
        END IF;

        -- connec Catalog ID
        IF (NEW.connecat_id IS NULL) THEN
            --PERFORM audit_function(150,350); 
            RETURN NULL;                   
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                PERFORM audit_function(115,440); 
                RETURN NULL;                     
            END IF;
            NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                PERFORM audit_function(120,440); 
                RETURN NULL;                     
            END IF;
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                PERFORM audit_function(125,440); 
                RETURN NULL;                         
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                PERFORM audit_function(130,440); 
                RETURN NULL;                     
            END IF;
        END IF;

	    -- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_vdefault WHERE "parameter"='state_vdefault' AND "user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
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
		
		SELECT code_autofill INTO code_autofill_bool FROM connec_type WHERE id=NEW.connec_type;
		
        -- FEATURE INSERT
		IF man_table='man_greentap' THEN

			-- Workcat_id
			IF (NEW.greentap_workcat_id IS NULL) THEN
				NEW.greentap_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.greentap_workcat_id IS NULL) THEN
					NEW.greentap_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;
			
			--Builtdate
				IF (NEW.greentap_builtdate IS NULL) THEN
					NEW.greentap_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
				END IF;

		--Copy id to code field
			IF (NEW.greentap_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.greentap_code=NEW.connec_id;
			END IF;
				
		  INSERT INTO connec (connec_id, code, elevation, "depth",connecat_id,  sector_id, customer_code, demand, "state", annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, 
		  workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, streetaxis_id, postnumber, descript, rotation, link,verified, the_geom, undelete, label_x,label_y,label_rotation,
		  expl_id, publish, inventory,num_value) 
		  VALUES (NEW.connec_id, NEW.greentap_code, NEW.greentap_elevation, NEW.greentap_depth, NEW.connecat_id, NEW.sector_id, NEW.greentap_customer_code,  NEW.greentap_demand, NEW."state", NEW.greentap_annotation, 
		  NEW.greentap_observ, NEW.greentap_comment, NEW.dma_id, NEW.presszonecat_id, NEW.greentap_soilcat_id, NEW.greentap_function_type, NEW.greentap_category_type, NEW.greentap_fluid_type, 
		  NEW.greentap_location_type, NEW.greentap_workcat_id, NEW.greentap_workcat_id_end,
		  NEW.greentap_buildercat_id, NEW.greentap_builtdate, NEW.greentap_enddate, NEW.greentap_ownercat_id, NEW.greentap_address_01, NEW.greentap_address_02, NEW.greentap_address_03, NEW.greentap_streetname, NEW.greentap_postnumber, 
		  NEW.greentap_descript, NEW.greentap_rotation, NEW.greentap_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.greentap_label_x,NEW.greentap_label_y,NEW.greentap_label_rotation, 
		  expl_id_int, NEW.publish, NEW.inventory, NEW.num_value );
		  
		  INSERT INTO man_greentap (connec_id, linked_connec) VALUES(NEW.connec_id, NEW.greentap_linked_connec); 
		  
		ELSIF man_table='man_fountain' THEN
					
			-- Workcat_id
			IF (NEW.fountain_workcat_id IS NULL) THEN
				NEW.fountain_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.fountain_workcat_id IS NULL) THEN
					NEW.fountain_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;
			
			--Builtdate
				IF (NEW.fountain_builtdate IS NULL) THEN
					NEW.fountain_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
				END IF;
		--Copy id to code field
			IF (NEW.fountain_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.fountain_code=NEW.connec_id;
			END IF;
			
		  INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id,customer_code, demand, "state", annotation, observ, "comment",,dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, 
		  workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, streetaxis_id, postnumber, descript, rotation, link,verified, the_geom, undelete,label_x,label_y,label_rotation, 
		  expl_id, publish, inventory,num_value) 
		  VALUES (NEW.connec_id, NEW.customer_code, NEW.fountain_elevation, NEW.fountain_depth, NEW.connecat_id, NEW.sector_id, NEW.fountain_customer_code, NEW.fountain_demand, NEW."state", NEW.fountain_annotation, 
		  NEW.fountain_observ, NEW.fountain_comment, NEW.dma_id, NEW.presszonecat_id, NEW.fountain_soilcat_id, NEW.fountain_function_type, NEW.fountain_category_type, NEW.fountain_fluid_type, NEW.fountain_location_type, NEW.fountain_workcat_id, 
		  NEW.fountain_workcat_id_end, NEW.fountain_buildercat_id, NEW.fountain_builtdate, NEW.fountain_enddate, NEW.fountain_ownercat_id, NEW.fountain_address_01, NEW.fountain_address_02, NEW.fountain_address_03, NEW.fountain_streetname, NEW.fountain_postnumber, 
		  NEW.fountain_descript, NEW.fountain_rotation, NEW.fountain_link, NEW.verified, NEW.the_geom, NEW.undelete, NEW.fountain_label_x,NEW.fountain_label_y,NEW.fountain_label_rotation, 
		  expl_id_int, NEW.publish, NEW.inventory, NEW.num_value);
		 
		 INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name, connection, chlorinator, arq_patrimony, the_geom_pol) 
		 VALUES (NEW.connec_id, NEW.fountain_vmax, NEW.fountain_linked_connec, NEW.fountain_vtotal,NEW.fountain_container_number, NEW.fountain_pump_number, NEW.fountain_power, NEW.fountain_regulation_tank, NEW.fountain_name, 
		 NEW.fountain_connection, NEW.fountain_chlorinator, NEW.fountain_arq_patrimony, NEW.the_geom_pol;
		 
		ELSIF man_table='man_tap' THEN
					
			-- Workcat_id
			IF (NEW.tap_workcat_id IS NULL) THEN
				NEW.tap_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.tap_workcat_id IS NULL) THEN
					NEW.tap_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
				IF (NEW.tap_builtdate IS NULL) THEN
					NEW.tap_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
				END IF;

			--Copy id to code field
			IF (NEW.tap_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.tap_code=NEW.connec_id;
			END IF;
				
		  INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id, customer_code, demand, "state", annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, 
		  location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, streetaxis_id, postnumber,descript, rotation, link,verified, the_geom,undelete,label_x,label_y,label_rotation, 
		  expl_id, publish, inventory,num_value) 
		  VALUES (NEW.connec_id, NEW.tap_code, NEW.tap_elevation, NEW.tap_depth, NEW.connecat_id, NEW.sector_id, NEW.tap_customer_code, NEW.tap_demand, NEW."state", NEW.tap_annotation, NEW.tap_observ, 
		  NEW.tap_comment, NEW.dma_id, NEW.presszonecat_id, NEW.tap_soilcat_id, NEW.tap_function_type, NEW.tap_category_type, NEW.tap_fluid_type, NEW.tap_location_type, NEW.tap_workcat_id, NEW.tap_workcat_id_end, NEW.tap_buildercat_id,
		  NEW.tap_builtdate, NEW.tap_enddate, NEW.tap_ownercat_id, NEW.tap_address_01, NEW.tap_address_02, NEW.tap_address_03, NEW.tap_streetname, NEW.tap_postnumber, NEW.tap_descript, NEW.tap_rotation, NEW.tap_link, 
		  NEW.verified, NEW.the_geom, NEW.undelete, NEW.tap_label_x,NEW.tap_label_y,NEW.tap_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.num_value);
		  
		  INSERT INTO man_tap(connec_id, linked_connec, cat_valve, drain_diam, drain_exit, drain_gully, drain_distance, arq_patrimony, com_state) 
		  VALUES (NEW.connec_id,  NEW.tap_linked_connec NEW.tap_cat_valve,  NEW.tap_drain_diam, NEW.tap_drain_exit,  NEW.tap_drain_gully, NEW.tap_drain_distance, NEW.tap_arq_patrimony, NEW.tap_com_state);
		  
		ELSIF man_table='man_wjoin' THEN  

			-- Workcat_id
			IF (NEW.wjoin_workcat_id IS NULL) THEN
				NEW.wjoin_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.wjoin_workcat_id IS NULL) THEN
					NEW.wjoin_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
				IF (NEW.wjoin_builtdate IS NULL) THEN
					NEW.wjoin_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
				END IF;
	
		--Copy id to code field
			IF (NEW.wjoin_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wjoin_code=NEW.connec_id;
			END IF;
			
		  INSERT INTO connec(connec_id, code, elevation, "depth",connecat_id,  sector_id, customer_code,  demand, "state", annotation, observ, "comment",dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, 
		  location_type, workcat_id, workcat_id_end, buildercat_id, builtdate,enddate, ownercat_id, address_01, address_02, address_03, streetaxis_id, postnumber, descript,rotation, link,verified, the_geom,undelete, label_x,label_y,label_rotation,
		  expl_id, publish, inventory, num_value) 
		  VALUES (NEW.connec_id, NEW.wjoin_code, NEW.wjoin_elevation, NEW.wjoin_depth, NEW.connecat_id, NEW.sector_id, NEW.wjoin_customer_code,  NEW.wjoin_demand, NEW."state", NEW.wjoin_annotation, NEW.wjoin_observ, 
		  NEW.wjoin_comment, NEW.dma_id,NEW.presszonecat_id, NEW.wjoin_soilcat_id, NEW.wjoin_function_type, NEW.wjoin_category_type, NEW.wjoin_fluid_type, NEW.wjoin_location_type, NEW.wjoin_workcat_id, NEW.workcat_id_end, NEW.wjoin_buildercat_id, 
		  NEW.wjoin_builtdate, NEW.wjoin_enddate, NEW.wjoin_ownercat_id, NEW.wjoin_address_01, NEW.wjoin_address_02, NEW.wjoin_address_03, NEW.wjoin_streetname, NEW.wjoin_postnumber, NEW.wjoin_descript, NEW.wjoin_rotation, NEW.wjoin_link, NEW.verified, 
		  NEW.the_geom, NEW.undelete, NEW.wjoin_workcat_id_end,NEW.wjoin_label_x,NEW.wjoin_label_y,NEW.wjoin_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.num_value); 
		 
		 INSERT INTO man_wjoin (connec_id, top_floor, cat_valve) 
		 VALUES (NEW.connec_id, NEW.wjoin_top_floor, NEW.wjoin_cat_valve);
		 
		END IF;		 
		RETURN NEW;

	
	ELSIF TG_OP = 'UPDATE' THEN


    -- UPDATE management values
		IF (NEW.connec_type <> OLD.connec_type) THEN 
			new_man_table:= (SELECT connec_type.man_table FROM connec_type WHERE connec_type.id = NEW.connec_type);
			old_man_table:= (SELECT connec_type.man_table FROM connec_type WHERE connec_type.id = OLD.connec_type);
			IF new_man_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||old_man_table||' WHERE connec_id= '||quote_literal(OLD.connec_id);
				EXECUTE v_sql;
				v_sql2:= 'INSERT INTO '||new_man_table||' (connec_id) VALUES ('||quote_literal(NEW.connec_id)||')';
				EXECUTE v_sql2;
			END IF;
		END IF;

            
		-- MANAGEMENT UPDATE	
        IF man_table ='man_greentap' THEN
			UPDATE connec 
			SET connec_id=NEW.connec_id, code=NEW.greentap_code, elevation=NEW.greentap_elevation, "depth"=NEW.greentap_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, code_customer=NEW.greentap_code_customer, 
			demand=NEW.greentap_demand, "state"=NEW."state", annotation=NEW.greentap_annotation, observ=NEW.greentap_observ, "comment"=NEW.greentap_comment, rotation=NEW.greentap_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id,
			soilcat_id=NEW.greentap_soilcat_id, function_type=NEW.greentap_function_type, category_type=NEW.greentap_category_type, fluid_type=NEW.greentap_fluid_type, location_type=NEW.greentap_location_type, workcat_id=NEW.greentap_workcat_id, 
			workcat_id_end=NEW.greentap_workcat_id_end, buildercat_id=NEW.greentap_buildercat_id, builtdate=NEW.greentap_builtdate, enddate=NEW.greentap_enddate, ownercat_id=NEW.greentap_ownercat_id, address_01=NEW.greentap_address_01, 
			address_02=NEW.greentap_address_02, address_03=NEW.greentap_address_03, streetaxis_id=NEW.greentap_streetaxis_id, postnumber=NEW.greentap_postnumber, descript=NEW.greentap_descript, link=NEW.greentap_link, verified=NEW.verified, 
			the_geom=NEW.the_geom, undelete=NEW.undelete, label_x=NEW.greentap_label_x,label_y=NEW.greentap_label_y, label_rotation=NEW.greentap_label_rotation,
			 publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value
			WHERE connec_id=OLD.connec_id;
			
            UPDATE man_greentap 
			SET connec_id=NEW.connec_id, linked_connec=NEW.greentap_linked_connec
			WHERE connec_id=OLD.connec_id;
			
        ELSIF man_table ='man_wjoin' THEN
			UPDATE connec 
			SET connec_id=NEW.connec_id,code=NEW.wjoin_code, elevation=NEW.wjoin_elevation, "depth"=NEW.wjoin_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.wjoin_cutomer_code,
			demand=NEW.wjoin_demand, "state"=NEW."state", annotation=NEW.wjoin_annotation, observ=NEW.wjoin_observ, "comment"=NEW.wjoin_comment, rotation=NEW.wjoin_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id
			soilcat_id=NEW.wjoin_soilcat_id, category_type=NEW.wjoin_category_type, fluid_type=NEW.wjoin_fluid_type, location_type=NEW.wjoin_location_type, workcat_id=NEW.wjoin_workcat_id, workcat_id_end=NEW.wjoin_workcat_id_end,
			buildercat_id=NEW.wjoin_buildercat_id, builtdate=NEW.wjoin_builtdate,enddate=NEW.wjoin_enddate, ownercat_id=NEW.wjoin_ownercat_id, address_01=NEW.wjoin_address_01, address_02=NEW.wjoin_address_02, address_03=NEW.wjoin_address_03, 
			streetaxis_id=NEW.wjoin_streetaxis_id, postnumber=NEW.wjoin_postnumber, descript=NEW.wjoin_descript, link=NEW.wjoin_link, verified=NEW.verified, the_geom=NEW.the_geom, undelete=NEW.undelete, label_x=NEW.wjoin_label_x,label_y=NEW.wjoin_label_y, label_rotation=NEW.wjoin_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value
			WHERE connec_id=OLD.connec_id;
		
            UPDATE man_wjoin 
			SET connec_id=NEW.connec_id, top_floor=NEW.wjoin_top_floor,cat_valve=NEW.wjoin_cat_valve
			WHERE connec_id=OLD.connec_id;
			
		ELSIF man_table ='man_tap' THEN
			UPDATE connec 
			SET connec_id=NEW.connec_id, code=NEW.code, elevation=NEW.tap_elevation, "depth"=NEW.tap_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, code_customer=NEW.tap_code_customer, demand=NEW.tap_demand, 
			"state"=NEW."state", annotation=NEW.tap_annotation, observ=NEW.tap_observ, "comment"=NEW.tap_comment, rotation=NEW.tap_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.tap_soilcat_id, 
			function_type=NEW.function_type, category_type=NEW.tap_category_type, fluid_type=NEW.tap_fluid_type, location_type=NEW.tap_location_type, workcat_id=NEW.tap_workcat_id, workcat_id_end=NEW.tap_workcat_id_end, 
			buildercat_id=NEW.tap_buildercat_id, builtdate=NEW.tap_builtdate, enddate=NEW.tap_enddate, ownercat_id=NEW.tap_ownercat_id, address_01=NEW.tap_address_01, address_02=NEW.tap_address_02, address_03=NEW.tap_address_03, 
			streetaxis_id=NEW.tap_streetaxis_id, postnumber=NEW.tap_postnumber, descript=NEW.tap_descript, link=NEW.tap_link, verified=NEW.verified, the_geom=NEW.the_geom, undelete=NEW.undelete, label_x=NEW.tap_label_x,
			label_y=NEW.tap_label_y, label_rotation=NEW.tap_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value
			WHERE connec_id=OLD.connec_id;
			
            UPDATE man_tap 
			SET connec_id=NEW.connec_id, linked_connec=NEW.tap_linked_connec, drain_diam=NEW.tap_drain_diam,drain_exit=NEW.tap_drain_exit,drain_gully=NEW.tap_drain_gully,drain_distance=NEW.tap_drain_distance,
			arq_patrimony=NEW.tap_arq_patrimony, com_state=NEW.tap_com_state
			WHERE connec_id=OLD.connec_id;
			
        ELSIF man_table ='man_fountain' THEN
            UPDATE connec 
			SET connec_id=NEW.connec_id, code=NEW.code, elevation=NEW.fountain_elevation, "depth"=NEW.fountain_depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.fountain_customer_code, 
			demand=NEW.fountain_demand, "state"=NEW."state", annotation=NEW.fountain_annotation, observ=NEW.fountain_observ, "comment"=NEW.fountain_comment, rotation=NEW.fountain_rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id,
			soilcat_id=NEW.fountain_soilcat_id, function_type=NEW.fountain_function_type, category_type=NEW.fountain_category_type, fluid_type=NEW.fountain_fluid_type, location_type=NEW.fountain_location_type, workcat_id=NEW.fountain_workcat_id,
			buildercat_id=NEW.fountain_buildercat_id, builtdate=NEW.fountain_builtdate,ownercat_id=NEW.fountain_ownercat_id, address_01=NEW.fountain_address_01, address_02=NEW.fountain_address_02,
			address_03=NEW.fountain_address_03, streetaxis_id=NEW.fountain_streetaxis_id, postnumber=NEW.fountain_postnumber, descript=NEW.fountain_descript, link=NEW.fountain_link, verified=NEW.verified, 
			the_geom=NEW.the_geom, undelete=NEW.undelete, workcat_id_end=NEW.fountain_workcat_id_end, label_x=NEW.fountain_label_x,label_y=NEW.fountain_label_y, label_rotation=NEW.fountain_label_rotation, 
		    publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.fountain_enddate, expl_id=NEW.expl_id, num_value=NEW.num_value
			WHERE connec_id=OLD.connec_id;
			
			UPDATE man_fountain 
			SET connec_id=NEW.connec_id, vmax=NEW.fountain_vmax,vtotal=NEW.fountain_vtotal,container_number=NEW.fountain_container_number,pump_number=NEW.fountain_pump_number,power=NEW.fountain_power,
			regulation_tank=NEW.fountain_regulation_tank,name=NEW.fountain_name,connection=NEW.fountain_connection,chlorinator=NEW.fountain_chlorinator, linked_connec=NEW.fountain_linked_connec, arq_patrimony=NEW.fountain_arq_patrimony,
			the_geom_pol=NEW.the_geom_pol
			WHERE connec_id=OLD.connec_id;
		END IF;

        --PERFORM audit_function(2,350);     
        RETURN NEW;
    

    ELSIF TG_OP = 'DELETE' THEN

        DELETE FROM connec WHERE connec_id = OLD.connec_id;

        --PERFORM audit_function(3,350);     
        RETURN NULL;
   
    

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