/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1220


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_node()
  RETURNS trigger AS
$BODY$
DECLARE 
v_inp_table varchar;
v_man_table varchar;
v_new_v_man_table varchar;
v_old_v_man_table varchar;
v_sql varchar;
v_type_v_man_table varchar;
v_code_autofill_bool boolean;
v_count integer;
v_promixity_buffer double precision;
v_link_path varchar;
v_doublegeom_buffer double precision;
v_addfields record;
v_new_value_param text;
v_old_value_param text;
v_customfeature text;
v_featurecat text;
v_streetaxis text;
v_streetaxis2 text;
v_matfromcat boolean = false;
v_sys_type text;
v_doublegeometry boolean;
v_length float;
v_width float;
v_rotation float;
v_unitsfactor float;
v_linelocatepoint float;
v_thegeom public.geometry;
v_the_geom_pol public.geometry;
p21x float; 
p02x float;
p21y float; 
p02y float;
p22x float;
p22y float;
p01x float;
p01y float;
dx float;
dy float;
v_x float;
v_y float;
v_new_pol_id varchar(16);
v_codeautofill boolean;
v_srid integer;


BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	v_man_table:= TG_ARGV[0];

	-- modify values for custom view inserts
	IF v_man_table IN (SELECT id FROM cat_feature_node) THEN
		v_customfeature:=v_man_table;
		v_man_table:=(SELECT man_table FROM cat_feature_node WHERE id=v_man_table);
	END IF;

	v_type_v_man_table:=v_man_table;

	-- get data from config table	
	v_promixity_buffer = (SELECT "value" FROM config_param_system WHERE "parameter"='edit_feature_buffer_on_mapzone');
	SELECT ((value::json)->>'activated')::boolean INTO v_doublegeometry FROM config_param_system WHERE parameter='edit_node_doublegeom';
	SELECT ((value::json)->>'value') INTO v_doublegeom_buffer FROM config_param_system WHERE parameter='edit_node_doublegeom';
	v_unitsfactor = (SELECT value::float FROM config_param_user WHERE "parameter"='edit_gully_doublegeom' AND cur_user=current_user);
	v_srid = (SELECT epsg FROM sys_version LIMIT 1);


	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
		-- transforming streetaxis name into id	
		v_streetaxis = (SELECT id FROM ext_streetaxis WHERE muni_id = NEW.muni_id AND name = NEW.streetname LIMIT 1);
		v_streetaxis2 = (SELECT id FROM ext_streetaxis WHERE muni_id = NEW.muni_id AND name = NEW.streetname2 LIMIT 1);
		
		-- managing matcat
		IF (SELECT matcat_id FROM cat_node WHERE id = NEW.nodecat_id) IS NOT NULL THEN
			v_matfromcat = true;
		END IF;
	END IF;

	-- manage netgully doublegeom in case of exists
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND v_doublegeometry AND v_man_table = 'man_netgully' THEN

		--set rotation field
		WITH index_query AS(
		SELECT ST_Distance(the_geom, NEW.the_geom) as distance, the_geom FROM arc WHERE state=1 ORDER BY the_geom <-> NEW.the_geom LIMIT 10)
		SELECT St_linelocatepoint(the_geom, St_closestpoint(the_geom, NEW.the_geom)), the_geom INTO v_linelocatepoint, v_thegeom FROM index_query ORDER BY distance LIMIT 1;
		IF v_linelocatepoint < 0.01 THEN
			v_rotation = st_azimuth (st_startpoint(v_thegeom), st_lineinterpolatepoint(v_thegeom,0.01));
		ELSIF v_linelocatepoint > 0.99 THEN
			v_rotation = st_azimuth (st_lineinterpolatepoint(v_thegeom,0.98), st_lineinterpolatepoint(v_thegeom,0.99));
		ELSE
			v_rotation = st_azimuth (st_lineinterpolatepoint(v_thegeom,v_linelocatepoint), st_lineinterpolatepoint(v_thegeom,v_linelocatepoint+0.01));
		END IF;

		NEW.rotation = v_rotation*180/pi();
		v_rotation = -(v_rotation - pi()/2);

		-- get gratecat dimensions
		v_length = (SELECT length FROM cat_grate WHERE id=NEW.gratecat_id);
		v_width = (SELECT width FROM cat_grate WHERE id=NEW.gratecat_id);

		-- control null grate dimensions
		IF v_length*v_width IS NULL OR v_length*v_width = 0 THEN -- use default values for node polygon
			v_length = v_doublegeom_buffer*100;
			v_width = v_doublegeom_buffer*100;
		END IF;
					
		-- transform grate dimensions
		v_unitsfactor = 0.01*v_unitsfactor ; -- using 0.01 to convert from cms of catalog  to meters of the map
		v_length = v_length*v_unitsfactor;
		v_width = v_width*v_unitsfactor;

		-- calculate center coordinates
		v_x = st_x(NEW.the_geom);
		v_y = st_y(NEW.the_geom);

		-- calculate dx & dy to fix extend from center
		dx = v_length/2;
		dy = v_width/2;

		-- calculate the extend polygon
		p01x = v_x - dx*cos(v_rotation)-dy*sin(v_rotation);
		p01y = v_y - dx*sin(v_rotation)+dy*cos(v_rotation);

		p02x = v_x + dx*cos(v_rotation)-dy*sin(v_rotation);
		p02y = v_y + dx*sin(v_rotation)+dy*cos(v_rotation);

		p21x = v_x - dx*cos(v_rotation)+dy*sin(v_rotation);
		p21y = v_y - dx*sin(v_rotation)-dy*cos(v_rotation); 

		p22x = v_x + dx*cos(v_rotation)+dy*sin(v_rotation);
		p22y = v_y + dx*sin(v_rotation)-dy*cos(v_rotation);
		
		-- generating the geometry
		EXECUTE 'SELECT ST_Multi(ST_makePolygon(St_SetSrid(ST_GeomFromText(''LINESTRING(' || p21x ||' '|| p21y || ',' ||
			p22x ||' '|| p22y || ',' || p02x || ' ' || p02y || ','|| p01x ||' '|| p01y || ',' || p21x ||' '|| p21y || ')''),'||v_srid||')))'
			INTO v_the_geom_pol;
	END IF;
		
	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN

		-- Node_id
		IF (NEW.node_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			NEW.node_id:= (SELECT nextval('urn_id_seq'));
		END IF;

		-- set and get id for polygon
		IF v_doublegeometry THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			v_new_pol_id:= (SELECT nextval('urn_id_seq'));
		END IF;

		-- get sys type for parent table
		IF v_man_table = 'parent' THEN
			v_sys_type := (SELECT type FROM cat_feature_node JOIN cat_node ON cat_node.node_type=cat_feature_node.id WHERE cat_node.id = NEW.nodecat_id);
		END IF;

		-- Node type
		IF (NEW.node_type IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_feature_node) = 0 ) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1004", "function":"1220","debug_msg":null}}$$);';
			END IF;
            
 			If v_customfeature IS NOT NULL THEN
 				NEW.node_type:=v_customfeature;
 			ELSE
				NEW.node_type:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_nodetype_vdefault' AND "cur_user"="current_user"() LIMIT 1);
			END IF;

			IF (NEW.node_type IS NULL) AND v_man_table='parent' THEN
				NEW.node_type:= (SELECT id FROM cat_feature_node LIMIT 1);

			ELSIF (NEW.node_type IS NULL) AND v_man_table !='parent' THEN
				NEW.node_type:= (SELECT id FROM cat_feature_node WHERE man_table=v_type_v_man_table LIMIT 1);
			END IF;
		END IF;

		-- Epa type
		IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM cat_feature_node WHERE id=NEW.node_type LIMIT 1)::text;   
		END IF;

		-- Node catalog
		IF (NEW.nodecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1006", "function":"1220","debug_msg":null}}$$);'; 
			END IF;      
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_nodecat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM exploitation) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"1110", "function":"1220","debug_msg":null}}$$);';
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
				"data":{"message":"2012", "function":"1220","debug_msg":"'||NEW.node_id::text||'"}}$$);';
			END IF;            
		END IF;
		
		-- Sector
		IF (NEW.sector_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM sector) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"1008", "function":"1220","debug_msg":null}}$$);';
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
			
			-- control error when no value
			IF (NEW.sector_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1010", "function":"1220","debug_msg":"'||NEW.node_id::text||'"}}$$);';
			END IF;            
		END IF;
		
		-- Dma
		IF (NEW.dma_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"1012", "function":"1220","debug_msg":null}}$$);';
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
			
			-- control error when no value
			IF (NEW.dma_id IS NULL) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"1014", "function":"1220","debug_msg":"'||NEW.node_id::text||'"}}$$);';
			END IF;            
		END IF;
		
		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			
			-- control error without any mapzones defined on the table of mapzone
			IF ((SELECT COUNT(*) FROM ext_municipality) = 0) THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		       	"data":{"message":"3110", "function":"1220","debug_msg":null}}$$);';
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
				"data":{"message":"2024", "function":"1220","debug_msg":"'||NEW.node_id::text||'"}}$$);';
			END IF;            
		END IF;
		
		-- Verified
		IF (NEW.verified IS NULL) THEN
			NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_verified_vdefault' AND "cur_user"="current_user"() LIMIT 1);
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
			"data":{"message":"3036", "function":"1220","debug_msg":"'||v_sql::text||'"}}$$);';
		END IF;
	
		--Inventory	
		NEW.inventory := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_inventory_sysvdefault');

		--Publish
		NEW.publish := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_publish_sysvdefault');	

		--Uncertain
		NEW.uncertain := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_uncertain_sysvdefault');		
		
		-- code autofill
		SELECT code_autofill INTO v_code_autofill_bool FROM cat_feature WHERE id=NEW.node_type;
		
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

		-- Link
		IF (SELECT "value" FROM config_param_system WHERE "parameter"='edit_feature_usefid_on_linkid')::boolean=TRUE THEN
			NEW.link=NEW.node_id;
		END IF;
		
		v_featurecat = NEW.node_type;

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
		IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.top_elev IS NULL) AND
			(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_insert_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
			NEW.top_elev = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM v_ext_raster_dem WHERE id =
				(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
		END IF; 

		
		-- feature insert
		IF v_matfromcat THEN
			INSERT INTO node (node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",
			dma_id,soilcat_id, function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode, district_id, streetaxis2_id,postnumber, postnumber2, postcomplement, postcomplement2, descript,rotation,link,verified,
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value, lastupdate, lastupdate_user)
			VALUES (NEW.node_id,NEW.code, NEW.top_elev,NEW.custom_top_elev, NEW.ymax, NEW. custom_ymax, NEW. elev, NEW. custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id, 
			NEW.state, NEW.state_type, NEW.annotation,NEW.observ, NEW.comment,NEW.dma_id,NEW.soilcat_id, NEW. function_type, NEW.category_type,NEW.fluid_type,NEW.location_type,
			NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id,NEW.builtdate, NEW.enddate, NEW.ownercat_id,
			NEW.muni_id, v_streetaxis, NEW.postcode, NEW.district_id,v_streetaxis2,NEW.postnumber,NEW.postnumber2, NEW.postcomplement, NEW.postcomplement2,
			NEW.descript, NEW.rotation,NEW.link, NEW.verified, NEW.undelete, NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom,
			NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.xyz_date, NEW.unconnected, NEW.num_value, now(), current_user);	
		ELSE
			INSERT INTO node 
			(node_id, code, top_elev, custom_top_elev, ymax, custom_ymax, elev, custom_elev, node_type,nodecat_id,epa_type,sector_id,"state", state_type, annotation,observ,"comment",
			dma_id,soilcat_id, function_type, category_type,fluid_type,location_type,workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id,
			muni_id, streetaxis_id, postcode, district_id, streetaxis2_id,postnumber, postnumber2, postcomplement, postcomplement2, descript,rotation,link,verified,
			undelete,label_x,label_y,label_rotation,the_geom, expl_id, publish, inventory, uncertain, xyz_date, unconnected, num_value, lastupdate, lastupdate_user, matcat_id)
			VALUES (NEW.node_id,NEW.code, NEW.top_elev,NEW.custom_top_elev, NEW.ymax, NEW. custom_ymax, NEW. elev, NEW. custom_elev, NEW.node_type,NEW.nodecat_id,NEW.epa_type,NEW.sector_id, 
			NEW.state, NEW.state_type, NEW.annotation,NEW.observ, NEW.comment,NEW.dma_id,NEW.soilcat_id, NEW. function_type, NEW.category_type,NEW.fluid_type,NEW.location_type,
			NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id,NEW.builtdate, NEW.enddate, NEW.ownercat_id,
			NEW.muni_id, v_streetaxis, NEW.postcode, NEW.district_id, v_streetaxis2,NEW.postnumber,NEW.postnumber2, NEW.postcomplement, NEW.postcomplement2,
			NEW.descript, NEW.rotation,NEW.link, NEW.verified, NEW.undelete, NEW.label_x,NEW.label_y,NEW.label_rotation,NEW.the_geom,
			NEW.expl_id, NEW.publish, NEW.inventory, NEW.uncertain, NEW.xyz_date, NEW.unconnected, NEW.num_value, now(), current_user, NEW.matcat_id);	
		END IF;
				
		IF v_man_table='man_junction' THEN
					
			INSERT INTO man_junction (node_id) VALUES (NEW.node_id);
			        
		ELSIF v_man_table='man_outfall' THEN

			INSERT INTO man_outfall (node_id, name) VALUES (NEW.node_id,NEW.name);
        
		ELSIF v_man_table='man_valve' THEN

			INSERT INTO man_valve (node_id, name) VALUES (NEW.node_id,NEW.name);	
		
		ELSIF v_man_table='man_storage' THEN
			
			IF v_doublegeometry THEN
				INSERT INTO polygon(pol_id, sys_type, the_geom) 
				VALUES (v_new_pol_id, 'STORAGE', (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_doublegeom_buffer))) from node where node_id=NEW.node_id));		
			END IF;

			INSERT INTO man_storage (node_id, pol_id, length, width, custom_area, max_volume, util_volume, min_height, accessibility, name)
			VALUES(NEW.node_id, v_new_pol_id, NEW.length, NEW.width,NEW.custom_area, NEW.max_volume, NEW.util_volume, NEW.min_height,NEW.accessibility, NEW.name);
						
		ELSIF v_man_table='man_netgully' THEN

			IF v_doublegeometry THEN
				INSERT INTO polygon(pol_id, sys_type, the_geom) 
				VALUES (v_new_pol_id, 'NETGULLY', (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_doublegeom_buffer))) from node where node_id=NEW.node_id));
			END IF;
			
			INSERT INTO man_netgully (node_id, pol_id, sander_depth, gratecat_id, units, groove, siphon ) 
			VALUES(NEW.node_id, v_new_pol_id, NEW.sander_depth, NEW.gratecat_id, NEW.units, 
			NEW.groove, NEW.siphon );
									 			
		ELSIF v_man_table='man_chamber' THEN

			IF v_doublegeometry THEN
				INSERT INTO polygon(pol_id, sys_type, the_geom) 
				VALUES (v_new_pol_id, 'CHAMBER', (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_doublegeom_buffer))) from node where node_id=NEW.node_id));
			END IF;

			INSERT INTO man_chamber (node_id, pol_id, length, width, sander_depth, max_volume, util_volume, inlet, bottom_channel, accessibility, name)
			VALUES (NEW.node_id, v_new_pol_id, NEW.length,NEW.width, NEW.sander_depth, NEW.max_volume, NEW.util_volume, 
			NEW.inlet, NEW.bottom_channel, NEW.accessibility,NEW.name);
						
		ELSIF v_man_table='man_manhole' THEN
		
			INSERT INTO man_manhole (node_id,length, width, sander_depth,prot_surface, inlet, bottom_channel, accessibility) 
			VALUES (NEW.node_id,NEW.length, NEW.width, NEW.sander_depth,NEW.prot_surface, NEW.inlet, NEW.bottom_channel, NEW.accessibility);	
		
		ELSIF v_man_table='man_netinit' THEN
			
			INSERT INTO man_netinit (node_id,length, width, inlet, bottom_channel, accessibility, name) 
			VALUES (NEW.node_id, NEW.length,NEW.width,NEW.inlet, NEW.bottom_channel, NEW.accessibility, NEW.name);
			
		ELSIF v_man_table='man_wjump' THEN
	
			INSERT INTO man_wjump (node_id, length, width,sander_depth,prot_surface, accessibility, name) 
			VALUES (NEW.node_id, NEW.length,NEW.width, NEW.sander_depth,NEW.prot_surface,NEW.accessibility, NEW.name);	

		ELSIF v_man_table='man_wwtp' THEN
		
			IF v_doublegeometry THEN
				INSERT INTO polygon(pol_id, sys_type, the_geom) VALUES (v_new_pol_id, 'WWTP', (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_doublegeom_buffer)))
				from node where node_id=NEW.node_id));
			END IF;
			
			INSERT INTO man_wwtp (node_id,pol_id, name) VALUES (NEW.node_id, v_new_pol_id, NEW.name);
						
		ELSIF v_man_table='man_netelement' THEN
					
			INSERT INTO man_netelement (node_id, serial_number) VALUES(NEW.node_id, NEW.serial_number);		
		
		ELSIF v_man_table='parent' THEN

			v_man_table:= (SELECT man_table FROM cat_feature_node WHERE id=NEW.node_type);
			v_sql:= 'INSERT INTO '||v_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
			EXECUTE v_sql;

			--insert double geometry
			IF (v_man_table IN ('man_chamber', 'man_storage', 'man_wwtp','man_netgully') and (v_doublegeometry IS TRUE)) THEN
					
				v_sys_type := (SELECT type FROM cat_feature_node JOIN cat_node ON cat_node.node_type=cat_feature_node.id WHERE cat_node.id = NEW.nodecat_id);

				INSERT INTO polygon(pol_id, sys_type, the_geom) 
				VALUES (v_new_pol_id, v_sys_type, (SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,v_doublegeom_buffer))) 
				from node where node_id=NEW.node_id));
	
				EXECUTE 'UPDATE '||v_man_table||' SET pol_id = '''||v_new_pol_id||''' WHERE node_id = '''||NEW.node_id||''';';
			END IF;
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
						USING NEW.node_id, v_addfields.id, v_new_value_param;
				END IF;	
			END LOOP;
		END IF;			

		-- epa type
		IF (NEW.epa_type = 'JUNCTION') THEN
			INSERT INTO inp_junction (node_id, y0, ysur, apond) VALUES (NEW.node_id, 0, 0, 0);
		ELSIF (NEW.epa_type = 'DIVIDER') THEN
			INSERT INTO inp_divider (node_id, divider_type) VALUES (NEW.node_id, 'CUTOFF');
		ELSIF (NEW.epa_type = 'OUTFALL') THEN
			INSERT INTO inp_outfall (node_id, outfall_type) VALUES (NEW.node_id, 'NORMAL');			
		ELSIF (NEW.epa_type = 'STORAGE') THEN
			INSERT INTO inp_storage (node_id, storage_type) VALUES (NEW.node_id, 'TABULAR');	
		END IF;
			  
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
	
		-- epa type
		IF (NEW.epa_type != OLD.epa_type) THEN    
			IF (OLD.epa_type = 'JUNCTION') THEN
				v_inp_table:= 'inp_junction';            
			ELSIF (OLD.epa_type = 'DIVIDER') THEN
				v_inp_table:= 'inp_divider';                
			ELSIF (OLD.epa_type = 'OUTFALL') THEN
				v_inp_table:= 'inp_outfall';    
			ELSIF (OLD.epa_type = 'STORAGE') THEN
				v_inp_table:= 'inp_storage';    
			END IF;
		
			IF v_inp_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||v_inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
				EXECUTE v_sql;
			END IF;
		    
			v_inp_table := NULL;

			IF (NEW.epa_type = 'JUNCTION') THEN
				v_inp_table:= 'inp_junction';   
			ELSIF (NEW.epa_type = 'DIVIDER') THEN
				v_inp_table:= 'inp_divider';     
			ELSIF (NEW.epa_type = 'OUTFALL') THEN
				v_inp_table:= 'inp_outfall';  
			ELSIF (NEW.epa_type = 'STORAGE') THEN
				v_inp_table:= 'inp_storage';
			END IF;
			IF v_inp_table IS NOT NULL THEN
				v_sql:= 'INSERT INTO '||v_inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
				EXECUTE v_sql;
			END IF;
		END IF;

		-- node type
		IF (NEW.node_type <> OLD.node_type) THEN 
			v_new_v_man_table:= (SELECT man_table FROM cat_feature_node WHERE id = NEW.node_type);
			v_old_v_man_table:= (SELECT man_table FROM cat_feature_node WHERE id = OLD.node_type);
			IF v_new_v_man_table IS NOT NULL THEN
				v_sql:= 'DELETE FROM '||v_old_v_man_table||' WHERE node_id= '||quote_literal(OLD.node_id);
				EXECUTE v_sql;
				v_sql:= 'INSERT INTO '||v_new_v_man_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
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
			"data":{"message":"2110", "function":"1220","debug_msg":null}}$$);';
					END IF;
				END IF;
			END IF;
		END IF;
		
		--check relation state - state_type
		IF (NEW.state_type != OLD.state_type) AND NEW.state_type NOT IN (SELECT id FROM value_state_type WHERE state = NEW.state) THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3036", "function":"1220","debug_msg":"'||NEW.state::text||'"}}$$);';
		END IF;		

		-- rotation
		IF NEW.rotation != OLD.rotation THEN
			UPDATE node SET rotation=NEW.rotation WHERE node_id = OLD.node_id;
		END IF;		
			
		-- The geom
		IF st_equals( NEW.the_geom, OLD.the_geom) IS FALSE AND geometrytype(NEW.the_geom)='POINT'  THEN
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;

			--update elevation from raster
			IF (SELECT upper(value) FROM config_param_system WHERE parameter='admin_raster_dem') = 'TRUE' AND (NEW.top_elev = OLD.top_elev) AND
			(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_update_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
				NEW.top_elev = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM v_ext_raster_dem WHERE id =
							(SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
			END IF;

			--update associated geometry of element (if exists)
			UPDATE element SET the_geom = NEW.the_geom WHERE St_dwithin(OLD.the_geom, the_geom, 0.001) 
			AND element_id IN (SELECT element_id FROM element_x_node WHERE node_id = NEW.node_id);		
			
		ELSIF st_equals( NEW.the_geom, OLD.the_geom) IS FALSE AND geometrytype(NEW.the_geom)='MULTIPOLYGON'  THEN
			UPDATE polygon SET the_geom=NEW.the_geom WHERE pol_id = OLD.pol_id;
		END IF;
			
		--link_path
		SELECT link_path INTO v_link_path FROM cat_feature WHERE id=NEW.node_type;
		IF v_link_path IS NOT NULL THEN
			NEW.link = replace(NEW.link, v_link_path,'');
		END IF;

		IF NEW.rotation != OLD.rotation THEN
			UPDATE node SET rotation=NEW.rotation WHERE node_id = OLD.node_id;
		END IF;

		-- Update of topocontrol fields only when one if it has changed in order to prevent to be triggered the topocontrol without changes
		IF  (NEW.top_elev <> OLD.top_elev) OR (NEW.custom_top_elev <> OLD.custom_top_elev) OR (NEW.ymax <> OLD.ymax) OR 
			(NEW.custom_ymax <> OLD.custom_ymax) OR (NEW.elev <> OLD.elev)  OR (NEW.custom_elev <> OLD.custom_elev) OR
			(NEW.top_elev IS NULL AND OLD.top_elev IS NOT NULL) OR (NEW.top_elev IS NOT NULL AND OLD.top_elev IS NULL) OR
			(NEW.custom_top_elev IS NULL AND OLD.custom_top_elev IS NOT NULL) OR (NEW.custom_top_elev IS NOT NULL AND OLD.custom_top_elev IS NULL) OR
			(NEW.ymax IS NULL AND OLD.ymax IS NOT NULL) OR (NEW.ymax IS NOT NULL AND OLD.ymax IS NULL) OR
			(NEW.custom_ymax IS NULL AND OLD.custom_ymax IS NOT NULL) OR (NEW.custom_ymax IS NOT NULL AND OLD.custom_ymax IS NULL) OR
			(NEW.elev IS NULL AND OLD.elev IS NOT NULL) OR (NEW.elev IS NOT NULL AND OLD.elev IS NULL) OR
			(NEW.custom_elev IS NULL AND OLD.custom_elev IS NOT NULL) OR (NEW.custom_elev IS NOT NULL AND OLD.custom_elev IS NULL) THEN			
				UPDATE	node SET top_elev=NEW.top_elev, custom_top_elev=NEW.custom_top_elev, ymax=NEW.ymax, custom_ymax=NEW.custom_ymax, elev=NEW.elev, custom_elev=NEW.custom_elev
				WHERE node_id = OLD.node_id;
		END IF;
		
		IF v_matfromcat THEN
			UPDATE node 
			SET code=NEW.code, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.annotation, 
			"observ"=NEW.observ, "comment"=NEW.comment, dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type,fluid_type=NEW.fluid_type, 
			location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate,
			ownercat_id=NEW.ownercat_id, postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, muni_id=NEW.muni_id, 
			streetaxis_id=v_streetaxis, postcode=NEW.postcode, district_id=NEW.district_id,
			streetaxis2_id=v_streetaxis2, postnumber=NEW.postnumber, postnumber2=NEW.postnumber2, descript=NEW.descript, link=NEW.link, verified=NEW.verified, undelete=NEW.undelete, 
			label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, rotation=NEW.rotation, uncertain=NEW.uncertain,
			xyz_date=NEW.xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.num_value, lastupdate=now(), lastupdate_user=current_user
			WHERE node_id = OLD.node_id;
		ELSE
			UPDATE node 
			SET code=NEW.code, node_type=NEW.node_type, nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, state_type=NEW.state_type, annotation=NEW.annotation, 
			"observ"=NEW.observ, "comment"=NEW.comment, dma_id=NEW.dma_id, soilcat_id=NEW.soilcat_id, function_type=NEW.function_type, category_type=NEW.category_type,fluid_type=NEW.fluid_type, 
			location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate,
			ownercat_id=NEW.ownercat_id, postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, muni_id=NEW.muni_id, 
			streetaxis_id=v_streetaxis, postcode=NEW.postcode, district_id=NEW.district_id,
			streetaxis2_id=v_streetaxis2, postnumber=NEW.postnumber, postnumber2=NEW.postnumber2, descript=NEW.descript, link=NEW.link, verified=NEW.verified, undelete=NEW.undelete, 
			label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, rotation=NEW.rotation, uncertain=NEW.uncertain,
			xyz_date=NEW.xyz_date, unconnected=NEW.unconnected, expl_id=NEW.expl_id, num_value=NEW.num_value, lastupdate=now(), lastupdate_user=current_user, matcat_id = NEW.matcat_id
			WHERE node_id = OLD.node_id;		
		END IF;
			
		IF v_man_table ='man_junction' THEN			
			UPDATE man_junction SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_netgully' THEN

			-- update geom polygon
			IF NEW.gratecat_id != OLD.gratecat_id OR OLD.gratecat_id IS NULL THEN
				UPDATE polygon SET the_geom = v_the_geom_pol WHERE pol_id = NEW.pol_id;
			END IF;

			UPDATE man_netgully SET pol_id=NEW.pol_id, sander_depth=NEW.sander_depth, gratecat_id=NEW.gratecat_id, units=NEW.units, groove=NEW.groove, siphon=NEW.siphon
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_outfall' THEN
			UPDATE man_outfall SET name=NEW.name
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_storage' THEN
			UPDATE man_storage SET pol_id=NEW.pol_id, length=NEW.length, width=NEW.width, custom_area=NEW.custom_area, 
			max_volume=NEW.max_volume, util_volume=NEW.util_volume,min_height=NEW.min_height, 
			accessibility=NEW.accessibility, name=NEW.name
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_valve' THEN
			UPDATE man_valve SET name=NEW.name
			WHERE node_id=OLD.node_id;
		
		ELSIF v_man_table='man_chamber' THEN
			UPDATE man_chamber SET pol_id=NEW.pol_id, length=NEW.length, width=NEW.width, sander_depth=NEW.sander_depth, max_volume=NEW.max_volume, util_volume=NEW.util_volume,
			inlet=NEW.inlet, bottom_channel=NEW.bottom_channel, accessibility=NEW.accessibility, name=NEW.name
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_manhole' THEN
			UPDATE man_manhole SET length=NEW.length, width=NEW.width, sander_depth=NEW.sander_depth, prot_surface=NEW.prot_surface, 
			inlet=NEW.inlet, bottom_channel=NEW.bottom_channel, accessibility=NEW.accessibility
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_netinit' THEN
			UPDATE man_netinit SET length=NEW.length, width=NEW.width, inlet=NEW.inlet, bottom_channel=NEW.bottom_channel, accessibility=NEW.accessibility, name=NEW.name
			WHERE node_id=OLD.node_id;
			
		ELSIF v_man_table='man_wjump' THEN
			UPDATE man_wjump SET length=NEW.length, width=NEW.width, sander_depth=NEW.sander_depth, prot_surface=NEW.prot_surface, accessibility=NEW.accessibility, name=NEW.name
			WHERE node_id=OLD.node_id;
		
		ELSIF v_man_table='man_wwtp' THEN
			UPDATE man_wwtp SET pol_id=NEW.pol_id, name=NEW.name
			WHERE node_id=OLD.node_id;
				
		ELSIF v_man_table ='man_netelement' THEN
			UPDATE man_netelement SET serial_number=NEW.serial_number
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
		
    ELSIF TG_OP = 'DELETE' THEN

		EXECUTE 'SELECT gw_fct_getcheckdelete($${"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{"id":"'||OLD.node_id||'","featureType":"NODE"}, "data":{}}$$)';

		-- delete from polygon table (before the deletion of node)
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_chamber WHERE node_id=OLD.node_id );
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_storage WHERE node_id=OLD.node_id );
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_wwtp WHERE node_id=OLD.node_id );
		DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_netgully WHERE node_id=OLD.node_id );
		
		-- delete from note table
		DELETE FROM node WHERE node_id = OLD.node_id;

		--Delete addfields (after or before deletion of node, doesn't matter)
		DELETE FROM man_addfields_value WHERE feature_id = OLD.node_id;

		RETURN NULL;	
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;