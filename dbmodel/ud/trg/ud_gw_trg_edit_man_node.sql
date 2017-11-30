/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1218
   

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
            --PERFORM setval('urn_id_seq', gw_fct_urn(),true);
            NEW.node_id:= (SELECT nextval('urn_id_seq'));
        END IF;

      
        -- Node type
        IF (NEW.node_type IS NULL) THEN
            IF ((SELECT COUNT(*) FROM node_type WHERE node_type.man_table=man_table_2) = 0) THEN
                --RETURN audit_function(1004,1218);  
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
                RETURN audit_function(1006,1218);  
            END IF;      
			NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='nodecat_vdefault' AND "cur_user"="current_user"());
        END IF;

        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1218);  
            END IF;
            NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
            IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1218);          
            END IF;            
        END IF;
        
        -- Dma ID
        IF (NEW.dma_id IS NULL) THEN
            IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1218);  
            END IF;
            NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1218);  
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
						
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1218);
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

			
		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
		
		SELECT code_autofill INTO code_autofill_bool FROM node_type WHERE id=NEW.node_type;
			
		IF man_table='man_junction' THEN
					
			-- Workcat_id
			IF (NEW.jt_workcat_id IS NULL) THEN
				NEW.jt_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.jt_workcat_id IS NULL) THEN
					NEW.jt_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.jt_builtdate IS NULL) THEN
				NEW.jt_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.jt_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.jt_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",
			dma_id,soilcat_id, function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber, postnumber2, descript,rotation,link,verified,
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value)
			VALUES (NEW.node_id,NEW.jt_code, NEW.jt_top_elev,NEW.jt_custom_top_elev, NEW.jt_ymax, NEW. jt_custom_ymax, NEW. jt_elev, NEW. jt_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id, 
			NEW.state, NEW.state_type, NEW.jt_annotation,NEW.jt_observ, NEW.jt_comment,NEW.dma_id,NEW.jt_soilcat_id, NEW. jt_function_type, NEW.jt_category_type,NEW.jt_fluid_type,NEW.jt_location_type,
			NEW.jt_workcat_id, NEW.jt_workcat_id_end, NEW.jt_buildercat_id,NEW.jt_builtdate, NEW.jt_enddate, NEW.jt_ownercat_id,
			NEW.jt_muni_id, NEW.jt_streetaxis_id, NEW.jt_postcode,NEW.jt_streetaxis2_id,NEW.jt_postnumber,NEW.jt_postnumber2,
			NEW.jt_descript, NEW.jt_rotation,NEW.jt_link, NEW.verified, NEW.undelete, NEW.jt_label_x,NEW.jt_label_y,NEW.jt_label_rotation,NEW.the_geom,
			NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.jt_xyz_date, NEW.unconnected, NEW.jt_num_value);	

			INSERT INTO man_junction (node_id) VALUES (NEW.node_id);

			        
		ELSIF man_table='man_outfall' THEN

			-- Workcat_id
			IF (NEW.of_workcat_id IS NULL) THEN
				NEW.of_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.of_workcat_id IS NULL) THEN
					NEW.of_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.of_builtdate IS NULL) THEN
				NEW.of_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;
			
		--Copy id to code field
			IF (NEW.of_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.of_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, 
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber, postnumber2,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.of_code, NEW.of_top_elev, NEW.of_custom_top_elev, NEW.of_ymax,NEW.of_custom_ymax, NEW.of_elev, NEW.of_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.state,
			NEW.state_type, NEW.of_annotation,NEW.of_observ, NEW.of_comment,NEW.dma_id,NEW.of_soilcat_id,NEW.of_function_type, NEW.of_category_type,NEW.of_fluid_type,NEW.of_location_type,
			NEW.of_workcat_id,NEW.of_workcat_id_end, NEW.of_buildercat_id,NEW.of_builtdate, NEW.of_enddate, NEW.of_ownercat_id,
			NEW.of_muni_id, NEW.of_streetaxis_id, NEW.of_postcode,NEW.of_streetaxis2_id,NEW.of_postnumber,NEW.of_postnumber2,
			NEW.of_descript,NEW.of_rotation,NEW.of_link,NEW.verified,NEW.undelete,NEW.of_label_x,NEW.of_label_y,NEW.of_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, 
			NEW.of_xyz_date, NEW.unconnected, NEW.of_num_value);

			INSERT INTO man_outfall (node_id, name) VALUES (NEW.node_id,NEW.of_name);
        
		ELSIF man_table='man_valve' THEN

			-- Workcat_id
			IF (NEW.vl_workcat_id IS NULL) THEN
				NEW.vl_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.vl_workcat_id IS NULL) THEN
					NEW.vl_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.vl_builtdate IS NULL) THEN
				NEW.vl_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.vl_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.vl_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",state_type, annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, 
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,descript, rotation,link,verified,
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.vl_code, NEW.vl_top_elev, NEW.vl_custom_top_elev, NEW.vl_ymax, NEW.vl_custom_ymax, NEW.vl_elev, NEW.vl_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,
			NEW.state, NEW.state_type, NEW.vl_annotation,NEW.vl_observ,NEW.vl_comment,NEW.dma_id, NEW.vl_soilcat_id,NEW.vl_function_type, NEW.vl_category_type,NEW.vl_fluid_type,NEW.vl_location_type,NEW.vl_workcat_id, 
			NEW.vl_workcat_id_end, NEW.vl_buildercat_id,NEW.vl_builtdate, NEW.vl_enddate, NEW.vl_ownercat_id, 
			NEW.vl_muni_id, NEW.vl_streetaxis_id, NEW.vl_postcode, NEW.vl_streetaxis2_id, NEW.vl_postnumber,NEW.vl_postnumber2,NEW.vl_descript, NEW.vl_rotation,NEW.vl_link,
			NEW.verified, NEW.undelete,NEW.vl_label_x, NEW.vl_label_y,NEW.vl_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.vl_xyz_date, NEW.unconnected, NEW.vl_num_value);

			INSERT INTO man_valve (node_id, name) VALUES (NEW.node_id,NEW.vl_name);	
		
		ELSIF man_table='man_storage' THEN
					
			-- Workcat_id
			IF (NEW.st_workcat_id IS NULL) THEN
				NEW.st_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.st_workcat_id IS NULL) THEN
					NEW.st_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.st_builtdate IS NULL) THEN
				NEW.st_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.st_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.st_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id, epa_type, sector_id,"state",state_type, annotation,observ,"comment",dma_id,soilcat_id,
			function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,builtdate, enddate, ownercat_id, 
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.st_code, NEW.st_top_elev, NEW.st_custom_top_elev, NEW.st_ymax,NEW.st_custom_ymax, NEW.st_elev, NEW.st_custom_elev, NEW.node_type, NEW.nodecat_id,
			NEW.epa_type,NEW.sector_id, NEW.state, NEW.state_type, NEW.st_annotation,NEW.st_observ,NEW.st_comment,NEW.dma_id,NEW.st_soilcat_id, NEW.st_function_type, NEW.st_category_type,NEW.st_fluid_type,
			NEW.st_location_type,NEW.st_workcat_id, NEW.st_workcat_id_end, NEW.st_buildercat_id,NEW.st_builtdate, NEW.st_enddate, NEW.st_ownercat_id,
			NEW.st_muni_id, NEW.st_streetaxis_id,  NEW.st_postcode,NEW.st_streetaxis2_id,
			NEW.st_postnumber,NEW.st_postnumber2,NEW.st_descript, NEW.st_rotation,NEW.st_link,NEW.verified,NEW.undelete,NEW.st_label_x,NEW.st_label_y,NEW.st_label_rotation,
			NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory,  NEW.uncertain, NEW.st_xyz_date, NEW.unconnected, NEW.st_num_value);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.st_pol_id IS NULL) THEN
					NEW.st_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name)
				VALUES(NEW.node_id, NEW.st_pol_id, NEW.st_length, NEW.st_width,NEW.st_custom_area, NEW.st_max_volume, NEW.st_util_volume, NEW.st_min_height,NEW.st_accessibility, NEW.st_name);
				
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.st_pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_storage (node_id,pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name)
				VALUES(NEW.node_id, NEW.st_pol_id, NEW.st_length, NEW.st_width,NEW.st_custom_area, NEW.st_max_volume, NEW.st_util_volume, NEW.st_min_height,NEW.st_accessibility, NEW.st_name);
			END IF;
			
		ELSIF man_table='man_storage_pol' THEN
					
			-- Workcat_id
			IF (NEW.st_workcat_id IS NULL) THEN
				NEW.st_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.st_workcat_id IS NULL) THEN
					NEW.st_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.st_builtdate IS NULL) THEN
				NEW.st_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.st_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.st_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id, epa_type, sector_id,"state",state_type, annotation,observ,"comment",dma_id,soilcat_id,
			function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,	builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript,rotation,link,verified,undelete,
			label_x,label_y,label_rotation,expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.st_code, NEW.st_top_elev, NEW.st_custom_top_elev, NEW.st_ymax,NEW.st_custom_ymax, NEW.st_elev, NEW.st_custom_elev, NEW.node_type, NEW.nodecat_id,
			NEW.epa_type,NEW.sector_id, NEW.state, NEW.state_type, NEW.st_annotation,NEW.st_observ,NEW.st_comment,NEW.dma_id,NEW.st_soilcat_id, NEW.st_function_type, NEW.st_category_type,NEW.st_fluid_type,
			NEW.st_location_type,NEW.st_workcat_id, NEW.st_workcat_id_end, NEW.st_buildercat_id,NEW.st_builtdate, NEW.st_enddate, NEW.st_ownercat_id,
			NEW.st_muni_id, NEW.st_streetaxis_id, NEW.st_postcode,NEW.st_streetaxis2_id,
			NEW.st_postnumber,NEW.st_postnumber2,NEW.st_descript, NEW.st_rotation,NEW.st_link,NEW.verified,NEW.undelete,NEW.st_label_x,NEW.st_label_y,NEW.st_label_rotation,
			NEW.expl_id, NEW.publish, NEW.inventory,  NEW.uncertain, NEW.st_xyz_date, NEW.unconnected, NEW.st_num_value);
			
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.st_pol_id IS NULL) THEN
					NEW.st_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_storage (node_id,pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name)
				VALUES(NEW.node_id, NEW.st_pol_id, NEW.st_length, NEW.st_width,NEW.st_custom_area, NEW.st_max_volume, NEW.st_util_volume, NEW.st_min_height,NEW.st_accessibility, NEW.st_name);
								INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.st_pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.st_pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_netgully' THEN
					
			-- Workcat_id
			IF (NEW.ng_workcat_id IS NULL) THEN
				NEW.ng_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.ng_workcat_id IS NULL) THEN
					NEW.ng_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.ng_builtdate IS NULL) THEN
				NEW.ng_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.ng_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ng_code=NEW.node_id;
			END IF;			

			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.ng_code, NEW.ng_top_elev, NEW.ng_custom_top_elev, NEW.ng_ymax, NEW.ng_custom_ymax, NEW.ng_elev, NEW.ng_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,
			NEW.state, NEW.state_type, NEW.ng_annotation,NEW.ng_observ, NEW.ng_comment,NEW.dma_id,NEW.ng_soilcat_id,NEW.ng_function_type, NEW.ng_category_type,NEW.ng_fluid_type,NEW.ng_location_type,NEW.ng_workcat_id, 
			NEW.ng_workcat_id_end,NEW.ng_buildercat_id,NEW.ng_builtdate,NEW.ng_enddate, NEW.ng_ownercat_id,
			NEW.ng_muni_id, NEW.ng_streetaxis_id, NEW.ng_postcode,NEW.ng_streetaxis2_id,NEW.ng_postnumber,NEW.ng_postnumber2,NEW.ng_descript, NEW.ng_rotation,
			NEW.ng_link, NEW.verified,NEW.undelete,NEW.ng_label_x,NEW.ng_label_y,NEW.ng_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.ng_xyz_date, NEW.unconnected, NEW.ng_num_value);
				
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.ng_pol_id IS NULL) THEN
					NEW.ng_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id, sander_depth, gratecat_id, units, groove, siphon, postnumber ) 
				VALUES(NEW.node_id, NEW.ng_pol_id, NEW.ng_sander_depth, NEW.ng_gratecat_id, NEW.ng_units, 
				NEW.ng_groove, NEW.ng_siphon, NEW.ng_postnumber );
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.ng_pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_netgully (node_id) VALUES(NEW.node_id);
			END IF;	

			
					 
		ELSIF man_table='man_netgully_pol' THEN

		-- Workcat_id
			IF (NEW.ng_workcat_id IS NULL) THEN
				NEW.ng_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.ng_workcat_id IS NULL) THEN
					NEW.ng_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.ng_builtdate IS NULL) THEN
				NEW.ng_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

				--Copy id to code field
			IF (NEW.ng_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ng_code=NEW.node_id;
			END IF;
					
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, 
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript,rotation,link,verified,undelete,label_x,label_y,label_rotation,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.ng_code, NEW.ng_top_elev, NEW.ng_custom_top_elev, NEW.ng_ymax, NEW.ng_custom_ymax, NEW.ng_elev, NEW.ng_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,
			NEW.state, NEW.state_type, NEW.ng_annotation,NEW.ng_observ, NEW.ng_comment,NEW.dma_id,NEW.ng_soilcat_id,NEW.ng_function_type, NEW.ng_category_type,NEW.ng_fluid_type,NEW.ng_location_type,NEW.ng_workcat_id, 
			NEW.ng_workcat_id_end,NEW.ng_buildercat_id,NEW.ng_builtdate,NEW.ng_enddate, NEW.ng_ownercat_id,
			NEW.ng_muni_id, NEW.ng_streetaxis_id, NEW.ng_postcode,NEW.ng_streetaxis2_id,NEW.ng_postnumber,NEW.ng_postnumber2,NEW.ng_descript, NEW.ng_rotation,
			NEW.ng_link, NEW.verified,NEW.undelete,NEW.ng_label_x,NEW.ng_label_y,NEW.ng_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.ng_xyz_date, NEW.unconnected, NEW.ng_num_value);

			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.ng_pol_id IS NULL) THEN
					NEW.ng_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_netgully (node_id,pol_id, sander_depth, gratecat_id, units, groove, siphon, postnumber ) VALUES(NEW.node_id, NEW.ng_pol_id, NEW.ng_sander_depth, NEW.ng_gratecat_id, NEW.ng_units, 
				NEW.ng_groove, NEW.ng_siphon, NEW.ng_postnumber );
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.ng_pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.ng_pol_id) WHERE node_id=NEW.node_id;
				
			END IF;
			
		ELSIF man_table='man_chamber' THEN

			-- Workcat_id
			IF (NEW.ch_workcat_id IS NULL) THEN
				NEW.ch_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.ch_workcat_id IS NULL) THEN
					NEW.ch_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.ch_builtdate IS NULL) THEN
				NEW.ch_builtdate:=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.ch_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ch_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",state_type, annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,enddate,ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.ch_code, NEW.ch_top_elev,NEW.ch_custom_top_elev, NEW.ch_ymax, NEW.ch_custom_ymax, NEW.ch_elev, NEW.ch_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,
			NEW.sector_id,NEW.state, NEW.state_type, NEW.ch_annotation,NEW.ch_observ, NEW.ch_comment,NEW.dma_id,NEW.ch_soilcat_id,NEW.ch_function_type, NEW.ch_category_type,NEW.ch_fluid_type,NEW.ch_location_type,
			NEW.ch_workcat_id, NEW.ch_workcat_id_end, NEW.ch_buildercat_id,NEW.ch_builtdate, NEW.ch_enddate, NEW.ch_ownercat_id,
			NEW.ch_muni_id, NEW.ch_streetaxis_id, NEW.ch_postcode,NEW.ch_streetaxis2_id,NEW.ch_postnumber,NEW.ch_postnumber2,
			NEW.ch_descript,NEW.ch_rotation,NEW.ch_link,NEW.verified, NEW.undelete,NEW.ch_label_x,NEW.ch_label_y,NEW.ch_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, 
			NEW.ch_xyz_date, NEW.unconnected, NEW.ch_num_value);
					
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.ch_pol_id IS NULL) THEN
					NEW.ch_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name)
				VALUES (NEW.node_id,NEW.ch_pol_id, NEW.ch_length,NEW.ch_width, NEW.ch_sander_depth, NEW.ch_max_volume, NEW.ch_util_volume, 
				NEW.ch_inlet, NEW.ch_bottom_channel, NEW.ch_accessibility,NEW.ch_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.ch_pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_chamber (node_id,pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name)
				VALUES (NEW.node_id,NEW.ch_pol_id, NEW.ch_length,NEW.ch_width, NEW.ch_sander_depth, NEW.ch_max_volume, NEW.ch_util_volume, 
				NEW.ch_inlet, NEW.ch_bottom_channel, NEW.ch_accessibility,NEW.ch_name);
			END IF;	
			
		ELSIF man_table='man_chamber_pol' THEN
			-- Workcat_id
			IF (NEW.ch_workcat_id IS NULL) THEN
				NEW.ch_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.ch_workcat_id IS NULL) THEN
					NEW.ch_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.ch_builtdate IS NULL) THEN
				NEW.ch_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.ch_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ch_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state",state_type, annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate,enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.ch_code, NEW.ch_top_elev,NEW.ch_custom_top_elev, NEW.ch_ymax, NEW.ch_custom_ymax, NEW.ch_elev, NEW.ch_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,
			NEW.sector_id,NEW.state,NEW.state_type, NEW.ch_annotation,NEW.ch_observ, NEW.ch_comment,NEW.dma_id,NEW.ch_soilcat_id,NEW.ch_function_type, NEW.ch_category_type,NEW.ch_fluid_type,NEW.ch_location_type,
			NEW.ch_workcat_id, NEW.ch_workcat_id_end, NEW.ch_buildercat_id,NEW.ch_builtdate, NEW.ch_enddate, NEW.ch_ownercat_id,
			NEW.ch_muni_id, NEW.ch_streetaxis_id,  NEW.ch_postcode,NEW.ch_streetaxis2_id,NEW.ch_postnumber,NEW.ch_postnumber2,
			NEW.ch_descript,NEW.ch_rotation,NEW.ch_link,NEW.verified, NEW.undelete,NEW.ch_label_x,NEW.ch_label_y,NEW.ch_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, 
			NEW.ch_xyz_date, NEW.unconnected, NEW.ch_num_value);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.ch_pol_id IS NULL) THEN
					NEW.ch_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_chamber (node_id,pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name)
				VALUES (NEW.node_id,NEW.ch_pol_id, NEW.ch_length,NEW.ch_width, NEW.ch_sander_depth, NEW.ch_max_volume, NEW.ch_util_volume, 
				NEW.ch_inlet, NEW.ch_bottom_channel, NEW.ch_accessibility,NEW.ch_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.ch_pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.ch_pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
		ELSIF man_table='man_manhole' THEN
		
			-- Workcat_id
			IF (NEW.mh_workcat_id IS NULL) THEN
				NEW.mh_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.mh_workcat_id IS NULL) THEN
					NEW.mh_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.mh_builtdate IS NULL) THEN
				NEW.mh_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

					--Copy id to code field
			IF (NEW.mh_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.mh_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id,soilcat_id,
			function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified,undelete,label_x,label_y,
			label_rotation,the_geom,expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.mh_code, NEW.mh_top_elev,NEW.mh_custom_top_elev, NEW.mh_ymax, NEW.mh_custom_ymax, NEW.mh_elev, NEW.mh_custom_elev, NEW.node_type,NEW.nodecat_id,
			NEW.epa_type,NEW.sector_id,NEW.state, NEW.state_type, NEW.mh_annotation,NEW.mh_observ,NEW.mh_comment,NEW.dma_id,NEW.mh_soilcat_id, NEW.mh_function_type, NEW.mh_category_type,NEW.mh_fluid_type,
			NEW.mh_location_type,NEW.mh_workcat_id, NEW.mh_workcat_id_end,NEW.mh_buildercat_id,NEW.mh_builtdate, NEW.mh_enddate, NEW.mh_ownercat_id,
			NEW.mh_muni_id, NEW.mh_streetaxis_id, NEW.mh_postcode,NEW.mh_streetaxis2_id,
			NEW.mh_postnumber,NEW.mh_postnumber2,NEW.mh_descript, NEW.mh_rotation,NEW.mh_link, NEW.verified, NEW.undelete,NEW.mh_label_x,NEW.mh_label_y,NEW.mh_label_rotation,NEW.the_geom,
			NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.mh_xyz_date, NEW.unconnected, NEW.mh_num_value);

			INSERT INTO man_manhole (node_id,length, width, sander_depth,prot_surface, inlet, bottom_channel, accessibility) 
			VALUES (NEW.node_id,NEW.mh_length, NEW.mh_width, NEW.mh_sander_depth,NEW.mh_prot_surface, NEW.mh_inlet, NEW.mh_bottom_channel, NEW.mh_accessibility);	
		
		ELSIF man_table='man_netinit' THEN
			
			-- Workcat_id
			IF (NEW.ni_workcat_id IS NULL) THEN
				NEW.ni_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.ni_workcat_id IS NULL) THEN
					NEW.ni_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.ni_builtdate IS NULL) THEN
				NEW.ni_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

				--Copy id to code field
			IF (NEW.ni_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.ni_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id, 
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id,
			builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value, sander_depth) 
			VALUES (NEW.node_id, NEW.ni_code, NEW.ni_top_elev,NEW.ni_custom_top_elev, NEW.ni_ymax, NEW.ni_custom_ymax, NEW.ni_elev, NEW.ni_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id,NEW.state, NEW.state_type,
			NEW.ni_annotation,NEW.ni_observ, NEW.ni_comment,NEW.dma_id,NEW.ni_soilcat_id, NEW.ni_function_type, NEW.ni_category_type,NEW.ni_fluid_type,NEW.ni_location_type,NEW.ni_workcat_id,NEW.ni_workcat_id_end, 
			NEW.ni_buildercat_id,NEW.ni_builtdate, NEW.ni_enddate, NEW.ni_ownercat_id,
			NEW.ni_muni_id, NEW.ni_streetaxis_id, NEW.ni_postcode,NEW.ni_streetaxis2_id,NEW.ni_postnumber,NEW.ni_postnumber2,NEW.ni_descript, NEW.ni_rotation,
			NEW.ni_link, NEW.verified, NEW.undelete,NEW.ni_label_x,NEW.ni_label_y,NEW.ni_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.ni_xyz_date, NEW.unconnected, NEW.ni_num_value, 
			NEW.ni_sander_depth); 

			INSERT INTO man_netinit (node_id,length, width, inlet, bottom_channel, accessibility, name) 
			VALUES (NEW.node_id, NEW.ni_length,NEW.ni_width,NEW.ni_inlet, NEW.ni_bottom_channel, NEW.ni_accessibility, NEW.ni_name);
			
		ELSIF man_table='man_wjump' THEN
	
			-- Workcat_id
			IF (NEW.wj_workcat_id IS NULL) THEN
				NEW.wj_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					NEW.wj_workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		
			--Builtdate
			IF (NEW.wj_builtdate IS NULL) THEN
				NEW.wj_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.wj_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wj_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state",state_type, annotation,observ,"comment",dma_id,soilcat_id,function_type, 
			category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified,undelete,label_x,label_y,label_rotation,the_geom,
			expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.wj_code, NEW.wj_top_elev,NEW.wj_custom_top_elev, NEW.wj_ymax, NEW.wj_custom_ymax, NEW.wj_elev, NEW.wj_custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id, 
			NEW.state, NEW.state_type, NEW.wj_annotation,NEW.wj_observ,NEW.wj_comment, NEW.dma_id,NEW.wj_soilcat_id,NEW.wj_function_type, NEW.wj_category_type,NEW.wj_fluid_type,NEW.wj_location_type,
			NEW.wj_workcat_id, NEW.wj_workcat_id_end,	NEW.wj_buildercat_id,NEW.wj_builtdate, NEW.wj_enddate, NEW.wj_ownercat_id, 
			NEW.wj_muni_id, NEW.wj_streetaxis_id, NEW.wj_postcode,NEW.wj_streetaxis2_id,NEW.wj_postnumber,NEW.wj_postnumber2,NEW.wj_descript,	
			NEW.wj_rotation,NEW.wj_link,NEW.verified, NEW.undelete,NEW.wj_label_x,NEW.wj_label_y,NEW.wj_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.wj_xyz_date, NEW.unconnected, 
			NEW.wj_num_value);

			INSERT INTO man_wjump (node_id, length, width,sander_depth,prot_surface, accessibility, name) 
			VALUES (NEW.node_id, NEW.wj_length,NEW.wj_width, NEW.wj_sander_depth,NEW.wj_prot_surface,NEW.wj_accessibility, NEW.wj_name);	

		ELSIF man_table='man_wwtp' THEN
		
			-- Workcat_id
			IF (NEW.wt_workcat_id IS NULL) THEN
				NEW.wt_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.wt_workcat_id IS NULL) THEN
					NEW.wt_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

			--Builtdate
			IF (NEW.wt_builtdate IS NULL) THEN
				NEW.wt_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;

		--Copy id to code field
			IF (NEW.wt_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wt_code=NEW.node_id;
			END IF;
		
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified, 
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.wt_code, NEW.wt_top_elev,NEW.wt_custom_top_elev, NEW.wt_ymax, NEW.wt_custom_ymax, NEW.wt_elev, NEW.wt_custom_elev, NEW.node_type, NEW.nodecat_id, 
			NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.wt_annotation,NEW.wt_observ,NEW.wt_comment,NEW.dma_id, NEW.wt_soilcat_id, NEW.wt_function_type, NEW.wt_category_type,NEW.wt_fluid_type,
			NEW.wt_location_type,NEW.wt_workcat_id, NEW.wt_workcat_id_end, NEW.wt_buildercat_id,NEW.wt_builtdate, NEW.wt_enddate, NEW.wt_ownercat_id,
			NEW.wt_muni_id, NEW.wt_streetaxis_id, NEW.wt_postcode,NEW.wt_streetaxis2_id, 
			NEW.wt_postnumber,NEW.wt_postnumber2,NEW.wt_descript, NEW.wt_rotation,NEW.wt_link,NEW.verified,NEW.undelete,NEW.wt_label_x,NEW.wt_label_y,NEW.wt_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, 
			NEW.uncertain, NEW.wt_xyz_date, NEW.unconnected, NEW.wt_num_value);

			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.wt_pol_id IS NULL) THEN
					NEW.wt_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,pol_id, name) VALUES (NEW.node_id,NEW.wt_pol_id,NEW.wt_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.wt_pol_id,(SELECT ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value)) from "SCHEMA_NAME".node where node_id=NEW.node_id));
			
			ELSE
				INSERT INTO man_wwtp (node_id, name) VALUES (NEW.node_id,NEW.wt_name);
			END IF;	
			
		ELSIF man_table='man_wwtp_pol' THEN
			
			-- Workcat_id
			IF (NEW.wt_workcat_id IS NULL) THEN
				NEW.wt_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.wt_workcat_id IS NULL) THEN
					NEW.wt_workcat_id := (SELECT id FROM cat_work limit 1);
				END IF;
			END IF;

				--Builtdate
			IF (NEW.wt_builtdate IS NULL) THEN
				NEW.wt_builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
			END IF;
			
					--Copy id to code field
			IF (NEW.wt_code IS NULL AND code_autofill_bool IS TRUE) THEN 
				NEW.wt_code=NEW.node_id;
			END IF;
			
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified, 
			undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.wt_code, NEW.wt_top_elev,NEW.wt_custom_top_elev, NEW.wt_ymax, NEW.wt_custom_ymax, NEW.wt_elev, NEW.wt_custom_elev, NEW.node_type, NEW.nodecat_id, 
			NEW.epa_type, NEW.sector_id, NEW.state,NEW.state_type, NEW.wt_annotation,NEW.wt_observ,NEW.wt_comment,NEW.dma_id, NEW.wt_soilcat_id, NEW.wt_function_type, NEW.wt_category_type,NEW.wt_fluid_type,
			NEW.wt_location_type,NEW.wt_workcat_id, NEW.wt_workcat_id_end, NEW.wt_buildercat_id,NEW.wt_builtdate, NEW.wt_enddate, NEW.wt_ownercat_id,
			NEW.wt_muni_id, NEW.wt_streetaxis_id, NEW.wt_postcode,NEW.wt_streetaxis2_id, 
			NEW.wt_postnumber,NEW.wt_postnumber2,NEW.wt_descript, NEW.wt_rotation,NEW.wt_link,NEW.verified,NEW.undelete,NEW.wt_label_x,NEW.wt_label_y,NEW.wt_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, 
			NEW.uncertain, NEW.wt_xyz_date, NEW.unconnected, NEW.wt_num_value);
			
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.wt_pol_id IS NULL) THEN
					NEW.wt_pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				
				INSERT INTO man_wwtp (node_id,pol_id, name) VALUES (NEW.node_id,NEW.wt_pol_id,NEW.wt_name);
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.wt_pol_id,NEW.the_geom);
				UPDATE node SET the_geom =(SELECT ST_Centroid(polygon.the_geom) FROM "SCHEMA_NAME".polygon where pol_id=NEW.wt_pol_id) WHERE node_id=NEW.node_id;
			END IF;
			
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
				
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev,node_type,nodecat_id,epa_type,sector_id,"state",state_type, annotation,observ,"comment",dma_id,
			soilcat_id,function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode,streetaxis2_id,postnumber,postnumber2,descript, rotation,link,verified, 
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value) 
			VALUES (NEW.node_id, NEW.ne_code, NEW.ne_top_elev,NEW.ne_custom_top_elev, NEW.ne_ymax, NEW.ne_custom_ymax, NEW.ne_elev, NEW.ne_custom_elev, NEW.node_type, NEW.nodecat_id, 
			NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.ne_annotation,NEW.ne_observ,NEW.ne_comment,NEW.dma_id, NEW.ne_soilcat_id, NEW.ne_function_type, NEW.ne_category_type,NEW.ne_fluid_type,
			NEW.ne_location_type,NEW.ne_workcat_id, NEW.ne_workcat_id_end, NEW.ne_buildercat_id,NEW.ne_builtdate, NEW.ne_enddate, NEW.ne_ownercat_id,
			NEW.ne_muni_id, NEW.ne_streetaxis_id, NEW.ne_postcode,NEW.ne_streetaxis2_id, 
			NEW.ne_postnumber,NEW.ne_postnumber2,NEW.ne_descript, NEW.ne_rotation,NEW.ne_link,NEW.verified,NEW.undelete,NEW.ne_label_x,NEW.ne_label_y,NEW.ne_label_rotation,NEW.the_geom, NEW.expl_id, NEW.publish, NEW.inventory, 
			NEW.uncertain, NEW.ne_xyz_date, NEW.unconnected, NEW.ne_num_value);
			
			INSERT INTO man_netelement (node_id, serial_number) VALUES(NEW.node_id, NEW.ne_serial_number);		
			
		END IF;
		
		-- EPA INSERT
        IF (NEW.epa_type = 'JUNCTION') THEN
			INSERT INTO inp_junction (node_id, y0, ysur, apond) VALUES (NEW.node_id, 0, 0, 0);
			
        ELSIF (NEW.epa_type = 'DIVIDER') THEN
			INSERT INTO inp_divider (node_id, divider_type) VALUES (NEW.node_id, 'CUTOFF');
		
        ELSIF (NEW.epa_type = 'OUTFALL') THEN
			INSERT INTO inp_outfall (node_id, of_type) VALUES (NEW.node_id, 'NORMAL');
		
        ELSIF (NEW.epa_type = 'STORAGE') THEN
			INSERT INTO inp_storage (node_id, st_type) VALUES (NEW.node_id, 'TABULAR');
		
		
        END IF;
          
        RETURN NEW;


    ELSIF TG_OP = 'UPDATE' THEN
	
