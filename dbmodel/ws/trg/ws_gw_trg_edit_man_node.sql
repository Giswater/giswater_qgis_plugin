/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 1318

-- Function: "SCHEMA_NAME".gw_trg_edit_man_node()

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node()
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
				RETURN audit_function(1006,1318);  
			END IF;
			NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='nodecat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.nodecat_id IS NULL) THEN
				PERFORM audit_function(1090,1318);
			END IF;				
			IF (NEW.nodecat_id NOT IN (select cat_node.id FROM cat_node JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE node_type.man_table=man_table_2)) THEN 
				PERFORM audit_function(1092,1318);
			END IF;

		END IF;
		
	-- Epa type
		IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM cat_node JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id LIMIT 1)::text;   
		END IF;
		
     -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1318);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1318);          
            END IF;            
        END IF;
        
     -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1318);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1318);  
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
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1318);
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


		SELECT code_autofill INTO code_autofill_bool FROM node JOIN cat_node ON cat_node.id =node.nodecat_id JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id ;   

-- FEATURE INSERT      
	IF man_table='man_tank' THEN
			
		-- Workcat_id
		IF (NEW.tk_workcat_id IS NULL) THEN
			NEW.tk_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.tk_workcat_id IS NULL) THEN
				NEW.tk_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.tk_builtdate IS NULL) THEN
			NEW.tk_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.tk_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.tk_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id,streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, the_geom, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.tk_code, NEW.tk_elevation, NEW.tk_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.tk_annotation, NEW.tk_observ, NEW.tk_comment,NEW.dma_id, NEW.presszonecat_id,
		NEW.tk_soilcat_id, NEW.tk_function_type, NEW.tk_category_type, NEW.tk_fluid_type, NEW.tk_location_type,NEW.tk_workcat_id, NEW.tk_workcat_id_end, NEW.tk_buildercat_id, NEW.tk_builtdate, NEW.tk_enddate, NEW.tk_ownercat_id, NEW.tk_muni_id, 
		NEW.tk_streetaxis_id, NEW.tk_streetaxis_02_id, NEW.tk_postcode,NEW.tk_postnumber,NEW.tk_postnumber_02, NEW.tk_descript, NEW.tk_rotation, NEW.verified, NEW.undelete,NEW.tk_label_x,NEW.tk_label_y,NEW.tk_label_rotation, 
		NEW.expl_id, NEW.publish, NEW.inventory, NEW.the_geom,  NEW.tk_hemisphere,NEW.tk_num_value);
		
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.tk_pol_id IS NULL) THEN
					NEW.tk_pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
				
					INSERT INTO man_tank (node_id,pol_id, vmax, vutil, area, chlorination,name) VALUES (NEW.node_id, NEW.tk_pol_id, NEW.tk_vmax, NEW.tk_vutil, NEW.tk_area,NEW.tk_chlorination, NEW.tk_name);
					INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.tk_pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			ELSE
				INSERT INTO man_tank (node_id, vmax, vutil, area, chlorination,name) VALUES (NEW.node_id, NEW.tk_vmax, NEW.tk_vutil, NEW.tk_area,NEW.tk_chlorination, NEW.tk_name);
			END IF;
			
	ELSIF man_table='man_tank_pol' THEN

		-- Workcat_id
		IF (NEW.tk_workcat_id IS NULL) THEN
			NEW.tk_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.tk_workcat_id IS NULL) THEN
				NEW.tk_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.tk_builtdate IS NULL) THEN				
			NEW.tk_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;
		
		--Copy id to code field
			IF (NEW.tk_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.tk_code=NEW.node_id;
			END IF;
			
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.tk_pol_id IS NULL) THEN
					NEW.tk_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_tank (node_id,pol_id, vmax, vutil, area, chlorination,name)
				VALUES (NEW.node_id, NEW.tk_pol_id, NEW.tk_vmax, NEW.tk_vutil, NEW.tk_area,NEW.tk_chlorination, NEW.tk_name);				
				
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.tk_pol_id,NEW.the_geom);
								
				INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
				buildercat_id, builtdate, enddate, ownercat_id, muni_id,streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, the_geom, hemisphere, num_value) 
				VALUES (NEW.node_id, NEW.tk_code, NEW.tk_elevation, NEW.tk_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.tk_annotation, NEW.tk_observ, NEW.tk_comment,NEW.dma_id, NEW.presszonecat_id,
				NEW.tk_soilcat_id, NEW.tk_function_type, NEW.tk_category_type, NEW.tk_fluid_type, NEW.tk_location_type,NEW.tk_workcat_id, NEW.tk_workcat_id_end, NEW.tk_buildercat_id, NEW.tk_builtdate, NEW.tk_enddate, NEW.tk_ownercat_id, NEW.tk_muni_id, 
				NEW.tk_streetaxis_id, NEW.tk_streetaxis_02_id, NEW.tk_postcode,NEW.tk_postnumber,NEW.tk_postnumber_02,NEW.tk_descript, NEW.tk_rotation, NEW.verified, NEW.undelete,NEW.tk_label_x,NEW.tk_label_y,NEW.tk_label_rotation, 
				NEW.expl_id, NEW.publish, NEW.inventory, (SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.tk_pol_id),  NEW.tk_hemisphere,NEW.tk_num_value);
		
				
			END IF;
			
	ELSIF man_table='man_hydrant' THEN
				
		-- Workcat_id
		IF (NEW.hy_workcat_id IS NULL) THEN
			NEW.hy_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.hy_workcat_id IS NULL) THEN
				NEW.hy_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
			
		--Builtdate
		IF (NEW.hy_builtdate IS NULL) THEN
			NEW.hy_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.hy_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.hy_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.hy_code, NEW.hy_elevation, NEW.hy_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.hy_annotation, NEW.hy_observ, NEW.hy_comment, 
		NEW.dma_id, NEW.presszonecat_id, NEW.hy_soilcat_id, NEW.hy_function_type, NEW.hy_category_type, NEW.hy_fluid_type, NEW.hy_location_type, NEW.hy_workcat_id, NEW.hy_workcat_id_end, 
		NEW.hy_buildercat_id, NEW.hy_builtdate,NEW.hy_enddate, NEW.hy_ownercat_id, NEW.hy_muni_id, NEW.hy_streetaxis_id, NEW.hy_streetaxis_02_id, NEW.hy_postcode, NEW.hy_postnumber, NEW.hy_postnumber_02,NEW.hy_descript, NEW.hy_rotation, 
		NEW.verified, NEW.the_geom, NEW.undelete, NEW.hy_label_x, NEW.hy_label_y,NEW.hy_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.hy_hemisphere, NEW.hy_num_value);
		
		INSERT INTO man_hydrant (node_id, fire_code, communication,valve,vl_diam) VALUES (NEW.node_id,NEW.hy_fire_code, NEW.hy_communication,NEW.hy_valve, NEW.hy_vl_diam);
		
	ELSIF man_table='man_junction' THEN
		-- Workcat_id
		IF (NEW.jt_workcat_id IS NULL) THEN
			NEW.jt_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.jt_workcat_id IS NULL) THEN
				NEW.jt_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
			--Builtdate
		IF (NEW.jt_builtdate IS NULL) THEN
			NEW.jt_builtdate  :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.jt_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.jt_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.jt_code, NEW.jt_elevation, NEW.jt_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.jt_annotation, NEW.jt_observ, 
		NEW.jt_comment, NEW.dma_id, NEW.presszonecat_id, NEW.jt_soilcat_id, NEW.jt_function_type, NEW.jt_category_type, NEW.jt_fluid_type, NEW.jt_location_type, NEW.jt_workcat_id, 
		NEW.jt_workcat_id_end, NEW.jt_buildercat_id, NEW.jt_builtdate, NEW.jt_enddate, NEW.jt_ownercat_id, NEW.jt_muni_id, NEW.jt_streetaxis_id, NEW.jt_streetaxis_02_id,NEW.jt_postcode,NEW.jt_postnumber, NEW.jt_postnumber_02, NEW.jt_descript, 
		NEW.jt_rotation, NEW.verified, NEW.the_geom, NEW.undelete,NEW.jt_label_x,NEW.jt_label_y,NEW.jt_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.jt_hemisphere, NEW.jt_num_value);
	
		INSERT INTO man_junction (node_id) VALUES(NEW.node_id);
			
	ELSIF man_table='man_pump' THEN		
				
		-- Workcat_id
		IF (NEW.pm_workcat_id IS NULL) THEN
			NEW.pm_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.pm_workcat_id IS NULL) THEN
				NEW.pm_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
		--Builtdate
		IF (NEW.pm_builtdate IS NULL) THEN
			NEW.pm_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.pm_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.pm_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere,num_value) 
		VALUES (NEW.node_id, NEW.pm_code, NEW.pm_elevation, NEW.pm_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,NEW."state", NEW.state_type, NEW.pm_annotation, NEW.pm_observ, NEW.pm_comment, NEW.dma_id, 
		NEW.presszonecat_id, NEW.pm_soilcat_id, NEW.pm_function_type, NEW.pm_category_type, NEW.pm_fluid_type, NEW.pm_location_type, NEW.pm_workcat_id, NEW.pm_workcat_id_end, NEW.pm_buildercat_id,
		NEW.pm_builtdate, NEW.pm_enddate, NEW.pm_ownercat_id, NEW.pm_muni_id, NEW.pm_streetaxis_id, NEW.pm_streetaxis_02_id, NEW.pm_postcode,NEW.pm_postnumber, NEW.pm_postnumber_02, NEW.pm_descript, NEW.pm_rotation, NEW.verified, NEW.the_geom,NEW.undelete, 
		NEW.pm_label_x,NEW.pm_label_y,NEW.pm_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.pm_hemisphere, NEW.pm_num_value);
		
		INSERT INTO man_pump (node_id, max_flow, min_flow, nom_flow, power, pressure, elev_height,name) VALUES(NEW.node_id, NEW.pm_max_flow, NEW.pm_min_flow, NEW.pm_nom_flow, NEW.pm_power, NEW.pm_pressure, NEW.pm_elev_height, NEW.pm_name);
		
	ELSIF man_table='man_reduction' THEN
				
		-- Workcat_id
		IF (NEW.rd_workcat_id IS NULL) THEN
			NEW.rd_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.rd_workcat_id IS NULL) THEN
				NEW.rd_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
		--Builtdate
		IF (NEW.rd_builtdate IS NULL) THEN
			NEW.rd_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.rd_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.rd_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state,state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.rd_code, NEW.rd_elevation, NEW.rd_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.rd_annotation, NEW.rd_observ, 
		NEW.rd_comment, NEW.dma_id, NEW.presszonecat_id, NEW.rd_soilcat_id, NEW.rd_function_type, NEW.rd_category_type, NEW.rd_fluid_type, NEW.rd_location_type, NEW.rd_workcat_id, NEW.rd_workcat_id_end,
		NEW.rd_buildercat_id, NEW.rd_builtdate, NEW.rd_enddate, NEW.rd_ownercat_id, NEW.rd_muni_id, NEW.rd_streetaxis_id, NEW.rd_streetaxis_02_id,NEW.rd_postcode,NEW.rd_postnumber, NEW.rd_postnumber_02, NEW.rd_descript, NEW.rd_rotation,
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.rd_label_x,NEW.rd_label_y,NEW.rd_label_rotation, 
		NEW.expl_id, NEW.publish, NEW.inventory, NEW.rd_hemisphere, NEW.rd_num_value);
		
		INSERT INTO man_reduction (node_id,diam1,diam2) VALUES(NEW.node_id,NEW.rd_diam1, NEW.rd_diam2);
		
	ELSIF man_table='man_valve' THEN	
				
		-- Workcat_id
		IF (NEW.vl_workcat_id IS NULL) THEN
			NEW.vl_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.vl_workcat_id IS NULL) THEN
				NEW.vl_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
	
		--Builtdate
		IF (NEW.vl_builtdate IS NULL) THEN
			NEW.vl_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.vl_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.vl_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.vl_code, NEW.vl_elevation, NEW.vl_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.vl_annotation, NEW.vl_observ, NEW.vl_comment, 
		NEW.dma_id, NEW.presszonecat_id, NEW.vl_soilcat_id, NEW.vl_function_type, NEW.vl_category_type, NEW.vl_fluid_type, NEW.vl_location_type, NEW.vl_workcat_id, NEW.vl_workcat_id_end, NEW.vl_buildercat_id, 
		NEW.vl_builtdate, NEW.vl_enddate, NEW.vl_ownercat_id, NEW.vl_muni_id, NEW.vl_streetaxis_id, NEW.vl_streetaxis_02_id,NEW.vl_postcode,NEW.vl_postnumber,NEW.vl_postnumber_02, NEW.vl_descript, NEW.vl_rotation, NEW.verified, NEW.the_geom, NEW.undelete,
		NEW.vl_label_x,	NEW.vl_label_y,NEW.vl_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.vl_hemisphere, NEW.vl_num_value);
		
		INSERT INTO man_valve (node_id,closed, broken, buried,irrigation_indicator,pression_entry, pression_exit, depth_valveshaft,regulator_situation, regulator_location, regulator_observ,lin_meters, exit_type,exit_code,vl_diam,drive_type, cat_valve2, arc_id) 
		VALUES (NEW.node_id, NEW.vl_closed, NEW.vl_broken, NEW.vl_buried, NEW.vl_irrigation_indicator, NEW.vl_pression_entry, NEW.vl_pression_exit, NEW.vl_depth_valveshaft, NEW.vl_regulator_situation, NEW.vl_regulator_location, NEW.vl_regulator_observ, NEW.vl_lin_meters, 
		NEW.vl_exit_type, NEW.vl_exit_code, NEW.vl_vl_diam, NEW.vl_drive_type, NEW.vl_cat_valve2, NEW.vl_arc_id);
		
	ELSIF man_table='man_manhole' THEN	

		-- Workcat_id
		IF (NEW.mh_workcat_id IS NULL) THEN
			NEW.mh_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.mh_workcat_id IS NULL) THEN
				NEW.mh_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

			--Builtdate
		IF (NEW.mh_builtdate IS NULL) THEN
			NEW.mh_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.mh_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.mh_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.mh_code, NEW.mh_elevation, NEW.mh_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.mh_annotation, NEW.mh_observ, NEW.mh_comment, NEW.dma_id, NEW.presszonecat_id,
		NEW.mh_soilcat_id, NEW.mh_function_type, NEW.mh_category_type, NEW.mh_fluid_type, NEW.mh_location_type, NEW.mh_workcat_id, NEW.mh_workcat_id_end, NEW.mh_buildercat_id, NEW.mh_builtdate, 
		NEW.mh_enddate, NEW.mh_ownercat_id, NEW.mh_muni_id, NEW.mh_streetaxis_id, NEW.mh_streetaxis_02_id,NEW.mh_postcode,NEW.mh_postnumber,NEW.mh_postnumber_02, NEW.mh_descript, NEW.mh_rotation, NEW.verified, NEW.the_geom, NEW.undelete,
		NEW.mh_label_x,NEW.mh_label_y,NEW.mh_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.mh_hemisphere, NEW.mh_num_value);
		
		INSERT INTO man_manhole (node_id, name) VALUES(NEW.node_id, NEW.mh_name);
		
	ELSIF man_table='man_meter' THEN
			
		-- Workcat_id
		IF (NEW.mt_workcat_id IS NULL) THEN
			NEW.mt_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.mt_workcat_id IS NULL) THEN
				NEW.mt_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

			--Builtdate
		IF (NEW.mt_builtdate IS NULL) THEN
				NEW.mt_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;		

		--Copy id to code field
			IF (NEW.mt_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.mt_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, 
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.mt_code, NEW.mt_elevation, NEW.mt_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.mt_annotation, NEW.mt_observ, NEW.mt_comment, NEW.dma_id, NEW.presszonecat_id,
		NEW.mt_soilcat_id, NEW.mt_function_type, NEW.mt_category_type, NEW.mt_fluid_type, NEW.mt_location_type, NEW.mt_workcat_id, NEW.mt_workcat_id_end, NEW.mt_buildercat_id, NEW.mt_builtdate, NEW.mt_enddate, 
		NEW.mt_ownercat_id, NEW.mt_muni_id, NEW.mt_streetaxis_id, NEW.mt_streetaxis_02_id, NEW.mt_postcode,NEW.mt_postnumber,NEW.mt_postnumber_02,NEW.mt_descript, NEW.mt_rotation,NEW.verified, NEW.the_geom, NEW.undelete,NEW.mt_label_x,NEW.mt_label_y,
		NEW.mt_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.mt_hemisphere, NEW.mt_num_value);
		
		INSERT INTO man_meter (node_id) VALUES(NEW.node_id);
		
	ELSIF man_table='man_source' THEN	

		-- Workcat_id
		IF (NEW.so_workcat_id IS NULL) THEN
			NEW.so_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.so_workcat_id IS NULL) THEN
				NEW.so_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.so_builtdate IS NULL) THEN
			NEW.so_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

				--Copy id to code field
			IF (NEW.so_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.so_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate,enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom,undelete, label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.so_code, NEW.so_elevation, NEW.so_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.so_annotation, NEW.so_observ, NEW.so_comment, NEW.dma_id, NEW.presszonecat_id, 
		NEW.so_soilcat_id, NEW.so_function_type, NEW.so_category_type, NEW.so_fluid_type, NEW.so_location_type, NEW.so_workcat_id, NEW.so_workcat_id_end, NEW.so_buildercat_id, NEW.so_builtdate, 
		NEW.so_enddate, NEW.so_ownercat_id, NEW.so_muni_id, NEW.so_streetaxis_id, NEW.so_streetaxis_02_id,NEW.so_postcode,NEW.so_postnumber,NEW.so_postnumber_02, NEW.so_descript, NEW.so_rotation, NEW.verified, NEW.the_geom, NEW.undelete,
		NEW.so_label_x,NEW.so_label_y,NEW.so_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.so_hemisphere, NEW.so_num_value);
		
		INSERT INTO man_source (node_id, name) VALUES(NEW.node_id, NEW.so_name);
		
	ELSIF man_table='man_waterwell' THEN
				
		-- Workcat_id
		IF (NEW.ww_workcat_id IS NULL) THEN
			NEW.ww_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.ww_workcat_id IS NULL) THEN
				NEW.ww_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
		
		--Builtdate
		IF (NEW.ww_builtdate IS NULL) THEN
			NEW.ww_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.ww_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ww_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		 VALUES (NEW.node_id, NEW.ww_code, NEW.ww_elevation, NEW.ww_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type,NEW.ww_annotation, NEW.ww_observ, NEW.ww_comment,
		NEW.dma_id,NEW.presszonecat_id, NEW.ww_soilcat_id, NEW.ww_function_type, NEW.ww_category_type, NEW.ww_fluid_type, NEW.ww_location_type, NEW.ww_workcat_id, NEW.ww_workcat_id_end, NEW.ww_buildercat_id, NEW.ww_builtdate, NEW.ww_enddate, 
		NEW.ww_ownercat_id, NEW.ww_muni_id, NEW.ww_streetaxis_id, NEW.ww_streetaxis_02_id,NEW.ww_postcode,NEW.ww_postnumber,NEW.ww_postnumber_02, NEW.ww_descript, NEW.ww_rotation, NEW.verified, NEW.the_geom,
		NEW.undelete,NEW.ww_label_x,NEW.ww_label_y,NEW.ww_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.ww_hemisphere, NEW.ww_num_value);
		
		INSERT INTO man_waterwell (node_id, name) VALUES(NEW.node_id, NEW.ww_name);
		
	ELSIF man_table='man_filter' THEN
				
		-- Workcat_id
		IF (NEW.fl_workcat_id IS NULL) THEN
			NEW.fl_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.fl_workcat_id IS NULL) THEN
				NEW.fl_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.fl_builtdate IS NULL) THEN
			NEW.fl_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.fl_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.fl_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, 
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value)
		VALUES (NEW.node_id, NEW.fl_code, NEW.fl_elevation, NEW.fl_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.fl_annotation, NEW.fl_observ, 
		NEW.fl_comment, NEW.dma_id, NEW.presszonecat_id, NEW.fl_soilcat_id, NEW.fl_function_type, NEW.fl_category_type, NEW.fl_fluid_type, NEW.fl_location_type, NEW.fl_workcat_id, NEW.fl_workcat_id_end, NEW.fl_buildercat_id, 
		NEW.fl_builtdate, NEW.fl_enddate, NEW.fl_ownercat_id, NEW.fl_muni_id, NEW.fl_streetaxis_id, NEW.fl_streetaxis_02_id, NEW.fl_postcode,NEW.fl_postnumber,NEW.fl_postnumber_02,NEW.fl_descript, NEW.fl_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.fl_label_x, NEW.fl_label_y,NEW.fl_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.fl_hemisphere, NEW.fl_num_value);
		
		INSERT INTO man_filter (node_id) VALUES(NEW.node_id);	
		
	ELSIF man_table='man_register' THEN
				
		-- Workcat_id
		IF (NEW.rg_workcat_id IS NULL) THEN
			NEW.rg_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.rg_workcat_id IS NULL) THEN
				NEW.rg_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.rg_builtdate IS NULL) THEN
			NEW.rg_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;
	
		--Copy id to code field
			IF (NEW.rg_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.rg_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.rg_code, NEW.rg_elevation, NEW.rg_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type,NEW.rg_annotation, NEW.rg_observ,
		NEW.rg_comment, NEW.dma_id, NEW.presszonecat_id, NEW.rg_soilcat_id, NEW.rg_function_type, NEW.rg_category_type, NEW.rg_fluid_type, NEW.rg_location_type, NEW.rg_workcat_id, NEW.rg_workcat_id_end, NEW.rg_buildercat_id, 
		NEW.rg_builtdate, NEW.rg_enddate, NEW.rg_ownercat_id, NEW.rg_muni_id, NEW.rg_streetaxis_id,NEW.rg_postcode,NEW.rg_postnumber,NEW.rg_postnumber_02, NEW.rg_streetaxis_02_id, NEW.rg_descript, NEW.rg_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.rg_label_x,NEW.rg_label_y,NEW.rg_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.rg_hemisphere, NEW.rg_num_value);
		
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.rg_pol_id IS NULL) THEN
					NEW.rg_pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
				
					INSERT INTO man_register (node_id,pol_id) VALUES (NEW.node_id, NEW.rg_pol_id);
					INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.rg_pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			ELSE
				INSERT INTO man_register (node_id) VALUES (NEW.node_id);
			END IF;	
			
	ELSIF man_table='man_register_pol' THEN
				
		-- Workcat_id
		IF (NEW.rg_workcat_id IS NULL) THEN
			NEW.rg_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.rg_workcat_id IS NULL) THEN
				NEW.rg_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.rg_builtdate IS NULL) THEN
			NEW.rg_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.rg_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.rg_code=NEW.node_id;
			END IF;
			
			
		IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.rg_pol_id IS NULL) THEN
					NEW.rg_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				

				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.rg_pol_id,NEW.the_geom);
				INSERT INTO man_register (node_id,pol_id) VALUES (NEW.node_id, NEW.rg_pol_id);
				
				INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.rg_code, NEW.rg_elevation, NEW.rg_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.rg_annotation, NEW.rg_observ,
		NEW.rg_comment, NEW.dma_id, NEW.presszonecat_id, NEW.rg_soilcat_id, NEW.rg_function_type, NEW.rg_category_type, NEW.rg_fluid_type, NEW.rg_location_type, NEW.rg_workcat_id, NEW.rg_workcat_id_end, NEW.rg_buildercat_id, 
		NEW.rg_builtdate, NEW.rg_enddate, NEW.rg_ownercat_id, NEW.rg_muni_id, NEW.rg_streetaxis_id, NEW.rg_streetaxis_02_id,NEW.rg_postcode,NEW.rg_postnumber,NEW.rg_postnumber_02, NEW.rg_descript, NEW.rg_rotation, NEW.verified, 
		(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.rg_pol_id), NEW.undelete,NEW.rg_label_x,NEW.rg_label_y,NEW.rg_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.rg_hemisphere, NEW.rg_num_value);
				
			END IF;			
			
	ELSIF man_table='man_netwjoin' THEN
				
		-- Workcat_id
		IF (NEW.nw_workcat_id IS NULL) THEN
			NEW.nw_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.nw_workcat_id IS NULL) THEN
				NEW.nw_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.nw_builtdate IS NULL) THEN
			NEW.nw_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.nw_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.nw_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, 
		workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.nw_code, NEW.nw_elevation, NEW.nw_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.nw_annotation, NEW.nw_observ,
		NEW.nw_comment, NEW.dma_id, NEW.presszonecat_id, NEW.nw_soilcat_id, NEW.nw_function_type, NEW.nw_category_type, NEW.nw_fluid_type, NEW.nw_location_type, NEW.nw_workcat_id, NEW.nw_workcat_id_end, 
		NEW.nw_buildercat_id, NEW.nw_builtdate, NEW.nw_enddate, NEW.nw_ownercat_id, NEW.nw_muni_id, NEW.nw_streetaxis_id, NEW.nw_streetaxis_02_id, NEW.nw_postcode,NEW.nw_postnumber,NEW.nw_postnumber_02, NEW.nw_descript, NEW.nw_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.nw_label_x,NEW.nw_label_y,NEW.nw_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.nw_hemisphere, NEW.nw_num_value);
		
		INSERT INTO man_netwjoin (node_id, muni_id, streetaxis_id, postnumber, top_floor,  cat_valve, customer_code) 
		VALUES(NEW.node_id, NEW.nw_muni_id, NEW.nw_streetaxis_id, NEW.nw_postnumber, NEW.nw_top_floor, NEW.nw_cat_valve, NEW.nw_customer_code);
		
	ELSIF man_table='man_expansiontank' THEN

		-- Workcat_id
		IF (NEW.ex_workcat_id IS NULL) THEN
			NEW.ex_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.ex_workcat_id IS NULL) THEN
				NEW.ex_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.ex_builtdate IS NULL) THEN
			NEW.ex_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;
		
		--Copy id to code field
			IF (NEW.ex_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ex_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation,  expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.ex_code, NEW.ex_elevation, NEW.ex_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,	NEW.state, NEW.state_type, NEW.ex_annotation, NEW.ex_observ,
		NEW.ex_comment, NEW.dma_id, NEW.presszonecat_id, NEW.ex_soilcat_id, NEW.ex_function_type, NEW.ex_category_type, NEW.ex_fluid_type, NEW.ex_location_type, NEW.ex_workcat_id, NEW.ex_workcat_id_end, 
		NEW.ex_buildercat_id, NEW.ex_builtdate, NEW.ex_enddate,  NEW.ex_ownercat_id, NEW.ex_muni_id, NEW.ex_streetaxis_id, NEW.ex_streetaxis_02_id,NEW.ex_postcode,NEW.ex_postnumber,NEW.ex_postnumber_02, NEW.ex_descript, NEW.ex_rotation, NEW.verified, 
		NEW.the_geom, NEW.undelete,NEW.ex_label_x,NEW.ex_label_y,NEW.ex_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.ex_hemisphere, NEW.ex_num_value);
		
		INSERT INTO man_expansiontank (node_id) VALUES(NEW.node_id);
		
	ELSIF man_table='man_flexunion' THEN
				
		-- Workcat_id
		IF (NEW.fu_workcat_id IS NULL) THEN
			NEW.fu_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.fu_workcat_id IS NULL) THEN
				NEW.fu_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.fu_builtdate IS NULL) THEN
			NEW.fu_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.fu_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.fu_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.fu_code, NEW.fu_elevation, NEW.fu_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,NEW.state, NEW.state_type, NEW.fu_annotation, NEW.fu_observ,
		NEW.fu_comment, NEW.dma_id, NEW.presszonecat_id, NEW.fu_soilcat_id, NEW.fu_function_type, NEW.fu_category_type, NEW.fu_fluid_type, NEW.fu_location_type, NEW.fu_workcat_id, NEW.fu_workcat_id_end, 
		NEW.fu_buildercat_id, NEW.fu_builtdate, NEW.fu_enddate,  NEW.fu_ownercat_id, NEW.fu_muni_id, NEW.fu_streetaxis_id, NEW.fu_streetaxis_02_id, NEW.fu_postcode,NEW.fu_postnumber,NEW.fu_postnumber_02,NEW.fu_descript, NEW.fu_rotation,
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.fu_label_x, NEW.fu_label_y, NEW.fu_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.fu_hemisphere, NEW.fu_num_value);
		
		INSERT INTO man_flexunion (node_id) VALUES(NEW.node_id);
		
		ELSIF man_table='man_netelement' THEN
				
		-- Workcat_id
		IF (NEW.ne_workcat_id IS NULL) THEN
			NEW.ne_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.ne_workcat_id IS NULL) THEN
				NEW.ne_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.ne_builtdate IS NULL) THEN
			NEW.ne_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.ne_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ne_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.ne_code, NEW.ne_elevation, NEW.ne_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.ne_annotation, NEW.ne_observ,
		NEW.ne_comment, NEW.dma_id, NEW.presszonecat_id, NEW.ne_soilcat_id, NEW.ne_function_type, NEW.ne_category_type, NEW.ne_fluid_type, NEW.ne_location_type, NEW.ne_workcat_id, 
		NEW.ne_workcat_id_end, NEW.ne_buildercat_id, NEW.ne_builtdate, NEW.ne_enddate, NEW.ne_ownercat_id, NEW.ne_muni_id, NEW.ne_streetaxis_id, NEW.ne_streetaxis_02_id, 
		NEW.ne_postcode,NEW.ne_postnumber,NEW.ne_postnumber_02,NEW.ne_descript, NEW.ne_rotation, NEW.verified, NEW.the_geom, NEW.undelete,NEW.ne_label_x,NEW.ne_label_y,NEW.ne_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.ne_hemisphere,
		NEW.ne_num_value);
		
		INSERT INTO man_netelement (node_id, serial_number) VALUES(NEW.node_id, NEW.ne_serial_number);		
		
		ELSIF man_table='man_netsamplepoint' THEN
				
		-- Workcat_id
		IF (NEW.ns_workcat_id IS NULL) THEN
			NEW.ns_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.ns_workcat_id IS NULL) THEN
				NEW.ns_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.ns_builtdate IS NULL) THEN
			NEW.ns_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.ns_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ns_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id,postcode, postnumber, postnumber_02, descript, rotation,verified, the_geom, undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.ns_code, NEW.ns_elevation, NEW.ns_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.ns_annotation, NEW.ns_observ,
		NEW.ns_comment, NEW.dma_id, NEW.presszonecat_id, NEW.ns_soilcat_id, NEW.ns_function_type, NEW.ns_category_type, NEW.ns_fluid_type, NEW.ns_location_type, NEW.ns_workcat_id, NEW.ns_workcat_id_end, 
		NEW.ns_buildercat_id, NEW.ns_builtdate, NEW.ns_enddate, NEW.ns_ownercat_id, NEW.ns_muni_id, NEW.ns_streetaxis_id, NEW.ns_streetaxis_02_id,NEW.ns_postcode,NEW.ns_postnumber,NEW.ns_postnumber_02, NEW.ns_descript, NEW.ns_rotation, 
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.ns_label_x,NEW.ns_label_y,NEW.ns_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.ns_hemisphere, NEW.ns_num_value);
		
		INSERT INTO man_netsamplepoint (node_id, lab_code) VALUES(NEW.node_id, NEW.ns_lab_code);
		
		ELSIF man_table='man_wtp' THEN
				
		-- Workcat_id
		IF (NEW.wt_workcat_id IS NULL) THEN
			NEW.wt_workcat_id :=  (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.wt_workcat_id IS NULL) THEN
				NEW.wt_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;

		--Builtdate
		IF (NEW.wt_builtdate IS NULL) THEN
			NEW.wt_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
			IF (NEW.wt_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wt_code=NEW.node_id;
			END IF;
			
		INSERT INTO node (node_id, code, elevation, depth,  nodecat_id, epa_type, sector_id, state, state_type,annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate,enddate, ownercat_id, muni_id, streetaxis_id, streetaxis_02_id, postcode, postnumber, postnumber_02,descript, rotation,verified, the_geom,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.wt_code, NEW.wt_elevation, NEW.wt_depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id,NEW.state, NEW.state_type, NEW.wt_annotation, NEW.wt_observ,
		NEW.wt_comment, NEW.dma_id, NEW.presszonecat_id, NEW.wt_soilcat_id, NEW.wt_function_type, NEW.wt_category_type, NEW.wt_fluid_type, NEW.wt_location_type, NEW.wt_workcat_id, NEW.wt_workcat_id_end, 
		NEW.wt_buildercat_id, NEW.wt_builtdate, NEW.wt_enddate,  NEW.wt_ownercat_id, NEW.wt_muni_id, NEW.wt_streetaxis_id, NEW.wt_streetaxis_02_id, NEW.wt_postcode,NEW.wt_postnumber,NEW.wt_postnumber_02,NEW.wt_descript, NEW.wt_rotation,
		NEW.verified, NEW.the_geom, NEW.undelete,NEW.wt_label_x, NEW.wt_label_y, NEW.wt_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.wt_hemisphere, NEW.wt_num_value);
		
		INSERT INTO man_wtp (node_id, name) VALUES(NEW.node_id, NEW.wt_name);
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
                RETURN audit_function(1016,1318);  
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
		IF (NEW.jt_rotation != OLD.jt_rotation) THEN
			   UPDATE node SET rotation=NEW.jt_rotation WHERE node_id = OLD.node_id;
		END IF;	
	
		UPDATE node 
		SET code=NEW.jt_code, elevation=NEW.jt_elevation, "depth"=NEW."jt_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.jt_annotation, "observ"=NEW."jt_observ", "comment"=NEW."jt_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.jt_soilcat_id, 
		function_type=NEW.jt_function_type, category_type=NEW.jt_category_type, fluid_type=NEW.jt_fluid_type, location_type=NEW.jt_location_type, workcat_id=NEW.jt_workcat_id, workcat_id_end=NEW.jt_workcat_id_end,  
		buildercat_id=NEW.jt_buildercat_id,builtdate=NEW.jt_builtdate, enddate=NEW.jt_enddate, ownercat_id=NEW.jt_ownercat_id, muni_id=NEW.jt_muni_id, streetaxis_id=NEW.jt_streetaxis_id, 
		streetaxis_02_id=NEW.jt_streetaxis_02_id,postcode=NEW.jt_postcode,postnumber=NEW.jt_postnumber,postnumber_02=NEW.jt_postnumber_02, descript=NEW.jt_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.jt_label_x, 
		label_y=NEW.jt_label_y, label_rotation=NEW.jt_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.jt_hemisphere, num_value=NEW.jt_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_junction 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_tank' THEN
	
				--Label rotation
		IF (NEW.tk_rotation != OLD.tk_rotation) THEN
			   UPDATE node SET rotation=NEW.tk_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node 
		SET  code=NEW.tk_code, elevation=NEW.tk_elevation, "depth"=NEW."tk_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.tk_annotation, "observ"=NEW."tk_observ", "comment"=NEW."tk_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.tk_soilcat_id, function_type=NEW.tk_function_type, 
		category_type=NEW.tk_category_type, fluid_type=NEW.tk_fluid_type, location_type=NEW.tk_location_type, workcat_id=NEW.tk_workcat_id, workcat_id_end=NEW.tk_workcat_id_end, buildercat_id=NEW.tk_buildercat_id, 
		builtdate=NEW.tk_builtdate, enddate=NEW.tk_enddate, ownercat_id=NEW.tk_ownercat_id, muni_id=NEW.tk_muni_id, streetaxis_id=NEW.tk_streetaxis_id, streetaxis_02_id=NEW.tk_streetaxis_02_id,postcode=NEW.tk_postcode,
		postnumber=NEW.tk_postnumber,postnumber_02=NEW.tk_postnumber_02,descript=NEW.tk_descript, 
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.tk_label_x, label_y=NEW.tk_label_y, label_rotation=NEW.tk_label_rotation,
		publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.tk_hemisphere, num_value=NEW.tk_num_value
		WHERE node_id = OLD.node_id;

		UPDATE man_tank 
		SET pol_id=NEW.tk_pol_id, vmax=NEW.tk_vmax, vutil=NEW.tk_vutil, area=NEW.tk_area, chlorination=NEW.tk_chlorination, name=NEW.tk_name
		WHERE node_id=OLD.node_id;
	
	ELSIF man_table ='man_tank_pol' THEN
	
				--Label rotation
		IF (NEW.tk_rotation != OLD.tk_rotation) THEN
			   UPDATE node SET rotation=NEW.tk_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node 
		SET  code=NEW.tk_code, elevation=NEW.tk_elevation, "depth"=NEW."tk_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.tk_annotation, "observ"=NEW."tk_observ", "comment"=NEW."tk_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.tk_soilcat_id, function_type=NEW.tk_function_type, 
		category_type=NEW.tk_category_type, fluid_type=NEW.tk_fluid_type, location_type=NEW.tk_location_type, workcat_id=NEW.tk_workcat_id, workcat_id_end=NEW.tk_workcat_id_end, buildercat_id=NEW.tk_buildercat_id, 
		builtdate=NEW.tk_builtdate, enddate=NEW.tk_enddate, ownercat_id=NEW.tk_ownercat_id, muni_id=NEW.tk_muni_id, streetaxis_id=NEW.tk_streetaxis_id, streetaxis_02_id=NEW.tk_streetaxis_02_id,
		postcode=NEW.tk_postcode,postnumber=NEW.tk_postnumber,postnumber_02=NEW.tk_postnumber_02,descript=NEW.tk_descript, 
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.tk_label_x, label_y=NEW.tk_label_y, label_rotation=NEW.tk_label_rotation,
		publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.tk_hemisphere, num_value=NEW.tk_num_value
		WHERE node_id = OLD.node_id;

		UPDATE man_tank 
		SET pol_id=NEW.tk_pol_id, vmax=NEW.tk_vmax, vutil=NEW.tk_vutil, area=NEW.tk_area, chlorination=NEW.tk_chlorination, name=NEW.tk_name
		WHERE node_id=OLD.node_id;
		
		IF (NEW.tk_pol_id IS NULL) THEN
				UPDATE man_tank 
				SET pol_id=NEW.tk_pol_id, vmax=NEW.tk_vmax, vutil=NEW.tk_vutil, area=NEW.tk_area, chlorination=NEW.tk_chlorination, name=NEW.tk_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
		ELSE
				UPDATE man_tank 
				SET pol_id=NEW.tk_pol_id, vmax=NEW.tk_vmax, vutil=NEW.tk_vutil, area=NEW.tk_area, chlorination=NEW.tk_chlorination, name=NEW.tk_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.tk_pol_id
				WHERE pol_id=OLD.pol_id;
		END IF;

	ELSIF man_table ='man_pump' THEN
	
				--Label rotation
		IF (NEW.pm_rotation != OLD.pm_rotation) THEN
			   UPDATE node SET rotation=NEW.pm_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.pm_code, elevation=NEW.pm_elevation, "depth"=NEW."pm_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.pm_annotation, "observ"=NEW."pm_observ", "comment"=NEW."pm_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.pm_soilcat_id, function_type=NEW.pm_function_type, 
		category_type=NEW.pm_category_type, fluid_type=NEW.pm_fluid_type, location_type=NEW.pm_location_type, workcat_id=NEW.pm_workcat_id, workcat_id_end=NEW.pm_workcat_id_end, buildercat_id=NEW.pm_buildercat_id, 
		builtdate=NEW.pm_builtdate,  enddate=NEW.pm_enddate, ownercat_id=NEW.pm_ownercat_id, muni_id=NEW.pm_muni_id, streetaxis_id=NEW.pm_streetaxis_id, streetaxis_02_id=NEW.pm_streetaxis_02_id, 
		postcode=NEW.pm_postcode, postnumber=NEW.pm_postnumber,postnumber_02=NEW.pm_postnumber_02,descript=NEW.pm_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.pm_label_x, label_y=NEW.pm_label_y,
		label_rotation=NEW.pm_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.pm_hemisphere, num_value=NEW.pm_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_pump 
		SET max_flow=NEW.pm_max_flow, min_flow=NEW.pm_min_flow, nom_flow=NEW.pm_nom_flow, "power"=NEW.pm_power, pressure=NEW.pm_pressure, elev_height=NEW.pm_elev_height, name=NEW.pm_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_manhole' THEN
	
				--Label rotation
		IF (NEW.mh_rotation != OLD.mh_rotation) THEN
			   UPDATE node SET rotation=NEW.mh_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.mh_code, elevation=NEW.mh_elevation, "depth"=NEW."mh_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.mh_annotation, "observ"=NEW."mh_observ", "comment"=NEW."mh_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.mh_soilcat_id, 
		function_type=NEW.mh_function_type, category_type=NEW.mh_category_type, fluid_type=NEW.mh_fluid_type, location_type=NEW.mh_location_type, workcat_id=NEW.mh_workcat_id, workcat_id_end=NEW.mh_workcat_id_end, 
		buildercat_id=NEW.mh_buildercat_id, builtdate=NEW.mh_builtdate, enddate=NEW.mh_enddate,  ownercat_id=NEW.mh_ownercat_id, muni_id=NEW.mh_muni_id, streetaxis_id=NEW.mh_streetaxis_id, 
		streetaxis_02_id=NEW.mh_streetaxis_02_id,postcode=NEW.mh_postcode, postnumber=NEW.mh_postnumber,postnumber_02=NEW.mh_postnumber_02, descript=NEW.mh_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.mh_label_x, 
		label_y=NEW.mh_label_y, label_rotation=NEW.mh_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.mh_hemisphere, num_value=NEW.mh_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_manhole 
		SET name=NEW.mh_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_hydrant' THEN
	
				--Label rotation
		IF (NEW.hy_rotation != OLD.hy_rotation) THEN
			   UPDATE node SET rotation=NEW.hy_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.hy_code, elevation=NEW.hy_elevation, "depth"=NEW."hy_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		annotation=NEW.hy_annotation, "observ"=NEW."hy_observ", "comment"=NEW."hy_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.hy_soilcat_id, 
		function_type=NEW.hy_function_type, category_type=NEW.hy_category_type, fluid_type=NEW.hy_fluid_type, location_type=NEW.hy_location_type, workcat_id=NEW.hy_workcat_id,workcat_id_end=NEW.hy_workcat_id_end, 
		buildercat_id=NEW.hy_buildercat_id, builtdate=NEW.hy_builtdate, enddate=NEW.hy_enddate, ownercat_id=NEW.hy_ownercat_id, muni_id=NEW.hy_muni_id, streetaxis_id=NEW.hy_streetaxis_id, 
		streetaxis_02_id=NEW.hy_streetaxis_02_id, postcode=NEW.hy_postcode, postnumber=NEW.hy_postnumber,postnumber_02=NEW.hy_postnumber_02,descript=NEW.hy_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.hy_label_x, 
		label_y=NEW.hy_label_y, label_rotation=NEW.hy_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.hy_hemisphere, num_value=NEW.hy_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_hydrant 
		SET fire_code=NEW.hy_fire_code, communication=NEW.hy_communication, valve=NEW.hy_valve, vl_diam=NEW.hy_vl_diam
		WHERE node_id=OLD.node_id;			

	ELSIF man_table ='man_source' THEN
	
				--Label rotation
		IF (NEW.so_rotation != OLD.so_rotation) THEN
			   UPDATE node SET rotation=NEW.so_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.so_code, elevation=NEW.so_elevation, "depth"=NEW."so_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.so_annotation, "observ"=NEW."so_observ", "comment"=NEW."so_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.so_soilcat_id, 
		function_type=NEW.so_function_type, category_type=NEW.so_category_type, fluid_type=NEW.so_fluid_type, location_type=NEW.so_location_type, workcat_id=NEW.so_workcat_id, workcat_id_end=NEW.so_workcat_id_end, 
		buildercat_id=NEW.so_buildercat_id, builtdate=NEW.so_builtdate, enddate=NEW.so_enddate, ownercat_id=NEW.so_ownercat_id, muni_id=NEW.so_muni_id, streetaxis_id=NEW.so_streetaxis_id, 
		streetaxis_02_id=NEW.so_streetaxis_02_id,postcode=NEW.so_postcode, postnumber=NEW.so_postnumber,postnumber_02=NEW.so_postnumber_02, descript=NEW.so_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.so_label_x, 
		label_y=NEW.so_label_y, label_rotation=NEW.so_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.so_hemisphere, num_value=NEW.so_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_source 
		SET name=NEW.so_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_meter' THEN
	
				--Label rotation
		IF (NEW.mt_rotation != OLD.mt_rotation) THEN
			   UPDATE node SET rotation=NEW.mt_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET elevation=NEW.mt_elevation, "depth"=NEW."mt_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
		annotation=NEW.mt_annotation, "observ"=NEW."mt_observ", "comment"=NEW."mt_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.mt_soilcat_id, function_type=NEW.mt_function_type, 
		category_type=NEW.mt_category_type, fluid_type=NEW.mt_fluid_type, location_type=NEW.mt_location_type, workcat_id=NEW.mt_workcat_id, workcat_id_end=NEW.mt_workcat_id_end, buildercat_id=NEW.mt_buildercat_id, 
		builtdate=NEW.mt_builtdate, enddate=NEW.mt_enddate,  ownercat_id=NEW.mt_ownercat_id, muni_id=NEW.mt_muni_id, streetaxis_id=NEW.mt_streetaxis_id, streetaxis_02_id=NEW.mt_streetaxis_02_id,
		postcode=NEW.mt_postcode, postnumber=NEW.mt_postnumber,postnumber_02=NEW.mt_postnumber_02,descript=NEW.mt_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.mt_label_x, label_y=NEW.mt_label_y, label_rotation=NEW.mt_label_rotation,
		code=NEW.mt_code, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.mt_hemisphere, num_value=NEW.mt_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_meter 
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_waterwell' THEN
	
				--Label rotation
		IF (NEW.ww_rotation != OLD.ww_rotation) THEN
			   UPDATE node SET rotation=NEW.ww_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.ww_code, elevation=NEW.ww_elevation, "depth"=NEW."ww_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.ww_annotation, "observ"=NEW."ww_observ", "comment"=NEW."ww_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, 
		soilcat_id=NEW.ww_soilcat_id, function_type=NEW.ww_function_type, category_type=NEW.ww_category_type, fluid_type=NEW.ww_fluid_type, location_type=NEW.ww_location_type, workcat_id=NEW.ww_workcat_id, 
		workcat_id_end=NEW.ww_workcat_id_end, buildercat_id=NEW.ww_buildercat_id, builtdate=NEW.ww_builtdate, enddate=NEW.ww_enddate, ownercat_id=NEW.ww_ownercat_id, 
		muni_id=NEW.ww_muni_id, streetaxis_id=NEW.ww_streetaxis_id, streetaxis_02_id=NEW.ww_streetaxis_02_id,
		postcode=NEW.ww_postcode, postnumber=NEW.ww_postnumber,postnumber_02=NEW.ww_postnumber_02,descript=NEW.ww_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ww_label_x, label_y=NEW.ww_label_y, label_rotation=NEW.ww_label_rotation, publish=NEW.publish, inventory=NEW.inventory, 
		expl_id=NEW.expl_id, hemisphere=NEW.ww_hemisphere, num_value=NEW.ww_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_waterwell 
		SET name=NEW.ww_name
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_reduction' THEN
	
				--Label rotation
		IF (NEW.rd_rotation != OLD.rd_rotation) THEN
			   UPDATE node SET rotation=NEW.rd_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.rd_code, elevation=NEW.rd_elevation, "depth"=NEW."rd_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.rd_annotation, "observ"=NEW."rd_observ", "comment"=NEW."rd_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.rd_soilcat_id, 
		function_type=NEW.rd_function_type, category_type=NEW.rd_category_type, fluid_type=NEW.rd_fluid_type, location_type=NEW.rd_location_type, workcat_id=NEW.rd_workcat_id, 
		workcat_id_end=NEW.rd_workcat_id_end, buildercat_id=NEW.rd_buildercat_id, builtdate=NEW.rd_builtdate, enddate=NEW.rd_enddate, ownercat_id=NEW.rd_ownercat_id, muni_id=NEW.rd_muni_id, 
		streetaxis_id=NEW.rd_streetaxis_id, streetaxis_02_id=NEW.rd_streetaxis_02_id,postcode=NEW.rd_postcode, postnumber=NEW.rd_postnumber,postnumber_02=NEW.rd_postnumber_02,descript=NEW.rd_descript, verified=NEW.verified, 
		undelete=NEW.undelete, label_x=NEW.rd_label_x, label_y=NEW.rd_label_y, label_rotation=NEW.rd_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.rd_hemisphere,
		num_value=NEW.rd_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_reduction 
		SET diam1=NEW.rd_diam1, diam2=NEW.rd_diam2
		WHERE node_id=OLD.node_id;

	ELSIF man_table ='man_valve' THEN
	
				--Label rotation
		IF (NEW.vl_rotation != OLD.vl_rotation) THEN
			   UPDATE node SET rotation=NEW.vl_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.vl_code, elevation=NEW.vl_elevation, "depth"=NEW."vl_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.vl_annotation, "observ"=NEW."vl_observ", "comment"=NEW."vl_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.vl_soilcat_id, 
		function_type=NEW.vl_function_type, category_type=NEW.vl_category_type, fluid_type=NEW.vl_fluid_type, location_type=NEW.vl_location_type, workcat_id=NEW.vl_workcat_id, workcat_id_end=NEW.vl_workcat_id_end, buildercat_id=NEW.vl_buildercat_id, 
		builtdate=NEW.vl_builtdate, enddate=NEW.vl_enddate,  ownercat_id=NEW.vl_ownercat_id, muni_id=NEW.vl_muni_id, streetaxis_id=NEW.vl_streetaxis_id, streetaxis_02_id=NEW.vl_streetaxis_02_id,
		postcode=NEW.vl_postcode, postnumber=NEW.vl_postnumber,postnumber_02=NEW.vl_postnumber_02,descript=NEW.vl_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.vl_label_x, label_y=NEW.vl_label_y, label_rotation=NEW.vl_label_rotation, publish=NEW.publish, 
		inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.vl_hemisphere, num_value=NEW.vl_num_value
		WHERE node_id = OLD.node_id;
		
		UPDATE man_valve 
		SET closed=NEW.vl_closed, broken=NEW.vl_broken, buried=NEW.vl_buried, irrigation_indicator=NEW.vl_irrigation_indicator, pression_entry=NEW.vl_pression_entry, pression_exit=NEW.vl_pression_exit, 
		depth_valveshaft=NEW.vl_depth_valveshaft, regulator_situation=NEW.vl_regulator_situation, regulator_location=NEW.vl_regulator_location, regulator_observ=NEW.vl_regulator_observ, lin_meters=NEW.vl_lin_meters, 
		vl_diam=NEW.vl_vl_diam, exit_type=NEW.vl_exit_type, exit_code=NEW.vl_exit_code, drive_type=NEW.vl_drive_type, cat_valve2=NEW.vl_cat_valve2, arc_id=NEW.vl_arc_id
		WHERE node_id=OLD.node_id;	
		
	ELSIF man_table ='man_register' THEN
	
				--Label rotation
		IF (NEW.rg_rotation != OLD.rg_rotation) THEN
			   UPDATE node SET rotation=NEW.rg_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.rg_code, elevation=NEW.rg_elevation, "depth"=NEW."rg_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.rg_annotation, "observ"=NEW."rg_observ", "comment"=NEW."rg_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.rg_soilcat_id, 
		function_type=NEW.rg_function_type, category_type=NEW.rg_category_type, fluid_type=NEW.rg_fluid_type, location_type=NEW.rg_location_type, workcat_id=NEW.rg_workcat_id, workcat_id_end=NEW.rg_workcat_id_end, 
		buildercat_id=NEW.rg_buildercat_id, builtdate=NEW.rg_builtdate, enddate=NEW.rg_enddate, ownercat_id=NEW.rg_ownercat_id, muni_id=NEW.rg_muni_id, streetaxis_id=NEW.rg_streetaxis_id, 
		streetaxis_02_id=NEW.rg_streetaxis_02_id,postcode=NEW.rg_postcode, postnumber=NEW.rg_postnumber,postnumber_02=NEW.rg_postnumber_02, descript=NEW.rg_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.rg_label_x, 
		label_y=NEW.rg_label_y, label_rotation=NEW.rg_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.rg_hemisphere, num_value=NEW.rg_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_register
		SET pol_id=NEW.rg_pol_id
		WHERE node_id=OLD.node_id;		


	ELSIF man_table ='man_register_pol' THEN
	
				--Label rotation
		IF (NEW.rg_rotation != OLD.rg_rotation) THEN
			   UPDATE node SET rotation=NEW.rg_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.rg_code, elevation=NEW.rg_elevation, "depth"=NEW."rg_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.rg_annotation, "observ"=NEW."rg_observ", "comment"=NEW."rg_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.rg_soilcat_id, 
		function_type=NEW.rg_function_type, category_type=NEW.rg_category_type, fluid_type=NEW.rg_fluid_type, location_type=NEW.rg_location_type, workcat_id=NEW.rg_workcat_id, workcat_id_end=NEW.rg_workcat_id_end, 
		buildercat_id=NEW.rg_buildercat_id, builtdate=NEW.rg_builtdate, enddate=NEW.rg_enddate, ownercat_id=NEW.rg_ownercat_id, muni_id=NEW.rg_muni_id, streetaxis_id=NEW.rg_streetaxis_id, 
		streetaxis_02_id=NEW.rg_streetaxis_02_id, postcode=NEW.rg_postcode, postnumber=NEW.rg_postnumber,postnumber_02=NEW.rg_postnumber_02,descript=NEW.rg_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.rg_label_x, 
		label_y=NEW.rg_label_y, label_rotation=NEW.rg_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.rg_hemisphere, num_value=NEW.rg_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_register
		SET pol_id=NEW.rg_pol_id
		WHERE node_id=OLD.node_id;			

		IF (NEW.rg_pol_id IS NULL) THEN
				UPDATE man_register
				SET pol_id=NEW.rg_pol_id
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
		ELSE
				UPDATE man_register
				SET pol_id=NEW.rg_pol_id
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.rg_pol_id
				WHERE pol_id=OLD.pol_id;
		END IF;
		
	ELSIF man_table ='man_netwjoin' THEN
		
		--Label rotation
		IF (NEW.nw_rotation != OLD.nw_rotation) THEN
			   UPDATE node SET rotation=NEW.nw_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.nw_code, elevation=NEW.nw_elevation, "depth"=NEW."nw_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.nw_annotation, "observ"=NEW."nw_observ", "comment"=NEW."nw_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.nw_soilcat_id, 
		function_type=NEW.nw_function_type, category_type=NEW.nw_category_type, fluid_type=NEW.nw_fluid_type, location_type=NEW.nw_location_type, workcat_id=NEW.nw_workcat_id, 
		workcat_id_end=NEW.nw_workcat_id_end, buildercat_id=NEW.nw_buildercat_id, builtdate=NEW.nw_builtdate, enddate=NEW.nw_enddate, ownercat_id=NEW.nw_ownercat_id, muni_id=NEW.nw_muni_id, 
		streetaxis_id=NEW.nw_streetaxis_id, streetaxis_02_id=NEW.nw_streetaxis_02_id,postcode=NEW.nw_postcode, postnumber=NEW.nw_postnumber,postnumber_02=NEW.nw_postnumber_02, descript=NEW.nw_descript, verified=NEW.verified, undelete=NEW.undelete, 
		label_x=NEW.nw_label_x, label_y=NEW.nw_label_y, label_rotation=NEW.nw_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.nw_hemisphere, num_value=NEW.nw_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_netwjoin
		SET muni_id=NEW.nw_muni_id, streetaxis_id=NEW.nw_streetaxis_id, postnumber=NEW.nw_postnumber,top_floor= NEW.nw_top_floor, cat_valve=NEW.nw_cat_valve, customer_code=NEW.nw_customer_code
		WHERE node_id=OLD.node_id;		
		
	ELSIF man_table ='man_expansiontank' THEN
	
				--Label rotation
		IF (NEW.ex_rotation != OLD.ex_rotation) THEN
			   UPDATE node SET rotation=NEW.ex_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.ex_code, elevation=NEW.ex_elevation, "depth"=NEW."ex_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.ex_annotation, "observ"=NEW."ex_observ", "comment"=NEW."ex_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.ex_soilcat_id, 
		function_type=NEW.ex_function_type, category_type=NEW.ex_category_type, fluid_type=NEW.ex_fluid_type, location_type=NEW.ex_location_type, workcat_id=NEW.ex_workcat_id, workcat_id_end=NEW.ex_workcat_id_end, 
		buildercat_id=NEW.ex_buildercat_id, builtdate=NEW.ex_builtdate, enddate=NEW.ex_enddate,  ownercat_id=NEW.ex_ownercat_id, muni_id=NEW.ex_muni_id, streetaxis_id=NEW.ex_streetaxis_id, 
		streetaxis_02_id=NEW.ex_streetaxis_02_id, postcode=NEW.ex_postcode, postnumber=NEW.ex_postnumber,postnumber_02=NEW.ex_postnumber_02,descript=NEW.ex_descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ex_label_x, 
		label_y=NEW.ex_label_y, label_rotation=NEW.ex_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.ex_hemisphere, num_value=NEW.ex_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_expansiontank
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;		

	ELSIF man_table ='man_flexunion' THEN
	
				--Label rotation
		IF (NEW.fu_rotation != OLD.fu_rotation) THEN
			   UPDATE node SET rotation=NEW.fu_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.fu_code, elevation=NEW.fu_elevation, "depth"=NEW."fu_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.fu_annotation, "observ"=NEW."fu_observ", "comment"=NEW."fu_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.fu_soilcat_id, 
		function_type=NEW.fu_function_type, category_type=NEW.fu_category_type, fluid_type=NEW.fu_fluid_type, location_type=NEW.fu_location_type, workcat_id=NEW.fu_workcat_id, 
		workcat_id_end=NEW.fu_workcat_id_end, buildercat_id=NEW.fu_buildercat_id, builtdate=NEW.fu_builtdate, enddate=NEW.fu_enddate,  ownercat_id=NEW.fu_ownercat_id, muni_id=NEW.fu_muni_id, 
		streetaxis_id=NEW.fu_streetaxis_id, streetaxis_02_id=NEW.fu_streetaxis_02_id,postcode=NEW.fu_postcode, postnumber=NEW.fu_postnumber,postnumber_02=NEW.fu_postnumber_02, descript=NEW.fu_descript, verified=NEW.verified, 
		undelete=NEW.undelete, label_x=NEW.fu_label_x, label_y=NEW.fu_label_y, label_rotation=NEW.fu_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.fu_hemisphere,
		num_value=NEW.fu_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_flexunion
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;				
		
	ELSIF man_table ='man_netelement' THEN
	
				--Label rotation
		IF (NEW.ne_rotation != OLD.ne_rotation) THEN
			   UPDATE node SET rotation=NEW.ne_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.ne_code, elevation=NEW.ne_elevation, "depth"=NEW."ne_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		annotation=NEW.ne_annotation, "observ"=NEW."ne_observ", "comment"=NEW."ne_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.ne_soilcat_id, 
		function_type=NEW.ne_function_type, category_type=NEW.ne_category_type, fluid_type=NEW.ne_fluid_type, location_type=NEW.ne_location_type, workcat_id=NEW.ne_workcat_id, 
		workcat_id_end=NEW.ne_workcat_id_end, buildercat_id=NEW.ne_buildercat_id, builtdate=NEW.ne_builtdate, enddate=NEW.ne_enddate,  ownercat_id=NEW.ne_ownercat_id, muni_id=NEW.ne_muni_id, 
		streetaxis_id=NEW.ne_streetaxis_id, streetaxis_02_id=NEW.ne_streetaxis_02_id,postcode=NEW.ne_postcode, postnumber=NEW.ne_postnumber,postnumber_02=NEW.ne_postnumber_02, descript=NEW.ne_descript, verified=NEW.verified, 
		undelete=NEW.undelete, label_x=NEW.ne_label_x, label_y=NEW.ne_label_y, label_rotation=NEW.ne_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.ne_hemisphere,
		num_value=NEW.ne_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_netelement
		SET serial_number=NEW.ne_serial_number
		WHERE node_id=OLD.node_id;	
	
	ELSIF man_table ='man_netsamplepoint' THEN
		
		--Label rotation
		IF (NEW.ns_rotation != OLD.ns_rotation) THEN
			   UPDATE node SET rotation=NEW.ns_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
		SET code=NEW.ns_code, elevation=NEW.ns_elevation, "depth"=NEW."ns_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
		state_type=NEW.state_type, annotation=NEW.ns_annotation, "observ"=NEW."ns_observ", "comment"=NEW."ns_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, 
		soilcat_id=NEW.ns_soilcat_id, function_type=NEW.ns_function_type, category_type=NEW.ns_category_type, fluid_type=NEW.ns_fluid_type, location_type=NEW.ns_location_type, workcat_id=NEW.ns_workcat_id, 
		workcat_id_end=NEW.ns_workcat_id_end, buildercat_id=NEW.ns_buildercat_id, builtdate=NEW.ns_builtdate, enddate=NEW.ns_enddate,  ownercat_id=NEW.ns_ownercat_id, 
		muni_id=NEW.ns_muni_id, streetaxis_id=NEW.ns_streetaxis_id, streetaxis_02_id=NEW.ns_streetaxis_02_id,postcode=NEW.ns_postcode, postnumber=NEW.ns_postnumber,postnumber_02=NEW.ns_postnumber_02, descript=NEW.ns_descript,
		verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ns_label_x, label_y=NEW.ns_label_y, label_rotation=NEW.ns_label_rotation, publish=NEW.publish, inventory=NEW.inventory,
		expl_id=NEW.expl_id, hemisphere=NEW.ns_hemisphere, num_value=NEW.ns_num_value
		WHERE node_id = OLD.node_id;
	
		UPDATE man_netsamplepoint
		SET node_id=NEW.node_id
		WHERE node_id=OLD.node_id;		
		
	ELSIF man_table ='man_wtp' THEN		
	
				--Label rotation
		IF (NEW.wt_rotation != OLD.wt_rotation) THEN
			   UPDATE node SET rotation=NEW.wt_rotation WHERE node_id = OLD.node_id;
		END IF;
		
		UPDATE node
			SET code=NEW.wt_code, elevation=NEW.wt_elevation, "depth"=NEW."wt_depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			state_type=NEW.state_type, annotation=NEW.wt_annotation, "observ"=NEW."wt_observ", "comment"=NEW."wt_comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.wt_soilcat_id, 
			function_type=NEW.wt_function_type, category_type=NEW.wt_category_type, fluid_type=NEW.wt_fluid_type, location_type=NEW.wt_location_type, workcat_id=NEW.wt_workcat_id, 
			workcat_id_end=NEW.wt_workcat_id_end, buildercat_id=NEW.wt_buildercat_id, builtdate=NEW.wt_builtdate, enddate=NEW.wt_enddate,  ownercat_id=NEW.wt_ownercat_id, muni_id=NEW.wt_muni_id, 
			streetaxis_id=NEW.wt_streetaxis_id, streetaxis_02_id=NEW.wt_streetaxis_02_id, postcode=NEW.wt_postcode, postnumber=NEW.wt_postnumber,postnumber_02=NEW.wt_postnumber_02,descript=NEW.wt_descript, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.wt_label_x, label_y=NEW.wt_label_y, label_rotation=NEW.wt_label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.wt_hemisphere,
			num_value=NEW.wt_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wtp
			SET name=NEW.wt_name
			WHERE node_id=OLD.node_id;			
			
			
	ELSIF man_table ='man_filter' THEN
		
		UPDATE node
			SET node_id=NEW.node_id, elevation=NEW.fl_elevation, "depth"=NEW."fl_depth", node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW."fl_state", annotation=NEW.fl_annotation, "observ"=NEW."fl_observ", "comment"=NEW."fl_comment", dma_id=NEW.dma_id, soilcat_id=NEW.fl_soilcat_id, 
			category_type=NEW.fl_category_type, fluid_type=NEW.fl_fluid_type, location_type=NEW.fl_location_type, workcat_id=NEW.fl_workcat_id, buildercat_id=NEW.fl_buildercat_id, 
			builtdate=NEW.fl_builtdate, ownercat_id=NEW.fl_ownercat_id, muni_id=NEW.fl_muni_id, 
			streetaxis_id=NEW.fl_streetaxis_id, streetaxis_02_id=NEW.fl_streetaxis_02_id, postcode=NEW.fl_postcode, postnumber=NEW.fl_postnumber,postnumber_02=NEW.fl_postnumber_02, descript=NEW.fl_descript,
			rotation=NEW.fl_rotation, link=NEW.fl_link, verified=NEW.verified, the_geom=NEW.the_geom, workcat_id_end=NEW.fl_workcat_id_end, undelete=NEW.undelete, label_x=NEW.fl_label_x, 
			label_y=NEW.fl_label_y, label_rotation=NEW.fl_label_rotation
			WHERE node_id = OLD.node_id;
			
		UPDATE man_filter 
			SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
			
	END IF;

            
        --PERFORM audit_function(2,1318); 
        RETURN NEW;
    

-- DELETE

    ELSIF TG_OP = 'DELETE' THEN

	PERFORM gw_fct_check_delete(OLD.node_id, 'NODE');
	
   	
	IF man_table='man_tank_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.tk_pol_id;
	ELSIF man_table='man_tank' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_tank WHERE node_id=OLD.node_id );
	ELSIF man_table='man_register_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.rg_pol_id;
	ELSIF man_table='man_register' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_register WHERE node_id=OLD.node_id );
	ELSE 
		DELETE FROM node WHERE node_id = OLD.node_id;
	END IF;
	
	-- PERFORM audit_function(3,1318); 
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_man_hydrant ON "SCHEMA_NAME".v_edit_man_hydrant;
CREATE TRIGGER gw_trg_edit_man_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_hydrant FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_hydrant');

