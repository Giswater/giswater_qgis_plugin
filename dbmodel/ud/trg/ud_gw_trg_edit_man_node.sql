/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


   

-- Function: "SCHEMA_NAME".gw_trg_edit_man_node()

-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    man_table varchar;
    new_man_table varchar;
    old_man_table varchar;
    v_sql varchar;
    v_sql2 varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    man_table_2 varchar;
	rec Record;
    node_id_seq int8;
	expl_id_int integer;
	code_autofill_bool boolean;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    man_table:= TG_ARGV[0];
    man_table_2:=man_table;

	--Get data from config table
	SELECT * INTO rec FROM config;	
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN

        -- Node ID
        IF (NEW.node_id IS NULL) THEN
            PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.node_id:= (SELECT nextval('urn_id_seq'));
        END IF;

      
        -- Node type
        IF (NEW.node_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM node_type WHERE node_type.man_table=man_table_2) = 0) THEN
                RETURN audit_function(105,830);  
            END IF;
            NEW.node_type:= (SELECT id FROM node_type WHERE node_type.man_table=man_table_2 LIMIT 1);
        END IF;

         -- Epa type
        IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM node_type WHERE node_type.id=NEW.node_type LIMIT 1)::text;   
		END IF;

        -- Node Catalog ID
        IF (NEW.nodecat_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
                RETURN audit_function(110,830);  
            END IF;      
			NEW.nodecat_id:= (SELECT "value" FROM config_vdefault WHERE "parameter"='nodecat_vdefault' AND "user"="current_user"());
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(115,830);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(120,830);          
            END IF;            
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(125,830);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(130,830);  
            END IF;            
        END IF;
		
		
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_vdefault WHERE "parameter"='verified_vdefault' AND "user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;

		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_vdefault WHERE "parameter"='state_vdefault' AND "user"="current_user"());
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

		SELECT code_autofill INTO code_autofill_bool FROM node_type WHERE id=NEW.node_type;
			
		IF man_table='man_junction' THEN
					
			-- Workcat_id
			IF (NEW.junction_workcat_id IS NULL) THEN
				NEW.junction_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.junction_workcat_id IS NULL) THEN
					NEW.junction_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.junction_builtdate IS NULL) THEN
				NEW.junction_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.junction_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.junction_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",
			dma_id,soilcat_id, function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,ownercat_id,address_01,address_02,address_03,descript,est_top_elev,est_ymax,rotation,link,verified,
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, enddate, uncertain, xyz_date, unconnected, num_value)
			VALUES (NEW.node_id,NEW.junction_top_elev,NEW.junction_custom_top_elev, NEW.junction_ymax, NEW. junction_custom_ymax, NEW. junction_elev, NEW. junction_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id, 
			NEW.state,NEW.junction_annotation,NEW.junction_observ, NEW.junction_comment,NEW.dma_id,NEW.junction_soilcat_id, NEW. junction_function_type, NEW.junction_category_type,NEW.junction_fluid_type,NEW.junction_location_type,
			NEW.junction_workcat_id, NEW.junction_workcat_id_end, NEW.junction_buildercat_id,NEW.junction_builtdate, NEW.junction_enddate, NEW.junction_ownercat_id,NEW.junction_address_01,NEW.junction_address_02,NEW.junction_address_03,
			NEW.junction_descript, NEW.junction_rotation,NEW.junction_link, NEW.verified, NEW.undelete, NEW.junction_label_x,NEW.junction_label_y,NEW.junction_label_rotation,NEW.the_geom,
			expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.junction_xyz_date, NEW.unconnected, NEW.junction_num_value);	

			INSERT INTO man_junction (node_id) VALUES (NEW.node_id);

			        
		ELSIF man_table='man_outfall' THEN

			-- Workcat_id
			IF (NEW.outfall_workcat_id IS NULL) THEN
				NEW.outfall_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.outfall_workcat_id IS NULL) THEN
					NEW.outfall_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.outfall_builtdate IS NULL) THEN
				NEW.outfall_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;
			
		--Copy id to code field
			IF (NEW.outfall_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.outfall_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,
			builtdate,ownercat_id,	address_01,address_02,address_03,descript,est_top_elev,est_ymax,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.outfall_code, NEW.outfall_top_elev,, NEW.outfall_custom_top_elev, NEW.outfall_ymax,NEW.outfall_custom_ymax, NEW.outfall_elev, NEW.outfall_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.state,
			NEW.outfall_annotation,NEW.outfall_observ, NEW.outfall_comment,NEW.dma_id,NEW.outfall_soilcat_id,NEW.outfall_function_type, NEW.outfall_category_type,NEW.outfall_fluid_type,NEW.outfall_location_type,NEW.outfall_workcat_id,NEW.outfall_workcat_id_end,
			NEW.outfall_buildercat_id,NEW.outfall_builtdate, NEW.outfall_enddate, NEW.outfall_ownercat_id,NEW.outfall_address_01,NEW.outfall_address_02,NEW.outfall_address_03,NEW.outfall_descript,NEW.outfall_rotation,NEW.outfall_link,
			NEW.verified,NEW.undelete,NEW.outfall_label_x,NEW.outfall_label_y,NEW.outfall_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.outfall_xyz_date, NEW.unconnected, NEW.outfall_num_value);

			INSERT INTO man_outfall (node_id, name) VALUES (NEW.node_id,NEW.outfall_name);
        
		ELSIF man_table='man_valve' THEN

			-- Workcat_id
			IF (NEW.valve_workcat_id IS NULL) THEN
				NEW.valve_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.valve_workcat_id IS NULL) THEN
					NEW.valve_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.valve_builtdate IS NULL) THEN
				NEW.valve_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.valve_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.valve_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, ownercat_id, address_01,address_02,address_03,descript, rotation,link,verified,
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.valve_code, NEW.valve_top_elev, NEW.valve_custom_top_elev, NEW.valve_ymax, NEW.valve_custom_ymax, NEW.valve_elev, NEW.valve_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,
			NEW.state,NEW.valve_annotation,NEW.valve_observ,NEW.valve_comment,NEW.dma_id, NEW.valve_soilcat_id,NEW.valve_function_type, NEW.valve_category_type,NEW.valve_fluid_type,NEW.valve_location_type,NEW.valve_workcat_id, 
			NEW.valve_workcat_id_end, NEW.valve_buildercat_id,NEW.valve_builtdate, NEW.valve_enddate, NEW.valve_ownercat_id,NEW.valve_address_01, NEW.valve_address_02, NEW.valve_address_03,NEW.valve_descript, NEW.valve_rotation,NEW.valve_link,
			NEW.verified, NEW.undelete,NEW.valve_label_x, NEW.valve_label_y,NEW.valve_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.valve_xyz_date, NEW.unconnected, NEW.valve_num_value);

			INSERT INTO man_valve (node_id, name) VALUES (NEW.node_id,NEW.valve_name);	
		
		ELSIF man_table='man_storage' THEN
					
			-- Workcat_id
			IF (NEW.storage_workcat_id IS NULL) THEN
				NEW.storage_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.storage_workcat_id IS NULL) THEN
					NEW.storage_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.storage_builtdate IS NULL) THEN
				NEW.storage_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.storage_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.storage_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id, epa_type, sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,
			function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,	builtdate,ownercat_id, address_01,address_02,address_03,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.storage_code, NEW.storage_top_elev, NEW.storage_custom_top_elev, NEW.storage_ymax,NEW.storage_custom_ymax, NEW.storage_elev, NEW.storage_custom_elev, NEW.node_type, NEW.nodecat_id,
			NEW.epa_type,NEW.sector_id, NEW.state,NEW.storage_annotation,NEW.storage_observ,NEW.storage_comment,NEW.dma_id,NEW.storage_soilcat_id, NEW.storage_function_type, NEW.storage_category_type,NEW.storage_fluid_type,
			NEW.storage_location_type,NEW.storage_workcat_id, NEW.storage_workcat_id_end, NEW.storage_buildercat_id,NEW.storage_builtdate, NEW.storage_enddate, NEW.storage_ownercat_id,NEW.storage_address_01,NEW.storage_address_02,
			NEW.storage_address_03,NEW.storage_descript,NEW.storage_est_top_elev,NEW.storage_est_ymax,NEW.storage_rotation,NEW.storage_link,NEW.verified,NEW.undelete,NEW.storage_label_x,NEW.storage_label_y,NEW.storage_label_rotation,
			NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory,  NEW.uncertain, NEW.storage_xyz_date, NEW.unconnected, NEW.storage_num_value);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name
				VALUES(NEW.node_id, NEW.pol_id, NEW.storage_length, NEW.storage_width,NEW.storage_custom_area, NEW.storage_max_volume, NEW.storage_util_volume, NEW.storage_min_height,NEW.storage_accessibility, NEW.storage_name);
				
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_storage (node_id,pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name
				VALUES(NEW.node_id, NEW.pol_id, NEW.storage_length, NEW.storage_width,NEW.storage_custom_area, NEW.storage_max_volume, NEW.storage_util_volume, NEW.storage_min_height,NEW.storage_accessibility, NEW.storage_name);
			END IF;
			
		ELSIF man_table='man_storage_pol' THEN
					
			-- Workcat_id
			IF (NEW.storage_workcat_id IS NULL) THEN
				NEW.storage_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.storage_workcat_id IS NULL) THEN
					NEW.storage_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.storage_builtdate IS NULL) THEN
				NEW.storage_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.storage_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.storage_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id, epa_type, sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,
			function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,	builtdate,ownercat_id,	address_01,address_02,address_03,descript,rotation,link,verified,undelete,
			label_x,label_y,label_rotation,the_geom,	expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.storage_code, NEW.storage_top_elev, NEW.storage_custom_top_elev, NEW.storage_ymax,NEW.storage_custom_ymax, NEW.storage_elev, NEW.storage_custom_elev, NEW.node_type, NEW.nodecat_id,
			NEW.epa_type,NEW.sector_id, NEW.state,NEW.storage_annotation,NEW.storage_observ,NEW.storage_comment,NEW.dma_id,NEW.storage_soilcat_id, NEW.storage_function_type, NEW.storage_category_type,NEW.storage_fluid_type,
			NEW.storage_location_type,NEW.storage_workcat_id, NEW.storage_workcat_id_end, NEW.storage_buildercat_id,NEW.storage_builtdate, NEW.storage_enddate, NEW.storage_ownercat_id,NEW.storage_address_01,NEW.storage_address_02,
			NEW.storage_address_03,NEW.storage_descript,NEW.storage_est_top_elev,NEW.storage_est_ymax,NEW.storage_rotation,NEW.storage_link,NEW.verified,NEW.undelete,NEW.storage_label_x,NEW.storage_label_y,NEW.storage_label_rotation,
			NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory,  NEW.uncertain, NEW.storage_xyz_date, NEW.unconnected, NEW.storage_num_value);
			
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name
				VALUES(NEW.node_id, NEW.pol_id, NEW.storage_length, NEW.storage_width,NEW.storage_custom_area, NEW.storage_max_volume, NEW.storage_util_volume, NEW.storage_min_height,NEW.storage_accessibility, NEW.storage_name);
								INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_netgully' THEN
					
			-- Workcat_id
			IF (NEW.netgully_workcat_id IS NULL) THEN
				NEW.netgully_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.netgully_workcat_id IS NULL) THEN
					NEW.netgully_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.netgully_builtdate IS NULL) THEN
				NEW.netgully_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.netgully_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.netgully_code=NEW.node_id;
			END IF;			

			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,ownercat_id,	address_01,address_02,address_03,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.netgully_code, NEW.netgully_top_elev, NEW.netgully_custom_top_elev, NEW.netgully_ymax, NEW.netgully_custom_ymax, NEW.netgully_elev, NEW.netgully_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,
			NEW.state,NEW.netgully_annotation,NEW.netgully_observ, NEW.netgully_comment,NEW.dma_id,NEW.netgully_soilcat_id,NEW.netgully_function_type, NEW.netgully_category_type,NEW.netgully_fluid_type,NEW.netgully_location_type,NEW.netgully_workcat_id, 
			NEW.netgully_workcat_id_end,NEW.netgully_buildercat_id,NEW.netgully_builtdate,NEW.netgully_enddate, NEW.netgully_ownercat_id,NEW.netgully_address_01,NEW.netgully_address_02,NEW.netgully_address_03,NEW.netgully_descript, NEW.netgully_rotation,
			NEW.netgully_link, NEW.verified,NEW.undelete,NEW.netgully_label_x,NEW.netgully_label_y,NEW.netgully_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.netgully_xyz_date, NEW.unconnected, NEW.netgully_num_value);
				
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id, sander_depth, gratecat_id, units, groove, siphon, streetaxis_id, postnumber ) 
				VALUES(NEW.node_id, NEW.pol_id, NEW.netgully_sander_depth, NEW.netgully_gratecat_id, NEW.netgully_units, 
				NEW.netgully_groove, NEW.netgully_siphon, NEW.netgully_streetaxis_id, NEW.netgully_postnumber );
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_netgully (node_id) VALUES(NEW.node_id);
			END IF;	

			
					 
		ELSIF man_table='man_netgully_pol' THEN

		-- Workcat_id
			IF (NEW.netgully_workcat_id IS NULL) THEN
				NEW.netgully_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.netgully_workcat_id IS NULL) THEN
					NEW.netgully_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.netgully_builtdate IS NULL) THEN
				NEW.netgully_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

				--Copy id to code field
			IF (NEW.netgully_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.netgully_code=NEW.node_id;
			END IF;
					
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,ownercat_id,	address_01,address_02,address_03,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.netgully_code, NEW.netgully_top_elev, NEW.netgully_custom_top_elev, NEW.netgully_ymax, NEW.netgully_custom_ymax, NEW.netgully_elev, NEW.netgully_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,
			NEW.state,NEW.netgully_annotation,NEW.netgully_observ, NEW.netgully_comment,NEW.dma_id,NEW.netgully_soilcat_id,NEW.netgully_function_type, NEW.netgully_category_type,NEW.netgully_fluid_type,NEW.netgully_location_type,NEW.netgully_workcat_id, 
			NEW.netgully_workcat_id_end,NEW.netgully_buildercat_id,NEW.netgully_builtdate,NEW.netgully_enddate, NEW.netgully_ownercat_id,NEW.netgully_address_01,NEW.netgully_address_02,NEW.netgully_address_03,NEW.netgully_descript, NEW.netgully_rotation,
			NEW.netgully_link, NEW.verified,NEW.undelete,NEW.netgully_label_x,NEW.netgully_label_y,NEW.netgully_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.netgully_xyz_date, NEW.unconnected, NEW.netgully_num_value);

			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id, sander_depth, gratecat_id, units, groove, siphon, streetaxis_id, postnumber ) VALUES(NEW.node_id, NEW.pol_id, NEW.netgully_sander_depth, NEW.netgully_gratecat_id, NEW.netgully_units, 
				NEW.netgully_groove, NEW.netgully_siphon, NEW.netgully_streetaxis_id, NEW.netgully_postnumber );
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
				
			END IF;
			
		ELSIF man_table='man_chamber' THEN

			-- Workcat_id
			IF (NEW.chamber_workcat_id IS NULL) THEN
				NEW.chamber_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.chamber_workcat_id IS NULL) THEN
					NEW.chamber_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.chamber_builtdate IS NULL) THEN
				NEW.chamber_builtdate:=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.chamber_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.chamber_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.chamber_code, NEW.chamber_top_elev,NEW.chamber_custom_top_elev, NEW.chamber_ymax, NEW.chamber_custom_ymax, NEW.chamber_elev, NEW.chamber_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,
			NEW.sector_id,NEW.state,NEW.chamber_annotation,NEW.chamber_observ, NEW.chamber_comment,NEW.dma_id,NEW.chamber_soilcat_id,NEW.chamber_function_type, NEW.chamber_category_type,NEW.chamber_fluid_type,NEW.chamber_location_type,
			NEW.chamber_workcat_id, NEW.chamber_workcat_id_end, NEW.chamber_buildercat_id,NEW.chamber_builtdate, NEW.chamber_enddate, NEW.chamber_ownercat_id,NEW.chamber_address_01,NEW.chamber_address_02,NEW.chamber_address_03,
			NEW.chamber_descript,NEW.chamber_rotation,NEW.chamber_link,NEW.verified, NEW.undelete,NEW.chamber_label_x,NEW.chamber_label_y,NEW.chamber_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, 
			NEW.chamber_xyz_date, NEW.unconnected, NEW.chamber_num_value);
					
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name
				VALUES (NEW.node_id,NEW.pol_id, NEW.chamber_length,NEW.chamber_width, NEW.chamber_sander_depth, NEW.chamber_max_volume, NEW.chamber_util_volume, 
				NEW.chamber_inlet, NEW.chamber_bottom_channel, NEW.chamber_accessibility,NEW.chamber_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_chamber (node_id,pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name
				VALUES (NEW.node_id,NEW.pol_id, NEW.chamber_length,NEW.chamber_width, NEW.chamber_sander_depth, NEW.chamber_max_volume, NEW.chamber_util_volume, 
				NEW.chamber_inlet, NEW.chamber_bottom_channel, NEW.chamber_accessibility,NEW.chamber_name);
			END IF;	
			
		ELSIF man_table='man_chamber_pol' THEN
			-- Workcat_id
			IF (NEW.chamber_workcat_id IS NULL) THEN
				NEW.chamber_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.chamber_workcat_id IS NULL) THEN
					NEW.chamber_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.chamber_builtdate IS NULL) THEN
				NEW.chamber_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.chamber_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.chamber_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.chamber_code, NEW.chamber_top_elev,NEW.chamber_custom_top_elev, NEW.chamber_ymax, NEW.chamber_custom_ymax, NEW.chamber_elev, NEW.chamber_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,
			NEW.sector_id,NEW.state,NEW.chamber_annotation,NEW.chamber_observ, NEW.chamber_comment,NEW.dma_id,NEW.chamber_soilcat_id,NEW.chamber_function_type, NEW.chamber_category_type,NEW.chamber_fluid_type,NEW.chamber_location_type,
			NEW.chamber_workcat_id, NEW.chamber_workcat_id_end, NEW.chamber_buildercat_id,NEW.chamber_builtdate, NEW.chamber_enddate, NEW.chamber_ownercat_id,NEW.chamber_address_01,NEW.chamber_address_02,NEW.chamber_address_03,
			NEW.chamber_descript,NEW.chamber_rotation,NEW.chamber_link,NEW.verified, NEW.undelete,NEW.chamber_label_x,NEW.chamber_label_y,NEW.chamber_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, 
			NEW.chamber_xyz_date, NEW.unconnected, NEW.chamber_num_value);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name
				VALUES (NEW.node_id,NEW.pol_id, NEW.chamber_length,NEW.chamber_width, NEW.chamber_sander_depth, NEW.chamber_max_volume, NEW.chamber_util_volume, 
				NEW.chamber_inlet, NEW.chamber_bottom_channel, NEW.chamber_accessibility,NEW.chamber_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_manhole' THEN
		
			-- Workcat_id
			IF (NEW.manhole_workcat_id IS NULL) THEN
				NEW.manhole_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.manhole_workcat_id IS NULL) THEN
					NEW.manhole_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.manhole_builtdate IS NULL) THEN
				NEW.manhole_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

					--Copy id to code field
			IF (NEW.manhole_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.manhole_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,
			builtdate, enddate, ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.manhole_code, NEW.manhole_top_elev,NEW.manhole_custom_top_elev, NEW.manhole_ymax, NEW.manhole_custom_ymax, NEW.manhole_elev, NEW.manhole_custom_elev, NEW.node_type,NEW.nodecat_id,
			NEW.epa_type,NEW.sector_id,NEW.state,NEW.manhole_annotation,NEW.manhole_observ,NEW.manhole_comment,NEW.dma_id,NEW.manhole_soilcat_id, NEW.manhole_function_type, NEW.manhole_category_type,NEW.manhole_fluid_type,
			NEW.manhole_location_type,NEW.manhole_workcat_id, NEW.manhole_workcat_id_end,NEW.manhole_buildercat_id,NEW.manhole_builtdate, NEW.manhole_enddate, NEW.manhole_ownercat_id,NEW.manhole_address_01,NEW.manhole_address_02,
			NEW.manhole_address_03,NEW.manhole_descript, NEW.manhole_rotation,NEW.manhole_link, NEW.verified, NEW.undelete,NEW.manhole_label_x,NEW.manhole_label_y,NEW.manhole_label_rotation,NEW.the_geom,
			expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.manhole_xyz_date, NEW.unconnected, NEW.manhole_num_value);

			INSERT INTO man_manhole (node_id,length, width, sander_depth,prot_surface, inlet, bottom_channel, accessibility) 
			VALUES (NEW.node_id,NEW.manhole_length, NEW.manhole_width, NEW.manhole_sander_depth,NEW.manhole_prot_surface, NEW.manhole_inlet, NEW.manhole_bottom_channel, NEW.manhole_accessibility);	
		
		ELSIF man_table='man_netinit' THEN
			
			-- Workcat_id
			IF (NEW.netinit_workcat_id IS NULL) THEN
				NEW.netinit_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.netinit_workcat_id IS NULL) THEN
					NEW.netinit_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.netinit_builtdate IS NULL) THEN
				NEW.netinit_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

				--Copy id to code field
			IF (NEW.netinit_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.netinit_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id, 
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,
			builtdate, enddate, ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.netinit_code, NEW.netinit_top_elev,NEW.netinit_custom_top_elev, NEW.netinit_ymax, NEW.netinit_custom_ymax, NEW.netinit_elev, NEW.netinit_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.state,
			NEW.netinit_annotation,NEW.netinit_observ, NEW.netinit_comment,NEW.dma_id,NEW.netinit_soilcat_id, NEW.netinit_function_type, NEW.netinit_category_type,NEW.netinit_fluid_type,NEW.netinit_location_type,NEW.netinit_workcat_id,NEW.netinit_workcat_id_end, 
			NEW.netinit_buildercat_id,NEW.netinit_builtdate, NEW.netinit_enddate, NEW.netinit_ownercat_id,NEW.netinit_address_01,NEW.netinit_address_02,NEW.netinit_address_03,NEW.netinit_descript, NEW.netinit_rotation,
			NEW.netinit_link, NEW.verified, NEW.undelete,NEW.netinit_label_x,NEW.netinit_label_y,NEW.netinit_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.netinit_xyz_date, NEW.unconnected, NEW.netinit_num_value); 

			INSERT INTO man_netinit (node_id,length, width, inlet, bottom_channel, accessibility, name) 
			VALUES (NEW.node_id, NEW.netinit_length,NEW.netinit_width,NEW.netinit_inlet, NEW.netinit_bottom_channel, NEW.netinit_accessibility, NEW.netinit_name);
			
		ELSIF man_table='man_wjump' THEN
	
			-- Workcat_id
			IF (NEW.wjump_workcat_id IS NULL) THEN
				NEW.wjump_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
					NEW.wjump_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		
			--Builtdate
			IF (NEW.wjump_builtdate IS NULL) THEN
				NEW.wjump_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.wjump_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wjump_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.wjump_code, NEW.netinit_top_elev,NEW.netinit_custom_top_elev, NEW.netinit_ymax, NEW.wjump_custom_ymax, NEW.wjump_elev, NEW.wjump_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id, 
			NEW.state,NEW.wjump_annotation,NEW.wjump_observ,NEW.wjump_comment, NEW.dma_id,NEW.wjump_soilcat_id,NEW.wjump_function_type, NEW.wjump_category_type,NEW.wjump_fluid_type,NEW.wjump_location_type,NEW.wjump_workcat_id, NEW.wjump_workcat_id_end,
			NEW.wjump_buildercat_id,NEW.wjump_builtdate, NEW.wjump_enddate, NEW.wjump_ownercat_id, NEW.wjump_address_01,NEW.wjump_address_02,NEW.wjump_address_03,NEW.wjump_descript,	NEW.wjump_rotation,NEW.wjump_link,NEW.verified,
			NEW.undelete,NEW.wjump_label_x,NEW.wjump_label_y,NEW.wjump_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.wjump_xyz_date, NEW.unconnected, NEW.wjump_num_value);

			INSERT INTO man_wjump (node_id, length, width,sander_depth,prot_surface, accessibility, name) 
			VALUES (NEW.node_id, NEW.wjump_length,NEW.wjump_width,,NEW.wjump_sander_depth,NEW.wjump_prot_surface,NEW.wjump_accessibility, NEW.wjump_name);	

		ELSIF man_table='man_wwtp' THEN
		
			-- Workcat_id
			IF (NEW.wwtp_workcat_id IS NULL) THEN
				NEW.wwtp_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.wwtp_workcat_id IS NULL) THEN
					NEW.wwtp_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.wwtp_builtdate IS NULL) THEN
				NEW.wwtp_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.wwtp_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wwtp_code=NEW.node_id;
			END IF;
		
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified, 
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.wwtp_code, NEW.netinit_top_elev,NEW.netinit_custom_top_elev, NEW.netinit_ymax, NEW.wwtp_custom_ymax, NEW.wwtp_elev, NEW.wwtp_custom_elev, NEW.node_type, NEW.nodecat_id, 
			NEW.epa_type, NEW.sector_id, NEW.state,NEW.wwtp_annotation,NEW.wwtp_observ,NEW.wwtp_comment,NEW.dma_id, NEW.wwtp_soilcat_id, NEW.wwtp_function_type, NEW.wwtp_category_type,NEW.wwtp_fluid_type,
			NEW.wwtp_location_type,NEW.wwtp_workcat_id, NEW.wwtp_workcat_id_end, NEW.wwtp_buildercat_id,NEW.wwtp_builtdate, NEW.wwtp_enddate, NEW.wwtp_ownercat_id,NEW.wwtp_address_01,NEW.wwtp_address_02, 
			NEW.wwtp_address_03,NEW.wwtp_descript, NEW.wwtp_rotation,NEW.wwtp_link,NEW.verified,NEW.undelete,NEW.wwtp_label_x,NEW.wwtp_label_y,NEW.wwtp_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, 
			NEW.uncertain, NEW.wwtp_xyz_date, NEW.unconnected, NEW.wwtp_num_value);

			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,pol_id, name) VALUES (NEW.node_id,NEW.pol_id,NEW.wwtp_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_wwtp (node_id, name) VALUES (NEW.node_id,NEW.wwtp_name);
			END IF;	
			
		ELSIF man_table='man_wwtp_pol' THEN
			
			-- Workcat_id
			IF (NEW.wwtp_workcat_id IS NULL) THEN
				NEW.wwtp_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.wwtp_workcat_id IS NULL) THEN
					NEW.wwtp_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

				--Builtdate
			IF (NEW.wwtp_builtdate IS NULL) THEN
				NEW.wwtp_builtdate :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;
			
					--Copy id to code field
			IF (NEW.wwtp_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wwtp_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified, 
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.wwtp_code, NEW.netinit_top_elev,NEW.netinit_custom_top_elev, NEW.netinit_ymax, NEW.wwtp_custom_ymax, NEW.wwtp_elev, NEW.wwtp_custom_elev, NEW.node_type, NEW.nodecat_id, 
			NEW.epa_type, NEW.sector_id, NEW.state,NEW.wwtp_annotation,NEW.wwtp_observ,NEW.wwtp_comment,NEW.dma_id, NEW.wwtp_soilcat_id, NEW.wwtp_function_type, NEW.wwtp_category_type,NEW.wwtp_fluid_type,
			NEW.wwtp_location_type,NEW.wwtp_workcat_id, NEW.wwtp_workcat_id_end, NEW.wwtp_buildercat_id,NEW.wwtp_builtdate, NEW.wwtp_enddate, NEW.wwtp_ownercat_id,NEW.wwtp_address_01,NEW.wwtp_address_02, 
			NEW.wwtp_address_03,NEW.wwtp_descript, NEW.wwtp_rotation,NEW.wwtp_link,NEW.verified,NEW.undelete,NEW.wwtp_label_x,NEW.wwtp_label_y,NEW.wwtp_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, 
			NEW.uncertain, NEW.wwtp_xyz_date, NEW.unconnected, NEW.wwtp_num_value);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('pol_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,pol_id, name) VALUES (NEW.node_id,NEW.pol_id,NEW.wwtp_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_netelement' THEN
				
			-- Workcat_id
			IF (NEW.netelement_workcat_id IS NULL) THEN
				NEW.netelement_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
				IF (NEW.netelement_workcat_id IS NULL) THEN
					NEW.netelement_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.netelement_builtdate IS NULL) THEN
				NEW.netelement_builtdate := (SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
			END IF;

			--Copy id to code field
				IF (NEW.netelement_code IS NULL AND code_autofill_bool IS TRUE) THEN 
					NEW.netelement_code=NEW.node_id;
				END IF;
				
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,sander,node_type,nodecat_id,epa_type,sector_id,"state",annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,	address_01,address_02,address_03,descript, rotation,link,verified, 
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.netelement_code, NEW.netinit_top_elev,NEW.netinit_custom_top_elev, NEW.netinit_ymax, NEW.netelement_custom_ymax, NEW.netelement_elev, NEW.netelement_custom_elev, NEW.node_type, NEW.nodecat_id, 
			NEW.epa_type, NEW.sector_id, NEW.state,NEW.netelement_annotation,NEW.netelement_observ,NEW.netelement_comment,NEW.dma_id, NEW.netelement_soilcat_id, NEW.netelement_function_type, NEW.netelement_category_type,NEW.netelement_fluid_type,
			NEW.netelement_location_type,NEW.netelement_workcat_id, NEW.netelement_workcat_id_end, NEW.netelement_buildercat_id,NEW.netelement_builtdate, NEW.netelement_enddate, NEW.netelement_ownercat_id,NEW.netelement_address_01,NEW.netelement_address_02, 
			NEW.netelement_address_03,NEW.netelement_descript, NEW.netelement_rotation,NEW.netelement_link,NEW.verified,NEW.undelete,NEW.netelement_label_x,NEW.netelement_label_y,NEW.netelement_label_rotation,NEW.the_geom, expl_id_int, NEW.publish, NEW.inventory, 
			NEW.uncertain, NEW.netelement_xyz_date, NEW.unconnected, NEW.netelement_num_value);
			
			INSERT INTO man_netelement (node_id, serial_number) VALUES(NEW.node_id, NEW.netelement_serial_number);		
			
		END IF;
		
		-- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN
			INSERT INTO inp_junction (node_id, y0, ysur, apond) VALUES (NEW.node_id, 0, 0, 0);
			
        ELSIF (NEW.epa_type = 'DIVIDER') THEN
			INSERT INTO inp_divider (node_id, divider_type) VALUES (NEW.node_id, 'CUTOFF');
		
        ELSIF (NEW.epa_type = 'OUTFALL') THEN
			INSERT INTO inp_outfall (node_id, outfall_type) VALUES (NEW.node_id, 'NORMAL');
		
        ELSIF (NEW.epa_type = 'STORAGE') THEN
			INSERT INTO inp_storage (node_id, storage_type) VALUES (NEW.node_id, 'TABULAR');
		
		
        END IF;
          
        --PERFORM audit_function (1,830);
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN

