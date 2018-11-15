/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- Function: "SCHEMA_NAME".gw_trg_edit_man_node()

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_custom_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    v_sql varchar;
    v_sql2 varchar;
    man_table varchar;
	man_table_2 varchar;
    new_man_table varchar;
    old_man_table varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    node_id_seq int8;
	rec Record;
	expl_id_int integer;
	code_autofill_bool boolean;
	rec_aux text;
	node_id_aux text;
	delete_aux text;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	man_table:= TG_ARGV[0];
	man_table_2:=man_table;
	
	--Get data from config table
	SELECT * INTO rec FROM config;	
	
-- INSERT

    -- Control insertions ID
	IF TG_OP = 'INSERT' THEN
	
    -- Node ID	
		IF (NEW.node_id IS NULL) THEN
			--PERFORM setval('urn_id_seq', gw_fct_urn(),true);
			NEW.node_id:= (SELECT nextval('urn_id_seq'));
		END IF;
	
	-- Node Catalog ID

		IF (NEW.nodecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
				RETURN audit_function(110,430);  
			END IF;
			NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='nodecat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.nodecat_id IS NULL) THEN
				RAISE EXCEPTION 'Please, fill the node catalog value or configure it with the value default parameter';
			END IF;				
			IF (NEW.nodecat_id NOT IN (select cat_node.id FROM cat_node JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE node_type.man_table=man_table_2)) THEN 
				RAISE EXCEPTION 'Your catalog is different than node type';
			END IF;

		END IF;
		
	-- Epa type
		IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM node JOIN cat_node ON cat_node.id =node.nodecat_id JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id LIMIT 1)::text;   
		END IF;
		
     -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,430);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,430);          
            END IF;            
        END IF;
        
     -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,430);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,430);  
            END IF;            
        END IF;
		
	-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;
		
		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
		
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
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

		SELECT code_autofill INTO code_autofill_bool FROM node JOIN cat_node ON cat_node.id =node.nodecat_id JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id ;   

-- FEATURE INSERT      
	IF man_table='man_tank' THEN
			
		-- Workcat_id
		IF (NEW.tank_workcat_id IS NULL) THEN
			NEW.tank_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.tank_workcat_id IS NULL) THEN
				NEW.tank_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.tank_builtdate IS NULL) THEN
			NEW.tank_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.tank_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.tank_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01,address_02, address_03, descript, rotation,verified,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, the_geom, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.tank_code, NEW.tank_elevation, NEW.tank_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.tank_annotation, NEW.tank_observ, NEW.tank_comment,NEW.dma_id, NEW.presszonecat_id,
		NEW.tank_soilcat_id, NEW.tank_function_type, NEW.tank_category_type, NEW.tank_fluid_type, NEW.tank_location_type,NEW.tank_workcat_id, NEW.tank_workcat_id_end, NEW.tank_buildercat_id, NEW.tank_builtdate, NEW.tank_enddate, NEW.tank_ownercat_id, NEW.tank_address_01, 
		NEW.tank_address_02, NEW.tank_address_03, NEW.tank_descript, NEW.tank_rotation, NEW.verified, NEW.undelete,NEW.tank_label_x,NEW.tank_label_y,NEW.tank_label_rotation, 
		expl_id_int, NEW.publish, NEW.inventory, NEW.the_geom,  NEW.tank_hemisphere,NEW.tank_num_value);
		
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.tank_pol_id IS NULL) THEN
					NEW.tank_pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
				
					INSERT INTO man_tank (node_id,pol_id, vmax, vutil, area, chlorination,name) VALUES (NEW.node_id, NEW.tank_pol_id, NEW.tank_vmax, NEW.tank_vutil, NEW.tank_area,NEW.tank_chlorination, NEW.tank_name);
					INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.tank_pol_id,(SELECT ST_multi(ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value))) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			ELSE
				INSERT INTO man_tank (node_id, vmax, vutil, area, chlorination,name) VALUES (NEW.node_id, NEW.tank_vmax, NEW.tank_vutil, NEW.tank_area,NEW.tank_chlorination, NEW.tank_name);
			END IF;
			
	ELSIF man_table='man_tank_pol' THEN

		-- Workcat_id
		IF (NEW.tank_workcat_id IS NULL) THEN
			NEW.tank_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.tank_workcat_id IS NULL) THEN
				NEW.tank_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.tank_builtdate IS NULL) THEN				
			NEW.tank_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;
		
		--Copy id to code field
			IF (NEW.tank_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.tank_code=NEW.node_id;
			END IF;
			
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.tank_pol_id IS NULL) THEN
					NEW.tank_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_tank (node_id,pol_id, vmax, vutil, area, chlorination,name)
				VALUES (NEW.node_id, NEW.tank_pol_id, NEW.tank_vmax, NEW.tank_vutil, NEW.tank_area,NEW.tank_chlorination, NEW.tank_name);				
				
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.tank_pol_id,NEW.the_geom);
								
				INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
				buildercat_id, builtdate, enddate, ownercat_id, address_01,address_02, address_03, descript, rotation,verified,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, the_geom, hemisphere, num_value) 
				VALUES (NEW.node_id, NEW.tank_code, NEW.tank_elevation, NEW.tank_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.tank_annotation, NEW.tank_observ, NEW.tank_comment,NEW.dma_id, NEW.presszonecat_id,
				NEW.tank_soilcat_id, NEW.tank_function_type, NEW.tank_category_type, NEW.tank_fluid_type, NEW.tank_location_type,NEW.tank_workcat_id, NEW.tank_workcat_id_end, NEW.tank_buildercat_id, NEW.tank_builtdate, NEW.tank_enddate, NEW.tank_ownercat_id, NEW.tank_address_01, 
				NEW.tank_address_02, NEW.tank_address_03, NEW.tank_descript, NEW.tank_rotation, NEW.verified, NEW.undelete,NEW.tank_label_x,NEW.tank_label_y,NEW.tank_label_rotation, 
				expl_id_int, NEW.publish, NEW.inventory, (SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.tank_pol_id),  NEW.tank_hemisphere,NEW.tank_num_value);
		
				
			END IF;
			
	ELSIF man_table='man_hydrant' THEN
				
		-- Workcat_id
		IF (NEW.hydrant_workcat_id IS NULL) THEN
			NEW.hydrant_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.hydrant_workcat_id IS NULL) THEN
				NEW.hydrant_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
			
		--Builtdate
		IF (NEW.hydrant_builtdate IS NULL) THEN
			NEW.hydrant_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.hydrant_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.hydrant_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.hydrant_code, NEW.hydrant_elevation, NEW.hydrant_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.hydrant_annotation, NEW.hydrant_observ, NEW.hydrant_comment, 
		NEW.dma_id, NEW.presszonecat_id, NEW.hydrant_soilcat_id, NEW.hydrant_function_type, NEW.hydrant_category_type, NEW.hydrant_fluid_type, NEW.hydrant_location_type, NEW.hydrant_workcat_id, NEW.hydrant_workcat_id_end, 
		NEW.hydrant_buildercat_id, NEW.hydrant_builtdate,NEW.hydrant_enddate, NEW.hydrant_ownercat_id, NEW.hydrant_address_01, NEW.hydrant_address_02, NEW.hydrant_address_03, NEW.hydrant_descript, NEW.hydrant_rotation, 
		NEW.verified, NEW.the_geom, NEW.undelete, NEW.hydrant_label_x, NEW.hydrant_label_y,NEW.hydrant_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.hydrant_hemisphere, NEW.hydrant_num_value);
		
		INSERT INTO man_hydrant (node_id, fire_code, communication,valve) VALUES (NEW.node_id,NEW.hydrant_fire_code, NEW.hydrant_communication,NEW.hydrant_valve);
		
	ELSIF man_table='man_junction' THEN
		-- Workcat_id
		IF (NEW.junction_workcat_id IS NULL) THEN
			NEW.junction_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.junction_workcat_id IS NULL) THEN
				NEW.junction_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
			--Builtdate
		IF (NEW.junction_builtdate IS NULL) THEN
			NEW.junction_builtdate  :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.junction_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.junction_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.junction_code, NEW.junction_elevation, NEW.junction_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.junction_annotation, NEW.junction_observ, 
		NEW.junction_comment, NEW.dma_id, NEW.presszonecat_id, NEW.junction_soilcat_id, NEW.junction_function_type, NEW.junction_category_type, NEW.junction_fluid_type, NEW.junction_location_type, NEW.junction_workcat_id, 
		NEW.junction_workcat_id_end, NEW.junction_buildercat_id, NEW.junction_builtdate, NEW.junction_enddate, NEW.junction_ownercat_id, NEW.junction_address_01, NEW.junction_address_02, NEW.junction_address_03, NEW.junction_descript, 
		NEW.junction_rotation, NEW.verified, NEW.the_geom, NEW.undelete,NEW.junction_label_x,NEW.junction_label_y,NEW.junction_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.junction_hemisphere, NEW.junction_num_value);
	
		INSERT INTO man_junction (node_id) VALUES(NEW.node_id);
				