DROP TRIGGER IF EXISTS gw_trg_edit_man_pump ON "SCHEMA_NAME".v_edit_man_pump;
CREATE TRIGGER gw_trg_edit_man_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_pump');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_source ON "SCHEMA_NAME".v_edit_man_source;
CREATE TRIGGER gw_trg_edit_man_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_source FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_source');

DROP TRIGGER IF EXISTS gw_trg_edit_man_meter ON "SCHEMA_NAME".v_edit_man_meter;
CREATE TRIGGER gw_trg_edit_man_meter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_meter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_meter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank ON "SCHEMA_NAME".v_edit_man_tank;
CREATE TRIGGER gw_trg_edit_man_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_tank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank_pol ON "SCHEMA_NAME".v_edit_man_tank_pol;
CREATE TRIGGER gw_trg_edit_man_tank_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_tank_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_waterwell ON "SCHEMA_NAME".v_edit_man_waterwell;
CREATE TRIGGER gw_trg_edit_man_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waterwell FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_waterwell');

DROP TRIGGER IF EXISTS gw_trg_edit_man_reduction ON "SCHEMA_NAME".v_edit_man_reduction;
CREATE TRIGGER gw_trg_edit_man_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_reduction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_reduction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');

DROP TRIGGER IF EXISTS gw_trg_edit_man_filter ON "SCHEMA_NAME".v_edit_man_filter;
CREATE TRIGGER gw_trg_edit_man_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_filter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_filter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register ON "SCHEMA_NAME".v_edit_man_register;
CREATE TRIGGER gw_trg_edit_man_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_register');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register_pol ON "SCHEMA_NAME".v_edit_man_register_pol;
CREATE TRIGGER gw_trg_edit_man_register_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_register_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netwjoin ON "SCHEMA_NAME".v_edit_man_netwjoin;
CREATE TRIGGER gw_trg_edit_man_netwjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netwjoin FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netwjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_expansiontank ON "SCHEMA_NAME".v_edit_man_expansiontank;
CREATE TRIGGER gw_trg_edit_man_expansiontank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_expansiontank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_expansiontank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_flexunion ON "SCHEMA_NAME".v_edit_man_flexunion;
CREATE TRIGGER gw_trg_edit_man_flexunion INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_flexunion FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_flexunion');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netsamplepoint ON "SCHEMA_NAME".v_edit_man_netsamplepoint;
CREATE TRIGGER gw_trg_edit_man_netsamplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netsamplepoint FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netsamplepoint');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netelement');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wtp ON "SCHEMA_NAME".v_edit_man_wtp;
CREATE TRIGGER gw_trg_edit_man_wtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wtp');
