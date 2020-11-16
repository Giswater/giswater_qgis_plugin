/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION NODE: 1320


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_node()
  RETURNS trigger AS
$BODY$
DECLARE 
v_inp_table varchar;
v_man_table varchar;
v_type_man_table varchar;
v_code_autofill_bool boolean;
v_node_id text;
v_tablename varchar;
v_pol_id varchar;
v_sql text;
v_count integer;
v_promixity_buffer double precision;
v_edit_node_reduction_auto_d1d2 boolean;
v_link_path varchar;
v_insert_double_geom boolean;
v_double_geom_buffer double precision;
v_new_node_type text;
v_old_node_type text;
v_addfields record;
v_new_value_param text;
v_old_value_param text;
v_customfeature text;
v_featurecat text;
v_auto_pol_id text;
v_new_epatable text;
v_old_epatable text;
v_new_epatype text;
v_streetaxis text;
v_streetaxis2 text;
v_sys_type text;

-- dynamic mapzones strategy
v_isdma boolean = false;
v_issector boolean = false;
v_ispresszone boolean = false;
v_isautoinsertdma boolean = false;
v_isautoinsertsector boolean = false;
v_isautoinsertpresszone boolean = false;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_man_table:= TG_ARGV[0];

	-- get dynamic mapzones status
	v_isdma := (SELECT value::json->>'DMA' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');
	v_issector:= (SELECT value::json->>'SECTOR' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');
	v_ispresszone:= (SELECT value::json->>'PRESSZONE' FROM config_param_system WHERE parameter = 'utils_grafanalytics_status');

	-- get automatic insert for mapzone
	v_isautoinsertsector:= (SELECT value::json->>'SECTOR' FROM config_param_system WHERE parameter = 'edit_mapzone_automatic_insert');
	v_isautoinsertdma := (SELECT value::json->>'DMA' FROM config_param_system WHERE parameter = 'edit_mapzones_automatic_insert');
	v_isautoinsertpresszone:= (SELECT value::json->>'PRESSZONE' FROM config_param_system WHERE parameter = 'edit_mapzones_automatic_insert');

	--modify values for custom view inserts
	IF v_man_table IN (SELECT id FROM cat_feature WHERE feature_type = 'NODE') THEN
		v_customfeature:=v_man_table;
		v_man_table:=(SELECT man_table FROM cat_feature_node WHERE id=v_man_table);
	END IF;
	
	v_type_man_table=v_man_table;

	--Get data from config table
	v_promixity_buffer = (SELECT "value" FROM config_param_system WHERE "parameter"='edit_feature_buffer_on_mapzone');
	v_edit_node_reduction_auto_d1d2 = (SELECT "value" FROM config_param_system WHERE "parameter"='edit_node_reduction_auto_d1d2');
	SELECT ((value::json)->>'activated')::boolean INTO v_insert_double_geom FROM config_param_system WHERE parameter='edit_node_doublegeom';
	SELECT ((value::json)->>'value') INTO v_double_geom_buffer FROM config_param_system WHERE parameter='edit_node_doublegeom';

	-- transforming streetaxis name into id
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
		v_streetaxis = (SELECT id FROM ext_streetaxis WHERE muni_id = NEW.muni_id AND name = NEW.streetname LIMIT 1);
		v_streetaxis2 = (SELECT id FROM ext_streetaxis WHERE muni_id = NEW.muni_id AND name = NEW.streetname2 LIMIT 1);
	END IF;
	
	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN
	
		-- Node ID	
		IF (NEW.node_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			NEW.node_id:= (SELECT nextval('urn_id_seq'));
		END IF;
	
		-- Node Catalog ID
		IF (NEW.nodecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        		"data":{"message":"1006", "function":"1320","debug_msg":null}}$$);';
			END IF;
			
			IF v_customfeature IS NOT NULL THEN		
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"=lower(concat(v_customfeature,'_vdefault')) AND "cur_user"="current_user"() LIMIT 1);			
			ELSE
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_nodecat_vdefault' AND "cur_user"="current_user"() LIMIT 1);

				-- get first value (last chance)
				IF (NEW.nodecat_id IS NULL) THEN
					NEW.nodecat_id := (SELECT id FROM cat_node LIMIT 1);
				END IF;
			END IF;
			
			IF (NEW.nodecat_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        		"data":{"message":"1090", "function":"1320","debug_msg":null}}$$);';
			END IF;				
		END IF;
		
		
		-- Epa type
		IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM cat_node JOIN cat_feature_node ON cat_feature_node.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id LIMIT 1)::text;   
		END IF;
		
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"1110", "function":"1320","debug_msg":null}}$$);';
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
				"data":{"message":"2012", "function":"1320","debug_msg":"'||NEW.node_id::text||'"}}$$);';
			END IF;            
		END IF;
				
		-- Sector
		IF NEW.sector_name IS NOT NULL AND v_isautoinsertsector AND v_issector AND (SELECT sector_id FROM sector WHERE sector_id=NEW.sector_name::integer) IS NULL THEN
				INSERT INTO sector VALUES (NEW.sector_name::integer, NEW.sector_name, NEW.expl_id);
		ELSE
			IF (NEW.sector_id IS NULL) THEN
				
				-- control error without any mapzones defined on the table of mapzone
				IF ((SELECT COUNT(*) FROM sector) = 0) THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1008", "function":"1320","debug_msg":null}}$$);';
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

				-- force cero values always - undefined
				IF (NEW.sector_id IS NULL) THEN
					NEW.sector_id := 0;
				END IF; 
			END IF;
		END IF;
		
		-- Dma
		IF NEW.dma_name IS NOT NULL AND v_isautoinsertdma AND v_isdma AND (SELECT dma_id FROM dma WHERE dma_id=NEW.dma_name::integer) IS NULL THEN
			INSERT INTO dma VALUES (NEW.dma_name::integer, NEW.dma_name, NEW.expl_id);
			NEW.dma_id = NEW.dma_name;
		ELSE
			IF (NEW.dma_id IS NULL) THEN
				
				-- control error without any mapzones defined on the table of mapzone
				IF ((SELECT COUNT(*) FROM dma) = 0) THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1012", "function":"1320","debug_msg":null}}$$);';
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

				-- force cero values always - undefined
				IF (NEW.dma_id IS NULL) THEN
					NEW.dma_id := 0;
				END IF;
			END IF;		
		END IF;
			
		-- Presszone
		IF NEW.presszone_name IS NOT NULL AND v_isautoinsertpresszone AND v_ispresszone AND (SELECT presszone_id FROM presszone WHERE presszone_id=NEW.presszone_name) IS NULL THEN
			INSERT INTO dma VALUES (NEW.dma_name, NEW.dma_name, NEW.expl_id);
			NEW.presszone_id = NEW.presszone_name;
		ELSE
			IF (NEW.presszone_id IS NULL) THEN
			
				-- control error without any mapzones defined on the table of mapzone
				IF ((SELECT COUNT(*) FROM presszone) = 0) THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3106", "function":"1320","debug_msg":null}}$$);';
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
				
				-- force cero values always - undefined
				IF (NEW.presszone_id IS NULL) THEN
					NEW.presszone_id := 0;
				END IF;            
			END IF;
		END IF;
		
		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM ext_municipality) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"3110", "function":"1320","debug_msg":null}}$$);';
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
				"data":{"message":"2024", "function":"1320","debug_msg":"'||NEW.node_id::text||'"}}$$);';
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
			"data":{"message":"3036", "function":"1320","debug_msg":"'||v_sql::text||'"}}$$);';

		END IF;
		
		
		--Inventory
		NEW.inventory := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_inventory_sysvdefault');
		
		
		--Publish
		NEW.publish := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_publish_sysvdefault');	
		
		
		SELECT code_autofill INTO v_code_autofill_bool FROM cat_feature JOIN cat_node ON cat_feature.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id;
		
		--Copy id to code field
		IF (NEW.code IS NULL AND v_code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.node_id;
		END IF;

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
		
		-- Parent id
		SELECT concat('man_',lower(system_id)), pol_id INTO v_tablename, v_pol_id FROM polygon JOIN cat_feature ON cat_feature.id=polygon.sys_type
		WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;

		IF v_pol_id IS NOT NULL THEN
			v_sql:= 'SELECT node_id FROM '||v_tablename||' WHERE pol_id::bigint='||v_pol_id||' LIMIT 1';
			EXECUTE v_sql INTO v_node_id;
			NEW.parent_id=v_node_id;
		END IF;

		
		-- link
		IF (SELECT "value" FROM config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid')::boolean=TRUE THEN
			NEW.link=NEW.node_id;
		END IF;

		v_featurecat = (SELECT nodetype_id FROM cat_node WHERE id = NEW.nodecat_id);

		--Location type
		IF NEW.location_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_location_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.location_type = (SELECT value FROM config_param_user WHERE parameter = 'featureval_location_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.location_type IS NULL THEN
			NEW.location_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_node_location_vdefault' AND cur_user = current_user);
		END IF;

		--Fluid type
		IF NEW.fluid_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_fluid_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.fluid_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_fluid_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.fluid_type IS NULL THEN
			NEW.fluid_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_node_fluid_vdefault' AND cur_user = current_user);
		END IF;

		--Category type
		IF NEW.category_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_category_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.category_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_category_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.category_type IS NULL THEN
			NEW.category_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_node_category_vdefault' AND cur_user = current_user);
		END IF;	

		--Function type
		IF NEW.function_type IS NULL AND (SELECT value FROM config_param_user WHERE parameter = 'edit_feature_function_vdefault' AND cur_user = current_user)  = v_featurecat THEN
			NEW.function_type = (SELECT value FROM config_param_user WHERE parameter = 'edit_featureval_function_vdefault' AND cur_user = current_user);
		END IF;

		IF NEW.function_type IS NULL THEN
			NEW.function_type = (SELECT value FROM config_param_user WHERE parameter = 'node_function_vdefault' AND cur_user = current_user);
		END IF;	
		
		--elevation from raster
		IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.elevation IS NULL) AND
		(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_insert_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
			NEW.elevation = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM v_ext_raster_dem WHERE id =
				(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
		END IF;   	

		-- FEATURE INSERT      
		INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ,comment, dma_id, presszone_id, 
		soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, muni_id,streetaxis_id, 
		streetaxis2_id, postcode, postnumber, postnumber2, postcomplement, district_id,	postcomplement2, descript, link, rotation,verified, undelete,label_x,label_y,label_rotation,
		expl_id, publish, inventory, the_geom, hemisphere, num_value, adate, adescript, accessibility)

		VALUES (NEW.node_id, NEW.code, NEW.elevation, NEW.depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.arc_id, NEW.parent_id, NEW.state, NEW.state_type, NEW.annotation, NEW.observ,
		NEW.comment,NEW.dma_id, NEW.presszone_id, NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type, NEW.location_type,NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, 
		NEW.builtdate, NEW.enddate, NEW.ownercat_id, NEW.muni_id, v_streetaxis, v_streetaxis2, NEW.postcode, NEW.postnumber ,NEW.postnumber2, NEW.postcomplement, NEW.district_id, 
		NEW.postcomplement2, NEW.descript, NEW.link, NEW.rotation, NEW.verified, NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation, 
		NEW.expl_id, NEW.publish, NEW.inventory, NEW.the_geom,  NEW.hemisphere,NEW.num_value,
		NEW.adate, NEW.adescript, NEW.accessibility);

		
		IF v_man_table='man_tank' THEN
			IF (v_insert_double_geom IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
					
				INSERT INTO polygon(pol_id, sys_type, the_geom) VALUES (NEW.pol_id, 'TANK', (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_double_geom_buffer))) 
				from node where node_id=NEW.node_id));
				
				INSERT INTO man_tank (node_id, pol_id, vmax, vutil, area, chlorination, name, hmax) 
				VALUES (NEW.node_id, NEW.pol_id, NEW.vmax, NEW.vutil, NEW.area,NEW.chlorination, NEW.name, NEW.hmax);
			ELSE
				INSERT INTO man_tank (node_id, vmax, vutil, area, chlorination, name, hmax) 
				VALUES (NEW.node_id, NEW.vmax, NEW.vutil, NEW.area,NEW.chlorination, NEW.name, NEW.hmax);
			END IF;
					
		ELSIF v_man_table='man_hydrant' THEN
			INSERT INTO man_hydrant (node_id, fire_code, communication, valve, geom1, geom2, brand, model) 
			VALUES (NEW.node_id, NEW.fire_code, NEW.communication, NEW.valve, NEW.geom1, NEW.geom2, NEW.brand, NEW.model);		
		
		ELSIF v_man_table='man_junction' THEN
			INSERT INTO man_junction (node_id) VALUES(NEW.node_id);
			
		ELSIF v_man_table='man_pump' THEN		
			INSERT INTO man_pump (node_id, max_flow, min_flow, nom_flow, power, pressure, elev_height, name, pump_number, brand, model) 
			VALUES(NEW.node_id, NEW.max_flow, NEW.min_flow, NEW.nom_flow, NEW.power, NEW.pressure, NEW.elev_height, NEW.name, NEW.pump_number,
			NEW.brand, NEW.model);
		
		ELSIF v_man_table='man_reduction' THEN
			
			IF v_edit_node_reduction_auto_d1d2 = 'TRUE' THEN
				IF (NEW.diam1 IS NULL) THEN
					NEW.diam1=(SELECT dnom FROM cat_node WHERE id=NEW.nodecat_id);
				END IF;
				IF (NEW.diam2 IS NULL) THEN
					NEW.diam2=(SELECT dint FROM cat_node WHERE id=NEW.nodecat_id);
				END IF;
			END IF;

			INSERT INTO man_reduction (node_id,diam1,diam2) VALUES(NEW.node_id,NEW.diam1, NEW.diam2);
			
		ELSIF v_man_table='man_valve' THEN	
			INSERT INTO man_valve (node_id,closed, broken, buried,irrigation_indicator,pression_entry, pression_exit, depth_valveshaft,regulator_situation, regulator_location, regulator_observ,
			lin_meters, exit_type,exit_code,drive_type, cat_valve2, ordinarystatus, shutter, brand, brand2, model, model2) 
			VALUES (NEW.node_id, NEW.closed, NEW.broken, NEW.buried, NEW.irrigation_indicator, NEW.pression_entry, NEW.pression_exit, NEW.depth_valveshaft, NEW.regulator_situation, 
			NEW.regulator_location, NEW.regulator_observ, NEW.lin_meters, NEW.exit_type, NEW.exit_code, NEW.drive_type, NEW.cat_valve2, NEW.ordinarystatus,
			NEW.shutter, NEW.brand, NEW.brand2, NEW.model, NEW.model2) ;
		
		ELSIF v_man_table='man_manhole' THEN	
			INSERT INTO man_manhole (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		ELSIF v_man_table='man_meter' THEN
			INSERT INTO man_meter (node_id, brand, model) 
			VALUES(NEW.node_id, NEW.brand, NEW.model);
		
		ELSIF v_man_table='man_source' THEN	
			INSERT INTO man_source (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		ELSIF v_man_table='man_waterwell' THEN
			INSERT INTO man_waterwell (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		ELSIF v_man_table='man_filter' THEN
			INSERT INTO man_filter (node_id) VALUES(NEW.node_id);	
		
		ELSIF v_man_table='man_register' THEN
			IF (v_insert_double_geom IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				INSERT INTO polygon(pol_id, sys_type, the_geom) VALUES (NEW.pol_id, 'REGISTER',
				 (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_double_geom_buffer))) from node where node_id=NEW.node_id));			
				INSERT INTO man_register (node_id,pol_id) VALUES (NEW.node_id, NEW.pol_id);
			ELSE
				INSERT INTO man_register (node_id) VALUES (NEW.node_id);
			END IF;
			
		ELSIF v_man_table='man_netwjoin' THEN
			INSERT INTO man_netwjoin (node_id, top_floor,  cat_valve, customer_code, brand, model)
			VALUES(NEW.node_id, NEW.top_floor, NEW.cat_valve, NEW.customer_code, NEW.brand, NEW.model);
		
		ELSIF v_man_table='man_expansiontank' THEN
			INSERT INTO man_expansiontank (node_id) VALUES(NEW.node_id);
		
		ELSIF v_man_table='man_flexunion' THEN
			INSERT INTO man_flexunion (node_id) VALUES(NEW.node_id);
		
		ELSIF v_man_table='man_netelement' THEN
			INSERT INTO man_netelement (node_id, serial_number, brand, model)
			VALUES(NEW.node_id, NEW.serial_number, NEW.brand, NEW.model);		
		
		ELSIF v_man_table='man_netsamplepoint' THEN
			INSERT INTO man_netsamplepoint (node_id, lab_code) 
			VALUES (NEW.node_id, NEW.lab_code);
		
		ELSIF v_man_table='man_wtp' THEN
			INSERT INTO man_wtp (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		END IF;

		IF v_man_table='parent' THEN
		    v_man_table:= (SELECT man_table FROM cat_feature_node n JOIN cat_node ON cat_node.id=NEW.nodecat_id WHERE n.id = cat_node.nodetype_id LIMIT 1)::text;
	         
			IF v_man_table IS NOT NULL THEN
			    v_sql:= 'INSERT INTO '||v_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
			    EXECUTE v_sql;
			END IF;

			--insert double geometry
			IF (v_man_table IN ('man_register', 'man_tank') and (v_insert_double_geom IS TRUE)) THEN
					
				v_auto_pol_id:= (SELECT nextval('urn_id_seq'));
                v_sys_type := (SELECT type FROM cat_feature_node JOIN cat_node ON cat_node.nodetype_id=cat_feature_node.id WHERE cat_node.id = NEW.nodecat_id);

				INSERT INTO polygon(pol_id, sys_type, the_geom) 
				VALUES (v_auto_pol_id, v_sys_type, (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_double_geom_buffer))) 
				from node where node_id=NEW.node_id));
					
				EXECUTE 'UPDATE '||v_man_table||' SET pol_id = '''||v_auto_pol_id||''' WHERE node_id = '''||NEW.node_id||''';';
			END IF;
		END IF;

		--insert tank into config_mincut_inlet
		IF v_man_table='man_tank' THEN
			INSERT INTO config_mincut_inlet(node_id, expl_id, active)
			VALUES (NEW.node_id, NEW.expl_id, TRUE);
		END IF;

		-- man addfields insert
		IF v_customfeature IS NOT NULL THEN
			FOR v_addfields IN SELECT * FROM sys_addfields
			WHERE (cat_feature_id = v_customfeature OR cat_feature_id is null) AND active IS TRUE AND iseditable IS TRUE
			LOOP
				EXECUTE 'SELECT $1."' ||v_addfields.param_name||'"'
					USING NEW
					INTO v_new_value_param;

				IF v_new_value_param IS NOT NULL THEN
					EXECUTE 'INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES ($1, $2, $3)'
						USING NEW.node_id, v_addfields.id, v_new_value_param;
				END IF;	
			END LOOP;
		END IF;				

		-- EPA insert
		IF (NEW.epa_type = 'JUNCTION') THEN 
				INSERT INTO inp_junction (node_id) VALUES (NEW.node_id);

		ELSIF (NEW.epa_type = 'TANK') THEN 
				INSERT INTO inp_tank (node_id) VALUES (NEW.node_id);

		ELSIF (NEW.epa_type = 'RESERVOIR') THEN
				INSERT INTO inp_reservoir (node_id) VALUES (NEW.node_id);
				
		ELSIF (NEW.epa_type = 'PUMP') THEN
				INSERT INTO inp_pump (node_id, status) VALUES (NEW.node_id, 'OPEN');

		ELSIF (NEW.epa_type = 'VALVE') THEN
				INSERT INTO inp_valve (node_id, valv_type, status) VALUES (NEW.node_id, 'PRV', 'ACTIVE');

		ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
				INSERT INTO inp_shortpipe (node_id) VALUES (NEW.node_id);
				
		ELSIF (NEW.epa_type = 'INLET') THEN
				INSERT INTO inp_inlet (node_id) VALUES (NEW.node_id);
				
		END IF;

		RETURN NEW;

    -- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN

		-- EPA update
		IF (NEW.epa_type != OLD.epa_type) THEN    
		 
		    IF (OLD.epa_type = 'JUNCTION') THEN
			v_inp_table:= 'inp_junction';            
		    ELSIF (OLD.epa_type = 'TANK') THEN
			v_inp_table:= 'inp_tank';                
		    ELSIF (OLD.epa_type = 'RESERVOIR') THEN
			v_inp_table:= 'inp_reservoir';    
		    ELSIF (OLD.epa_type = 'SHORTPIPE') THEN
			v_inp_table:= 'inp_shortpipe';    
		    ELSIF (OLD.epa_type = 'VALVE') THEN
			v_inp_table:= 'inp_valve';    
		    ELSIF (OLD.epa_type = 'PUMP') THEN
			v_inp_table:= 'inp_pump';  
		    ELSIF (OLD.epa_type = 'INLET') THEN
			v_inp_table:= 'inp_inlet';
		    END IF;
		    IF v_inp_table IS NOT NULL THEN
			v_sql:= 'DELETE FROM '||v_inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
			EXECUTE v_sql;
		    END IF;
				v_inp_table := NULL;

		    IF (NEW.epa_type = 'JUNCTION') THEN
			v_inp_table:= 'inp_junction';   
		    ELSIF (NEW.epa_type = 'TANK') THEN
			v_inp_table:= 'inp_tank';     
		    ELSIF (NEW.epa_type = 'RESERVOIR') THEN
			v_inp_table:= 'inp_reservoir';  
		    ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
			v_inp_table:= 'inp_shortpipe';    
		    ELSIF (NEW.epa_type = 'VALVE') THEN
			v_inp_table:= 'inp_valve';    
		    ELSIF (NEW.epa_type = 'PUMP') THEN
			v_inp_table:= 'inp_pump';  
		    ELSIF (NEW.epa_type = 'INLET') THEN
			v_inp_table:= 'inp_inlet';  
		    END IF;
		    IF v_inp_table IS NOT NULL THEN
			v_sql:= 'INSERT INTO '||v_inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
			EXECUTE v_sql;
		    END IF;
		END IF;

		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
			IF NEW.state = 2 AND OLD.state=1 THEN
				INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
				VALUES (NEW.node_id, (SELECT config_param_user.value::integer AS value FROM config_param_user WHERE config_param_user.parameter::text
				= 'plan_psector_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1), 1, true);
			END IF;
			IF NEW.state = 1 AND OLD.state=2 THEN
				DELETE FROM plan_psector_x_node WHERE node_id=NEW.node_id;					
			END IF;			
		END IF;
		
		-- State_type
		IF NEW.state=0 AND OLD.state=1 THEN
			IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN
			NEW.state_type=(SELECT "value" FROM config_param_user WHERE parameter='statetype_end_vdefault' AND "cur_user"="current_user"() LIMIT 1);
				IF NEW.state_type IS NULL THEN
				NEW.state_type=(SELECT id from value_state_type WHERE state=0 LIMIT 1);
					IF NEW.state_type IS NULL THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        				"data":{"message":"2110", "function":"1320","debug_msg":null}}$$);';
					END IF;
				END IF;
			END IF;
		END IF;
		
		--check relation state - state_type
		IF (NEW.state_type != OLD.state_type) AND NEW.state_type NOT IN (SELECT id FROM value_state_type WHERE state = NEW.state) THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3036", "function":"1320","debug_msg":"'||NEW.state::text||'"}}$$);';
		END IF;

		-- rotation
		IF NEW.rotation != OLD.rotation THEN
			UPDATE node SET rotation=NEW.rotation WHERE node_id = OLD.node_id;
		END IF;
        
		-- The geom
		IF st_equals( NEW.the_geom, OLD.the_geom) IS FALSE THEN
		
			--the_geom
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
			
			-- Parent id
			SELECT concat('man_',lower(system_id)), pol_id INTO v_tablename, v_pol_id FROM polygon JOIN cat_feature ON cat_feature.id=polygon.sys_type
			WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;
	
			IF v_pol_id IS NOT NULL THEN
				v_sql:= 'SELECT node_id FROM '||v_tablename||' WHERE pol_id::integer='||v_pol_id||' LIMIT 1';
				EXECUTE v_sql INTO v_node_id;
				NEW.parent_id=v_node_id;
			END IF;
			
			--update elevation from raster
			IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.elevation = OLD.elevation) AND
				(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_update_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
				NEW.elevation = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM v_ext_raster_dem WHERE id =
							(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
			END IF;
			
			--update associated geometry of element (if exists)
			UPDATE element SET the_geom = NEW.the_geom WHERE St_dwithin(OLD.the_geom, the_geom, 0.001) 
			AND element_id IN (SELECT element_id FROM element_x_node WHERE node_id = NEW.node_id);		
			
		END IF;
	
		--Hemisphere
		IF (NEW.hemisphere != OLD.hemisphere) THEN
			   UPDATE node SET hemisphere=NEW.hemisphere WHERE node_id = OLD.node_id;
		END IF;	
		
		--link_path
		SELECT link_path INTO v_link_path FROM cat_feature JOIN cat_node ON cat_node.nodetype_id=cat_feature.id WHERE cat_node.id=NEW.nodecat_id;
		IF v_link_path IS NOT NULL THEN
			NEW.link = replace(NEW.link, v_link_path,'');
		END IF;
		

		-- Man and epa epa tables when parent is used
		IF v_man_table='parent' THEN
	    	IF (NEW.nodecat_id != OLD.nodecat_id) THEN

				-- man tables
				v_new_node_type= (SELECT system_id FROM cat_feature JOIN cat_node ON cat_feature.id=nodetype_id where cat_node.id=NEW.nodecat_id);
				v_old_node_type= (SELECT system_id FROM cat_feature JOIN cat_node ON cat_feature.id=nodetype_id where cat_node.id=OLD.nodecat_id);
				IF v_new_node_type != v_old_node_type THEN
					v_sql='INSERT INTO man_'||lower(v_new_node_type)||' (node_id) VALUES ('||NEW.node_id||')';
					EXECUTE v_sql;
					v_sql='DELETE FROM man_'||lower(v_old_node_type)||' WHERE node_id='||quote_literal(OLD.node_id);
					EXECUTE v_sql;
				END IF;

				-- epa tables
				v_new_epatable = (SELECT epa_table FROM cat_feature_node JOIN cat_node ON cat_feature_node.id=nodetype_id where cat_node.id=NEW.nodecat_id);
				v_old_epatable = (SELECT epa_table FROM cat_feature_node WHERE epa_default = OLD.epa_type LIMIT 1);
				NEW.epa_type = (SELECT epa_default FROM cat_feature_node WHERE epa_table = v_new_epatable LIMIT 1);
				IF v_new_epatable != v_old_epatable THEN
					v_sql='DELETE FROM '||v_old_epatable||' WHERE node_id='||quote_literal(OLD.node_id);
					EXECUTE v_sql;
					v_sql='INSERT INTO '||v_new_epatable||' (node_id) VALUES ('||NEW.node_id||')';
					EXECUTE v_sql;
				END IF;
				
			END IF;
		END IF;

		UPDATE node 
		SET code=NEW.code, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, arc_id=NEW.arc_id, parent_id=NEW.parent_id,
		state_type=NEW.state_type, annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, presszone_id=NEW.presszone_id, soilcat_id=NEW.soilcat_id,
		function_type=NEW.function_type, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end,  
		buildercat_id=NEW.buildercat_id,builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, muni_id=NEW.muni_id, streetaxis_id=v_streetaxis, 
		postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, streetaxis2_id=v_streetaxis2,postcode=NEW.postcode,district_id=NEW.district_id,postnumber=NEW.postnumber,
		postnumber2=NEW.postnumber2, descript=NEW.descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, 
		publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, num_value=NEW.num_value, link=NEW.link, lastupdate=now(), lastupdate_user=current_user,
		adate=NEW.adate, adescript=NEW.adescript, accessibility = NEW.accessibility
		WHERE node_id = OLD.node_id;
		
		IF v_man_table ='man_junction' THEN
			UPDATE man_junction SET node_id=NEW.node_id	
			WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_tank' THEN
			UPDATE man_tank SET pol_id=NEW.pol_id, vmax=NEW.vmax, vutil=NEW.vutil, area=NEW.area, chlorination=NEW.chlorination, name=NEW.name,
			hmax=NEW.hmax
			WHERE node_id=OLD.node_id;
			
			--update config_mincut_inlet if exploitation changes
			IF NEW.expl_id != OLD.expl_id THEN
				UPDATE config_mincut_inlet SET expl_id=NEW.expl_id WHERE node_id=NEW.node_id;
			END IF;
	
		ELSIF v_man_table ='man_pump' THEN
			UPDATE man_pump SET max_flow=NEW.max_flow, min_flow=NEW.min_flow, nom_flow=NEW.nom_flow, "power"=NEW.power, 
			pressure=NEW.pressure, elev_height=NEW.elev_height, name=NEW.name, pump_number=NEW.pump_number,
			brand=NEW.brand, model=NEW.model
			WHERE node_id=OLD.node_id;
		
		ELSIF v_man_table ='man_manhole' THEN
			UPDATE man_manhole SET name=NEW.name
			WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_hydrant' THEN
			UPDATE man_hydrant SET fire_code=NEW.fire_code, communication=NEW.communication, valve=NEW.valve,
			geom1=NEW.geom1, geom2=NEW.geom2, brand=NEW.brand, model=NEW.model
			WHERE node_id=OLD.node_id;			

		ELSIF v_man_table ='man_source' THEN
			UPDATE man_source SET name=NEW.name
			WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_meter' THEN
			UPDATE man_meter SET
			brand=NEW.brand, model=NEW.model
			WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_waterwell' THEN
			UPDATE man_waterwell SET name=NEW.name
			WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_reduction' THEN
			UPDATE man_reduction SET diam1=NEW.diam1, diam2=NEW.diam2
			WHERE node_id=OLD.node_id;

		ELSIF v_man_table ='man_valve' THEN
			UPDATE man_valve 
			SET closed=NEW.closed, broken=NEW.broken, buried=NEW.buried, irrigation_indicator=NEW.irrigation_indicator, pression_entry=NEW.pression_entry, pression_exit=NEW.pression_exit, 
			depth_valveshaft=NEW.depth_valveshaft, regulator_situation=NEW.regulator_situation, regulator_location=NEW.regulator_location, regulator_observ=NEW.regulator_observ, 
			lin_meters=NEW.lin_meters, exit_type=NEW.exit_type, exit_code=NEW.exit_code, drive_type=NEW.drive_type, cat_valve2=NEW.cat_valve2, ordinarystatus = NEW.ordinarystatus,
			shutter=NEW.shutter, brand=NEW.brand, brand2=NEW.brand2, model=NEW.model, model2=NEW.model2
			WHERE node_id=OLD.node_id;	
		
		ELSIF v_man_table ='man_register' THEN
			UPDATE man_register	SET pol_id=NEW.pol_id
			WHERE node_id=OLD.node_id;		
	
		ELSIF v_man_table ='man_netwjoin' THEN			
			UPDATE man_netwjoin
			SET top_floor= NEW.top_floor, cat_valve=NEW.cat_valve, customer_code=NEW.customer_code,
			brand=NEW.brand, model=NEW.model
			WHERE node_id=OLD.node_id;		
		
		ELSIF v_man_table ='man_expansiontank' THEN
			UPDATE man_expansiontank SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;		

		ELSIF v_man_table ='man_flexunion' THEN
			UPDATE man_flexunion SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;				
		
		ELSIF v_man_table ='man_netelement' THEN
			UPDATE man_netelement SET serial_number=NEW.serial_number,
			brand=NEW.brand, model=NEW.model
			WHERE node_id=OLD.node_id;	
	
		ELSIF v_man_table ='man_netsamplepoint' THEN
			UPDATE man_netsamplepoint SET node_id=NEW.node_id, lab_code=NEW.lab_code
			WHERE node_id=OLD.node_id;		
		
		ELSIF v_man_table ='man_wtp' THEN		
			UPDATE man_wtp SET name=NEW.name
			WHERE node_id=OLD.node_id;			
			
		ELSIF v_man_table ='man_filter' THEN
			UPDATE man_filter SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
		
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
						USING NEW.node_id , v_addfields.id, v_new_value_param;	

				ELSIF v_new_value_param IS NULL AND v_old_value_param IS NOT NULL THEN

					EXECUTE 'DELETE FROM man_addfields_value WHERE feature_id=$1 AND parameter_id=$2'
						USING NEW.node_id , v_addfields.id;
				END IF;
			
			END LOOP;
		END IF;       

		RETURN NEW;

   -- DELETE
   ELSIF TG_OP = 'DELETE' THEN

		EXECUTE 'SELECT gw_fct_getcheckdelete($${"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"id":"'||OLD.node_id||'","featureType":"NODE"}, "data":{}}$$)';

		-- delete from polygon table (before the deletion of node)
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_tank WHERE node_id=OLD.node_id );
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_register WHERE node_id=OLD.node_id );

		-- delete from node table
		DELETE FROM node WHERE node_id = OLD.node_id;

		--remove node from config_mincut_inlet
		DELETE FROM config_mincut_inlet WHERE node_id=OLD.node_id;

		--Delete addfields (after or before deletion of node, doesn't matter)
		DELETE FROM man_addfields_value WHERE feature_id = OLD.node_id  and parameter_id in 
		(SELECT id FROM sys_addfields WHERE cat_feature_id IS NULL OR cat_feature_id =OLD.node_type);

		RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;