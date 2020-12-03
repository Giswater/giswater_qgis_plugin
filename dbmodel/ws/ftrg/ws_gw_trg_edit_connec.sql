/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1304


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_connec()
  RETURNS trigger AS
$BODY$

DECLARE 
v_sql varchar;
v_man_table varchar; 
v_code_autofill_bool boolean;
v_type_man_table varchar;
v_promixity_buffer double precision;
v_link_path varchar;
v_record_link record;
v_record_vnode record;
v_count integer;
v_insert_double_geom boolean;
v_double_geom_buffer double precision;
v_new_connec_type text;
v_old_connec_type text;
v_customfeature text;
v_addfields record;
v_new_value_param text;
v_old_value_param text;
v_featurecat text;
v_psector_vdefault integer;
v_arc_id text;
v_auto_pol_id text;
v_streetaxis text;
v_streetaxis2 text;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    v_man_table:= TG_ARGV[0];
	
	IF v_man_table IN (SELECT id FROM cat_feature WHERE feature_type = 'CONNEC') THEN
		v_customfeature:=v_man_table;
		v_man_table:=(SELECT man_table FROM cat_feature_connec WHERE id=v_man_table);
	END IF;
	
	v_type_man_table:=v_man_table;
	
	--Get data from config table
	v_promixity_buffer = (SELECT "value" FROM config_param_system WHERE "parameter"='edit_feature_buffer_on_mapzone');
	SELECT ((value::json)->>'activated') INTO v_insert_double_geom FROM config_param_system WHERE parameter='insert_double_geometry';
	SELECT ((value::json)->>'value') INTO v_double_geom_buffer FROM config_param_system WHERE parameter='insert_double_geometry';
	
	IF v_promixity_buffer IS NULL THEN v_promixity_buffer=0.5; END IF;
	IF v_insert_double_geom IS NULL THEN v_insert_double_geom=FALSE; END IF;
	IF v_double_geom_buffer IS NULL THEN v_double_geom_buffer=1; END IF;
	
	-- transforming streetaxis name into id
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
		v_streetaxis = (SELECT id FROM ext_streetaxis WHERE muni_id = NEW.muni_id AND name = NEW.streetname LIMIT 1);
		v_streetaxis2 = (SELECT id FROM ext_streetaxis WHERE muni_id = NEW.muni_id AND name = NEW.streetname2 LIMIT 1);
		
		IF NEW.arc_id IS NOT NULL AND NEW.expl_id IS NOT NULL THEN
			IF (SELECT expl_id FROM arc WHERE arc_id = NEW.arc_id) != NEW.expl_id THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3144", "function":"1304","debug_msg":"'||NEW.arc_id::text||'"}}$$);';
			END IF;
		END IF;
	END IF;
	
	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN

		-- connec ID
		IF (NEW.connec_id IS NULL) THEN
				PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
		    NEW.connec_id:= (SELECT nextval('urn_id_seq'));
		END IF;

		-- connec Catalog ID
		IF (NEW.connecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_connec) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			  "data":{"message":"1022", "function":"1304","debug_msg":null, "variables":null}}$$);';
			END IF;

			IF v_customfeature IS NOT NULL THEN
				NEW.connecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"=lower(concat(v_customfeature,'_vdefault')) AND "cur_user"="current_user"() LIMIT 1);
			ELSE
				NEW.connecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_connecat_vdefault' AND "cur_user"="current_user"() LIMIT 1);

				-- get first value (last chance)
				IF (NEW.connecat_id IS NULL) THEN
					NEW.connecat_id := (SELECT id FROM cat_connec LIMIT 1);
				END IF;
			END IF;

			IF (NEW.connecat_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				 "data":{"message":"1086", "function":"1304","debug_msg":null, "variables":null}}$$);';
			END IF;				
		END IF;
			
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1110", "function":"1304","debug_msg":null}}$$);';
			END IF;
			
			-- getting value default
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			
			-- getting value from geometry of mapzone
			IF (NEW.expl_id IS NULL) THEN
				SELECT count(*)into v_count FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) AND active IS TRUE;
				IF v_count = 1 THEN
					NEW.expl_id = (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) AND active IS TRUE LIMIT 1);
				ELSE
					NEW.expl_id =(SELECT expl_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, v_promixity_buffer) 
					order by ST_Distance (NEW.the_geom, v_edit_arc.the_geom) LIMIT 1);
				END IF;	
			END IF;
			
			-- control error when no value
			IF (NEW.expl_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2012", "function":"1304","debug_msg":"'||NEW.connec_id::text||'"}}$$);';
			END IF;            
		END IF;
		
		-- Sector ID
		IF (NEW.sector_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM sector) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1008", "function":"1304","debug_msg":null}}$$);';
			END IF;
			
			-- getting value default
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_sector_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			
			-- getting value from geometry of mapzone
			IF (NEW.sector_id IS NULL) THEN
				SELECT count(*)into v_count FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001);
				IF v_count = 1 THEN
					NEW.sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
				ELSE
					NEW.sector_id =(SELECT sector_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, v_promixity_buffer) 
					order by ST_Distance (NEW.the_geom, v_edit_arc.the_geom) LIMIT 1);
				END IF;	
			END IF;
			
			-- control when no value
			IF NEW.sector_id IS NULL THEN
				NEW.sector_id = 0;
			END IF;
		END IF;

		-- Dma ID
		IF (NEW.dma_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"1012", "function":"1304","debug_msg":null}}$$);';
			END IF;
			
			-- getting value default
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_dma_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			
			-- getting value from geometry of mapzone
			IF (NEW.dma_id IS NULL) THEN
				SELECT count(*)into v_count FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001);
				IF v_count = 1 THEN
					NEW.dma_id = (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
				ELSE
					NEW.dma_id =(SELECT dma_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, v_promixity_buffer) 
					order by ST_Distance (NEW.the_geom, v_edit_arc.the_geom) LIMIT 1);
				END IF;	
			END IF;
			
			-- control when no value
			IF NEW.dma_id IS NULL THEN
				NEW.dma_id = 0;
			END IF;           
		END IF;
			
			
		-- Presszone
		IF (NEW.presszone_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM presszone) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3106", "function":"1304","debug_msg":null}}$$);';
			END IF;
			
			-- getting value default
			IF (NEW.presszone_id IS NULL) THEN
				NEW.presszone_id := (SELECT "value" FROM config_param_user WHERE "parameter"='presszone_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			
			-- getting value from geometry of mapzone
			IF (NEW.presszone_id IS NULL) THEN
				SELECT count(*)into v_count FROM presszone WHERE ST_DWithin(NEW.the_geom, presszone.the_geom,0.001);
				IF v_count = 1 THEN
					NEW.presszone_id = (SELECT presszone_id FROM presszone WHERE ST_DWithin(NEW.the_geom, presszone.the_geom,0.001) LIMIT 1);
				ELSE
					NEW.presszone_id =(SELECT presszone_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, v_promixity_buffer)
					order by ST_Distance (NEW.the_geom, v_edit_arc.the_geom) LIMIT 1);
				END IF;	
			END IF;
			
			-- control when no value
			IF NEW.presszone_id IS NULL THEN
				NEW.presszone_id = 0;
			END IF;           
		END IF;
		
		
		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM ext_municipality) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3110", "function":"1304","debug_msg":null}}$$);';
			END IF;
			
			-- getting value default
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_municipality_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
			
			-- getting value from geometry of mapzone
			IF (NEW.muni_id IS NULL) THEN
				SELECT count(*)into v_count FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001);
				IF v_count = 1 THEN
					NEW.muni_id = (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
				ELSE
					NEW.muni_id =(SELECT muni_id FROM v_edit_arc WHERE ST_DWithin(NEW.the_geom, v_edit_arc.the_geom, v_promixity_buffer) 
					order by ST_Distance (NEW.the_geom, v_edit_arc.the_geom) LIMIT 1);
				END IF;	
			END IF;
			
			-- control error when no value
			IF (NEW.muni_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"2024", "function":"1304","debug_msg":"'||NEW.connec_id::text||'"}}$$);';
			END IF;            
		END IF;
			
			
		-- State
		IF (NEW.state IS NULL) THEN
			NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_state_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
			
		-- State_type
		IF (NEW.state=0) THEN
			IF (NEW.state_type IS NULL) THEN
				NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_statetype_0_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
		ELSIF (NEW.state=1) THEN
			IF (NEW.state_type IS NULL) THEN
				NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_statetype_1_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
		ELSIF (NEW.state=2) THEN
			IF (NEW.state_type IS NULL) THEN
				NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_statetype_2_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;
		END IF;
			
		--check relation state - state_type
		IF NEW.state_type NOT IN (SELECT id FROM value_state_type WHERE state = NEW.state) THEN
			IF NEW.state IS NOT NULL THEN
				v_sql = NEW.state;
			ELSE
				v_sql = 'null';
			END IF;
			
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3036", "function":"1318","debug_msg":"'||v_sql::text||'"}}$$);';
		END IF;

		--Inventory	
		NEW.inventory := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_inventory_sysvdefault');

		--Publish
		NEW.publish := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_publish_sysvdefault');	
		
		
		-- Workcat_id
		IF (NEW.workcat_id IS NULL) THEN
			NEW.workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_workcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
		
		-- Ownercat_id
		IF (NEW.ownercat_id IS NULL) THEN
			NEW.ownercat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_ownercat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
			
		-- Soilcat_id
		IF (NEW.soilcat_id IS NULL) THEN
			NEW.soilcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_soilcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
				
		--Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='edit_builtdate_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
		
		-- Verified
		IF (NEW.verified IS NULL) THEN
			NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_verified_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;

		SELECT code_autofill INTO v_code_autofill_bool FROM cat_feature join cat_connec on cat_feature.id=cat_connec.connectype_id where cat_connec.id=NEW.connecat_id;
		
		--Copy id to code field
		IF (NEW.code IS NULL AND v_code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.connec_id;
		END IF;	 
		
		-- LINK
		IF (SELECT "value" FROM config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid')::boolean=TRUE THEN
			NEW.link=NEW.connec_id;
		END IF;

		-- Customer code  
		IF NEW.customer_code IS NULL AND (SELECT (value::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connec_autofill_ccode') IS TRUE
		AND (SELECT (value::json->>'field')::text FROM config_param_system WHERE parameter = 'edit_connec_autofill_ccode')='code'  THEN
		
			NEW.customer_code = NEW.code;
			
		ELSIF NEW.customer_code IS NULL AND (SELECT (value::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connec_autofill_ccode') IS TRUE
		AND (SELECT (value::json->>'field')::text FROM config_param_system WHERE parameter = 'edit_connec_autofill_ccode')='connec_id'  THEN

			NEW.customer_code = NEW.connec_id;

		END IF;

		v_featurecat = (SELECT connectype_id FROM cat_connec WHERE id = NEW.connecat_id);

		--Location type
		IF NEW.location_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_location_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.location_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_location_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.location_type IS NULL THEN
			NEW.location_type = (SELECT value FROM config_param_user WHERE parameter = 'connec_location_vdefault' AND cur_user = current_user);
		END IF;

		--Fluid type
		IF NEW.arc_id IS NOT NULL THEN
				NEW.fluid_type = (SELECT fluid_type FROM arc WHERE arc_id = NEW.arc_id);
		END IF;

		IF NEW.fluid_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_fluid_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.fluid_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_fluid_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.fluid_type IS NULL THEN
			NEW.fluid_type = (SELECT value FROM config_param_user WHERE parameter = 'connec_fluid_vdefault' AND cur_user = current_user);
		END IF;		

		--Category type
		IF NEW.category_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_category_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.category_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_category_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.category_type IS NULL THEN
			NEW.category_type = (SELECT value FROM config_param_user WHERE parameter = 'connec_category_vdefault' AND cur_user = current_user);
		END IF;	

		--Function type
		IF NEW.function_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_function_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.function_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_function_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.function_type IS NULL THEN
			NEW.function_type = (SELECT value FROM config_param_user WHERE parameter = 'connec_function_vdefault' AND cur_user = current_user);
		END IF;

		--elevation from raster
		IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.elevation IS NULL) AND
		(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_insert_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
			NEW.elevation = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM v_ext_raster_dem WHERE id =
				(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
		END IF; 	

		-- FEATURE INSERT
		INSERT INTO connec (connec_id, code, elevation, depth,connecat_id,  sector_id, customer_code,  state, state_type, annotation, observ, comment,dma_id, presszone_id, soilcat_id,
		function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, streetaxis2_id, postnumber, postnumber2, 
		muni_id, streetaxis_id,  postcode, district_id, postcomplement, postcomplement2, descript, link, verified, rotation,  the_geom, undelete, label_x,label_y,label_rotation, expl_id,
		publish, inventory,num_value, connec_length, arc_id, minsector_id, dqa_id, staticpressure, adate, adescript, accessibility) 
		
		VALUES (NEW.connec_id, NEW.code, NEW.elevation, NEW.depth, NEW.connecat_id, NEW.sector_id, NEW.customer_code,  NEW.state, NEW.state_type, NEW.annotation,   NEW.observ, NEW.comment, 
		NEW.dma_id, NEW.presszone_id, NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type,  NEW.location_type, NEW.workcat_id, NEW.workcat_id_end,  NEW.buildercat_id,
		NEW.builtdate, NEW.enddate, NEW.ownercat_id, v_streetaxis, NEW.postnumber, NEW.postnumber2, NEW.muni_id, v_streetaxis, NEW.postcode, NEW.district_id, NEW.postcomplement, 
		NEW.postcomplement2, NEW.descript, NEW.link, NEW.verified, NEW.rotation, NEW.the_geom,NEW.undelete,NEW.label_x, NEW.label_y,NEW.label_rotation,  NEW.expl_id, NEW.publish, NEW.inventory, 
		NEW.num_value, NEW.connec_length, NEW.arc_id, NEW.minsector_id, NEW.dqa_id, NEW.staticpressure,
		NEW.adate, NEW.adescript, NEW.accessibility);
		 
		IF v_man_table='man_greentap' THEN
			INSERT INTO man_greentap (connec_id, linked_connec, brand, model) 
			VALUES(NEW.connec_id, NEW.linked_connec, NEW.brand, NEW.model); 
		
		ELSIF v_man_table='man_fountain' THEN 
			IF (v_insert_double_geom IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
		
				INSERT INTO polygon(pol_id, sys_type, the_geom) VALUES (NEW.pol_id, 'FOUNTAIN',
				 (SELECT ST_Multi(ST_Envelope(ST_Buffer(connec.the_geom,v_double_geom_buffer))) from connec where connec_id=NEW.connec_id));
					
				INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name,  chlorinator, arq_patrimony, pol_id) 
				VALUES (NEW.connec_id, NEW.linked_connec, NEW.vmax, NEW.vtotal,NEW.container_number, NEW.pump_number, NEW.power, NEW.regulation_tank, NEW.name, 
				NEW.chlorinator, NEW.arq_patrimony, NEW.pol_id);
			
			ELSE
				INSERT INTO man_fountain(connec_id, linked_connec, vmax, vtotal, container_number, pump_number, power, regulation_tank,name, chlorinator, arq_patrimony, pol_id) 
				VALUES (NEW.connec_id, NEW.linked_connec, NEW.vmax, NEW.vtotal,NEW.container_number, NEW.pump_number, NEW.power, NEW.regulation_tank, NEW.name, 
				NEW.chlorinator, NEW.arq_patrimony, NEW.pol_id);
			
			END IF;
		 
		ELSIF v_man_table='man_tap' THEN		
			INSERT INTO man_tap(connec_id, linked_connec, cat_valve, drain_diam, drain_exit, drain_gully, drain_distance, arq_patrimony, com_state) 
			VALUES (NEW.connec_id,  NEW.linked_connec, NEW.cat_valve,  NEW.drain_diam, NEW.drain_exit,  NEW.drain_gully, NEW.drain_distance, NEW.arq_patrimony, NEW.com_state);
		  
		ELSIF v_man_table='man_wjoin' THEN  
		 	INSERT INTO man_wjoin (connec_id, top_floor, cat_valve, brand, model) 
			VALUES (NEW.connec_id, NEW.top_floor, NEW.cat_valve, NEW.brand, NEW.model);
			
		END IF;	

		IF v_man_table='parent' THEN
		    v_man_table:= (SELECT man_table FROM cat_feature_connec JOIN cat_connec ON cat_connec.id=NEW.connecat_id
		    	WHERE cat_feature_connec.id = cat_connec.connectype_id LIMIT 1)::text;
	         
	        IF v_man_table IS NOT NULL THEN
	            v_sql:= 'INSERT INTO '||v_man_table||' (connec_id) VALUES ('||quote_literal(NEW.connec_id)||')';
	            EXECUTE v_sql;
	        END IF;

	        --insert double geometry
			IF (v_man_table IN ('man_fountain') and (v_insert_double_geom IS TRUE)) THEN
				
				v_auto_pol_id:= (SELECT nextval('urn_id_seq'));

				INSERT INTO polygon(pol_id,the_geom) 
				VALUES (v_auto_pol_id,(SELECT ST_Multi(ST_Envelope(ST_Buffer(connec.the_geom,v_double_geom_buffer))) 
				from connec where connec_id=NEW.connec_id));
				
				EXECUTE 'UPDATE '||v_man_table||' SET pol_id = '''||v_auto_pol_id||''' WHERE connec_id = '''||NEW.connec_id||''';';
			END IF;

		END IF;

		
		IF NEW.state=1 THEN
			-- Control of automatic insert of link and vnode
			IF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_connec_automatic_link'
			AND cur_user=current_user LIMIT 1) IS TRUE THEN

				EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
				"feature":{"id":'|| array_to_json(array_agg(NEW.connec_id))||'},"data":{"feature_type":"CONNEC"}}$$)';
				
			END IF;

		ELSIF NEW.state=2 THEN
			-- for planned connects always must exits link defined because alternatives will use parameters and rows of that defined link adding only geometry defined on plan_psector

			EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
			"feature":{"id":'|| array_to_json(array_agg(NEW.connec_id))||'},"data":{"feature_type":"CONNEC"}}$$)';

			-- for planned always must exits arc_id defined on default psector because it is impossible to draw a new planned link. Unique option for user is modify the existing automatic link
			SELECT arc_id INTO v_arc_id FROM connec WHERE connec_id=NEW.connec_id;
			v_psector_vdefault=(SELECT value::integer FROM config_param_user WHERE config_param_user.parameter::text = 'plan_psector_vdefault'::text AND 
			config_param_user.cur_user::name = "current_user"());
			INSERT INTO plan_psector_x_connec (connec_id, psector_id, state, doable, arc_id) 
			VALUES (NEW.connec_id, v_psector_vdefault, 1, true, v_arc_id);
		
		END IF;
			

		-- man addfields insert
		IF v_customfeature IS NOT NULL THEN
			FOR v_addfields IN SELECT * FROM sys_addfields
			WHERE (cat_feature_id = v_customfeature OR cat_feature_id is null) AND active IS TRUE AND iseditable IS TRUE
			LOOP
				EXECUTE 'SELECT $1."' || v_addfields.param_name||'"'
					USING NEW
					INTO v_new_value_param;

				IF v_new_value_param IS NOT NULL THEN
					EXECUTE 'INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES ($1, $2, $3)'
						USING NEW.connec_id, v_addfields.id, v_new_value_param;
				END IF;	
			END LOOP;
		END IF;		

		-- inp connec insert
		INSERT INTO inp_connec (connec_id) VALUES (NEW.connec_id);

		RETURN NEW;

	
	ELSIF TG_OP = 'UPDATE' THEN

		-- UPDATE geom
		IF st_equals(NEW.the_geom, OLD.the_geom) IS FALSE AND geometrytype(NEW.the_geom)='POINT'  THEN
			UPDATE connec SET the_geom=NEW.the_geom WHERE connec_id = OLD.connec_id;

			--update elevation from raster
			IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.elevation = OLD.elevation) AND
			(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_update_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
				NEW.elevation = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM v_ext_raster_dem WHERE id =
							(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
			END IF;	
			
			--update associated geometry of element (if exists)
			UPDATE element SET the_geom = NEW.the_geom WHERE St_dwithin(OLD.the_geom, the_geom, 0.001) 
			AND element_id IN (SELECT element_id FROM element_x_connec WHERE connec_id = NEW.connec_id);		
		
		ELSIF st_equals( NEW.the_geom, OLD.the_geom) IS FALSE AND geometrytype(NEW.the_geom)='MULTIPOLYGON'  THEN
			UPDATE polygon SET the_geom=NEW.the_geom WHERE pol_id = OLD.pol_id;
			NEW.sector_id:= (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);          
			NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);         
			NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);         			
        
		END IF;

		-- Reconnect arc_id
		IF (NEW.arc_id != OLD.arc_id) OR (NEW.arc_id IS NOT NULL AND OLD.arc_id IS NULL) OR (NEW.arc_id IS NULL AND OLD.arc_id IS NOT NULL) THEN

			-- when arc_id comes from connec table
			IF OLD.arc_id NOT IN (SELECT arc_id FROM plan_psector_x_connec WHERE connec_id=NEW.connec_id) THEN 
			
				UPDATE connec SET arc_id=NEW.arc_id where connec_id=NEW.connec_id;
				
				IF (SELECT link_id FROM link WHERE feature_id=NEW.connec_id AND feature_type='CONNEC' LIMIT 1) IS NOT NULL THEN

					EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
					"feature":{"id":'|| array_to_json(array_agg(NEW.connec_id))||'},"data":{"feature_type":"CONNEC"}}$$)';
				
				ELSIF (SELECT value::boolean FROM config_param_user WHERE parameter='edit_connec_automatic_link' AND cur_user=current_user LIMIT 1) IS TRUE THEN

					EXECUTE 'SELECT gw_fct_setlinktonetwork($${"client":{"device":4, "infoType":1, "lang":"ES"},
					"feature":{"id":'|| array_to_json(array_agg(NEW.connec_id))||'},"data":{"feature_type":"CONNEC"}}$$)';
				ELSE

					IF NEW.arc_id IS NOT NULL THEN
						NEW.fluid_type = (SELECT fluid_type FROM arc WHERE arc_id = NEW.arc_id);
						NEW.dma_id = (SELECT dma_id FROM arc WHERE arc_id = NEW.arc_id);
						NEW.presszone_id = (SELECT presszone_id FROM arc WHERE arc_id = NEW.arc_id);
						NEW.sector_id = (SELECT sector_id FROM arc WHERE arc_id = NEW.arc_id);
						NEW.dqa_id = (SELECT dqa_id FROM arc WHERE arc_id = NEW.arc_id);
					END IF;
				END IF;

			-- when arc_id comes from plan psector tables
			ELSIF (OLD.arc_id IN (SELECT arc_id FROM plan_psector_x_connec WHERE connec_id=NEW.connec_id)) THEN
				UPDATE plan_psector_x_connec SET arc_id = NEW.arc_id WHERE connec_id=OLD.connec_id AND arc_id = OLD.arc_id;		
			END IF;
		END IF;

		-- Looking for state control and insert planned connecs to default psector
		IF (NEW.state != OLD.state) THEN   
			PERFORM gw_fct_state_control('CONNEC', NEW.connec_id, NEW.state, TG_OP);
			IF NEW.state = 2 AND OLD.state=1 THEN
				INSERT INTO plan_psector_x_connec (connec_id, psector_id, state, doable)
				VALUES (NEW.connec_id, (SELECT config_param_user.value::integer AS value FROM config_param_user WHERE config_param_user.parameter::text
				= 'plan_psector_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1), 1, true);
			END IF;
			IF NEW.state = 1 AND OLD.state=2 THEN
				DELETE FROM plan_psector_x_connec WHERE connec_id=NEW.connec_id;					
			END IF;
			UPDATE connec SET state=NEW.state WHERE connec_id = OLD.connec_id;
			
		END IF;
		
		-- State_type
		IF NEW.state=0 AND OLD.state=1 THEN
			IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN
				NEW.state_type=(SELECT "value" FROM config_param_user WHERE parameter='statetype_end_vdefault' AND "cur_user"="current_user"() LIMIT 1);
				IF NEW.state_type IS NULL THEN
					NEW.state_type=(SELECT id from value_state_type WHERE state=0 LIMIT 1);
					IF NEW.state_type IS NULL THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
      	 				 "data":{"message":"2110", "function":"1318","debug_msg":null}}$$);';
					END IF;
				END IF;
			END IF;

			-- Automatic downgrade of associated link/vnode
			UPDATE link SET state=0 WHERE feature_id=OLD.connec_id;
			UPDATE vnode SET state=0 WHERE vnode_id=(SELECT exit_id FROM link WHERE feature_id=OLD.connec_id LIMIT 1)::integer;

		END IF;
		
		--check relation state - state_type
		IF (NEW.state_type != OLD.state_type) THEN
			IF NEW.state_type NOT IN (SELECT id FROM value_state_type WHERE state = NEW.state) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3036", "function":"1318","debug_msg":"'||NEW.state::text||'"}}$$);';
			ELSE
				UPDATE connec SET state_type=NEW.state_type WHERE connec_id = OLD.connec_id;
			END IF;
		END IF;			
       	
		-- rotation
		IF NEW.rotation != OLD.rotation THEN
			UPDATE connec SET rotation=NEW.rotation WHERE connec_id = OLD.connec_id;
		END IF;

		--link_path
		SELECT link_path INTO v_link_path FROM cat_feature JOIN cat_connec ON cat_connec.connectype_id=cat_feature.id WHERE cat_connec.id=NEW.connecat_id;
		IF v_link_path IS NOT NULL THEN
			NEW.link = replace(NEW.link, v_link_path,'');
		END IF;
		
		-- Connec type for parent tables
		IF v_man_table='parent' THEN
	    	IF (NEW.connecat_id != OLD.connecat_id) THEN
				v_new_connec_type= (SELECT system_id FROM cat_feature JOIN cat_connec ON cat_feature.id=connectype_id where cat_connec.id=NEW.connecat_id);
				v_old_connec_type= (SELECT system_id FROM cat_feature JOIN cat_connec ON cat_feature.id=connectype_id where cat_connec.id=OLD.connecat_id);
				IF v_new_connec_type != v_old_connec_type THEN
					v_sql='INSERT INTO man_'||lower(v_new_connec_type)||' (connec_id) VALUES ('||NEW.connec_id||')';
					EXECUTE v_sql;
					v_sql='DELETE FROM man_'||lower(v_old_connec_type)||' WHERE connec_id='||quote_literal(OLD.connec_id);
					EXECUTE v_sql;
				END IF;
			END IF;
		END IF;

		-- customer_code
		IF (NEW.customer_code != OLD.customer_code) OR (OLD.customer_code IS NULL AND NEW.customer_code IS NOT NULL) THEN
			UPDATE connec SET customer_code=NEW.customer_code WHERE connec_id = OLD.connec_id;
		END IF;

		UPDATE connec 
			SET code=NEW.code, elevation=NEW.elevation, "depth"=NEW.depth, connecat_id=NEW.connecat_id, sector_id=NEW.sector_id, 
			annotation=NEW.annotation, observ=NEW.observ, "comment"=NEW.comment, rotation=NEW.rotation,dma_id=NEW.dma_id, presszone_id=NEW.presszone_id,
			soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, 
			workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, streetaxis2_id=v_streetaxis2, 
			postnumber=NEW.postnumber, postnumber2=NEW.postnumber2, muni_id=NEW.muni_id, streetaxis_id=v_streetaxis, postcode=NEW.postcode, 
			district_id =NEW.district_id, descript=NEW.descript, verified=NEW.verified, postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, 
			undelete=NEW.undelete, label_x=NEW.label_x,label_y=NEW.label_y, label_rotation=NEW.label_rotation,publish=NEW.publish, 
			inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value, connec_length=NEW.connec_length, link=NEW.link, lastupdate=now(), lastupdate_user=current_user,
			dqa_id=NEW.dqa_id, minsector_id=NEW.minsector_id, staticpressure=NEW.staticpressure,
			adate=NEW.adate, adescript=NEW.adescript, accessibility =  NEW.accessibility
			WHERE connec_id=OLD.connec_id;
			
		IF v_man_table ='man_greentap' THEN
			UPDATE man_greentap SET linked_connec=NEW.linked_connec,
			brand=NEW.brand, model=NEW.model
			WHERE connec_id=OLD.connec_id;
			
		ELSIF v_man_table ='man_wjoin' THEN
			UPDATE man_wjoin SET top_floor=NEW.top_floor,cat_valve=NEW.cat_valve,
			brand=NEW.brand, model=NEW.model
			WHERE connec_id=OLD.connec_id;
			
		ELSIF v_man_table ='man_tap' THEN
			UPDATE man_tap SET linked_connec=NEW.linked_connec, drain_diam=NEW.drain_diam,drain_exit=NEW.drain_exit,drain_gully=NEW.drain_gully,
			drain_distance=NEW.drain_distance, arq_patrimony=NEW.arq_patrimony, com_state=NEW.com_state, cat_valve=NEW.cat_valve
			WHERE connec_id=OLD.connec_id;
			
		ELSIF v_man_table ='man_fountain' THEN 			
			UPDATE man_fountain SET vmax=NEW.vmax,vtotal=NEW.vtotal,container_number=NEW.container_number,pump_number=NEW.pump_number,power=NEW.power,
			regulation_tank=NEW.regulation_tank,name=NEW.name,chlorinator=NEW.chlorinator, linked_connec=NEW.linked_connec, arq_patrimony=NEW.arq_patrimony,
			pol_id=NEW.pol_id
			WHERE connec_id=OLD.connec_id;	
			
		END IF;

		-- man addfields update
			IF v_customfeature IS NOT NULL THEN
				FOR v_addfields IN SELECT * FROM sys_addfields
				WHERE (cat_feature_id = v_customfeature OR cat_feature_id is null) AND active IS TRUE AND iseditable IS TRUE
				LOOP

					EXECUTE 'SELECT $1."' || v_addfields.param_name||'"'
						USING NEW
						INTO v_new_value_param;
		 
					EXECUTE 'SELECT $1."' || v_addfields.param_name||'"'
						USING OLD
						INTO v_old_value_param;

					IF v_new_value_param IS NOT NULL THEN 

						EXECUTE 'INSERT INTO man_addfields_value(feature_id, parameter_id, value_param) VALUES ($1, $2, $3) 
							ON CONFLICT (feature_id, parameter_id)
							DO UPDATE SET value_param=$3 WHERE man_addfields_value.feature_id=$1 AND man_addfields_value.parameter_id=$2'
							USING NEW.connec_id , v_addfields.id, v_new_value_param;	

					ELSIF v_new_value_param IS NULL AND v_old_value_param IS NOT NULL THEN

						EXECUTE 'DELETE FROM man_addfields_value WHERE feature_id=$1 AND parameter_id=$2'
							USING NEW.connec_id , v_addfields.id;
					END IF;
				
				END LOOP;
		    END IF;   

        RETURN NEW;
    

	ELSIF TG_OP = 'DELETE' THEN
	
		EXECUTE 'SELECT gw_fct_getcheckdelete($${"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"id":"'||OLD.connec_id||'","featureType":"CONNEC"}, "data":{}}$$)';

		IF v_man_table ='man_fountain'  THEN
			DELETE FROM connec WHERE connec_id=OLD.connec_id;
			DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_fountain WHERE connec_id=OLD.connec_id );
		ELSE
			DELETE FROM connec WHERE connec_id = OLD.connec_id;
		END IF;		

		-- delete links & vnode's
		FOR v_record_link IN SELECT * FROM link WHERE feature_type='CONNEC' AND feature_id=OLD.connec_id
		LOOP
			-- delete link
			DELETE FROM link WHERE link_id=v_record_link.link_id;

			-- delete vnode if no more links are related to vnode
			SELECT count(exit_id) INTO v_count FROM link WHERE exit_id=v_record_link.exit_id;
						
			IF v_count =0 THEN 
				DELETE FROM vnode WHERE vnode_id=v_record_link.exit_id::integer;
			END IF;
		END LOOP;
        
		--Delete addfields
  		DELETE FROM man_addfields_value WHERE feature_id = OLD.connec_id  and parameter_id in 
  		(SELECT id FROM sys_addfields WHERE cat_feature_id IS NULL OR cat_feature_id =OLD.connec_type);

		RETURN NULL;

	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;