/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 1212

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
			NEW.arc_id:= (SELECT nextval('urn_id_seq'));
			END IF;

			 -- Arc type
			IF (NEW.arc_type IS NULL) THEN
				IF ((SELECT COUNT(*) FROM arc_type) = 0) THEN
					RETURN audit_function(1018,1212);  
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
					RETURN audit_function(1020,1212); 
				END IF; 
					NEW.arccat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='arccat_vdefault' AND "cur_user"="current_user"());
				IF (NEW.arccat_id IS NULL) THEN
					NEW.arccat_id := (SELECT arccat_id from arc WHERE ST_DWithin(NEW.the_geom, arc.the_geom,0.001) LIMIT 1);
				END IF;
				IF (NEW.arccat_id IS NULL) THEN
						NEW.arccat_id := (SELECT id FROM cat_arc LIMIT 1);
				END IF;       
			END IF;
			
			-- Sector ID
			IF (NEW.sector_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					RETURN audit_function(1008,1212); 
				END IF;
				NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
				IF (NEW.sector_id IS NULL) THEN
					RETURN audit_function(1010,1212); 
				END IF;
			END IF;
			
			-- Dma ID
			IF (NEW.dma_id IS NULL) THEN
				IF ((SELECT COUNT(*) FROM dma) = 0) THEN
					RETURN audit_function(1012,1212); 
				END IF;
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
				IF (NEW.dma_id IS NULL) THEN
					RETURN audit_function(1014,1212); 
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
						PERFORM audit_function(2012,1212);
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
			
			
			-- FEATURE INSERT
						
			IF man_table='man_conduit' THEN
						
				-- Workcat_id
				IF (NEW.cd_workcat_id IS NULL) THEN
					NEW.cd_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					IF (NEW.cd_workcat_id IS NULL) THEN
						NEW.cd_workcat_id := (SELECT id FROM cat_work limit 1);
					END IF;
				END IF;

				--Builtdate
				IF (NEW.cd_builtdate IS NULL) THEN
					NEW.cd_builtdate:=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
		
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", state_type,
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, 
				builtdate, enddate, ownercat_id, muni_id, streetaxis_id, postcode, streetaxis2_id, postnumber, postnumber2, descript, link, verified, the_geom,undelete,label_x,label_y, label_rotation, expl_id, publish, inventory,
				uncertain, num_value) 
				VALUES (NEW.arc_id, NEW.cd_code, null, null, NEW.cd_y1, NEW.cd_y2, NEW.cd_custom_y1, NEW.cd_custom_y2, NEW.cd_elev1, NEW.cd_elev2, 
				NEW.cd_custom_elev1, NEW.cd_custom_elev2,NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.cd_annotation, NEW.cd_observ, NEW.cd_comment, 
				NEW.cd_inverted_slope, NEW.cd_custom_length, NEW.dma_id, NEW.cd_soilcat_id, NEW.cd_function_type, NEW.cd_category_type, NEW.cd_fluid_type, 
				NEW.cd_location_type, NEW.cd_workcat_id,NEW.cd_workcat_id_end,NEW.cd_buildercat_id, NEW.cd_builtdate, NEW.cd_enddate, NEW.cd_ownercat_id, 
				NEW.cd_muni_id, NEW.cd_steetaxis_id, NEW.cd_postcode, NEW.cd_streetaxis2_id, NEW.cd_postnumber, NEW.cd_postnumber2, NEW.cd_descript, NEW.cd_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.cd_label_x, 
				NEW.cd_label_y, NEW.cd_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.cd_num_value);
				
				INSERT INTO man_conduit (arc_id) VALUES (NEW.arc_id);
			
			ELSIF man_table='man_siphon' THEN

				-- Workcat_id
				IF (NEW.sh_workcat_id IS NULL) THEN
					NEW.sh_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					IF (NEW.sh_workcat_id IS NULL) THEN
						NEW.sh_workcat_id :=(SELECT id FROM cat_work limit 1);
					END IF;
				END IF;

				--Builtdate
				IF (NEW.sh_builtdate IS NULL) THEN
					NEW.sh_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
				
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", state_type,
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id,workcat_id_end, buildercat_id, 
				builtdate, enddate, ownercat_id, muni_id, streetaxis_id, postcode, streetaxis2_id, postnumber, postnumber2, descript, link, verified, the_geom,undelete, label_x,label_y, label_rotation, expl_id, publish, inventory, 
				uncertain,num_value) 
				VALUES (NEW.arc_id, NEW.sh_code, null, null, NEW.sh_y1, NEW.sh_y2, NEW.sh_custom_y1, NEW.sh_custom_y2, NEW.sh_elev1, NEW.sh_elev2, 
				NEW.sh_custom_elev1, NEW.sh_custom_elev2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.sh_annotation, NEW.sh_observ, NEW.sh_comment,
				NEW.sh_inverted_slope, NEW.sh_custom_length, NEW.dma_id, NEW.sh_soilcat_id, NEW.sh_function_type, NEW.sh_category_type, NEW.sh_fluid_type, 
				NEW.sh_location_type, NEW.sh_workcat_id,NEW.sh_workcat_id_end, NEW.sh_buildercat_id, NEW.sh_builtdate, NEW.sh_enddate, NEW.sh_ownercat_id, 
				NEW.sh_muni_id, NEW.sh_steetaxis_id, NEW.sh_postcode, NEW.sh_streetaxis2_id, NEW.sh_postnumber, NEW.sh_postnumber2, NEW.sh_descript, NEW.sh_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.sh_label_x, 
				NEW.sh_label_y, NEW.sh_label_rotation,NEW.expl_id, NEW.publish, NEW.inventory,  NEW.uncertain, NEW.sh_num_value);
				
				INSERT INTO man_siphon (arc_id,name) VALUES (NEW.arc_id,NEW.sh_name);
				
			ELSIF man_table='man_waccel' THEN
						
				-- Workcat_id
				IF (NEW.wl_workcat_id IS NULL) THEN
					NEW.wl_workcat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					IF (NEW.wl_workcat_id IS NULL) THEN
						NEW.wl_workcat_id :=(SELECT id FROM cat_work limit 1);
					END IF;
				END IF;

				--Builtdate
				IF (NEW.wl_builtdate IS NULL) THEN
					NEW.wl_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
				
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", state_type,
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, 
				builtdate, enddate, ownercat_id, muni_id, streetaxis_id, postcode, streetaxis2_id, postnumber, postnumber2, descript, link, verified, the_geom,undelete, label_x,label_y, label_rotation, expl_id, publish, inventory, 
				uncertain,num_value)
				VALUES (NEW.arc_id, NEW.wl_code, null, null, NEW.wl_y1, NEW.wl_y2, NEW.wl_custom_y1, NEW.wl_custom_y2, NEW.wl_elev1, NEW.wl_elev2, 
				NEW.wl_custom_elev1, NEW.wl_custom_elev2,NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.wl_annotation, NEW.wl_observ, NEW.wl_comment,
				NEW.wl_inverted_slope, NEW.wl_custom_length, NEW.dma_id, NEW.wl_soilcat_id, NEW.wl_function_type,NEW.wl_category_type, NEW.wl_fluid_type, 
				NEW.wl_location_type, NEW.wl_workcat_id, NEW.wl_workcat_id_end, NEW.wl_buildercat_id, NEW.wl_builtdate, NEW.wl_enddate, NEW.wl_ownercat_id, 
				NEW.wl_muni_id, NEW.wl_steetaxis_id, NEW.wl_postcode, NEW.wl_streetaxis2_id, NEW.wl_postnumber, NEW.wl_postnumber2, NEW.wl_descript,NEW.wl_link, NEW.verified, NEW.the_geom, NEW.undelete,NEW.wl_label_x, 
				NEW.wl_label_y, NEW.wl_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.wl_num_value);
				
				INSERT INTO man_waccel (arc_id, sander_length,sander_depth,prot_surface,name) 
				VALUES (NEW.arc_id, NEW.wl_sander_length, NEW.wl_sander_depth,NEW.wl_prot_surface,NEW.wl_name);
				
			ELSIF man_table='man_varc' THEN
						
				-- Workcat_id
				IF (NEW.va_workcat_id IS NULL) THEN
					NEW.va_workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
					IF (NEW.va_workcat_id IS NULL) THEN
						NEW.va_workcat_id :=(SELECT id FROM cat_work limit 1);
					END IF;
				END IF;		
		
				--Builtdate
				IF (NEW.va_builtdate IS NULL) THEN
					NEW.va_builtdate := (SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
				END IF;
				
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", state_type,
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, 
				builtdate,enddate, ownercat_id, muni_id, streetaxis_id, postcode, streetaxis2_id, postnumber, postnumber2, descript, link, verified, the_geom,undelete, label_x,label_y, label_rotation, expl_id, publish, inventory, 
				uncertain, num_value) 
				VALUES (NEW.arc_id, NEW.va_code, null, null, NEW.va_y1, NEW.va_y2, NEW.va_custom_y1, NEW.va_custom_y2, NEW.va_elev1, NEW.va_elev2, 
				NEW.va_custom_elev1, NEW.va_custom_elev2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.state_type, NEW.va_annotation, NEW.va_observ, NEW.va_comment, 
				NEW.va_inverted_slope, NEW.va_custom_length, NEW.dma_id, NEW.va_soilcat_id, NEW.va_function_type, NEW.va_category_type, NEW.va_fluid_type, 
				NEW.va_location_type, NEW.va_workcat_id, NEW.va_workcat_id_end, NEW.va_buildercat_id, NEW.va_builtdate, NEW.va_enddate, NEW.va_ownercat_id, 
				NEW.va_muni_id, NEW.va_steetaxis_id, NEW.va_postcode, NEW.va_streetaxis2_id, NEW.va_postnumber, NEW.va_postnumber2, NEW.va_descript, NEW.va_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.va_label_x,
				NEW.va_label_y, NEW.va_label_rotation, NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.va_num_value);
				
				INSERT INTO man_varc (arc_id) VALUES (NEW.arc_id);
				
			END IF;
							
							
			-- EPA INSERT
        IF (NEW.epa_type = 'CONDUIT') THEN 
            INSERT INTO inp_conduit (arc_id, q0, qmax) VALUES (NEW.arc_id,0,0); 
			
        ELSIF (NEW.epa_type = 'PUMP') THEN 
            INSERT INTO inp_pump (arc_id) VALUES (NEW.arc_id); 
			
		ELSIF (NEW.epa_type = 'ORIFICE') THEN 
            INSERT INTO inp_orifice (arc_id, ori_type) VALUES (NEW.arc_id,'BOTTOM');
			
		ELSIF (NEW.epa_type = 'WEIR') THEN 
            INSERT INTO inp_weir (arc_id, weir_type) VALUES (NEW.arc_id,'SIDEFLOW');
			
		ELSIF (NEW.epa_type = 'OUTLET') THEN 
            INSERT INTO inp_outlet (arc_id, outlet_type) VALUES (NEW.arc_id,'TABULAR/HEAD');
            
		ELSIF (NEW.epa_type = 'VIRTUAL') THEN 
            INSERT INTO inp_virtual (arc_id, add_length) VALUES (NEW.arc_id, false);
				
		END IF;
		
			RETURN NEW;
			   
		ELSIF TG_OP = 'UPDATE' THEN
		
			-- State
			IF (NEW.state != OLD.state) THEN
				UPDATE arc SET state=NEW.state WHERE arc_id = OLD.arc_id;
			END IF;
				
			-- The geom
			IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom)  THEN
				UPDATE arc SET the_geom=NEW.the_geom WHERE arc_id = OLD.arc_id;
			END IF;

			IF (NEW.epa_type != OLD.epa_type) THEN    
			 
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
				ELSIF (OLD.epa_type = 'VIRTUAL') THEN 
				inp_table:= 'inp_virtual';
				END IF;
				v_sql:= 'DELETE FROM '||inp_table||' WHERE arc_id = '||quote_literal(OLD.arc_id);
				EXECUTE v_sql;
				
				inp_table := NULL;


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
				ELSIF (NEW.epa_type = 'VIRTUAL') THEN 
				inp_table:= 'inp_virtual';
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
				SET  y1=NEW.cd_y1, y2=NEW.cd_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
				annotation= NEW.cd_annotation, "observ"=NEW.cd_observ,"comment"=NEW.cd_comment, inverted_slope=NEW.cd_inverted_slope, custom_length=NEW.cd_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.cd_soilcat_id, category_type=NEW.cd_category_type, fluid_type=NEW.cd_fluid_type,location_type=NEW.cd_location_type, workcat_id=NEW.cd_workcat_id, 
				buildercat_id=NEW.cd_buildercat_id, builtdate=NEW.cd_builtdate,ownercat_id=NEW.cd_ownercat_id, 
				muni_id=NEW.cd_muni_id, streetaxis_id=NEW.cd_streetaxis_id,  postcode=NEW.cd_postcode, streetaxis2_id=NEW.cd_streetaxis2_id, 
				postnumber=NEW.cd_postnumber, postnumber2=NEW.cd_postnumber2,  descript=NEW.cd_descript, link=NEW.cd_link, custom_y1=NEW.cd_custom_y1, custom_y2=NEW.cd_custom_y2, verified=NEW.verified, 
				undelete=NEW.undelete,label_x=NEW.cd_label_x,label_y=NEW.cd_label_y, label_rotation=NEW.cd_label_rotation,workcat_id_end=NEW.cd_workcat_id_end,
				code=NEW.cd_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.cd_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;		
			
			
				UPDATE man_conduit SET arc_id=NEW.arc_id
				WHERE arc_id=OLD.arc_id;
			
			ELSIF man_table='man_siphon' THEN			
				UPDATE arc 
				SET  y1=NEW.sh_y1, y2=NEW.sh_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
				annotation= NEW.sh_annotation, "observ"=NEW.sh_observ,"comment"=NEW.sh_comment, inverted_slope=NEW.sh_inverted_slope, custom_length=NEW.sh_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.sh_soilcat_id, category_type=NEW.sh_category_type, fluid_type=NEW.sh_fluid_type,location_type=NEW.sh_location_type, workcat_id=NEW.sh_workcat_id, 
				buildercat_id=NEW.sh_buildercat_id, builtdate=NEW.sh_builtdate,ownercat_id=NEW.sh_ownercat_id, 
				muni_id=NEW.sh_muni_id, streetaxis_id=NEW.sh_streetaxis_id, postcode=NEW.sh_postcode, streetaxis2_id=NEW.sh_streetaxis2_id, postnumber=NEW.sh_postnumber, postnumber2=NEW.sh_postnumber2, 
				descript=NEW.sh_descript, link=NEW.sh_link, custom_y1=NEW.sh_custom_y1, custom_y2=NEW.sh_custom_y2, verified=NEW.verified,  undelete=NEW.undelete,
				label_x=NEW.sh_label_x,label_y=NEW.sh_label_y, label_rotation=NEW.sh_label_rotation,workcat_id_end=NEW.sh_workcat_id_end,
				code=NEW.sh_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.sh_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;		
				
				UPDATE man_siphon SET  name=NEW.sh_name
				WHERE arc_id=OLD.arc_id;
			
			ELSIF man_table='man_waccel' THEN
				UPDATE arc 
				SET  y1=NEW.wl_y1, y2=NEW.wl_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
				annotation= NEW.wl_annotation, "observ"=NEW.wl_observ,"comment"=NEW.wl_comment, inverted_slope=NEW.wl_inverted_slope, custom_length=NEW.wl_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.wl_soilcat_id, category_type=NEW.wl_category_type, fluid_type=NEW.wl_fluid_type,location_type=NEW.wl_location_type, workcat_id=NEW.wl_workcat_id, 
				buildercat_id=NEW.wl_buildercat_id, builtdate=NEW.wl_builtdate,ownercat_id=NEW.wl_ownercat_id, 
				muni_id=NEW.wl_muni_id, streetaxis_id=NEW.wl_streetaxis_id, postcode=NEW.wl_postcode, streetaxis2_id=NEW.wl_streetaxis2_id, postnumber=NEW.wl_postnumber, postnumber2=NEW.wl_postnumber2,
				descript=NEW.wl_descript, link=NEW.wl_link, custom_y1=NEW.wl_custom_y1, custom_y2=NEW.wl_custom_y2, verified=NEW.verified,  
				undelete=NEW.undelete,label_x=NEW.wl_label_x,label_y=NEW.wl_label_y, label_rotation=NEW.wl_label_rotation,workcat_id_end=NEW.wl_workcat_id_end,
				code=NEW.wl_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.wl_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;	
				
				UPDATE man_waccel SET  sander_length=NEW.wl_sander_length, sander_depth=NEW.wl_sander_depth, prot_surface=NEW.wl_prot_surface,name=NEW.wl_name
				WHERE arc_id=OLD.arc_id;
			
			ELSIF man_table='man_varc' THEN
				UPDATE arc 
				SET  y1=NEW.va_y1, y2=NEW.va_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type,
				annotation= NEW.va_annotation, "observ"=NEW.va_observ,"comment"=NEW.va_comment, inverted_slope=NEW.va_inverted_slope, custom_length=NEW.va_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.va_soilcat_id, category_type=NEW.va_category_type, fluid_type=NEW.va_fluid_type,location_type=NEW.va_location_type, workcat_id=NEW.va_workcat_id, 
				buildercat_id=NEW.va_buildercat_id, builtdate=NEW.va_builtdate,ownercat_id=NEW.va_ownercat_id, 
				muni_id=NEW.va_muni_id, streetaxis_id=NEW.va_streetaxis_id, postcode=NEW.va_postcode, streetaxis2_id=NEW.va_streetaxis2_id, postnumber=NEW.va_postnumber, postnumber2=NEW.va_postnumber2,
				descript=NEW.va_descript, link=NEW.va_link, custom_y1=NEW.va_custom_y1, custom_y2=NEW.va_custom_y2, verified=NEW.verified,  undelete=NEW.undelete,
				label_x=NEW.va_label_x,label_y=NEW.va_label_y, label_rotation=NEW.va_label_rotation,workcat_id_end=NEW.va_workcat_id_end,
				code=NEW.va_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.va_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;		
				
				UPDATE man_varc SET arc_id=NEW.arc_id
				WHERE arc_id=OLD.arc_id;
			
			END IF;
			
			RETURN NEW;

		 ELSIF TG_OP = 'DELETE' THEN
		 
		 	PERFORM gw_fct_check_delete(OLD.arc_id, 'ARC');
		 
			DELETE FROM arc WHERE arc_id = OLD.arc_id;

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
		  