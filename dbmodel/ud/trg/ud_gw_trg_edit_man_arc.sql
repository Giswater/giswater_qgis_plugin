	/*
	This file is part of Giswater 3
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
		expl_id_int integer;
		
	BEGIN

		EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
		man_table:= TG_ARGV[0];
		man_table_2:=man_table;

		IF TG_OP = 'INSERT' THEN   
			-- Arc ID
			IF (NEW.arc_id IS NULL) THEN
				PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				NEW.arc_id:= (SELECT nextval('urn_id_seq'));
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
					NEW.arccat_id:= (SELECT "value" FROM config_vdefault WHERE "parameter"='arccat_vdefault' AND "user"="current_user"());
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
		
			-- FEATURE INSERT
			
			
			IF man_table='man_conduit' THEN
						
				-- Workcat_id
				IF (NEW.conduit_workcat_id IS NULL) THEN
					NEW.conduit_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
					IF (NEW.conduit_workcat_id IS NULL) THEN
						NEW.conduit_workcat_id := (SELECT id FROM cat_work limit 1);
					END IF;
				END IF;

				--Builtdate
				IF (NEW.conduit_builtdate IS NULL) THEN
					NEW.conduit_builtdate:=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
				END IF;
		
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", 
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, 
				builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, link, verified, the_geom,undelete,label_x,label_y, label_rotation, expl_id, publish, inventory,
				uncertain, num_value) 
				VALUES (NEW.arc_id, NEW.conduit_code, null, null, NEW.conduit_y1, NEW.conduit_y2, NEW.conduit_custom_y1, NEW.conduit_custom_y2, NEW.conduit_elev1, NEW.conduit_elev2, 
				NEW.conduit_custom_elev1, NEW.conduit_custom_elev2,NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.conduit_annotation, NEW.conduit_observ, NEW.conduit_comment, 
				NEW.conduit_inverted_slope, NEW.conduit_custom_length, NEW.dma_id, NEW.conduit_soilcat_id, NEW.conduit_function_type, NEW.conduit_category_type, NEW.conduit_fluid_type, 
				NEW.conduit_location_type, NEW.conduit_workcat_id,NEW.conduit_workcat_id_end,NEW.conduit_buildercat_id, NEW.conduit_builtdate, NEW.conduit_enddate, NEW.conduit_ownercat_id, 
				NEW.conduit_address_01, NEW.conduit_address_02, NEW.conduit_address_03, NEW.conduit_descript, NEW.conduit_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.conduit_label_x, 
				NEW.conduit_label_y, NEW.conduit_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.conduit_num_value);
				
				INSERT INTO man_conduit (arc_id) VALUES (NEW.arc_id);
			
			ELSIF man_table='man_siphon' THEN

				-- Workcat_id
				IF (NEW.siphon_workcat_id IS NULL) THEN
					NEW.siphon_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
					IF (NEW.siphon_workcat_id IS NULL) THEN
						NEW.siphon_workcat_id :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
					END IF;
				END IF;

				--Builtdate
				IF (NEW.siphon_builtdate IS NULL) THEN
					NEW.siphon_builtdate := (SELECT builtdate_vdefault FROM config);
				END IF;
				
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", 
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id,workcat_id_end, buildercat_id, 
				builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, link, verified, the_geom,undelete, label_x,label_y, label_rotation, expl_id, publish, inventory, 
				uncertain,num_value) 
				VALUES (NEW.arc_id, NEW.siphon_code, null, null, NEW.siphon_y1, NEW.siphon_y2, NEW.siphon_custom_y1, NEW.siphon_custom_y2, NEW.siphon_elev1, NEW.siphon_elev2, 
				NEW.siphon_custom_elev1, NEW.siphon_custom_elev2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.siphon_annotation, NEW.siphon_observ, NEW.siphon_comment,
				NEW.siphon_inverted_slope, NEW.siphon_custom_length, NEW.dma_id, NEW.siphon_soilcat_id, NEW.siphon_function_type, NEW.siphon_category_type, NEW.siphon_fluid_type, 
				NEW.siphon_location_type, NEW.siphon_workcat_id,NEW.siphon_workcat_id_end, NEW.siphon_buildercat_id, NEW.siphon_builtdate, NEW.siphon_enddate, NEW.siphon_ownercat_id, 
				NEW.siphon_address_01, NEW.siphon_address_02, NEW.siphon_address_03, NEW.siphon_descript, NEW.siphon_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.siphon_label_x, 
				NEW.siphon_label_y, NEW.siphon_label_rotation,expl_id_int, NEW.publish, NEW.inventory,  NEW.uncertain, NEW.siphon_num_value);
				
				INSERT INTO man_siphon (arc_id,name) VALUES (NEW.arc_id,NEW.siphon_name);
				
			ELSIF man_table='man_waccel' THEN
						
				-- Workcat_id
				IF (NEW.waccel_workcat_id IS NULL) THEN
					NEW.waccel_workcat_id:= (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
					IF (NEW.waccel_workcat_id IS NULL) THEN
						NEW.waccel_workcat_id :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
					END IF;
				END IF;

				--Builtdate
				IF (NEW.waccel_builtdate IS NULL) THEN
					NEW.waccel_builtdate := (SELECT builtdate_vdefault FROM config);
				END IF;
				
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", 
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, 
				builtdate, enddate, ownercat_id, address_01, address_02, address_03, descript, link, verified, the_geom,undelete, label_x,label_y, label_rotation, expl_id, publish, inventory, 
				uncertain,num_value)
				VALUES (NEW.arc_id, NEW.waccel_code, null, null, NEW.waccel_y1, NEW.waccel_y2, NEW.waccel_custom_y1, NEW.waccel_custom_y2, NEW.waccel_elev1, NEW.waccel_elev2, 
				NEW.waccel_custom_elev1, custom_elev2,NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.waccel_annotation, NEW.waccel_observ, NEW.waccel_comment,
				NEW.waccel_inverted_slope, NEW.waccel_custom_length, NEW.dma_id, NEW.waccel_soilcat_id, NEW.waccel_function_type,NEW.waccel_category_type, NEW.waccel_fluid_type, 
				NEW.waccel_location_type, NEW.waccel_workcat_id, NEW.waccel_workcat_id_end, NEW.waccel_buildercat_id, NEW.waccel_builtdate, NEW.waccel_enddate, NEW.waccel_ownercat_id, 
				NEW.waccel_address_01, NEW.waccel_address_02, NEW.waccel_address_03, NEW.waccel_descript,NEW.waccel_link, NEW.verified, NEW.the_geom, NEW.undelete,NEW.waccel_label_x, 
				NEW.waccel_label_y, NEW.waccel_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.waccel_num_value);
				
				INSERT INTO man_waccel (arc_id, sander_length,sander_depth,prot_surface,name) 
				VALUES (NEW.arc_id, NEW.waccel_sander_length, NEW.waccel_sander_depth,NEW.waccel_prot_surface,NEW.waccel_name);
				
			ELSIF man_table='man_varc' THEN
						
				-- Workcat_id
				IF (NEW.varc_workcat_id IS NULL) THEN
					NEW.varc_workcat_id := (SELECT "value" FROM config_vdefault WHERE "parameter"='workcat_vdefault' AND "user"="current_user"());
					IF (NEW.varc_workcat_id IS NULL) THEN
						NEW.varc_workcat_id :=(SELECT "value" FROM config_vdefault WHERE "parameter"='builtdate_vdefault' AND "user"="current_user"());
					END IF;
				END IF;		
		
				--Builtdate
				IF (NEW.varc_builtdate IS NULL) THEN
					NEW.varc_builtdate := (SELECT builtdate_vdefault FROM config);
				END IF;
				
				INSERT INTO arc (arc_id, code, node_1, node_2, y1, y2, custom_y1, custom_y2, elev1, elev2, custom_elev1, custom_elev2, arc_type, arccat_id, epa_type, sector_id, "state", 
				annotation, observ, "comment", inverted_slope, custom_length, dma_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, 
				builtdate,enddate, ownercat_id, address_01, address_02, address_03, descript, link, verified, the_geom,undelete, label_x,label_y, label_rotation, expl_id, publish, inventory, 
				uncertain, num_value) 
				VALUES (NEW.arc_id, NEW.varc_code, null, null, NEW.varc_y1, NEW.varc_y2, NEW.varc_custom_y1, NEW.varc_custom_y2, NEW.varc_elev1, NEW.varc_elev2, 
				NEW.varc_custom_elev1, NEW.varc_custom_elev2, NEW.arc_type, NEW.arccat_id, NEW.epa_type, NEW.sector_id, NEW.state, NEW.varc_annotation, NEW.varc_observ, NEW.varc_comment, 
				NEW.varc_inverted_slope, NEW.varc_custom_length, NEW.dma_id, NEW.varc_soilcat_id, NEW.varc_function_type, NEW.varc_category_type, NEW.varc_fluid_type, 
				NEW.varc_location_type, NEW.varc_workcat_id, NEW.varc_workcat_id_end, NEW.varc_buildercat_id, NEW.varc_builtdate, NEW.varc_enddate, NEW.varc_ownercat_id, 
				NEW.varc_address_01, NEW.varc_address_02, NEW.varc_address_03, NEW.varc_descript, NEW.varc_link, NEW.verified, NEW.the_geom,NEW.undelete,NEW.varc_label_x,
				NEW.varc_label_y, NEW.varc_label_rotation, expl_id_int, NEW.publish, NEW.inventory, NEW.uncertain, NEW.varc_num_value);
				
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
			
		END IF;
			RETURN NEW;
			   
		ELSIF TG_OP = 'UPDATE' THEN

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
				SET arc_id=NEW.arc_id, y1=NEW.conduit_y1, y2=NEW.conduit_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, 
				annotation= NEW.conduit_annotation, "observ"=NEW.conduit_observ,"comment"=NEW.conduit_comment, inverted_slope=NEW.conduit_inverted_slope, custom_length=NEW.conduit_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.conduit_soilcat_id, category_type=NEW.conduit_category_type, fluid_type=NEW.conduit_fluid_type,location_type=NEW.conduit_location_type, workcat_id=NEW.conduit_workcat_id, 
				buildercat_id=NEW.conduit_buildercat_id, builtdate=NEW.conduit_builtdate,ownercat_id=NEW.conduit_ownercat_id, address_01=NEW.conduit_address_01, address_02=NEW.conduit_address_02, 
				address_03=NEW.conduit_address_03, descript=NEW.conduit_descript, link=NEW.conduit_link, custom_y1=NEW.conduit_custom_y1, custom_y2=NEW.conduit_custom_y2, verified=NEW.verified, 
				the_geom=NEW.the_geom, undelete=NEW.undelete,label_x=NEW.conduit_label_x,label_y=NEW.conduit_label_y, label_rotation=NEW.conduit_label_rotation,workcat_id_end=NEW.conduit_workcat_id_end,
				code=NEW.conduit_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.conduit_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;		
			
			
				UPDATE man_conduit SET arc_id=NEW.arc_id
				WHERE arc_id=OLD.arc_id;
			
			ELSIF man_table='man_siphon' THEN			
				UPDATE arc 
				SET arc_id=NEW.arc_id, y1=NEW.siphon_y1, y2=NEW.siphon_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, 
				annotation= NEW.siphon_annotation, "observ"=NEW.siphon_observ,"comment"=NEW.siphon_comment, inverted_slope=NEW.siphon_inverted_slope, custom_length=NEW.siphon_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.siphon_soilcat_id, category_type=NEW.siphon_category_type, fluid_type=NEW.siphon_fluid_type,location_type=NEW.siphon_location_type, workcat_id=NEW.siphon_workcat_id, 
				buildercat_id=NEW.siphon_buildercat_id, builtdate=NEW.siphon_builtdate,ownercat_id=NEW.siphon_ownercat_id, address_01=NEW.siphon_address_01, address_02=NEW.siphon_address_02, address_03=NEW.siphon_address_03, 
				descript=NEW.siphon_descript, link=NEW.siphon_link, custom_y1=NEW.siphon_custom_y1, custom_y2=NEW.siphon_custom_y2, verified=NEW.verified, the_geom=NEW.the_geom, undelete=NEW.undelete,
				label_x=NEW.siphon_label_x,label_y=NEW.siphon_label_y, label_rotation=NEW.siphon_label_rotation,workcat_id_end=NEW.siphon_workcat_id_end,
				code=NEW.siphon_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.siphon_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;		
				
				UPDATE man_siphon SET arc_id=NEW.arc_id,security_bar=NEW.siphon_security_bar, steps=NEW.siphon_steps,siphon_name=NEW.siphon_name
				WHERE arc_id=OLD.arc_id;
			
			ELSIF man_table='man_waccel' THEN
				UPDATE arc 
				SET arc_id=NEW.arc_id, y1=NEW.waccel_y1, y2=NEW.waccel_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, 
				annotation= NEW.waccel_annotation, "observ"=NEW.waccel_observ,"comment"=NEW.waccel_comment, inverted_slope=NEW.waccel_inverted_slope, custom_length=NEW.waccel_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.waccel_soilcat_id, category_type=NEW.waccel_category_type, fluid_type=NEW.waccel_fluid_type,location_type=NEW.waccel_location_type, workcat_id=NEW.waccel_workcat_id, 
				buildercat_id=NEW.waccel_buildercat_id, builtdate=NEW.waccel_builtdate,ownercat_id=NEW.waccel_ownercat_id, address_01=NEW.waccel_address_01, address_02=NEW.waccel_address_02, address_03=NEW.waccel_address_03, 
				descript=NEW.waccel_descript, link=NEW.waccel_link, custom_y1=NEW.waccel_custom_y1, custom_y2=NEW.waccel_custom_y2, verified=NEW.verified, the_geom=NEW.the_geom, 
				undelete=NEW.undelete,label_x=NEW.waccel_label_x,label_y=NEW.waccel_label_y, label_rotation=NEW.waccel_label_rotation,workcat_id_end=NEW.waccel_workcat_id_end,
				code=NEW.waccel_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.waccel_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;	
				
				UPDATE man_waccel SET arc_id=NEW.arc_id, sander_length=NEW.waccel_sander_length, sander_depth=NEW.waccel_sander_depth,security_bar=NEW.waccel_security_bar,
				steps=NEW.waccel_steps,prot_surface=NEW.waccel_prot_surface,waccel_name=NEW.waccel_name
				WHERE arc_id=OLD.arc_id;
			
			ELSIF man_table='man_varc' THEN
				UPDATE arc 
				SET arc_id=NEW.arc_id, y1=NEW.varc_y1, y2=NEW.varc_y2, arc_type=NEW.arc_type, arccat_id=NEW.arccat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, "state"=NEW.state, 
				annotation= NEW.varc_annotation, "observ"=NEW.varc_observ,"comment"=NEW.varc_comment, inverted_slope=NEW.varc_inverted_slope, custom_length=NEW.varc_custom_length, dma_id=NEW.dma_id, 
				soilcat_id=NEW.varc_soilcat_id, category_type=NEW.varc_category_type, fluid_type=NEW.varc_fluid_type,location_type=NEW.varc_location_type, workcat_id=NEW.varc_workcat_id, 
				buildercat_id=NEW.varc_buildercat_id, builtdate=NEW.varc_builtdate,ownercat_id=NEW.varc_ownercat_id, address_01=NEW.varc_address_01, address_02=NEW.varc_address_02, address_03=NEW.varc_address_03, 
				descript=NEW.varc_descript, link=NEW.varc_link, custom_y1=NEW.varc_custom_y1, custom_y2=NEW.varc_custom_y2, verified=NEW.verified, the_geom=NEW.the_geom, undelete=NEW.undelete,
				label_x=NEW.varc_label_x,label_y=NEW.varc_label_y, label_rotation=NEW.varc_label_rotation,workcat_id_end=NEW.varc_workcat_id_end,
				code=NEW.varc_code, publish=NEW.publish, inventory=NEW.inventory, enddate=NEW.varc_enddate, uncertain=NEW.uncertain, expl_id=NEW.expl_id
				WHERE arc_id=OLD.arc_id;		
				
				UPDATE man_varc SET arc_id=NEW.arc_id
				WHERE arc_id=OLD.arc_id;
			
			END IF;
			
		--	PERFORM audit_function (2,840);
			RETURN NEW;

		 ELSIF TG_OP = 'DELETE' THEN
			DELETE FROM arc WHERE arc_id = OLD.arc_id;

			--PERFORM audit_function (3,840);
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
		  