/*
	IF (NEW.elev <> OLD.elev) THEN
                RETURN audit_function(1048,1218);  
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

		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
		END IF;
			
		-- The geom
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
		END IF;
			
        
		IF man_table ='man_junction' THEN
			
			--Label rotation
			IF (NEW.jt_rotation != OLD.jt_rotation) THEN
				UPDATE node SET rotation=NEW.jt_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.jt_code, top_elev=NEW.jt_top_elev, custom_top_elev=NEW.jt_custom_top_elev, ymax=NEW.jt_ymax, custom_ymax=NEW.jt_custom_ymax, elev=NEW.jt_elev, 
			custom_elev=NEW.jt_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.jt_annotation, "observ"=NEW.jt_observ, 
			"comment"=NEW.jt_comment, dma_id=NEW.dma_id, soilcat_id=NEW.jt_soilcat_id, function_type=NEW.jt_function_type,	category_type=NEW.jt_category_type,fluid_type=NEW.jt_fluid_type, 
			location_type=NEW.jt_location_type, workcat_id=NEW.jt_workcat_id, workcat_id_end=NEW.jt_workcat_id_end, buildercat_id=NEW.jt_buildercat_id, builtdate=NEW.jt_builtdate, enddate=NEW.jt_enddate,
			ownercat_id=NEW.jt_ownercat_id, 
			muni_id=NEW.jt_muni_id, streetaxis_id=NEW.jt_streetaxis_id, postcode=NEW.jt_postcode,streetaxis2_id=NEW.jt_streetaxis2_id, postnumber=NEW.jt_postnumber, postnumber2=NEW.jt_postnumber2, descript=NEW.jt_descript,
			link=NEW.jt_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.jt_label_x, label_y=NEW.jt_label_y, label_rotation=NEW.jt_label_rotation,
			 publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.jt_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.jt_num_value
			WHERE node_id = OLD.node_id;
			
            UPDATE man_junction SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_netgully' THEN

			--Label rotation
			IF (NEW.ng_rotation != OLD.ng_rotation) THEN
				UPDATE node SET rotation=NEW.ng_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.ng_code, top_elev=NEW.ng_top_elev, custom_top_elev=NEW.ng_custom_top_elev, ymax=NEW.ng_ymax, custom_ymax=NEW.ng_custom_ymax, elev=NEW.ng_elev, 
			custom_elev=NEW.ng_custom_elev,  node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.ng_annotation, "observ"=NEW.ng_observ, 
			"comment"=NEW.ng_comment, dma_id=NEW.dma_id, soilcat_id=NEW.ng_soilcat_id, function_type=NEW.ng_function_type, category_type=NEW.ng_category_type,fluid_type=NEW.ng_fluid_type, 
			location_type=NEW.ng_location_type, workcat_id=NEW.ng_workcat_id, workcat_id_end=NEW.ng_workcat_id_end, buildercat_id=NEW.ng_buildercat_id, builtdate=NEW.ng_builtdate, enddate=NEW.ng_enddate,
			ownercat_id=NEW.ng_ownercat_id, 
			muni_id=NEW.ng_muni_id, streetaxis_id=NEW.ng_streetaxis_id, postcode=NEW.ng_postcode,streetaxis2_id=NEW.ng_streetaxis2_id, postnumber=NEW.ng_postnumber, postnumber2=NEW.ng_postnumber2, descript=NEW.ng_descript,
			link=NEW.ng_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ng_label_x, label_y=NEW.ng_label_y, 
			label_rotation=NEW.ng_label_rotation,  publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.ng_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.ng_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netgully SET pol_id=NEW.ng_pol_id, sander_depth=NEW.ng_sander_depth, gratecat_id=NEW.ng_gratecat_id, units=NEW.ng_units, groove=NEW.ng_groove, siphon=NEW.ng_siphon, 
			postnumber=NEW.ng_postnumber
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_netgully_pol' THEN
		
			--Label rotation
			IF (NEW.ng_rotation != OLD.ng_rotation) THEN
				UPDATE node SET rotation=NEW.ng_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.ng_code, top_elev=NEW.ng_top_elev, custom_top_elev=NEW.ng_custom_top_elev, ymax=NEW.ng_ymax, custom_ymax=NEW.ng_custom_ymax, elev=NEW.ng_elev, 
			custom_elev=NEW.ng_custom_elev,  node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.ng_annotation, "observ"=NEW.ng_observ, 
			"comment"=NEW.ng_comment, dma_id=NEW.dma_id, soilcat_id=NEW.ng_soilcat_id, function_type=NEW.ng_function_type, category_type=NEW.ng_category_type,fluid_type=NEW.ng_fluid_type, 
			location_type=NEW.ng_location_type, workcat_id=NEW.ng_workcat_id, workcat_id_end=NEW.ng_workcat_id_end, buildercat_id=NEW.ng_buildercat_id, builtdate=NEW.ng_builtdate, enddate=NEW.ng_enddate,
			ownercat_id=NEW.ng_ownercat_id, 
			muni_id=NEW.ng_muni_id, streetaxis_id=NEW.ng_streetaxis_id, postcode=NEW.ng_postcode,streetaxis2_id=NEW.ng_streetaxis2_id, postnumber=NEW.ng_postnumber, postnumber2=NEW.ng_postnumber2, descript=NEW.ng_descript,
			link=NEW.ng_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ng_label_x, label_y=NEW.ng_label_y, 
			label_rotation=NEW.ng_label_rotation,  publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.ng_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.ng_num_value
			WHERE node_id = OLD.node_id;
			
			IF (NEW.ng_pol_id IS NULL) THEN
				UPDATE man_netgully SET pol_id=NEW.ng_pol_id, sander_depth=NEW.ng_sander_depth, gratecat_id=NEW.ng_gratecat_id, units=NEW.ng_units, groove=NEW.ng_groove, siphon=NEW.ng_siphon, 
				postnumber=NEW.ng_postnumber
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.ng_pol_id;
			ELSE
				UPDATE man_netgully SET pol_id=NEW.ng_pol_id, sander_depth=NEW.ng_sander_depth, gratecat_id=NEW.ng_gratecat_id, units=NEW.ng_units, groove=NEW.ng_groove, siphon=NEW.ng_siphon, 
				postnumber=NEW.ng_postnumber
				WHERE node_id=OLD.node_id;	
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.ng_pol_id
				WHERE pol_id=OLD.ng_pol_id;
			END IF;
			
		ELSIF man_table='man_outfall' THEN

		--Label rotation
			IF (NEW.of_rotation != OLD.of_rotation) THEN
				UPDATE node SET rotation=NEW.of_rotation WHERE node_id = OLD.node_id;
			END IF;	
			
			UPDATE node 
			SET code=NEW.of_code, top_elev=NEW.of_top_elev, custom_top_elev=NEW.of_custom_top_elev, ymax=NEW.of_ymax, custom_ymax=NEW.of_custom_ymax, elev=NEW.of_elev, 
			custom_elev=NEW.of_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.of_annotation, "observ"=NEW.of_observ, 
			"comment"=NEW.of_comment, dma_id=NEW.dma_id, soilcat_id=NEW.of_soilcat_id, function_type=NEW.of_function_type, category_type=NEW.of_category_type,fluid_type=NEW.of_fluid_type, location_type=NEW.of_location_type, 
			workcat_id=NEW.of_workcat_id, workcat_id_end=NEW.of_workcat_id_end,buildercat_id=NEW.of_buildercat_id, builtdate=NEW.of_builtdate, enddate=NEW.of_enddate,  ownercat_id=NEW.of_ownercat_id, 
			muni_id=NEW.of_muni_id, streetaxis_id=NEW.of_streetaxis_id, postcode=NEW.of_postcode,streetaxis2_id=NEW.of_streetaxis2_id, postnumber=NEW.of_postnumber, postnumber2=NEW.of_postnumber2, descript=NEW.of_descript,
			link=NEW.of_link, verified=NEW.verified,  undelete=NEW.undelete, label_x=NEW.of_label_x, label_y=NEW.of_label_y, label_rotation=NEW.of_label_rotation, 
			publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.of_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.of_num_value
			WHERE node_id = OLD.node_id;
			
			UPDATE man_outfall SET name=NEW.of_name
			WHERE node_id=OLD.node_id;
			
		ELSIF man_table='man_storage' THEN

		--Label rotation
			IF (NEW.st_rotation != OLD.st_rotation) THEN
				UPDATE node SET rotation=NEW.st_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.st_code, top_elev=NEW.st_top_elev, custom_top_elev=NEW.st_custom_top_elev, ymax=NEW.st_ymax, custom_ymax=NEW.st_custom_ymax, 
			elev=NEW.st_elev, custom_elev=NEW.st_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			state_type=NEW.state_type, annotation=NEW.st_annotation, "observ"=NEW.st_observ, "comment"=NEW.st_comment, dma_id=NEW.dma_id, soilcat_id=NEW.st_soilcat_id, function_type=NEW.st_function_type,
			category_type=NEW.st_category_type,fluid_type=NEW.st_fluid_type, location_type=NEW.st_location_type, workcat_id=NEW.st_workcat_id, workcat_id_end=NEW.st_workcat_id_end, buildercat_id=NEW.st_buildercat_id, 
			builtdate=NEW.st_builtdate, enddate=NEW.st_enddate, ownercat_id=NEW.st_ownercat_id, 
			muni_id=NEW.st_muni_id, streetaxis_id=NEW.st_streetaxis_id, postcode=NEW.st_postcode,streetaxis2_id=NEW.st_streetaxis2_id, postnumber=NEW.st_postnumber, postnumber2=NEW.st_postnumber2, descript=NEW.st_descript,
			link=NEW.st_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.st_label_x, label_y=NEW.st_label_y, 
			label_rotation=NEW.st_label_rotation, publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.st_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id,
			num_value=NEW.st_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_storage SET pol_id=NEW.st_pol_id, length=NEW.st_length, width=NEW.st_width, custom_area=NEW.st_custom_area, max_volume=NEW.st_max_volume,
			util_volume=NEW.st_util_volume,min_height=NEW.st_min_height, accessibility=NEW.st_accessibility, name=NEW.st_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_storage_pol' THEN

			--Label rotation
			IF (NEW.st_rotation != OLD.st_rotation) THEN
				UPDATE node SET rotation=NEW.st_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.st_code, top_elev=NEW.st_top_elev, custom_top_elev=NEW.st_custom_top_elev, ymax=NEW.st_ymax, custom_ymax=NEW.st_custom_ymax, 
			elev=NEW.st_elev, custom_elev=NEW.st_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 
			state_type=NEW.state_type, annotation=NEW.st_annotation, "observ"=NEW.st_observ, "comment"=NEW.st_comment, dma_id=NEW.dma_id, soilcat_id=NEW.st_soilcat_id, function_type=NEW.st_function_type,
			category_type=NEW.st_category_type,fluid_type=NEW.st_fluid_type, location_type=NEW.st_location_type, workcat_id=NEW.st_workcat_id, workcat_id_end=NEW.st_workcat_id_end, buildercat_id=NEW.st_buildercat_id, 
			builtdate=NEW.st_builtdate, enddate=NEW.st_enddate, ownercat_id=NEW.st_ownercat_id, 
			muni_id=NEW.st_muni_id, streetaxis_id=NEW.st_streetaxis_id, postcode=NEW.st_postcode,streetaxis2_id=NEW.st_streetaxis2_id, postnumber=NEW.st_postnumber, postnumber2=NEW.st_postnumber2, descript=NEW.st_descript,
			link=NEW.st_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.st_label_x, label_y=NEW.st_label_y, label_rotation=NEW.st_label_rotation, 
			publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.st_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.st_num_value
			WHERE node_id = OLD.node_id;
		
			IF (NEW.st_pol_id IS NULL) THEN
				UPDATE man_storage SET pol_id=NEW.st_pol_id, length=NEW.st_length, width=NEW.st_width, custom_area=NEW.st_custom_area, max_volume=NEW.st_max_volume,
				util_volume=NEW.st_util_volume,min_height=NEW.st_min_height, accessibility=NEW.st_accessibility, name=NEW.st_name
				WHERE node_id=OLD.node_id;	
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.st_pol_id;
			ELSE
				UPDATE man_storage SET pol_id=NEW.st_pol_id, length=NEW.st_length, width=NEW.st_width, custom_area=NEW.st_custom_area, max_volume=NEW.st_max_volume,
				util_volume=NEW.st_util_volume,min_height=NEW.st_min_height, accessibility=NEW.st_accessibility, name=NEW.st_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.st_pol_id
				WHERE pol_id=OLD.st_pol_id;
			END IF;

		ELSIF man_table='man_valve' THEN

		--Label rotation
			IF (NEW.vl_rotation != OLD.vl_rotation) THEN
				UPDATE node SET rotation=NEW.vl_rotation WHERE node_id = OLD.node_id;
			END IF;	
			
			UPDATE node 
			SET code=NEW.vl_code, top_elev=NEW.vl_top_elev, custom_top_elev=NEW.vl_custom_top_elev, ymax=NEW.vl_ymax, custom_ymax=NEW.vl_custom_ymax, elev=NEW.vl_elev, 
			custom_elev=NEW.vl_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.vl_annotation, "observ"=NEW.vl_observ, 
			"comment"=NEW.vl_comment, dma_id=NEW.dma_id, soilcat_id=NEW.vl_soilcat_id, function_type=NEW.vl_function_type, category_type=NEW.vl_category_type,fluid_type=NEW.vl_fluid_type, location_type=NEW.vl_location_type, 
			workcat_id=NEW.vl_workcat_id, workcat_id_end=NEW.vl_workcat_id_end, buildercat_id=NEW.vl_buildercat_id, builtdate=NEW.vl_builtdate, enddate=NEW.vl_enddate,  ownercat_id=NEW.vl_ownercat_id, 
			muni_id=NEW.vl_muni_id, streetaxis_id=NEW.vl_streetaxis_id, postcode=NEW.vl_postcode,streetaxis2_id=NEW.vl_streetaxis2_id, postnumber=NEW.vl_postnumber, postnumber2=NEW.vl_postnumber2, descript=NEW.vl_descript, link=NEW.vl_link, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.vl_label_x, label_y=NEW.vl_label_y, label_rotation=NEW.vl_label_rotation, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.vl_xyz_date, 
			unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.vl_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_valve SET name=NEW.vl_name
			WHERE node_id=OLD.node_id;

		
		ELSIF man_table='man_chamber' THEN
			
			--Label rotation
			IF (NEW.ch_rotation != OLD.ch_rotation) THEN
				UPDATE node SET rotation=NEW.ch_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.ch_code, top_elev=NEW.ch_top_elev, custom_top_elev=NEW.ch_custom_top_elev, ymax=NEW.ch_ymax, custom_ymax=NEW.ch_custom_ymax, elev=NEW.ch_elev, 
			custom_elev=NEW.ch_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.ch_annotation, 
			"observ"=NEW.ch_observ, "comment"=NEW.ch_comment, dma_id=NEW.dma_id, soilcat_id=NEW.ch_soilcat_id, function_type=NEW.ch_function_type, category_type=NEW.ch_category_type,fluid_type=NEW.ch_fluid_type, 
			location_type=NEW.ch_location_type, workcat_id=NEW.ch_workcat_id, workcat_id_end=NEW.ch_workcat_id_end, buildercat_id=NEW.ch_buildercat_id, builtdate=NEW.ch_builtdate, enddate=NEW.ch_enddate,  
			ownercat_id=NEW.ch_ownercat_id, 
			muni_id=NEW.ch_muni_id, streetaxis_id=NEW.ch_streetaxis_id, postcode=NEW.ch_postcode,streetaxis2_id=NEW.ch_streetaxis2_id, postnumber=NEW.ch_postnumber, postnumber2=NEW.ch_postnumber2, descript=NEW.ch_descript,
			link=NEW.ch_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ch_label_x, label_y=NEW.ch_label_y, label_rotation=NEW.ch_label_rotation,
			publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.ch_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.ch_num_value
			WHERE node_id = OLD.node_id;
			
			UPDATE man_chamber SET pol_id=NEW.ch_pol_id, length=NEW.ch_length, width=NEW.ch_width, sander_depth=NEW.ch_sander_depth, max_volume=NEW.ch_max_volume, util_volume=NEW.ch_util_volume,
			inlet=NEW.ch_inlet, bottom_channel=NEW.ch_bottom_channel, accessibility=NEW.ch_accessibility, name=NEW.ch_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_chamber_pol' THEN
			
			--Label rotation
			IF (NEW.ch_rotation != OLD.ch_rotation) THEN
				UPDATE node SET rotation=NEW.ch_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.ch_code, top_elev=NEW.ch_top_elev, custom_top_elev=NEW.ch_custom_top_elev, ymax=NEW.ch_ymax, custom_ymax=NEW.ch_custom_ymax, elev=NEW.ch_elev, 
			custom_elev=NEW.ch_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.ch_annotation, 
			"observ"=NEW.ch_observ, "comment"=NEW.ch_comment, dma_id=NEW.dma_id, soilcat_id=NEW.ch_soilcat_id, function_type=NEW.ch_function_type, category_type=NEW.ch_category_type,fluid_type=NEW.ch_fluid_type, 
			location_type=NEW.ch_location_type, workcat_id=NEW.ch_workcat_id, workcat_id_end=NEW.ch_workcat_id_end, buildercat_id=NEW.ch_buildercat_id, builtdate=NEW.ch_builtdate, enddate=NEW.ch_enddate,  
			ownercat_id=NEW.ch_ownercat_id, 
			muni_id=NEW.ch_muni_id, streetaxis_id=NEW.ch_streetaxis_id, postcode=NEW.ch_postcode,streetaxis2_id=NEW.ch_streetaxis2_id, postnumber=NEW.ch_postnumber, postnumber2=NEW.ch_postnumber2, descript=NEW.ch_descript,
			link=NEW.ch_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ch_label_x, label_y=NEW.ch_label_y, label_rotation=NEW.ch_label_rotation, 
			publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.ch_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.ch_num_value
			WHERE node_id = OLD.node_id;
		
			IF (NEW.ch_pol_id IS NULL) THEN
				UPDATE man_chamber SET pol_id=NEW.ch_pol_id, length=NEW.ch_length, width=NEW.ch_width, sander_depth=NEW.ch_sander_depth, max_volume=NEW.ch_max_volume, util_volume=NEW.ch_util_volume,
				inlet=NEW.ch_inlet, bottom_channel=NEW.ch_bottom_channel, accessibility=NEW.ch_accessibility, name=NEW.ch_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.ch_pol_id;
			ELSE
				UPDATE man_chamber SET pol_id=NEW.ch_pol_id, length=NEW.ch_length, width=NEW.ch_width, sander_depth=NEW.ch_sander_depth, max_volume=NEW.ch_max_volume, util_volume=NEW.ch_util_volume,
				inlet=NEW.ch_inlet, bottom_channel=NEW.ch_bottom_channel, accessibility=NEW.ch_accessibility, name=NEW.ch_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.ch_pol_id
				WHERE pol_id=OLD.ch_pol_id;
			END IF;	
			
		ELSIF man_table='man_manhole' THEN

		--Label rotation
			IF (NEW.mh_rotation != OLD.mh_rotation) THEN
				UPDATE node SET rotation=NEW.mh_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.mh_code,top_elev=NEW.mh_top_elev, custom_top_elev=NEW.mh_custom_top_elev, ymax=NEW.mh_ymax, custom_ymax=NEW.mh_custom_ymax, elev=NEW.mh_elev, 
			custom_elev=NEW.mh_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.mh_annotation, "observ"=NEW.mh_observ, 
			"comment"=NEW.mh_comment, dma_id=NEW.dma_id, soilcat_id=NEW.mh_soilcat_id, function_type=NEW.mh_function_type, category_type=NEW.mh_category_type,fluid_type=NEW.mh_fluid_type, 
			location_type=NEW.mh_location_type, workcat_id=NEW.mh_workcat_id, workcat_id_end=NEW.mh_workcat_id_end, buildercat_id=NEW.mh_buildercat_id, builtdate=NEW.mh_builtdate, enddate=NEW.mh_enddate, 
			ownercat_id=NEW.mh_ownercat_id, 
			muni_id=NEW.mh_muni_id, streetaxis_id=NEW.mh_streetaxis_id, postcode=NEW.mh_postcode,streetaxis2_id=NEW.mh_streetaxis2_id, postnumber=NEW.mh_postnumber, postnumber2=NEW.mh_postnumber2, descript=NEW.mh_descript,
			link=NEW.mh_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.mh_label_x, label_y=NEW.mh_label_y, label_rotation=NEW.mh_label_rotation, 
			publish=NEW.publish, inventory=NEW.inventory,  uncertain=NEW.uncertain, xyz_date=NEW.mh_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.mh_num_value
			WHERE node_id = OLD.node_id;
			
			UPDATE man_manhole SET length=NEW.mh_length, width=NEW.mh_width, sander_depth=NEW.mh_sander_depth, prot_surface=NEW.mh_prot_surface, inlet=NEW.mh_inlet,
			bottom_channel=NEW.mh_bottom_channel, accessibility=NEW.mh_accessibility
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_netinit' THEN

			--Label rotation
			IF (NEW.ni_rotation != OLD.ni_rotation) THEN
				UPDATE node SET rotation=NEW.ni_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.ni_code, top_elev=NEW.ni_top_elev, custom_top_elev=NEW.ni_custom_top_elev, ymax=NEW.ni_ymax, custom_ymax=NEW.ni_custom_ymax, elev=NEW.ni_elev, 
			custom_elev=NEW.ni_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.ni_annotation, "observ"=NEW.ni_observ, 
			"comment"=NEW.ni_comment, dma_id=NEW.dma_id, soilcat_id=NEW.ni_soilcat_id, function_type=NEW.ni_function_type, category_type=NEW.ni_category_type,fluid_type=NEW.ni_fluid_type, location_type=NEW.ni_location_type, 
			workcat_id=NEW.ni_workcat_id, workcat_id_end=NEW.ni_workcat_id_end,  buildercat_id=NEW.ni_buildercat_id, builtdate=NEW.ni_builtdate, enddate=NEW.ni_enddate,  ownercat_id=NEW.ni_ownercat_id, 
			muni_id=NEW.ni_muni_id, streetaxis_id=NEW.ni_streetaxis_id, postcode=NEW.ni_postcode,streetaxis2_id=NEW.ni_streetaxis2_id, postnumber=NEW.ni_postnumber, postnumber2=NEW.ni_postnumber2, descript=NEW.ni_descript, rotation=NEW.ni_rotation, link=NEW.ni_link, verified=NEW.verified, 
			undelete=NEW.undelete, label_x=NEW.ni_label_x, label_y=NEW.ni_label_y, label_rotation=NEW.ni_label_rotation, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, 
			xyz_date=NEW.ni_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.ni_num_value, sander_depth=NEW.ni_sander_depth
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netinit SET length=NEW.ni_length, width=NEW.ni_width, inlet=NEW.ni_inlet, bottom_channel=NEW.ni_bottom_channel, accessibility=NEW.ni_accessibility, name=NEW.ni_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wjump' THEN
	
			--Label rotation
			IF (NEW.wj_rotation != OLD.wj_rotation) THEN
				UPDATE node SET rotation=NEW.wj_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.wj_code,top_elev=NEW.wj_top_elev, custom_top_elev=NEW.wj_custom_top_elev, ymax=NEW.wj_ymax, custom_ymax=NEW.wj_custom_ymax, elev=NEW.wj_elev, 
			custom_elev=NEW.wj_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.wj_annotation, "observ"=NEW.wj_observ, 
			"comment"=NEW.wj_comment, dma_id=NEW.dma_id, soilcat_id=NEW.wj_soilcat_id, category_type=NEW.wj_category_type, function_type=NEW.wj_function_type, fluid_type=NEW.wj_fluid_type, location_type=NEW.wj_location_type, 
			workcat_id=NEW.wj_workcat_id, workcat_id_end=NEW.wj_workcat_id_end, buildercat_id=NEW.wj_buildercat_id, builtdate=NEW.wj_builtdate, enddate=NEW.wj_enddate,  ownercat_id=NEW.wj_ownercat_id, 
			muni_id=NEW.wj_muni_id, streetaxis_id=NEW.wj_streetaxis_id, postcode=NEW.wj_postcode,streetaxis2_id=NEW.wj_streetaxis2_id, postnumber=NEW.wj_postnumber, postnumber2=NEW.wj_postnumber2, descript=NEW.wj_descript, link=NEW.wj_link, verified=NEW.verified, undelete=NEW.undelete, 
			label_x=NEW.wj_label_x, label_y=NEW.wj_label_y, label_rotation=NEW.wj_label_rotation, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.wj_xyz_date, 
			unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.wj_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wjump SET length=NEW.wj_length, width=NEW.wj_width, sander_depth=NEW.wj_sander_depth, prot_surface=NEW.wj_prot_surface, accessibility=NEW.wj_accessibility, name=NEW.wj_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wwtp' THEN
	
				--Label rotation
			IF (NEW.wt_rotation != OLD.wt_rotation) THEN
				UPDATE node SET rotation=NEW.wt_rotation WHERE node_id = OLD.node_id;
			END IF;
		
			UPDATE node 
			SET code=NEW.wt_code,top_elev=NEW.wt_top_elev, custom_top_elev=NEW.wt_custom_top_elev, ymax=NEW.wt_ymax, custom_ymax=NEW.wt_custom_ymax, elev=NEW.wt_elev, custom_elev=NEW.wt_custom_elev,
			node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 	state_type=NEW.state_type, annotation=NEW.wt_annotation, "observ"=NEW.wt_observ, 
			"comment"=NEW.wt_comment, dma_id=NEW.dma_id, soilcat_id=NEW.wt_soilcat_id, function_type=NEW.wt_function_type, category_type=NEW.wt_category_type, fluid_type=NEW.wt_fluid_type, 
			location_type=NEW.wt_location_type, workcat_id=NEW.wt_workcat_id, workcat_id_end=NEW.wt_workcat_id_end, buildercat_id=NEW.wt_buildercat_id, builtdate=NEW.wt_builtdate, enddate=NEW.wt_enddate,  
			ownercat_id=NEW.wt_ownercat_id,
			muni_id=NEW.wt_muni_id, streetaxis_id=NEW.wt_streetaxis_id, postcode=NEW.wt_postcode,streetaxis2_id=NEW.wt_streetaxis2_id, postnumber=NEW.wt_postnumber, postnumber2=NEW.wt_postnumber2, descript=NEW.wt_descript, link=NEW.wt_link, 
			verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.wt_label_x, label_y=NEW.wt_label_y,	label_rotation=NEW.wt_label_rotation, publish=NEW.publish, inventory=NEW.inventory, 
			uncertain=NEW.uncertain, xyz_date=NEW.wt_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.wt_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_wwtp SET pol_id=NEW.wt_pol_id, name=NEW.wt_name
			WHERE node_id=OLD.node_id;

			
		ELSIF man_table='man_wwtp_pol' THEN
	
			--Label rotation
			IF (NEW.wt_rotation != OLD.wt_rotation) THEN
				UPDATE node SET rotation=NEW.wt_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.wt_code,top_elev=NEW.wt_top_elev, custom_top_elev=NEW.wt_custom_top_elev, ymax=NEW.wt_ymax, custom_ymax=NEW.wt_custom_ymax, elev=NEW.wt_elev, custom_elev=NEW.wt_custom_elev, 
			node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, 	state_type=NEW.state_type, annotation=NEW.wt_annotation, "observ"=NEW.wt_observ, "comment"=NEW.wt_comment, 
			dma_id=NEW.dma_id, soilcat_id=NEW.wt_soilcat_id, function_type=NEW.wt_function_type, category_type=NEW.wt_category_type, fluid_type=NEW.wt_fluid_type, location_type=NEW.wt_location_type, workcat_id=NEW.wt_workcat_id, 
			workcat_id_end=NEW.wt_workcat_id_end, buildercat_id=NEW.wt_buildercat_id, builtdate=NEW.wt_builtdate, enddate=NEW.wt_enddate,  ownercat_id=NEW.wt_ownercat_id,
			muni_id=NEW.wt_muni_id, streetaxis_id=NEW.wt_streetaxis_id, postcode=NEW.wt_postcode,streetaxis2_id=NEW.wt_streetaxis2_id, 
			postnumber=NEW.wt_postnumber, postnumber2=NEW.wt_postnumber2, descript=NEW.wt_descript, link=NEW.wt_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.wt_label_x, label_y=NEW.wt_label_y,
			label_rotation=NEW.wt_label_rotation, publish=NEW.publish, inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.wt_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.wt_num_value
			WHERE node_id = OLD.node_id;
		
		
			IF (NEW.wt_pol_id IS NULL) THEN
				UPDATE man_wwtp SET pol_id=NEW.wt_pol_id, name=NEW.wt_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom
				WHERE pol_id=OLD.wt_pol_id;
			ELSE
				UPDATE man_wwtp SET pol_id=NEW.wt_pol_id, name=NEW.wt_name
				WHERE node_id=OLD.node_id;
				UPDATE polygon SET the_geom=NEW.the_geom,pol_id=NEW.wt_pol_id
				WHERE pol_id=OLD.wt_pol_id;
			END IF;	
			
		ELSIF man_table ='man_netelement' THEN
	
				--Label rotation
			IF (NEW.ne_rotation != OLD.ne_rotation) THEN
				UPDATE node SET rotation=NEW.ne_rotation WHERE node_id = OLD.node_id;
			END IF;
			
			UPDATE node 
			SET code=NEW.ne_code,top_elev=NEW.ne_top_elev, custom_top_elev=NEW.ne_custom_top_elev, ymax=NEW.ne_ymax, custom_ymax=NEW.ne_custom_ymax, elev=NEW.ne_elev, 
			custom_elev=NEW.ne_custom_elev, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.ne_annotation, 
			"observ"=NEW.ne_observ, "comment"=NEW.ne_comment, dma_id=NEW.dma_id, soilcat_id=NEW.ne_soilcat_id, function_type=NEW.ne_function_type, category_type=NEW.ne_category_type, fluid_type=NEW.ne_fluid_type, 
			location_type=NEW.ne_location_type, workcat_id=NEW.ne_workcat_id, workcat_id_end=NEW.ne_workcat_id_end, buildercat_id=NEW.ne_buildercat_id, builtdate=NEW.ne_builtdate, enddate=NEW.ne_enddate,  
			ownercat_id=NEW.ne_ownercat_id,
			muni_id=NEW.ne_muni_id, streetaxis_id=NEW.ne_streetaxis_id, postcode=NEW.ne_postcode,streetaxis2_id=NEW.ne_streetaxis2_id, postnumber=NEW.ne_postnumber, postnumber2=NEW.ne_postnumber2, descript=NEW.ne_descript,
			link=NEW.ne_link, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.ne_label_x, label_y=NEW.ne_label_y,label_rotation=NEW.ne_label_rotation, publish=NEW.publish, 
			inventory=NEW.inventory, uncertain=NEW.uncertain, xyz_date=NEW.ne_xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.ne_num_value
			WHERE node_id = OLD.node_id;
		
			UPDATE man_netelement
			SET serial_number=NEW.ne_serial_number
			WHERE node_id=OLD.node_id;	
		
		
		END IF;
        RETURN NEW;
		
		
	
    ELSIF TG_OP = 'DELETE' THEN
	
	PERFORM gw_fct_check_delete(OLD.node_id, 'NODE');
	
	IF man_table='man_chamber_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.ch_pol_id;
	ELSIF man_table='man_chamber' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_chamber WHERE node_id=OLD.node_id );
	ELSIF man_table='man_storage_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.st_pol_id;
	ELSIF man_table='man_storage' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_storage WHERE node_id=OLD.node_id );
	ELSIF man_table='man_wwtp_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.wt_pol_id;
	ELSIF man_table='man_wwtp' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_wwtp WHERE node_id=OLD.node_id );
	ELSIF man_table='man_netgully_pol' THEN
		DELETE FROM polygon WHERE pol_id=OLD.ng_pol_id;
	ELSIF man_table='man_netgully' THEN
		DELETE FROM node WHERE node_id=OLD.node_id;
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_netgully WHERE node_id=OLD.node_id );
	ELSE 
		DELETE FROM node WHERE node_id = OLD.node_id;
	END IF;
  RETURN NULL;
   
  END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber ON "SCHEMA_NAME".v_edit_man_chamber;
CREATE TRIGGER gw_trg_edit_man_chamber INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber');     

DROP TRIGGER IF EXISTS gw_trg_edit_man_chamber_pol ON "SCHEMA_NAME".v_edit_man_chamber_pol;
CREATE TRIGGER gw_trg_edit_man_ch_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_chamber_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_chamber_pol');  
  
DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully ON "SCHEMA_NAME".v_edit_man_netgully;
CREATE TRIGGER gw_trg_edit_man_netgully INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netgully_pol ON "SCHEMA_NAME".v_edit_man_netgully_pol;
CREATE TRIGGER gw_trg_edit_man_ng_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netgully_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netgully_pol');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_netinit ON "SCHEMA_NAME".v_edit_man_netinit;
CREATE TRIGGER gw_trg_edit_man_netinit INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netinit FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netinit');  

DROP TRIGGER IF EXISTS gw_trg_edit_man_outfall ON "SCHEMA_NAME".v_edit_man_outfall;
CREATE TRIGGER gw_trg_edit_man_outfall INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_outfall FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_outfall');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage ON "SCHEMA_NAME".v_edit_man_storage;
CREATE TRIGGER gw_trg_edit_man_storage INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage');

DROP TRIGGER IF EXISTS gw_trg_edit_man_storage_pol ON "SCHEMA_NAME".v_edit_man_storage_pol;
CREATE TRIGGER gw_trg_edit_man_st_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_storage_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_storage_pol');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wjump ON "SCHEMA_NAME".v_edit_man_wjump;
CREATE TRIGGER gw_trg_edit_man_wjump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wjump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wjump');   

DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp ON "SCHEMA_NAME".v_edit_man_wwtp;
CREATE TRIGGER gw_trg_edit_man_wwtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp');
     
DROP TRIGGER IF EXISTS gw_trg_edit_man_wwtp_pol ON "SCHEMA_NAME".v_edit_man_wwtp_pol;
CREATE TRIGGER gw_trg_edit_man_wt_pol INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wwtp_pol FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wwtp_pol'); 

DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netelement');   