--- CUSTOM
		INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) 
				VALUES (NEW.node_id, junction_parameter_1, NEW.junction_parameter_1);
		INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) 
				VALUES (NEW.node_id, junction_parameter_2, NEW.junction_parameter_2);

			
	ELSIF man_table='man_pump' THEN		
				
		-- Workcat_id
		IF (NEW.pump_workcat_id IS NULL) THEN
			NEW.pump_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.pump_workcat_id IS NULL) THEN
				NEW.pump_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
		--Builtdate
		IF (NEW.pump_builtdate IS NULL) THEN
			NEW.pump_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.pump_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.pump_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere,num_value) 
		VALUES (NEW.node_id, NEW.pump_code, NEW.pump_elevation, NEW.pump_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,NEW."state", NEW.state_type, NEW.pump_annotation, NEW.pump_observ, NEW.pump_comment, NEW.dma_id, 
		NEW.presszonecat_id, NEW.pump_soilcat_id, NEW.pump_function_type, NEW.pump_category_type, NEW.pump_fluid_type, NEW.pump_location_type, NEW.pump_workcat_id, NEW.pump_workcat_id_end, NEW.pump_buildercat_id,
		NEW.pump_builtdate, NEW.pump_enddate, NEW.pump_ownercat_id, NEW.pump_address_01, NEW.pump_address_02, NEW.pump_address_03, NEW.pump_descript, NEW.pump_rotation, NEW.verified, NEW.the_geom,NEW.undelete, 
		NEW.pump_label_x,NEW.pump_label_y,NEW.pump_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.pump_hemisphere, NEW.pump_num_value);
		
		INSERT INTO man_pump (node_id, max_flow, min_flow, nom_flow, power, pressure, elev_height,name) VALUES(NEW.node_id, NEW.pump_max_flow, NEW.pump_min_flow, NEW.pump_nom_flow, NEW.pump_power, NEW.pump_pressure, NEW.pump_elev_height, NEW.pump_name);
		
	ELSIF man_table='man_reduction' THEN
				
		-- Workcat_id
		IF (NEW.reduction_workcat_id IS NULL) THEN
			NEW.reduction_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.reduction_workcat_id IS NULL) THEN
				NEW.reduction_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
		--Builtdate
		IF (NEW.reduction_builtdate IS NULL) THEN
			NEW.reduction_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.reduction_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.reduction_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state,state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.reduction_code, NEW.reduction_elevation, NEW.reduction_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.reduction_annotation, NEW.reduction_observ, 
		NEW.reduction_comment, NEW.dma_id, NEW.presszonecat_id, NEW.reduction_soilcat_id, NEW.reduction_function_type, NEW.reduction_category_type, NEW.reduction_fluid_type, NEW.reduction_location_type, NEW.reduction_workcat_id, NEW.reduction_workcat_id_end,
		NEW.reduction_buildercat_id, NEW.reduction_builtdate, NEW.reduction_enddate, NEW.reduction_ownercat_id, NEW.reduction_address_01, NEW.reduction_address_02, NEW.reduction_address_03, NEW.reduction_descript, NEW.reduction_rotation,
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.reduction_label_x,NEW.reduction_label_y,NEW.reduction_label_rotation, 
		expl_id_int, NEW.publish, NEW.inventory, NEW.reduction_hemisphere, NEW.reduction_num_value);
		
		INSERT INTO man_reduction (node_id,diam1,diam2) VALUES(NEW.node_id,NEW.reduction_diam1, NEW.reduction_diam2);
		
	ELSIF man_table='man_valve' THEN	
				
		-- Workcat_id
		IF (NEW.valve_workcat_id IS NULL) THEN
			NEW.valve_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.valve_workcat_id IS NULL) THEN
				NEW.valve_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
		--Builtdate
		IF (NEW.valve_builtdate IS NULL) THEN
			NEW.valve_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.valve_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.valve_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.valve_code, NEW.valve_elevation, NEW.valve_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.valve_annotation, NEW.valve_observ, NEW.valve_comment, 
		NEW.dma_id, NEW.presszonecat_id, NEW.valve_soilcat_id, NEW.valve_function_type, NEW.valve_category_type, NEW.valve_fluid_type, NEW.valve_location_type, NEW.valve_workcat_id, NEW.valve_workcat_id_end, NEW.valve_buildercat_id, 
		NEW.valve_builtdate, NEW.valve_enddate, NEW.valve_ownercat_id, NEW.valve_address_01, NEW.valve_address_02, NEW.valve_address_03, NEW.valve_descript, NEW.valve_rotation, NEW.verified, NEW.the_geom, NEW.undelete,
		NEW.valve_label_x,	NEW.valve_label_y,NEW.valve_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.valve_hemisphere, NEW.valve_num_value);
		
		INSERT INTO man_valve (node_id,closed, broken, buried,irrigation_indicator,pression_entry, pression_exit, depth_valveshaft,regulator_situation, regulator_location, regulator_observ,lin_meters, exit_type,exit_code,drive_type, cat_valve2, arc_id) 
		VALUES (NEW.node_id, NEW.valve_closed, NEW.valve_broken, NEW.valve_buried, NEW.valve_irrigation_indicator, NEW.valve_pression_entry, NEW.valve_pression_exit, NEW.valve_depth_valveshaft, NEW.valve_regulator_situation, NEW.valve_regulator_location, NEW.valve_regulator_observ, NEW.valve_lin_meters, 
		NEW.valve_exit_type, NEW.valve_exit_code, NEW.valve_drive_type, NEW.valve_cat_valve2, NEW.valve_arc_id);
		
	ELSIF man_table='man_manhole' THEN	

		-- Workcat_id
		IF (NEW.manhole_workcat_id IS NULL) THEN
			NEW.manhole_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.manhole_workcat_id IS NULL) THEN
				NEW.manhole_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

			--Builtdate
		IF (NEW.manhole_builtdate IS NULL) THEN
			NEW.manhole_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.manhole_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.manhole_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.manhole_code, NEW.manhole_elevation, NEW.manhole_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.manhole_annotation, NEW.manhole_observ, NEW.manhole_comment, NEW.dma_id, NEW.presszonecat_id,
		NEW.manhole_soilcat_id, NEW.manhole_function_type, NEW.manhole_category_type, NEW.manhole_fluid_type, NEW.manhole_location_type, NEW.manhole_workcat_id, NEW.manhole_workcat_id_end, NEW.manhole_buildercat_id, NEW.manhole_builtdate, 
		NEW.manhole_enddate, NEW.manhole_ownercat_id, NEW.manhole_address_01, NEW.manhole_address_02, NEW.manhole_address_03, NEW.manhole_descript, NEW.manhole_rotation, NEW.verified, NEW.the_geom, NEW.undelete,
		NEW.manhole_label_x,NEW.manhole_label_y,NEW.manhole_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.manhole_hemisphere, NEW.manhole_num_value);
		
		INSERT INTO man_manhole (node_id, name) VALUES(NEW.node_id, NEW.manhole_name);
		
	ELSIF man_table='man_meter' THEN
			
		-- Workcat_id
		IF (NEW.meter_workcat_id IS NULL) THEN
			NEW.meter_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.meter_workcat_id IS NULL) THEN
				NEW.meter_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

			--Builtdate
		IF (NEW.meter_builtdate IS NULL) THEN
				NEW.meter_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;		

		--Copy id to code field
			IF (NEW.meter_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.meter_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, 
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.meter_code, NEW.meter_elevation, NEW.meter_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.meter_annotation, NEW.meter_observ, NEW.meter_comment, NEW.dma_id, NEW.presszonecat_id,
		NEW.meter_soilcat_id, NEW.meter_function_type, NEW.meter_category_type, NEW.meter_fluid_type, NEW.meter_location_type, NEW.meter_workcat_id, NEW.meter_workcat_id_end, NEW.meter_buildercat_id, NEW.meter_builtdate, NEW.meter_enddate, 
		NEW.meter_ownercat_id, NEW.meter_address_01, NEW.meter_address_02, NEW.meter_address_03, NEW.meter_descript, NEW.meter_rotation,NEW.verified, NEW.the_geom, NEW.undelete,NEW.meter_label_x,NEW.meter_label_y,
		NEW.meter_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.meter_hemisphere, NEW.meter_num_value);
		
		INSERT INTO man_meter (node_id) VALUES(NEW.node_id);
		
	ELSIF man_table='man_source' THEN	

		-- Workcat_id
		IF (NEW.source_workcat_id IS NULL) THEN
			NEW.source_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.source_workcat_id IS NULL) THEN
				NEW.source_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.source_builtdate IS NULL) THEN
			NEW.source_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

				--Copy id to code field
			IF (NEW.source_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.source_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate,enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom,undelete, label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.source_code, NEW.source_elevation, NEW.source_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.source_annotation, NEW.source_observ, NEW.source_comment, NEW.dma_id, NEW.presszonecat_id, 
		NEW.source_soilcat_id, NEW.source_function_type, NEW.source_category_type, NEW.source_fluid_type, NEW.source_location_type, NEW.source_workcat_id, NEW.source_workcat_id_end, NEW.source_buildercat_id, NEW.source_builtdate, 
		NEW.source_enddate, NEW.source_ownercat_id, NEW.source_address_01, NEW.source_address_02, NEW.source_address_03, NEW.source_descript, NEW.source_rotation, NEW.verified, NEW.the_geom, NEW.undelete,
		NEW.source_label_x,NEW.source_label_y,NEW.source_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.source_hemisphere, NEW.source_num_value);
		
		INSERT INTO man_source (node_id, name) VALUES(NEW.node_id, NEW.source_name);
		
	ELSIF man_table='man_waterwell' THEN
				
		-- Workcat_id
		IF (NEW.waterwell_workcat_id IS NULL) THEN
			NEW.waterwell_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.waterwell_workcat_id IS NULL) THEN
				NEW.waterwell_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
		
		--Builtdate
		IF (NEW.waterwell_builtdate IS NULL) THEN
			NEW.waterwell_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.waterwell_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.waterwell_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		 VALUES (NEW.node_id, NEW.waterwell_code, NEW.waterwell_elevation, NEW.waterwell_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type,NEW.waterwell_annotation, NEW.waterwell_observ, NEW.waterwell_comment,
		NEW.dma_id,NEW.presszonecat_id, NEW.waterwell_soilcat_id, NEW.waterwell_function_type, NEW.waterwell_category_type, NEW.waterwell_fluid_type, NEW.waterwell_location_type, NEW.waterwell_workcat_id, NEW.waterwell_workcat_id_end, NEW.waterwell_buildercat_id, NEW.waterwell_builtdate, NEW.waterwell_enddate, 
		NEW.waterwell_ownercat_id, NEW.waterwell_address_01, NEW.waterwell_address_02, NEW.waterwell_address_03, NEW.waterwell_descript, NEW.waterwell_rotation, NEW.verified, NEW.the_geom,
		NEW.undelete,NEW.waterwell_label_x,NEW.waterwell_label_y,NEW.waterwell_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.waterwell_hemisphere, NEW.waterwell_num_value);
		
		INSERT INTO man_waterwell (node_id, name) VALUES(NEW.node_id, NEW.waterwell_name);
		
	ELSIF man_table='man_filter' THEN
				
		-- Workcat_id
		IF (NEW.filter_workcat_id IS NULL) THEN
			NEW.filter_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.filter_workcat_id IS NULL) THEN
				NEW.filter_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.filter_builtdate IS NULL) THEN
			NEW.filter_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.filter_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.filter_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, 
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.filter_code, NEW.filter_elevation, NEW.filter_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.filter_annotation, NEW.filter_observ, 
		NEW.filter_comment, NEW.dma_id, NEW.presszonecat_id, NEW.filter_soilcat_id, NEW.filter_function_type, NEW.filter_category_type, NEW.filter_fluid_type, NEW.filter_location_type, NEW.filter_workcat_id, NEW.filter_workcat_id_end, NEW.filter_buildercat_id, 
		NEW.filter_builtdate, NEW.filter_enddate, NEW.filter_ownercat_id, NEW.filter_address_01, NEW.filter_address_02, NEW.filter_address_03, NEW.filter_descript, NEW.filter_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.filter_label_x, NEW.filter_label_y,NEW.filter_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.filter_hemisphere, NEW.filter_num_value);
		
		INSERT INTO man_filter (node_id) VALUES(NEW.node_id);	
		
	ELSIF man_table='man_register' THEN
				
		-- Workcat_id
		IF (NEW.register_workcat_id IS NULL) THEN
			NEW.register_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.register_workcat_id IS NULL) THEN
				NEW.register_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.register_builtdate IS NULL) THEN
			NEW.register_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;
	
		--Copy id to code field
			IF (NEW.register_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.register_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.register_code, NEW.register_elevation, NEW.register_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type,NEW.register_annotation, NEW.register_observ,
		NEW.register_comment, NEW.dma_id, NEW.presszonecat_id, NEW.register_soilcat_id, NEW.register_function_type, NEW.register_category_type, NEW.register_fluid_type, NEW.register_location_type, NEW.register_workcat_id, NEW.register_workcat_id_end, NEW.register_buildercat_id, 
		NEW.register_builtdate, NEW.register_enddate, NEW.register_ownercat_id, NEW.register_address_01, NEW.register_address_02, NEW.register_address_03, NEW.register_descript, NEW.register_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.register_label_x,NEW.register_label_y,NEW.register_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.register_hemisphere, NEW.register_num_value);
		
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.register_pol_id IS NULL) THEN
					NEW.register_pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
				
					INSERT INTO man_register (node_id,pol_id) VALUES (NEW.node_id, NEW.register_pol_id);
					INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.register_pol_id,(SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value))) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			ELSE
				INSERT INTO man_register (node_id) VALUES (NEW.node_id);
			END IF;	
			
	ELSIF man_table='man_register_pol' THEN
				
		-- Workcat_id
		IF (NEW.register_workcat_id IS NULL) THEN
			NEW.register_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.register_workcat_id IS NULL) THEN
				NEW.register_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.register_builtdate IS NULL) THEN
			NEW.register_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.register_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.register_code=NEW.node_id;
			END IF;
			
			
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.register_pol_id IS NULL) THEN
					NEW.register_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				

				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.register_pol_id,NEW.the_geom);
				INSERT INTO man_register (node_id,pol_id) VALUES (NEW.node_id, NEW.register_pol_id);
				
				INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.register_code, NEW.register_elevation, NEW.register_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.register_annotation, NEW.register_observ,
		NEW.register_comment, NEW.dma_id, NEW.presszonecat_id, NEW.register_soilcat_id, NEW.register_function_type, NEW.register_category_type, NEW.register_fluid_type, NEW.register_location_type, NEW.register_workcat_id, NEW.register_workcat_id_end, NEW.register_buildercat_id, 
		NEW.register_builtdate, NEW.register_enddate, NEW.register_ownercat_id, NEW.register_address_01, NEW.register_address_02, NEW.register_address_03, NEW.register_descript, NEW.register_rotation, NEW.verified, 
		(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.register_pol_id), NEW.undelete,NEW.register_label_x,NEW.register_label_y,NEW.register_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.register_hemisphere, NEW.register_num_value);
				
			END IF;			
			
	ELSIF man_table='man_netwjoin' THEN
				
		-- Workcat_id
		IF (NEW.netwjoin_workcat_id IS NULL) THEN
			NEW.netwjoin_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.netwjoin_workcat_id IS NULL) THEN
				NEW.netwjoin_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.netwjoin_builtdate IS NULL) THEN
			NEW.netwjoin_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.netwjoin_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.netwjoin_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, 
		workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.netwjoin_code, NEW.netwjoin_elevation, NEW.netwjoin_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.netwjoin_annotation, NEW.netwjoin_observ,
		NEW.netwjoin_comment, NEW.dma_id, NEW.presszonecat_id, NEW.netwjoin_soilcat_id, NEW.netwjoin_function_type, NEW.netwjoin_category_type, NEW.netwjoin_fluid_type, NEW.netwjoin_location_type, NEW.netwjoin_workcat_id, NEW.netwjoin_workcat_id_end, 
		NEW.netwjoin_buildercat_id, NEW.netwjoin_builtdate, NEW.netwjoin_enddate, NEW.netwjoin_ownercat_id, NEW.netwjoin_address_01, NEW.netwjoin_address_02, NEW.netwjoin_address_03, NEW.netwjoin_descript, NEW.netwjoin_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.netwjoin_label_x,NEW.netwjoin_label_y,NEW.netwjoin_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.netwjoin_hemisphere, NEW.netwjoin_num_value);
		
		INSERT INTO man_netwjoin (node_id, streetaxis_id, postnumber, top_floor,  cat_valve, customer_code) 
		VALUES(NEW.node_id, NEW.netwjoin_streetaxis_id, NEW.netwjoin_postnumber, NEW.netwjoin_top_floor, NEW.netwjoin_cat_valve, NEW.netwjoin_customer_code);
		
	ELSIF man_table='man_expansiontank' THEN

		-- Workcat_id
		IF (NEW.exptank_workcat_id IS NULL) THEN
			NEW.exptank_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.exptank_workcat_id IS NULL) THEN
				NEW.exptank_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.exptank_builtdate IS NULL) THEN
			NEW.exptank_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;
		
		--Copy id to code field
			IF (NEW.exptank_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.exptank_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.exptank_code, NEW.exptank_elevation, NEW.exptank_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.exptank_annotation, NEW.exptank_observ,
		NEW.exptank_comment, NEW.dma_id, NEW.presszonecat_id, NEW.exptank_soilcat_id, NEW.exptank_function_type, NEW.exptank_category_type, NEW.exptank_fluid_type, NEW.exptank_location_type, NEW.exptank_workcat_id, NEW.exptank_workcat_id_end, 
		NEW.exptank_buildercat_id, NEW.exptank_builtdate, NEW.exptank_enddate,  NEW.exptank_ownercat_id, NEW.exptank_address_01, NEW.exptank_address_02, NEW.exptank_address_03, NEW.exptank_descript, NEW.exptank_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.exptank_label_x,NEW.exptank_label_y,NEW.exptank_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.exptank_hemisphere, NEW.exptank_num_value);
		
		INSERT INTO man_expansiontank (node_id) VALUES(NEW.node_id);
		
	ELSIF man_table='man_flexunion' THEN
				
		-- Workcat_id
		IF (NEW.flexunion_workcat_id IS NULL) THEN
			NEW.flexunion_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.flexunion_workcat_id IS NULL) THEN
				NEW.flexunion_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.flexunion_builtdate IS NULL) THEN
			NEW.flexunion_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.flexunion_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.flexunion_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.flexunion_code, NEW.flexunion_elevation, NEW.flexunion_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.flexunion_annotation, NEW.flexunion_observ,
		NEW.flexunion_comment, NEW.dma_id, NEW.presszonecat_id, NEW.flexunion_soilcat_id, NEW.flexunion_function_type, NEW.flexunion_category_type, NEW.flexunion_fluid_type, NEW.flexunion_location_type, NEW.flexunion_workcat_id, NEW.flexunion_workcat_id_end, 
		NEW.flexunion_buildercat_id, NEW.flexunion_builtdate, NEW.flexunion_enddate,  NEW.flexunion_ownercat_id, NEW.flexunion_address_01, NEW.flexunion_address_02, NEW.flexunion_address_03, NEW.flexunion_descript, NEW.flexunion_rotation,
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.flexunion_label_x, NEW.flexunion_label_y, NEW.flexunion_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.flexunion_hemisphere, NEW.flexunion_num_value);
		
		INSERT INTO man_flexunion (node_id) VALUES(NEW.node_id);
		
		ELSIF man_table='man_netelement' THEN
				
		-- Workcat_id
		IF (NEW.netelement_workcat_id IS NULL) THEN
			NEW.netelement_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.netelement_workcat_id IS NULL) THEN
				NEW.netelement_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.netelement_builtdate IS NULL) THEN
			NEW.netelement_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.netelement_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.netelement_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.netelement_code, NEW.netelement_elevation, NEW.netelement_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.netelement_annotation, NEW.netelement_observ,
		NEW.netelement_comment, NEW.dma_id, NEW.presszonecat_id, NEW.netelement_soilcat_id, NEW.netelement_function_type, NEW.netelement_category_type, NEW.netelement_fluid_type, NEW.netelement_location_type, NEW.netelement_workcat_id, 
		NEW.netelement_workcat_id_end, NEW.netelement_buildercat_id, NEW.netelement_builtdate, NEW.netelement_enddate, NEW.netelement_ownercat_id, NEW.netelement_address_01, NEW.netelement_address_02, NEW.netelement_address_03, 
		NEW.netelement_descript, NEW.netelement_rotation, NEW.verified, NEW.the_geom, NEW.undelete,NEW.netelement_label_x,NEW.netelement_label_y,NEW.netelement_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.netelement_hemisphere,
		NEW.netelement_num_value);
		
		INSERT INTO man_netelement (node_id, serial_number) VALUES(NEW.node_id, NEW.netelement_serial_number);		
		
		ELSIF man_table='man_netsamplepoint' THEN
				
		-- Workcat_id
		IF (NEW.netsample_workcat_id IS NULL) THEN
			NEW.netsample_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.netsample_workcat_id IS NULL) THEN
				NEW.netsample_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.netsample_builtdate IS NULL) THEN
			NEW.netsample_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.netsample_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.netsample_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.netsample_code, NEW.netsample_elevation, NEW.netsample_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.netsample_annotation, NEW.netsample_observ,
		NEW.netsample_comment, NEW.dma_id, NEW.presszonecat_id, NEW.netsample_soilcat_id, NEW.netsample_function_type, NEW.netsample_category_type, NEW.netsample_fluid_type, NEW.netsample_location_type, NEW.netsample_workcat_id, NEW.netsample_workcat_id_end, 
		NEW.netsample_buildercat_id, NEW.netsample_builtdate, NEW.netsample_enddate, NEW.netsample_ownercat_id, NEW.netsample_address_01, NEW.netsample_address_02, NEW.netsample_address_03, NEW.netsample_descript, NEW.netsample_rotation, 
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.netsample_label_x,NEW.netsample_label_y,NEW.netsample_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.netsample_hemisphere, NEW.netsample_num_value);
		
		INSERT INTO man_netsamplepoint (node_id, lab_code) VALUES(NEW.node_id, NEW.netsample_lab_code);
		
		ELSIF man_table='man_wtp' THEN
				
		-- Workcat_id
		IF (NEW.wtp_workcat_id IS NULL) THEN
			NEW.wtp_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.wtp_workcat_id IS NULL) THEN
				NEW.wtp_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.wtp_builtdate IS NULL) THEN
			NEW.wtp_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.wtp_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wtp_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate,enddate, ownercat_id, address_01, address_02, address_03, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.wtp_code, NEW.wtp_elevation, NEW.wtp_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.wtp_annotation, NEW.wtp_observ,
		NEW.wtp_comment, NEW.dma_id, NEW.presszonecat_id, NEW.wtp_soilcat_id, NEW.wtp_function_type, NEW.wtp_category_type, NEW.wtp_fluid_type, NEW.wtp_location_type, NEW.wtp_workcat_id, NEW.wtp_workcat_id_end, 
		NEW.wtp_buildercat_id, NEW.wtp_builtdate, NEW.wtp_enddate,  NEW.wtp_ownercat_id, NEW.wtp_address_01, NEW.wtp_address_02, NEW.wtp_address_03, NEW.wtp_descript, NEW.wtp_rotation,
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.wtp_label_x, NEW.wtp_label_y, NEW.wtp_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.wtp_hemisphere, NEW.wtp_num_value);
		
		INSERT INTO man_wtp (node_id, name) VALUES(NEW.node_id, NEW.wtp_name);
	END IF;

								
-- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN 
			INSERT INTO inp_junction (node_id) VALUES (NEW.node_id);

        ELSIF (NEW.epa_type = 'TANK') THEN 
			INSERT INTO inp_tank (node_id) VALUES (NEW.node_id);

        ELSIF (NEW.epa_type = 'RESERVOIR') THEN
			INSERT INTO inp_tank (node_id) VALUES (NEW.node_id);
			
        ELSIF (NEW.epa_type = 'PUMP') THEN
			INSERT INTO inp_pump (node_id, status) VALUES (NEW.node_id, 'OPEN');

        ELSIF (NEW.epa_type = 'VALVE') THEN
			INSERT INTO inp_valve (node_id, valv_type, status) VALUES (NEW.node_id, 'PRV', 'ACTIVE');

        ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
			INSERT INTO inp_shortpipe (node_id) VALUES (NEW.node_id);
			
        END IF;

	
        /*IF man_table IS NOT NULL THEN        
            EXECUTE v_sql;
        END IF;	
		*/
        --PERFORM audit_function(XXX,XXX); 
        RETURN NEW;



-- UPDATE


    ELSIF TG_OP = 'UPDATE' THEN


-- EPA UPDATE
        IF (NEW.epa_type != OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';                
            ELSIF (OLD.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';    
            ELSIF (OLD.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (OLD.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (OLD.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
                EXECUTE v_sql;
            END IF;
			inp_table := NULL;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';     
            ELSIF (NEW.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';  
            ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (NEW.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (NEW.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
                EXECUTE v_sql;
            END IF;
        END IF;

	-- Node catalog restriction
      /*  IF (OLD.nodecat_id IS NOT NULL) AND (NEW.nodecat_id <> OLD.nodecat_id) AND (NEW.node_type=OLD.node_type) THEN  
            old_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id) = (cat_node.nodetype_id))) WHERE cat_node.id=OLD.nodecat_id);
            new_nodetype:= (SELECT node_type.type FROM node_type JOIN cat_node ON (((node_type.id) = (cat_node.nodetype_id))) WHERE cat_node.id=NEW.nodecat_id);
            IF (quote_literal(old_nodetype) <> quote_literal(new_nodetype)) THEN
                RETURN audit_function(135,430);  
            END IF;
        END IF;


    -- UPDATE management values
		IF (NEW.node_type <> OLD.node_type) THEN 
			new_man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = NEW.node_type);
			old_man_table:= (SELECT node_type.man_table FROM node_type WHERE node_type.id = OLD.node_type);
			IF new_man_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||old_man_table||' WHERE node_id= '||quote_literal(OLD.node_id);
				EXECUTE v_sql;
				v_sql2:= 'INSERT INTO '||new_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
				EXECUTE v_sql2;
			END IF;
		END IF;
*/

	-- State
    IF (NEW.state != OLD.state) THEN
        UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
    END IF;
        
	-- The geom
	IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
           UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
    END IF;


		

-- MANAGEMENT UPDATE
    IF man_table ='man_junction' THEN

			--Label rotation
		IF (NEW.junction_rotation != OLD.junction_rotation) THEN
			   UPDATE node SET rotation=NEW.junction_rotation WHERE node_id = OLD.node_id;
		END IF;	
	
		UPDATE node 
		SET code=NEW.junction_code, elevation=NEW.junction_elevation, "depth"=NEW."junction_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.junction_annotation, "observ"=NEW."junction_observ", "comment"=NEW."junction_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.junction_soilcat_id, 
		function_type=NEW.junction_function_type, category_type=NEW.junction_category_type, fluid_type=NEW.junction_fluid_type, location_type=NEW.junction_location_type, workcat_id=NEW.junction_workcat_id, workcat_id_end=NEW.junction_workcat_id_end,  
		buildercat_id=NEW.junction_buildercat_id,	builtdate=NEW.junction_builtdate, enddate=NEW.junction_enddate, ownercat_id=NEW.junction_ownercat_id, address_01=NEW.junction_address_01, address_02=NEW.junction_address_02, 
		address_03=NEW.junction_address_03, descript=NEW.junction_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.junction_label_x, 
		label_y=NEW.junction_label_y, label_rotation=NEW.junction_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.junction_hemisphere, num_value=NEW.junction_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_junction 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_tank' THEN
	
				--Label rotation
		IF (NEW.tank_rotation != OLD.tank_rotation) THEN
			   UPDATE node SET rotation=NEW.tank_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node 
		SET  code=NEW.tank_code, elevation=NEW.tank_elevation, "depth"=NEW."tank_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.tank_annotation, "observ"=NEW."tank_observ", "comment"=NEW."tank_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.tank_soilcat_id, function_type=NEW.tank_function_type, 
		category_type=NEW.tank_category_type, fluid_type=NEW.tank_fluid_type, location_type=NEW.tank_location_type, workcat_id=NEW.tank_workcat_id, workcat_id_end=NEW.tank_workcat_id_end, buildercat_id=NEW.tank_buildercat_id, 
		builtdate=NEW.tank_builtdate, enddate=NEW.tank_enddate, ownercat_id=NEW.tank_ownercat_id, address_01=NEW.tank_address_01, address_02=NEW.tank_address_02, address_03=NEW.tank_address_03, descript=NEW.tank_descript, 
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.tank_label_x, label_y=NEW.tank_label_y, label_rotation=NEW.tank_label_rotation,
		publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.tank_hemisphere, num_value=NEW.tank_num_value
		WHERE node_id = OLD.node_id;

		UPDATE man_tank 
		SET pol_id=NEW.tank_pol_id, vmax=NEW.tank_vmax, vutil=NEW.tank_vutil, area=NEW.tank_area, chlorination=NEW.tank_chlorination, name=NEW.tank_name
		WHERE node_id=OLD.node_id;
	
	ELSIF man_table ='man_tank_pol' THEN
	
				--Label rotation
		IF (NEW.tank_rotation != OLD.tank_rotation) THEN
			   UPDATE node SET rotation=NEW.tank_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node 
		SET  code=NEW.tank_code, elevation=NEW.tank_elevation, "depth"=NEW."tank_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.tank_annotation, "observ"=NEW."tank_observ", "comment"=NEW."tank_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.tank_soilcat_id, function_type=NEW.tank_function_type, 
		category_type=NEW.tank_category_type, fluid_type=NEW.tank_fluid_type, location_type=NEW.tank_location_type, workcat_id=NEW.tank_workcat_id, workcat_id_end=NEW.tank_workcat_id_end, buildercat_id=NEW.tank_buildercat_id, 
		builtdate=NEW.tank_builtdate, enddate=NEW.tank_enddate, ownercat_id=NEW.tank_ownercat_id, address_01=NEW.tank_address_01, address_02=NEW.tank_address_02, address_03=NEW.tank_address_03, descript=NEW.tank_descript, 
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.tank_label_x, label_y=NEW.tank_label_y, label_rotation=NEW.tank_label_rotation,
		publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.tank_hemisphere, num_value=NEW.tank_num_value
		WHERE node_id = OLD.node_id;

		UPDATE man_tank 
		SET pol_id=NEW.tank_pol_id, vmax=NEW.tank_vmax, vutil=NEW.tank_vutil, area=NEW.tank_area, chlorination=NEW.tank_chlorination, name=NEW.tank_name
		WHERE node_id=OLD.node_id;
		
		IF (NEW.tank_pol_id IS NULL) THEN
				UPDATE man_tank 
				SET pol_id=NEW.tank_pol_id, vmax=NEW.tank_vmax, vutil=NEW.tank_vutil, area=NEW.tank_area, chlorination=NEW.tank_chlorination, name=NEW.tank_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
		ELSE
				UPDATE man_tank 
				SET pol_id=NEW.tank_pol_id, vmax=NEW.tank_vmax, vutil=NEW.tank_vutil, area=NEW.tank_area, chlorination=NEW.tank_chlorination, name=NEW.tank_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.tank_pol_id
				WHERE pol_id=OLD.pol_id;
		END IF;

	ELSIF man_table ='man_pump' THEN
	
				--Label rotation
		IF (NEW.pump_rotation != OLD.pump_rotation) THEN
			   UPDATE node SET rotation=NEW.pump_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.pump_code, elevation=NEW.pump_elevation, "depth"=NEW."pump_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.pump_annotation, "observ"=NEW."pump_observ", "comment"=NEW."pump_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.pump_soilcat_id, function_type=NEW.pump_function_type, 
		category_type=NEW.pump_category_type, fluid_type=NEW.pump_fluid_type, location_type=NEW.pump_location_type, workcat_id=NEW.pump_workcat_id, workcat_id_end=NEW.pump_workcat_id_end, buildercat_id=NEW.pump_buildercat_id, 
		builtdate=NEW.pump_builtdate,  enddate=NEW.pump_enddate, ownercat_id=NEW.pump_ownercat_id, address_01=NEW.pump_address_01, address_02=NEW.pump_address_02, address_03=NEW.pump_address_03, 
		descript=NEW.pump_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.pump_label_x, label_y=NEW.pump_label_y,
		label_rotation=NEW.pump_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.pump_hemisphere, num_value=NEW.pump_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_pump 
		SET max_flow=NEW.pump_max_flow, min_flow=NEW.pump_min_flow, nom_flow=NEW.pump_nom_flow, "power"=NEW.pump_power, pressure=NEW.pump_pressure, elev_height=NEW.pump_elev_height, name=NEW.pump_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_manhole' THEN
	
				--Label rotation
		IF (NEW.manhole_rotation != OLD.manhole_rotation) THEN
			   UPDATE node SET rotation=NEW.manhole_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.manhole_code, elevation=NEW.manhole_elevation, "depth"=NEW."manhole_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.manhole_annotation, "observ"=NEW."manhole_observ", "comment"=NEW."manhole_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.manhole_soilcat_id, 
		function_type=NEW.manhole_function_type, category_type=NEW.manhole_category_type, fluid_type=NEW.manhole_fluid_type, location_type=NEW.manhole_location_type, workcat_id=NEW.manhole_workcat_id, workcat_id_end=NEW.manhole_workcat_id_end, 
		buildercat_id=NEW.manhole_buildercat_id, builtdate=NEW.manhole_builtdate, enddate=NEW.manhole_enddate,  ownercat_id=NEW.manhole_ownercat_id, address_01=NEW.manhole_address_01, address_02=NEW.manhole_address_02, 
		address_03=NEW.manhole_address_03, descript=NEW.manhole_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.manhole_label_x, 
		label_y=NEW.manhole_label_y, label_rotation=NEW.manhole_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.manhole_hemisphere, num_value=NEW.manhole_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_manhole 
		SET name=NEW.manhole_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_hydrant' THEN
	
				--Label rotation
		IF (NEW.hydrant_rotation != OLD.hydrant_rotation) THEN
			   UPDATE node SET rotation=NEW.hydrant_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.hydrant_code, elevation=NEW.hydrant_elevation, "depth"=NEW."hydrant_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		annotation=NEW.hydrant_annotation, "observ"=NEW."hydrant_observ", "comment"=NEW."hydrant_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.hydrant_soilcat_id, 
		function_type=NEW.hydrant_function_type, category_type=NEW.hydrant_category_type, fluid_type=NEW.hydrant_fluid_type, location_type=NEW.hydrant_location_type, workcat_id=NEW.hydrant_workcat_id,workcat_id_end=NEW.hydrant_workcat_id_end, 
		buildercat_id=NEW.hydrant_buildercat_id, builtdate=NEW.hydrant_builtdate, enddate=NEW.hydrant_enddate, ownercat_id=NEW.hydrant_ownercat_id, address_01=NEW.hydrant_address_01, address_02=NEW.hydrant_address_02, 
		address_03=NEW.hydrant_address_03, descript=NEW.hydrant_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.hydrant_label_x, 
		label_y=NEW.hydrant_label_y, label_rotation=NEW.hydrant_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.hydrant_hemisphere, num_value=NEW.hydrant_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_hydrant 
		SET fire_code=NEW.hydrant_fire_code, communication=NEW.hydrant_communication, valve=NEW.hydrant_valve
		WHERE node_id=OLD.node_id;			

	ELSIF man_table ='man_source' THEN
	
				--Label rotation
		IF (NEW.source_rotation != OLD.source_rotation) THEN
			   UPDATE node SET rotation=NEW.source_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.source_code, elevation=NEW.source_elevation, "depth"=NEW."source_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.source_annotation, "observ"=NEW."source_observ", "comment"=NEW."source_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.source_soilcat_id, 
		function_type=NEW.source_function_type, category_type=NEW.source_category_type, fluid_type=NEW.source_fluid_type, location_type=NEW.source_location_type, workcat_id=NEW.source_workcat_id, workcat_id_end=NEW.source_workcat_id_end, 
		buildercat_id=NEW.source_buildercat_id, builtdate=NEW.source_builtdate, enddate=NEW.source_enddate, ownercat_id=NEW.source_ownercat_id, address_01=NEW.source_address_01, address_02=NEW.source_address_02, 
		address_03=NEW.source_address_03, descript=NEW.source_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.source_label_x, 
		label_y=NEW.source_label_y, label_rotation=NEW.source_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.source_hemisphere, num_value=NEW.source_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_source 
		SET name=NEW.source_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_meter' THEN
	
				--Label rotation
		IF (NEW.meter_rotation != OLD.meter_rotation) THEN
			   UPDATE node SET rotation=NEW.meter_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET elevation=NEW.meter_elevation, "depth"=NEW."meter_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.meter_annotation, "observ"=NEW."meter_observ", "comment"=NEW."meter_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.meter_soilcat_id, function_type=NEW.meter_function_type, 
		category_type=NEW.meter_category_type, fluid_type=NEW.meter_fluid_type, location_type=NEW.meter_location_type, workcat_id=NEW.meter_workcat_id, workcat_id_end=NEW.meter_workcat_id_end, buildercat_id=NEW.meter_buildercat_id, 
		builtdate=NEW.meter_builtdate, enddate=NEW.meter_enddate,  ownercat_id=NEW.meter_ownercat_id, address_01=NEW.meter_address_01, address_02=NEW.meter_address_02, address_03=NEW.meter_address_03, descript=NEW.meter_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.meter_label_x, label_y=NEW.meter_label_y, label_rotation=NEW.meter_label_rotation,
		code=NEW.meter_code, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.meter_hemisphere, num_value=NEW.meter_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_meter 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_waterwell' THEN
	
				--Label rotation
		IF (NEW.waterwell_rotation != OLD.waterwell_rotation) THEN
			   UPDATE node SET rotation=NEW.waterwell_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.waterwell_code, elevation=NEW.waterwell_elevation, "depth"=NEW."waterwell_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.waterwell_annotation, "observ"=NEW."waterwell_observ", "comment"=NEW."waterwell_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, 
		soilcat_id=NEW.waterwell_soilcat_id, function_type=NEW.waterwell_function_type, category_type=NEW.waterwell_category_type, fluid_type=NEW.waterwell_fluid_type, location_type=NEW.waterwell_location_type, workcat_id=NEW.waterwell_workcat_id, 
		workcat_id_end=NEW.waterwell_workcat_id_end, buildercat_id=NEW.waterwell_buildercat_id, builtdate=NEW.waterwell_builtdate, enddate=NEW.waterwell_enddate, ownercat_id=NEW.waterwell_ownercat_id, 
		address_01=NEW.waterwell_address_01, address_02=NEW.waterwell_address_02, address_03=NEW.waterwell_address_03, descript=NEW.waterwell_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.waterwell_label_x, label_y=NEW.waterwell_label_y, label_rotation=NEW.waterwell_label_rotation, publish=NEW.publish, inventory=NEW.inventory, 
		expl_id=NEW.expl_id, hemisphere=NEW.waterwell_hemisphere, num_value=NEW.waterwell_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_waterwell 
		SET name=NEW.waterwell_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_reduction' THEN
	
				--Label rotation
		IF (NEW.reduction_rotation != OLD.reduction_rotation) THEN
			   UPDATE node SET rotation=NEW.reduction_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.reduction_code, elevation=NEW.reduction_elevation, "depth"=NEW."reduction_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.reduction_annotation, "observ"=NEW."reduction_observ", "comment"=NEW."reduction_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.reduction_soilcat_id, 
		function_type=NEW.reduction_function_type, category_type=NEW.reduction_category_type, fluid_type=NEW.reduction_fluid_type, location_type=NEW.reduction_location_type, workcat_id=NEW.reduction_workcat_id, 
		workcat_id_end=NEW.reduction_workcat_id_end, buildercat_id=NEW.reduction_buildercat_id, builtdate=NEW.reduction_builtdate, enddate=NEW.reduction_enddate, ownercat_id=NEW.reduction_ownercat_id, address_01=NEW.reduction_address_01, 
		address_02=NEW.reduction_address_02, address_03=NEW.reduction_address_03, descript=NEW.reduction_descript, verified=NEW.verified, 
		undelete=NEW.undelete, label_x=NEW.reduction_label_x, label_y=NEW.reduction_label_y, label_rotation=NEW.reduction_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.reduction_hemisphere,
		num_value=NEW.reduction_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_reduction 
		SET diam1=NEW.reduction_diam1, diam2=NEW.reduction_diam2
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_valve' THEN
	
				--Label rotation
		IF (NEW.valve_rotation != OLD.valve_rotation) THEN
			   UPDATE node SET rotation=NEW.valve_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.valve_code, elevation=NEW.valve_elevation, "depth"=NEW."valve_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.valve_annotation, "observ"=NEW."valve_observ", "comment"=NEW."valve_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.valve_soilcat_id, 
		function_type=NEW.valve_function_type, category_type=NEW.valve_category_type, fluid_type=NEW.valve_fluid_type, location_type=NEW.valve_location_type, workcat_id=NEW.valve_workcat_id, workcat_id_end=NEW.valve_workcat_id_end, buildercat_id=NEW.valve_buildercat_id, 
		builtdate=NEW.valve_builtdate, enddate=NEW.valve_enddate,  ownercat_id=NEW.valve_ownercat_id, address_01=NEW.valve_address_01, address_02=NEW.valve_address_02, address_03=NEW.valve_address_03, descript=NEW.valve_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.valve_label_x, label_y=NEW.valve_label_y, label_rotation=NEW.valve_label_rotation, publish=NEW.publish, 
		inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.valve_hemisphere, num_value=NEW.valve_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_valve 
		SET closed=NEW.valve_closed, broken=NEW.valve_broken, buried=NEW.valve_buried, irrigation_indicator=NEW.valve_irrigation_indicator, pression_entry=NEW.valve_pression_entry, pression_exit=NEW.valve_pression_exit, 
		depth_valveshaft=NEW.valve_depth_valveshaft, regulator_situation=NEW.valve_regulator_situation, regulator_location=NEW.valve_regulator_location, regulator_observ=NEW.valve_regulator_observ, lin_meters=NEW.valve_lin_meters, 
		exit_type=NEW.valve_exit_type, exit_code=NEW.valve_exit_code, drive_type=NEW.valve_drive_type, cat_valve2=NEW.valve_cat_valve2, arc_id=NEW.valve_arc_id
		WHERE node_id=OLD.node_id;	
		
	ELSIF man_table ='man_register' THEN
	
				--Label rotation
		IF (NEW.register_rotation != OLD.register_rotation) THEN
			   UPDATE node SET rotation=NEW.register_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.register_code, elevation=NEW.register_elevation, "depth"=NEW."register_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.register_annotation, "observ"=NEW."register_observ", "comment"=NEW."register_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.register_soilcat_id, 
		function_type=NEW.register_function_type, category_type=NEW.register_category_type, fluid_type=NEW.register_fluid_type, location_type=NEW.register_location_type, workcat_id=NEW.register_workcat_id, workcat_id_end=NEW.register_workcat_id_end, 
		buildercat_id=NEW.register_buildercat_id, builtdate=NEW.register_builtdate, enddate=NEW.register_enddate, ownercat_id=NEW.register_ownercat_id, address_01=NEW.register_address_01, address_02=NEW.register_address_02, 
		address_03=NEW.register_address_03, descript=NEW.register_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.register_label_x, 
		label_y=NEW.register_label_y, label_rotation=NEW.register_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.register_hemisphere, num_value=NEW.register_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_register
		SET pol_id=NEW.register_pol_id
		WHERE node_id=OLD.node_id;		


	ELSIF man_table ='man_register_pol' THEN
	
				--Label rotation
		IF (NEW.register_rotation != OLD.register_rotation) THEN
			   UPDATE node SET rotation=NEW.register_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.register_code, elevation=NEW.register_elevation, "depth"=NEW."register_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.register_annotation, "observ"=NEW."register_observ", "comment"=NEW."register_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.register_soilcat_id, 
		function_type=NEW.register_function_type, category_type=NEW.register_category_type, fluid_type=NEW.register_fluid_type, location_type=NEW.register_location_type, workcat_id=NEW.register_workcat_id, workcat_id_end=NEW.register_workcat_id_end, 
		buildercat_id=NEW.register_buildercat_id, builtdate=NEW.register_builtdate, enddate=NEW.register_enddate, ownercat_id=NEW.register_ownercat_id, address_01=NEW.register_address_01, address_02=NEW.register_address_02, 
		address_03=NEW.register_address_03, descript=NEW.register_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.register_label_x, 
		label_y=NEW.register_label_y, label_rotation=NEW.register_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.register_hemisphere, num_value=NEW.register_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_register
		SET pol_id=NEW.register_pol_id
		WHERE node_id=OLD.node_id;			

		IF (NEW.register_pol_id IS NULL) THEN
				UPDATE man_register
				SET pol_id=NEW.register_pol_id
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
		ELSE
				UPDATE man_register
				SET pol_id=NEW.register_pol_id
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.register_pol_id
				WHERE pol_id=OLD.pol_id;
		END IF;
		
	ELSIF man_table ='man_netwjoin' THEN
		
		--Label rotation
		IF (NEW.netwjoin_rotation != OLD.netwjoin_rotation) THEN
			   UPDATE node SET rotation=NEW.netwjoin_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.netwjoin_code, elevation=NEW.netwjoin_elevation, "depth"=NEW."netwjoin_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.netwjoin_annotation, "observ"=NEW."netwjoin_observ", "comment"=NEW."netwjoin_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.netwjoin_soilcat_id, 
		function_type=NEW.netwjoin_function_type, category_type=NEW.netwjoin_category_type, fluid_type=NEW.netwjoin_fluid_type, location_type=NEW.netwjoin_location_type, workcat_id=NEW.netwjoin_workcat_id, 
		workcat_id_end=NEW.netwjoin_workcat_id_end, buildercat_id=NEW.netwjoin_buildercat_id, builtdate=NEW.netwjoin_builtdate, enddate=NEW.netwjoin_enddate, ownercat_id=NEW.netwjoin_ownercat_id, address_01=NEW.netwjoin_address_01, 
		address_02=NEW.netwjoin_address_02, address_03=NEW.netwjoin_address_03, descript=NEW.netwjoin_descript, verified=NEW.verified, undelete=NEW.undelete, 
		label_x=NEW.netwjoin_label_x, label_y=NEW.netwjoin_label_y, label_rotation=NEW.netwjoin_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.netwjoin_hemisphere, num_value=NEW.netwjoin_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_netwjoin
		SET streetaxis_id=NEW.netwjoin_streetaxis_id, postnumber=NEW.netwjoin_postnumber,top_floor= NEW.netwjoin_top_floor, cat_valve=NEW.netwjoin_cat_valve, customer_code=NEW.netwjoin_customer_code
		WHERE node_id=OLD.node_id;		
		
	ELSIF man_table ='man_expansiontank' THEN
	
				--Label rotation
		IF (NEW.exptank_rotation != OLD.exptank_rotation) THEN
			   UPDATE node SET rotation=NEW.exptank_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.exptank_code, elevation=NEW.exptank_elevation, "depth"=NEW."exptank_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.exptank_annotation, "observ"=NEW."exptank_observ", "comment"=NEW."exptank_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.exptank_soilcat_id, 
		function_type=NEW.exptank_function_type, category_type=NEW.exptank_category_type, fluid_type=NEW.exptank_fluid_type, location_type=NEW.exptank_location_type, workcat_id=NEW.exptank_workcat_id, workcat_id_end=NEW.exptank_workcat_id_end, 
		buildercat_id=NEW.exptank_buildercat_id, builtdate=NEW.exptank_builtdate, enddate=NEW.exptank_enddate,  ownercat_id=NEW.exptank_ownercat_id, address_01=NEW.exptank_address_01, address_02=NEW.exptank_address_02, 
		address_03=NEW.exptank_address_03, descript=NEW.exptank_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.exptank_label_x, 
		label_y=NEW.exptank_label_y, label_rotation=NEW.exptank_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.exptank_hemisphere, num_value=NEW.exptank_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_expansiontank
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;		

	ELSIF man_table ='man_flexunion' THEN
	
				--Label rotation
		IF (NEW.flexunion_rotation != OLD.flexunion_rotation) THEN
			   UPDATE node SET rotation=NEW.flexunion_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.flexunion_code, elevation=NEW.flexunion_elevation, "depth"=NEW."flexunion_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.flexunion_annotation, "observ"=NEW."flexunion_observ", "comment"=NEW."flexunion_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.flexunion_soilcat_id, 
		function_type=NEW.flexunion_function_type, category_type=NEW.flexunion_category_type, fluid_type=NEW.flexunion_fluid_type, location_type=NEW.flexunion_location_type, workcat_id=NEW.flexunion_workcat_id, 
		workcat_id_end=NEW.flexunion_workcat_id_end, buildercat_id=NEW.flexunion_buildercat_id, builtdate=NEW.flexunion_builtdate, enddate=NEW.flexunion_enddate,  ownercat_id=NEW.flexunion_ownercat_id, address_01=NEW.flexunion_address_01, 
		address_02=NEW.flexunion_address_02, address_03=NEW.flexunion_address_03, descript=NEW.flexunion_descript, verified=NEW.verified, 
		undelete=NEW.undelete, label_x=NEW.flexunion_label_x, label_y=NEW.flexunion_label_y, label_rotation=NEW.flexunion_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.flexunion_hemisphere,
		num_value=NEW.flexunion_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_flexunion
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;				
		
	ELSIF man_table ='man_netelement' THEN
	
				--Label rotation
		IF (NEW.netelement_rotation != OLD.netelement_rotation) THEN
			   UPDATE node SET rotation=NEW.netelement_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.netelement_code, elevation=NEW.netelement_elevation, "depth"=NEW."netelement_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		annotation=NEW.netelement_annotation, "observ"=NEW."netelement_observ", "comment"=NEW."netelement_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.netelement_soilcat_id, 
		function_type=NEW.netelement_function_type, category_type=NEW.netelement_category_type, fluid_type=NEW.netelement_fluid_type, location_type=NEW.netelement_location_type, workcat_id=NEW.netelement_workcat_id, 
		workcat_id_end=NEW.netelement_workcat_id_end, buildercat_id=NEW.netelement_buildercat_id, builtdate=NEW.netelement_builtdate, enddate=NEW.netelement_enddate,  ownercat_id=NEW.netelement_ownercat_id, address_01=NEW.netelement_address_01, 
		address_02=NEW.netelement_address_02, address_03=NEW.netelement_address_03, descript=NEW.netelement_descript, verified=NEW.verified, 
		undelete=NEW.undelete, label_x=NEW.netelement_label_x, label_y=NEW.netelement_label_y, label_rotation=NEW.netelement_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.netelement_hemisphere,
		num_value=NEW.netelement_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_netelement
		SET serial_number=NEW.netelement_serial_number
		WHERE node_id=OLD.node_id;	
	
	ELSIF man_table ='man_netsamplepoint' THEN
		
		--Label rotation
		IF (NEW.netsample_rotation != OLD.netsample_rotation) THEN
			   UPDATE node SET rotation=NEW.netsample_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.netsample_code, elevation=NEW.netsample_elevation, "depth"=NEW."netsample_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.netsample_annotation, "observ"=NEW."netsample_observ", "comment"=NEW."netsample_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, 
		soilcat_id=NEW.netsample_soilcat_id, function_type=NEW.netsample_function_type, category_type=NEW.netsample_category_type, fluid_type=NEW.netsample_fluid_type, location_type=NEW.netsample_location_type, workcat_id=NEW.netsample_workcat_id, 
		workcat_id_end=NEW.netsample_workcat_id_end, buildercat_id=NEW.netsample_buildercat_id, builtdate=NEW.netsample_builtdate, enddate=NEW.netsample_enddate,  ownercat_id=NEW.netsample_ownercat_id, 
		address_01=NEW.netsample_address_01, address_02=NEW.netsample_address_02, address_03=NEW.netsample_address_03, descript=NEW.netsample_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.netsample_label_x, label_y=NEW.netsample_label_y, label_rotation=NEW.netsample_label_rotation, publish=NEW.publish, inventory=NEW.inventory,
		expl_id=NEW.expl_id, hemisphere=NEW.netsample_hemisphere, num_value=NEW.netsample_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_netsamplepoint
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;		
		
	ELSIF man_table ='man_wtp' THEN		
	
				--Label rotation
		IF (NEW.wtp_rotation != OLD.wtp_rotation) THEN
			   UPDATE node SET rotation=NEW.wtp_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
			SET code=NEW.wtp_code, elevation=NEW.wtp_elevation, "depth"=NEW."wtp_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			state_type=NEW.state_type, annotation=NEW.wtp_annotation, "observ"=NEW."wtp_observ", "comment"=NEW."wtp_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.wtp_soilcat_id, 
			function_type=NEW.wtp_function_type, category_type=NEW.wtp_category_type, fluid_type=NEW.wtp_fluid_type, location_type=NEW.wtp_location_type, workcat_id=NEW.wtp_workcat_id, 
			workcat_id_end=NEW.wtp_workcat_id_end, buildercat_id=NEW.wtp_buildercat_id, builtdate=NEW.wtp_builtdate, enddate=NEW.wtp_enddate,  ownercat_id=NEW.wtp_ownercat_id, address_01=NEW.wtp_address_01, 
			address_02=NEW.wtp_address_02, address_03=NEW.wtp_address_03, descript=NEW.wtp_descript, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.wtp_label_x, label_y=NEW.wtp_label_y, label_rotation=NEW.wtp_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.wtp_hemisphere,
			num_value=NEW.wtp_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wtp
			SET name=NEW.wtp_name
			WHERE node_id=OLD.node_id;			
			
			
	ELSIF man_table ='man_filter' THEN
		
		UPDATE node
			SET node_id=NEW.node_id, elevation=NEW.filter_elevation, "depth"=NEW."filter_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW."filter_state", annotation=NEW.filter_annotation, "observ"=NEW."filter_observ", "comment"=NEW."filter_comment", dma_id=NEW.dma_id, soilcat_id=NEW.filter_soilcat_id, 
			category_type=NEW.filter_category_type, fluid_type=NEW.filter_fluid_type, location_type=NEW.filter_location_type, workcat_id=NEW.filter_workcat_id, buildercat_id=NEW.filter_buildercat_id, 
			builtdate=NEW.filter_builtdate, ownercat_id=NEW.filter_ownercat_id, adress_01=NEW.filter_adress_01, adress_02=NEW.filter_adress_02, adress_03=NEW.filter_adress_03, descript=NEW.filter_descript,
			rotation=NEW.filter_rotation, link=NEW.filter_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.filter_workcat_id_end, undelete=NEW.undelete, label_x=NEW.filter_label_x, 
			label_y=NEW.filter_label_y, label_rotation=NEW.filter_label_rotation
			WHERE node_id = OLD.node_id;
			
		UPDATE man_filter 
			SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
			
	END IF;

            
        --PERFORM audit_function(2,430); 
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

	PERFORM gw_fct_check_delete(OLD.node_id, 'NODE');
	
   	
	IF man_table='man_tank_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.tank_pol_id;
	ELSIF man_table='man_tank' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_tank WHERE node_id=OLD.node_id );
	ELSIF man_table='man_register_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.register_pol_id;
	ELSIF man_table='man_register' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_register WHERE node_id=OLD.node_id );
	ELSE 
		DELETE FROM node WHERE node_id = OLD.node_id;
	END IF;
	
	-- PERFORM audit_function(3,430); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

