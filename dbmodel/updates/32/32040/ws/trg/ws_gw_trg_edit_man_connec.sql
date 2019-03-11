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
	P_man_table varchar;
	new_man_table varchar;
	old_man_table varchar;
    connec_id_seq int8;
	code_autofill_bool boolean;
	P_man_table_2 varchar;
	count_aux integer;
	promixity_buffer_aux double precision;
	v_addfields record;
	v_customfeature text;
	v_id_last int8;
	v_parameter_name text;
	v_new_value_param text;
	v_old_value_param text;
	insert_double_geometry_aux boolean;
	buffer_value_aux double precision;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    v_customfeature = TG_ARGV[0];

	EXECUTE 'SELECT man_table FROM connec_type WHERE id=$1'
	INTO p_man_table
	USING v_customfeature;

	p_man_table_2:=P_man_table;
	
	--Get data from config table
	promixity_buffer_aux = (SELECT "value" FROM config_param_system WHERE "parameter"='proximity_buffer');
	insert_double_geometry_aux = (SELECT "value" FROM config_param_system WHERE "parameter"='insert_double_geometry');
	buffer_value_aux= (SELECT "value" FROM config_param_system WHERE "parameter"='buffer_value');

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
				RETURN audit_function(1022,1316);
			END IF;
			
			IF (NEW.connecat_id IS NULL) THEN
				NEW.connecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"=lower(concat(v_customfeature,'_vdefault')) AND "cur_user"="current_user"() LIMIT 1);
				IF (NEW.connecat_id IS NULL) THEN
					PERFORM audit_function(1086,1316);
				END IF;	
			END IF;
						
			IF (NEW.connecat_id NOT IN (select cat_connec.id FROM cat_connec JOIN connec_type ON cat_connec.connectype_id=connec_type.id WHERE connec_type.man_table=p_man_table_2)) THEN 
				PERFORM audit_function(1088,1316);
			END IF;
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1316);  
			END IF;
				SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.sector_id =(SELECT sector_id FROM ve_node WHERE ST_DWithin(NEW.the_geom, ve_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, ve_node.the_geom) LIMIT 1);
			END IF;	
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1316,NEW.connec_id);          
            END IF;            
        END IF;
        
	-- Dma ID
        IF (NEW.dma_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1316);  
            END IF;
				SELECT count(*)into count_aux FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.dma_id =(SELECT dma_id FROM ve_node WHERE ST_DWithin(NEW.the_geom, ve_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, ve_node.the_geom) LIMIT 1);
			END IF;
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1316,NEW.connec_id);  
            END IF;            
        END IF;

	    -- State	
		IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- State_type
		IF (NEW.state_type IS NULL) THEN
			NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='statetype_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
	
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Presszone
        IF (NEW.presszonecat_id IS NULL) THEN
            NEW.presszonecat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='presszone_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1316,NEW.connec_id);
				END IF;		
			END IF;
		END IF;

		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
				IF (NEW.muni_id IS NULL) THEN
					PERFORM audit_function(2024,1316,NEW.connec_id);
				END IF;	
			END IF;
		END IF;
		
		-- Workcat_id
		IF (NEW.workcat_id IS NULL) THEN
			NEW.workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
		
		-- Ownercat_id
        IF (NEW.ownercat_id IS NULL) THEN
            NEW.ownercat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='ownercat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
		
		-- Soilcat_id
        IF (NEW.soilcat_id IS NULL) THEN
            NEW.soilcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='soilcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
        END IF;
			
		--Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;

		--Copy id to code field
		IF (NEW.code IS NULL AND code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.connec_id;
		END IF;	 

		
        -- FEATURE INSERT
		INSERT INTO connec (connec_id, code, elevation, depth,connecat_id,  sector_id, customer_code,  state, state_type, annotation, observ, comment,dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, 
		workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, muni_id, streetaxis_id, postcode, postcomplement, postcomplement2, descript, rotation,verified, the_geom, undelete, label_x,label_y,label_rotation,
		expl_id, publish, inventory,num_value, connec_length, arc_id) 
		VALUES (NEW.connec_id, NEW.code, NEW.elevation, NEW.depth, NEW.connecat_id, NEW.sector_id, NEW.customer_code,  NEW.state, NEW.state_type, NEW.annotation,   NEW.observ, NEW.comment, NEW.dma_id, NEW.presszonecat_id, NEW.soilcat_id, 
		NEW.function_type, NEW.category_type, NEW.fluid_type,  NEW.location_type, NEW.workcat_id, NEW.workcat_id_end,  NEW.buildercat_id, NEW.builtdate, NEW.enddate, NEW.ownercat_id, NEW.streetaxis2_id, NEW.postnumber, NEW.postnumber2, 
		NEW.muni_id, NEW.streetaxis_id, NEW.postcode, NEW.postcomplement, NEW.postcomplement2, NEW.descript, NEW.rotation, NEW.verified, NEW.the_geom,NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation,  NEW.expl_id, NEW.publish, NEW.inventory, NEW.num_value, NEW.connec_length, NEW.arc_id);
		 
		IF p_man_table='man_greentap' THEN
			INSERT INTO man_greentap (connec_id, linked_connec) VALUES(NEW.connec_id, NEW.linked_connec); 
		
		ELSIF p_man_table='man_fountain' THEN 
			IF (insert_double_geometry_aux IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
		
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Multi(ST_Envelope(ST_Buffer(connec.the_geom,buffer_value_aux))) from "SCHEMA_NAME".connec where connec_id=NEW.connec_id));
					
				INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name,  chlorinator, arq_patrimony, pol_id) 
				VALUES (NEW.connec_id, NEW.linked_connec, NEW.vmax, NEW.vtotal,NEW.container_number, NEW.pump_number, NEW.power, NEW.regulation_tank, NEW.name, 
				NEW.chlorinator, NEW.arq_patrimony, NEW.pol_id);
			
			ELSE
				INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name, chlorinator, arq_patrimony, pol_id) 
				VALUES (NEW.connec_id, NEW.linked_connec, NEW.vmax, NEW.vtotal,NEW.container_number, NEW.pump_number, NEW.power, NEW.regulation_tank, NEW.name, 
				NEW.chlorinator, NEW.arq_patrimony, NEW.pol_id);
			
			END IF;
		 
		ELSIF p_man_table='man_tap' THEN		
			INSERT INTO man_tap(connec_id, linked_connec, cat_valve, drain_diam, drain_exit, drain_gully, drain_distance, arq_patrimony, com_state) 
			VALUES (NEW.connec_id,  NEW.linked_connec, NEW.cat_valve,  NEW.drain_diam, NEW.drain_exit,  NEW.drain_gully, NEW.drain_distance, NEW.arq_patrimony, NEW.com_state);
		  
		ELSIF p_man_table='man_wjoin' THEN  
		 	INSERT INTO man_wjoin (connec_id, top_floor, cat_valve) 
			VALUES (NEW.connec_id, NEW.top_floor, NEW.cat_valve);
			
		END IF;		 
		

			-- man addfields insert
		FOR v_addfields IN SELECT * FROM man_addfields_parameter WHERE cat_feature_id = v_customfeature
		LOOP
			EXECUTE 'SELECT $1.' || v_addfields.idval
				USING NEW
				INTO v_new_value_param;

			IF v_new_value_param IS NOT NULL THEN
				EXECUTE 'INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES ($1, $2, $3)'
					USING NEW.connec_id, v_addfields.id, v_new_value_param;
			END IF;	
		END LOOP;

		RETURN NEW;

	
	ELSIF TG_OP = 'UPDATE' THEN

		-- UPDATE geom/dma/sector/expl_id
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom) AND geometrytype(NEW.the_geom)='POINT'  THEN
			UPDATE connec SET the_geom=NEW.the_geom WHERE connec_id = OLD.connec_id;
		
		ELSIF (NEW.the_geom IS DISTINCT FROM OLD.the_geom) AND geometrytype(NEW.the_geom)='MULTIPOLYGON'  THEN
			UPDATE polygon SET the_geom=NEW.the_geom WHERE pol_id = OLD.pol_id;
			NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
			NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
			NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);         			
        
		END IF;

         -- Looking for state control
        IF (NEW.state != OLD.state) THEN   
			PERFORM gw_fct_state_control('CONNEC', NEW.connec_id, NEW.state, TG_OP);	
		
		END IF;
		
		-- State_type
		IF NEW.state=0 AND OLD.state=1 THEN
			IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN
			NEW.state_type=(SELECT "value" FROM config_param_user WHERE parameter='statetype_end_vdefault' AND "cur_user"="current_user"() LIMIT 1);
				IF NEW.state_type IS NULL THEN
				NEW.state_type=(SELECT id from value_state_type WHERE state=0 LIMIT 1);
					IF NEW.state_type IS NULL THEN
					RETURN audit_function(2110,1318);
					END IF;
				END IF;
			END IF;
		END IF;

		
		UPDATE connec 
			SET code=NEW.code, elevation=NEW.elevation, "depth"=NEW.depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, customer_code=NEW.customer_code,
			"state"=NEW."state", state_type=NEW.state_type, annotation=NEW.annotation, observ=NEW.observ, "comment"=NEW.comment, rotation=NEW.rotation,dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id,
			soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, 
			workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, streetaxis2_id=NEW.streetaxis2_id, 
			postnumber=NEW.postnumber, postnumber2=NEW.postnumber2, muni_id=NEW.muni_id, streetaxis_id=NEW.streetaxis_id, postcode=NEW.postcode, descript=NEW.descript, verified=NEW.verified, 
			postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, undelete=NEW.undelete, label_x=NEW.label_x,label_y=NEW.label_y, label_rotation=NEW.label_rotation,
			publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value, connec_length=NEW.connec_length, arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
			
        IF p_man_table ='man_greentap' THEN
		    UPDATE man_greentap SET linked_connec=NEW.linked_connec
			WHERE connec_id=OLD.connec_id;
			
        ELSIF p_man_table ='man_wjoin' THEN
			UPDATE man_wjoin SET top_floor=NEW.top_floor,cat_valve=NEW.cat_valve
			WHERE connec_id=OLD.connec_id;
			
		ELSIF p_man_table ='man_tap' THEN
			UPDATE man_tap SET linked_connec=NEW.linked_connec, drain_diam=NEW.drain_diam,drain_exit=NEW.drain_exit,drain_gully=NEW.drain_gully,
			drain_distance=NEW.drain_distance, arq_patrimony=NEW.arq_patrimony, com_state=NEW.com_state
			WHERE connec_id=OLD.connec_id;
			
        ELSIF p_man_table ='man_fountain' THEN 			
			UPDATE man_fountain SET vmax=NEW.vmax,vtotal=NEW.vtotal,container_number=NEW.container_number,pump_number=NEW.pump_number,power=NEW.power,
			regulation_tank=NEW.regulation_tank,name=NEW.name,chlorinator=NEW.chlorinator, linked_connec=NEW.linked_connec, arq_patrimony=NEW.arq_patrimony,
			pol_id=NEW.pol_id
			WHERE connec_id=OLD.connec_id;	
			
		END IF;

			-- man addfields update
		FOR v_addfields IN SELECT * FROM man_addfields_parameter WHERE cat_feature_id = v_customfeature
		LOOP
			EXECUTE 'SELECT $1.' || v_addfields.idval
				USING NEW
				INTO v_new_value_param;
 
			EXECUTE 'SELECT $1.' || v_addfields.idval
				USING OLD
				INTO v_old_value_param;

			IF v_new_value_param IS NOT NULL THEN 

				EXECUTE 'INSERT INTO man_addfields_value(feature_id, parameter_id, value_param) VALUES ($1, $2, $3) 
					ON CONFLICT (feature_id, parameter_id)
					DO UPDATE SET value_param=$3 WHERE man_addfields_value.feature_id=$1 AND man_addfields_value.parameter_id=$2'
					USING NEW.connec_id, v_addfields.id, v_new_value_param;	

			ELSIF v_new_value_param IS NULL AND v_old_value_param IS NOT NULL THEN

				EXECUTE 'DELETE FROM man_addfields_value WHERE feature_id=$1 AND parameter_id=$2'
					USING NEW.connec_id, v_addfields.id;
			END IF;
		
		END LOOP;

        RETURN NEW;
    

	ELSIF TG_OP = 'DELETE' THEN
	
			PERFORM gw_fct_check_delete(OLD.connec_id, 'CONNEC');
		
			IF p_man_table ='man_fountain'  THEN
				DELETE FROM connec WHERE connec_id=OLD.connec_id;
				DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_fountain WHERE connec_id=OLD.connec_id );
			ELSE
				DELETE FROM connec WHERE connec_id = OLD.connec_id;
			END IF;		

				RETURN NULL;

	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