/*
	IF (NEW.elev <> OLD.elev) THEN
                RETURN audit_function(200,830);  
	END IF;

        NEW.elev=NEW.top_elev-NEW.ymax;
 */

        IF (NEW.epa_type != OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'DIVIDER') THEN
                inp_table:= 'inp_divider';                
            ELSIF (OLD.epa_type = 'OUTFALL') THEN
                inp_table:= 'inp_outfall';    
            ELSIF (OLD.epa_type = 'STORAGE') THEN
                inp_table:= 'inp_storage';    
			END IF;
            v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
            EXECUTE v_sql;
			inp_table := NULL;


            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'DIVIDER') THEN
                inp_table:= 'inp_divider';     
            ELSIF (NEW.epa_type = 'OUTFALL') THEN
                inp_table:= 'inp_outfall';  
            ELSIF (NEW.epa_type = 'STORAGE') THEN
                inp_table:= 'inp_storage';
            END IF;
            v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
            EXECUTE v_sql;

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

		
        
		IF man_table ='man_junction' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.junction_code, top_elev=NEW.junction_top_elev, custom_top_elev=NEW.junction_custom_top_elev, ymax=NEW.junction_ymax, custom_ymax=NEW.junction_custom_ymax, elev=NEW.junction_elev, 
			custom_elev=NEW.junction_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.junction_annotation, "observ"=NEW.junction_observ, 
			"comment"=NEW.junction_comment, dma_id=NEW.dma_id, soilcat_id=NEW.junction_soilcat_id, function_type=NEW.junction_function_type,	category_type=NEW.junction_category_type,fluid_type=NEW.junction_fluid_type, 
			location_type=NEW.junction_location_type, workcat_id=NEW.junction_workcat_id, workcat_id_end=NEW.junction_workcat_id_end, buildercat_id=NEW.junction_buildercat_id, builtdate=NEW.junction_builtdate, enddate=NEW.junction_enddate, , 
			ownercat_id=NEW.junction_ownercat_id, address_01=NEW.junction_address_01,address_02=NEW.junction_address_02, address_03=NEW.junction_address_03, descript=NEW.junction_descript, rotation=NEW.junction_rotation, 
			link=NEW.junction_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.junction_label_x, label_y=NEW.junction_label_y, label_rotation=NEW.junction_label_rotation,the_geom=NEW.the_geom, 
			 publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.junction_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.junction_num_value
			WHERE node_id = OLD.node_id;
			
            UPDATE man_junction SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_netgully' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id,code=NEW.netgully_code, top_elev=NEW.netgully_top_elev, custom_top_elev=NEW.netgully_custom_top_elev, ymax=NEW.netgully_ymax, custom_ymax=NEW.netgully_custom_ymax, elev=NEW.netgully_elev, 
			custom_elev=NEW.netgully_custom_elev,  node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.netgully_annotation, "observ"=NEW.netgully_observ, 
			"comment"=NEW.netgully_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netgully_soilcat_id, function_type=NEW.netgully_function_type,	category_type=NEW.netgully_category_type,fluid_type=NEW.netgully_fluid_type, 
			location_type=NEW.netgully_location_type, workcat_id=NEW.netgully_workcat_id, workcat_id_end=NEW.netgully_workcat_id_end, buildercat_id=NEW.netgully_buildercat_id, builtdate=NEW.netgully_builtdate, enddate=NEW.netgully_enddate,
			ownercat_id=NEW.netgully_ownercat_id, address_01=NEW.netgully_address_01,address_02=NEW.netgully_address_02, address_03=NEW.netgully_address_03, descript=NEW.netgully_descript,
			est_top_elev=NEW.netgully_est_top_elev, est_ymax=NEW.netgully_est_ymax, rotation=NEW.netgully_rotation, link=NEW.netgully_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.netgully_label_x, label_y=NEW.netgully_label_y, 
			label_rotation=NEW.netgully_label_rotation, the_geom=NEW.the_geom,  publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.netgully_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.netgully_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id, sander_depth=NEW.netgully_sander_depth, gratecat_id=NEW.netgully_gratecat_id, units=NEW.netgully_units, groove=NEW.netgully_groove, siphon=NEW.netgully_siphon, 
			streetaxis_id=NEW.netgully_streetaxis_id, postnumber=NEW.netgully_postnumber
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_netgully_pol' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id,code=NEW.netgully_code, top_elev=NEW.netgully_top_elev, custom_top_elev=NEW.netgully_custom_top_elev, ymax=NEW.netgully_ymax, custom_ymax=NEW.netgully_custom_ymax, elev=NEW.netgully_elev, 
			custom_elev=NEW.netgully_custom_elev,  node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.netgully_annotation, "observ"=NEW.netgully_observ, 
			"comment"=NEW.netgully_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netgully_soilcat_id, function_type=NEW.netgully_function_type,	category_type=NEW.netgully_category_type,fluid_type=NEW.netgully_fluid_type, 
			location_type=NEW.netgully_location_type, workcat_id=NEW.netgully_workcat_id, workcat_id_end=NEW.netgully_workcat_id_end, buildercat_id=NEW.netgully_buildercat_id, builtdate=NEW.netgully_builtdate, enddate=NEW.netgully_enddate,
			ownercat_id=NEW.netgully_ownercat_id, address_01=NEW.netgully_address_01,address_02=NEW.netgully_address_02, address_03=NEW.netgully_address_03, descript=NEW.netgully_descript,
			est_top_elev=NEW.netgully_est_top_elev, est_ymax=NEW.netgully_est_ymax, rotation=NEW.netgully_rotation, link=NEW.netgully_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.netgully_label_x, label_y=NEW.netgully_label_y, 
			label_rotation=NEW.netgully_label_rotation, the_geom=NEW.the_geom,  publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.netgully_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.netgully_num_value
			WHERE node_id = OLD.node_id;
			
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id, sander_depth=NEW.netgully_sander_depth, gratecat_id=NEW.netgully_gratecat_id, units=NEW.netgully_units, groove=NEW.netgully_groove, siphon=NEW.netgully_siphon, 
				streetaxis_id=NEW.netgully_streetaxis_id, postnumber=NEW.netgully_postnumber
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_netgully SET node_id=NEW.node_id, pol_id=NEW.pol_id, sander_depth=NEW.netgully_sander_depth, gratecat_id=NEW.netgully_gratecat_id, units=NEW.netgully_units, groove=NEW.netgully_groove, siphon=NEW.netgully_siphon, 
				streetaxis_id=NEW.netgully_streetaxis_id, postnumber=NEW.netgully_postnumber
				WHERE node_id=OLD.node_id;	
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;
			
		ELSIF man_table='man_outfall' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.outfall_code, top_elev=NEW.outfall_top_elev, custom_top_elev=NEW.outfall_custom_top_elev, ymax=NEW.outfall_ymax, custom_ymax=NEW.outfall_custom_ymax, elev=NEW.outfall_elev, 
			custom_elev=NEW.outfall_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.outfall_annotation, "observ"=NEW.outfall_observ, 
			"comment"=NEW.outfall_comment, dma_id=NEW.dma_id, soilcat_id=NEW.outfall_soilcat_id, function_type=NEW.outfall_function_type, category_type=NEW.outfall_category_type,fluid_type=NEW.outfall_fluid_type, location_type=NEW.outfall_location_type, 
			workcat_id=NEW.outfall_workcat_id, workcat_id_end=NEW.outfall_workcat_id_end,buildercat_id=NEW.outfall_buildercat_id, builtdate=NEW.outfall_builtdate, enddate=NEW.outfall_enddate,  ownercat_id=NEW.outfall_ownercat_id, 
			address_01=NEW.outfall_address_01,address_02=NEW.outfall_address_02, address_03=NEW.outfall_address_03, descript=NEW.outfall_descript,est_top_elev=NEW.outfall_est_top_elev, est_ymax=NEW.outfall_est_ymax, rotation=NEW.outfall_rotation, 
			link=NEW.outfall_link, verified=NEW.verified,  undelete=NEW.undelete, label_x=NEW.outfall_label_x, label_y=NEW.outfall_label_y, label_rotation=NEW.outfall_label_rotation, the_geom=NEW.the_geom,
			 publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.outfall_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.outfall_num_value
			WHERE node_id = OLD.node_id;
			
			UPDATE man_outfall SET node_id=NEW.node_id, name=NEW.outfall_name
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_storage' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.storage_code, top_elev=NEW.storage_top_elev, custom_top_elev=NEW.storage_custom_top_elev, ymax=NEW.storage_ymax, custom_ymax=NEW.storage_custom_ymax, 
			elev=NEW.storage_elev, custom_elev=NEW.storage_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.storage_state, annotation=NEW.storage_annotation, "observ"=NEW.storage_observ, "comment"=NEW.storage_comment, dma_id=NEW.dma_id, soilcat_id=NEW.storage_soilcat_id, function_type=NEW.storage_function_type,
			category_type=NEW.storage_category_type,fluid_type=NEW.storage_fluid_type, location_type=NEW.storage_location_type, workcat_id=NEW.storage_workcat_id, workcat_id_end=NEW.storage_workcat_id_end, buildercat_id=NEW.storage_buildercat_id, 
			builtdate=NEW.storage_builtdate, enddate=NEW.storage_enddate, ownercat_id=NEW.storage_ownercat_id, address_01=NEW.storage_address_01,address_02=NEW.storage_address_02, address_03=NEW.storage_address_03, descript=NEW.storage_descript,
			est_top_elev=NEW.storage_est_top_elev, est_ymax=NEW.storage_est_ymax, rotation=NEW.storage_rotation, link=NEW.storage_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.storage_label_x, label_y=NEW.storage_label_y, 
			label_rotation=NEW.storage_label_rotation, the_geom=NEW.the_geom, publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.storage_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id,
			num_value=NEW.storage_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, length=NEW.storage_length, width=NEW.storage_width, custom_area=NEW.storage_custom_area, max_volume=NEW.storage_max_volume,
			util_volume=NEW.storage_util_volume,min_height=NEW.storage_min_height, accessibility=NEW.storage_accessibility, name=NEW.storage_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_storage_pol' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.storage_code, top_elev=NEW.storage_top_elev, custom_top_elev=NEW.storage_custom_top_elev, ymax=NEW.storage_ymax, custom_ymax=NEW.storage_custom_ymax, 
			elev=NEW.storage_elev, custom_elev=NEW.storage_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			"state"=NEW.storage_state, annotation=NEW.storage_annotation, "observ"=NEW.storage_observ, "comment"=NEW.storage_comment, dma_id=NEW.dma_id, soilcat_id=NEW.storage_soilcat_id, function_type=NEW.storage_function_type,
			category_type=NEW.storage_category_type,fluid_type=NEW.storage_fluid_type, location_type=NEW.storage_location_type, workcat_id=NEW.storage_workcat_id, workcat_id_end=NEW.storage_workcat_id_end, buildercat_id=NEW.storage_buildercat_id, 
			builtdate=NEW.storage_builtdate, enddate=NEW.storage_enddate, ownercat_id=NEW.storage_ownercat_id, address_01=NEW.storage_address_01,address_02=NEW.storage_address_02, address_03=NEW.storage_address_03, descript=NEW.storage_descript,
			rotation=NEW.storage_rotation, link=NEW.storage_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.storage_label_x, label_y=NEW.storage_label_y, label_rotation=NEW.storage_label_rotation, the_geom=NEW.the_geom, 
			publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.storage_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.storage_num_value
			WHERE node_id = OLD.node_id;
		
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, length=NEW.storage_length, width=NEW.storage_width, custom_area=NEW.storage_custom_area, max_volume=NEW.storage_max_volume,
				util_volume=NEW.storage_util_volume,min_height=NEW.storage_min_height, accessibility=NEW.storage_accessibility, name=NEW.storage_name
				WHERE node_id=OLD.node_id;	
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_storage SET node_id=NEW.node_id, pol_id=NEW.pol_id, length=NEW.storage_length, width=NEW.storage_width, custom_area=NEW.storage_custom_area, max_volume=NEW.storage_max_volume,
				util_volume=NEW.storage_util_volume,min_height=NEW.storage_min_height, accessibility=NEW.storage_accessibility, name=NEW.storage_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;

		ELSIF man_table='man_valve' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.valve_code, top_elev=NEW.valve_top_elev, custom_top_elev=NEW.valve_custom_top_elev, ymax=NEW.valve_ymax, custom_ymax=NEW.valve_custom_ymax, elev=NEW.valve_elev, 
			custom_elev=NEW.valve_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.valve_annotation, "observ"=NEW.valve_observ, 
			"comment"=NEW.valve_comment, dma_id=NEW.dma_id, soilcat_id=NEW.valve_soilcat_id, function_type=NEW.valve_function_type, category_type=NEW.valve_category_type,fluid_type=NEW.valve_fluid_type, location_type=NEW.valve_location_type, 
			workcat_id=NEW.valve_workcat_id, workcat_id_end=NEW.valve_workcat_id_end, buildercat_id=NEW.valve_buildercat_id, builtdate=NEW.valve_builtdate, enddate=NEW.valve_enddate,  ownercat_id=NEW.valve_ownercat_id, 
			address_01=NEW.valve_address_01,address_02=NEW.valve_address_02, address_03=NEW.valve_address_03, descript=NEW.valve_descript, rotation=NEW.valve_rotation, link=NEW.valve_link, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.valve_label_x, label_y=NEW.valve_label_y, label_rotation=NEW.valve_label_rotation, the_geom=NEW.the_geom, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.valve_xyz_date, 
			unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.valve_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_valve SET node_id=NEW.node_id, name=NEW.valve_name
			WHERE node_id=OLD.node_id;

		
		ELSIF man_table='man_chamber' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.chamber_code, top_elev=NEW.chamber_top_elev, custom_top_elev=NEW.chamber_custom_top_elev, ymax=NEW.chamber_ymax, custom_ymax=NEW.chamber_custom_ymax, elev=NEW.chamber_elev, 
			custom_elev=NEW.chamber_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.chamber_annotation, 
			"observ"=NEW.chamber_observ, "comment"=NEW.chamber_comment, dma_id=NEW.dma_id, soilcat_id=NEW.chamber_soilcat_id, function_type=NEW.chamber_function_type, category_type=NEW.chamber_category_type,fluid_type=NEW.chamber_fluid_type, 
			location_type=NEW.chamber_location_type, workcat_id=NEW.chamber_workcat_id, workcat_id_end=NEW.chamber_workcat_id_end, buildercat_id=NEW.chamber_buildercat_id, builtdate=NEW.chamber_builtdate, enddate=NEW.chamber_enddate,  
			ownercat_id=NEW.chamber_ownercat_id, address_01=NEW.chamber_address_01,address_02=NEW.chamber_address_02, address_03=NEW.chamber_address_03, descript=NEW.chamber_descript,
			rotation=NEW.chamber_rotation, link=NEW.chamber_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.chamber_label_x, label_y=NEW.chamber_label_y, label_rotation=NEW.chamber_label_rotation, the_geom=NEW.the_geom,
			publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.chamber_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.chamber_num_value
			WHERE node_id = OLD.node_id;
			
			UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, length=NEW.chamber_length, width=NEW.chamber_width, sander_depth=NEW.chamber_sander_depth, max_volume=NEW.chamber_max_volume, util_volume=NEW.chamber_util_volume,
			inlet=NEW.chamber_inlet, bottom_channel=NEW.chamber_bottom_channel, accessibility=NEW.chamber_accessibility, name=NEW.chamber_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_chamber_pol' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.chamber_code, top_elev=NEW.chamber_top_elev, custom_top_elev=NEW.chamber_custom_top_elev, ymax=NEW.chamber_ymax, custom_ymax=NEW.chamber_custom_ymax, elev=NEW.chamber_elev, 
			custom_elev=NEW.chamber_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.chamber_annotation, 
			"observ"=NEW.chamber_observ, "comment"=NEW.chamber_comment, dma_id=NEW.dma_id, soilcat_id=NEW.chamber_soilcat_id, function_type=NEW.chamber_function_type, category_type=NEW.chamber_category_type,fluid_type=NEW.chamber_fluid_type, 
			location_type=NEW.chamber_location_type, workcat_id=NEW.chamber_workcat_id, workcat_id_end=NEW.chamber_workcat_id_end, buildercat_id=NEW.chamber_buildercat_id, builtdate=NEW.chamber_builtdate, enddate=NEW.chamber_enddate,  
			ownercat_id=NEW.chamber_ownercat_id, address_01=NEW.chamber_address_01,address_02=NEW.chamber_address_02, address_03=NEW.chamber_address_03, descript=NEW.chamber_descript,
			rotation=NEW.chamber_rotation, link=NEW.chamber_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.chamber_label_x, label_y=NEW.chamber_label_y, label_rotation=NEW.chamber_label_rotation, the_geom=NEW.the_geom,
			publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.chamber_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.chamber_num_value
			WHERE node_id = OLD.node_id;
		
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, length=NEW.chamber_length, width=NEW.chamber_width, sander_depth=NEW.chamber_sander_depth, max_volume=NEW.chamber_max_volume, util_volume=NEW.chamber_util_volume,
				inlet=NEW.chamber_inlet, bottom_channel=NEW.chamber_bottom_channel, accessibility=NEW.chamber_accessibility, name=NEW.chamber_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_chamber SET node_id=NEW.node_id, pol_id=NEW.pol_id, length=NEW.chamber_length, width=NEW.chamber_width, sander_depth=NEW.chamber_sander_depth, max_volume=NEW.chamber_max_volume, util_volume=NEW.chamber_util_volume,
				inlet=NEW.chamber_inlet, bottom_channel=NEW.chamber_bottom_channel, accessibility=NEW.chamber_accessibility, name=NEW.chamber_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;	
			
		ELSIF man_table='man_manhole' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.manhole_code,top_elev=NEW.manhole_top_elev, custom_top_elev=NEW.manhole_custom_top_elev, ymax=NEW.manhole_ymax, custom_ymax=NEW.manhole_custom_ymax, elev=NEW.manhole_elev, 
			custom_elev=NEW.manhole_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type,  sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.manhole_annotation, "observ"=NEW.manhole_observ, 
			"comment"=NEW.manhole_comment, dma_id=NEW.dma_id, soilcat_id=NEW.manhole_soilcat_id, function_type=NEW.manhole_function_type, category_type=NEW.manhole_category_type,fluid_type=NEW.manhole_fluid_type, 
			location_type=NEW.manhole_location_type, workcat_id=NEW.manhole_workcat_id, workcat_id_end=NEW.manhole_workcat_id_end, buildercat_id=NEW.manhole_buildercat_id, builtdate=NEW.manhole_builtdate, enddate=NEW.manhole_enddate, 
			ownercat_id=NEW.manhole_ownercat_id, address_01=NEW.manhole_address_01,address_02=NEW.manhole_address_02, address_03=NEW.manhole_address_03, descript=NEW.manhole_descript,
			rotation=NEW.manhole_rotation, link=NEW.manhole_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.manhole_label_x, label_y=NEW.manhole_label_y, label_rotation=NEW.manhole_label_rotation, the_geom=NEW.the_geom, 
			publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.manhole_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.manhole_num_value
			WHERE node_id = OLD.node_id;
			
			UPDATE man_manhole SET node_id=NEW.node_id, length=NEW.manhole_length, width=NEW.manhole_width, sander_depth=NEW.manhole_sander_depth, prot_surface=NEW.manhole_prot_surface, inlet=NEW.manhole_inlet,
			bottom_channel=NEW.manhole_bottom_channel, accessibility=NEW.manhole_accessibility
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_netinit' THEN
			
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.netinit_code, top_elev=NEW.netinit_top_elev, custom_top_elev=NEW.netinit_custom_top_elev, ymax=NEW.netinit_ymax, custom_ymax=NEW.netinit_custom_ymax, elev=NEW.netinit_elev, 
			custom_elev=NEW.netinit_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.netinit_annotation, "observ"=NEW.netinit_observ, 
			"comment"=NEW.netinit_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netinit_soilcat_id, function_type=NEW.netinit_function_type, category_type=NEW.netinit_category_type,fluid_type=NEW.netinit_fluid_type, location_type=NEW.netinit_location_type, 
			workcat_id=NEW.netinit_workcat_id, workcat_id_end=NEW.netinit_workcat_id_end,  buildercat_id=NEW.netinit_buildercat_id, builtdate=NEW.netinit_builtdate, enddate=NEW.netinit_enddate,  ownercat_id=NEW.netinit_ownercat_id, 
			address_01=NEW.netinit_address_01,address_02=NEW.netinit_address_02, address_03=NEW.netinit_address_03, descript=NEW.netinit_descript, rotation=NEW.netinit_rotation, link=NEW.netinit_link, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.netinit_label_x, label_y=NEW.netinit_label_y, label_rotation=NEW.netinit_label_rotation, the_geom=NEW.the_geom,publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, 
			xyz_date=NEW.netinit_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.netinit_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netinit SET node_id=NEW.node_id, length=NEW.netinit_length, width=NEW.netinit_width, inlet=NEW.netinit_inlet, bottom_channel=NEW.netinit_bottom_channel, accessibility=NEW.netinit_accessibility, name=NEW.netinit_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wjump' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id,code=NEW.wjump_code,top_elev=NEW.wjump_top_elev, custom_top_elev=NEW.wjump_custom_top_elev, ymax=NEW.wjump_ymax, custom_ymax=NEW.wjump_custom_ymax, elev=NEW.wjump_elev, 
			custom_elev=NEW.wjump_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, annotation=NEW.wjump_annotation, "observ"=NEW.wjump_observ, 
			"comment"=NEW.wjump_comment, dma_id=NEW.dma_id, soilcat_id=NEW.wjump_soilcat_id, category_type=NEW.wjump_category_type, function_type=NEW.wjump_function_type, fluid_type=NEW.wjump_fluid_type, location_type=NEW.wjump_location_type, 
			workcat_id=NEW.wjump_workcat_id, workcat_id_end=NEW.wjump_workcat_id_end, buildercat_id=NEW.wjump_buildercat_id, builtdate=NEW.wjump_builtdate, enddate=NEW.wjump_enddate,  ownercat_id=NEW.wjump_ownercat_id, 
			address_01=NEW.wjump_address_01,address_02=NEW.wjump_address_02, address_03=NEW.wjump_address_03, descript=NEW.wjump_descript,	rotation=NEW.wjump_rotation, link=NEW.wjump_link, verified=NEW.verified, undelete=NEW.undelete, 
			label_x=NEW.wjump_label_x, label_y=NEW.wjump_label_y, label_rotation=NEW.wjump_label_rotation, the_geom=NEW.the_geom, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.wjump_xyz_date, 
			unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.wjump_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wjump SET node_id=NEW.node_id, length=NEW.wjump_length, width=NEW.wjump_width, sander_depth=NEW.wjump_sander_depth, prot_surface=NEW.wjump_prot_surface, accessibility=NEW.wjump_accessibility, name=NEW.wjump_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wwtp' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.wwtp_code,top_elev=NEW.wwtp_top_elev, custom_top_elev=NEW.wwtp_custom_top_elev, ymax=NEW.wwtp_ymax, custom_ymax=NEW.wwtp_custom_ymax, elev=NEW.wwtp_elev, custom_elev=NEW.wwtp_custom_elev, n
			ode_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 	"state"=NEW.state, annotation=NEW.wwtp_annotation, "observ"=NEW.wwtp_observ, "comment"=NEW.wwtp_comment, dma_id=NEW.dma_id, 
			soilcat_id=NEW.wwtp_soilcat_id, function_type=NEW.wwtp_function_type, category_type=NEW.wwtp_category_type, fluid_type=NEW.wwtp_fluid_type, location_type=NEW.wwtp_location_type, workcat_id=NEW.wwtp_workcat_id, 
			workcat_id_end=NEW.wwtp_workcat_id_end, buildercat_id=NEW.wwtp_buildercat_id, builtdate=NEW.wwtp_builtdate, enddate=NEW.wwtp_enddate,  ownercat_id=NEW.wwtp_ownercat_id,address_01=NEW.wwtp_address_01,address_02=NEW.wwtp_address_02, 
			address_03=NEW.wwtp_address_03, descript=NEW.wwtp_descript,rotation=NEW.wwtp_rotation, link=NEW.wwtp_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.wwtp_label_x, label_y=NEW.wwtp_label_y,
			label_rotation=NEW.wwtp_label_rotation, the_geom=NEW.the_geom, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.wwtp_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.wwtp_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, name=NEW.wwtp_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wwtp_pol' THEN
		
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.wwtp_code,top_elev=NEW.wwtp_top_elev, custom_top_elev=NEW.wwtp_custom_top_elev, ymax=NEW.wwtp_ymax, custom_ymax=NEW.wwtp_custom_ymax, elev=NEW.wwtp_elev, custom_elev=NEW.wwtp_custom_elev, n
			ode_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 	"state"=NEW.state, annotation=NEW.wwtp_annotation, "observ"=NEW.wwtp_observ, "comment"=NEW.wwtp_comment, dma_id=NEW.dma_id, 
			soilcat_id=NEW.wwtp_soilcat_id, function_type=NEW.wwtp_function_type, category_type=NEW.wwtp_category_type, fluid_type=NEW.wwtp_fluid_type, location_type=NEW.wwtp_location_type, workcat_id=NEW.wwtp_workcat_id, 
			workcat_id_end=NEW.wwtp_workcat_id_end, buildercat_id=NEW.wwtp_buildercat_id, builtdate=NEW.wwtp_builtdate, enddate=NEW.wwtp_enddate,  ownercat_id=NEW.wwtp_ownercat_id,address_01=NEW.wwtp_address_01,address_02=NEW.wwtp_address_02, 
			address_03=NEW.wwtp_address_03, descript=NEW.wwtp_descript,rotation=NEW.wwtp_rotation, link=NEW.wwtp_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.wwtp_label_x, label_y=NEW.wwtp_label_y,
			label_rotation=NEW.wwtp_label_rotation, the_geom=NEW.the_geom, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.wwtp_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.wwtp_num_value
			WHERE node_id = OLD.node_id;
		
		
			IF (NEW.pol_id IS NULL) THEN
				UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, name=NEW.wwtp_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.pol_id;
			ELSE
				UPDATE man_wwtp SET node_id=NEW.node_id, pol_id=NEW.pol_id, name=NEW.wwtp_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.pol_id
				WHERE pol_id=OLD.pol_id;
			END IF;	
			
		ELSIF man_table ='man_netelement' THEN
			UPDATE node 
			SET node_id=NEW.node_id, code=NEW.netelement_code,top_elev=NEW.netelement_top_elev, custom_top_elev=NEW.netelement_custom_top_elev, ymax=NEW.netelement_ymax, custom_ymax=NEW.netelement_custom_ymax, elev=NEW.netelement_elev, 
			custom_elev=NEW.netelement_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 	"state"=NEW.state, annotation=NEW.netelement_annotation, "observ"=NEW.netelement_observ, 
			"comment"=NEW.netelement_comment, dma_id=NEW.dma_id, soilcat_id=NEW.netelement_soilcat_id, function_type=NEW.netelement_function_type, category_type=NEW.netelement_category_type, fluid_type=NEW.netelement_fluid_type, 
			location_type=NEW.netelement_location_type, workcat_id=NEW.netelement_workcat_id, workcat_id_end=NEW.netelement_workcat_id_end, buildercat_id=NEW.netelement_buildercat_id, builtdate=NEW.netelement_builtdate, enddate=NEW.netelement_enddate,  
			ownercat_id=NEW.netelement_ownercat_id,address_01=NEW.netelement_address_01,address_02=NEW.netelement_address_02, address_03=NEW.netelement_address_03, descript=NEW.netelement_descript,rotation=NEW.netelement_rotation, 
			link=NEW.netelement_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.netelement_label_x, label_y=NEW.netelement_label_y,label_rotation=NEW.netelement_label_rotation, the_geom=NEW.the_geom, publish=NEW.publish, 
			inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.netelement_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.netelement_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netelement
			SET node_id=NEW.node_id, serial_number=NEW.netelement_serial_number
			WHERE node_id=OLD.node_id;	
		
		
		END IF;
		--PERFORM audit_function (2,830);
        RETURN NEW;
		
		
	
    ELSIF TG_OP = 'DELETE' THEN

	IF man_table ='man_storage' OR man_table ='man_chamber' OR man_table ='man_wwtp' OR man_table ='man_netgully' THEN
		IF OLD.pol_id IS NOT NULL THEN
			DELETE FROM polygon WHERE pol_id = OLD.pol_id;
			DELETE FROM node WHERE node_id = OLD.node_id;
		ELSE
			DELETE FROM node WHERE node_id = OLD.node_id;
		END IF;
	ELSE
		DELETE FROM node WHERE node_id = OLD.node_id;
	END IF;

		--PERFORM audit_function (3,830);
        RETURN NULL;
   
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber ON "SCHEMA_NAME".v_edit_man_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".v_edit_man_chamber_pol;
CREATE TRIGGER gw_trg_edit_man_chamber_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber_pol');  
  
DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully ON "SCHEMA_NAME".v_edit_man_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".v_edit_man_netgully_pol;
CREATE TRIGGER gw_trg_edit_man_netgully_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully_pol');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netinit ON "SCHEMA_NAME".v_edit_man_netinit;
CREATE TRIGGER gw_trg_edit_man_netinit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netinit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netinit');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_outfall ON "SCHEMA_NAME".v_edit_man_outfall;
CREATE TRIGGER gw_trg_edit_man_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_outfall FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_outfall');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage ON "SCHEMA_NAME".v_edit_man_storage;
CREATE TRIGGER gw_trg_edit_man_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".v_edit_man_storage_pol;
CREATE TRIGGER gw_trg_edit_man_storage_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjump ON "SCHEMA_NAME".v_edit_man_wjump;
CREATE TRIGGER gw_trg_edit_man_wjump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wjump');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp ON "SCHEMA_NAME".v_edit_man_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp');
     
DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".v_edit_man_wwtp_pol;
CREATE TRIGGER gw_trg_edit_man_wwtp_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp_pol'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netelement');   