/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1114


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_element();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_element()
RETURNS trigger AS
$BODY$
DECLARE 

v_code_autofill_bool boolean;
v_doublegeometry boolean;
v_insert_double_geom boolean;
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
v_srid integer;
v_project_type text;

v_feature text;
v_tablefeature text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- get values
	SELECT ((value::json)->>'activated')::boolean INTO v_insert_double_geom FROM config_param_system WHERE parameter='edit_element_doublegeom';
	SELECT ((value::json)->>'value')::float INTO v_unitsfactor FROM config_param_system WHERE parameter='edit_element_doublegeom';

	IF v_unitsfactor IS NULL THEN
		v_unitsfactor = 1;
	END IF;

	v_srid = (SELECT epsg FROM sys_version limit 1);
	v_project_type = (SELECT project_type FROM sys_version limit 1);

	-- get associated feature
	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
		SELECT node_id, 'node'::text INTO v_feature, v_tablefeature FROM v_edit_node WHERE st_dwithin(the_geom, NEW.the_geom, 0.01);
		IF v_feature IS NULL THEN
			SELECT connec_id, 'connec'::text INTO v_feature, v_tablefeature FROM v_edit_connec WHERE st_dwithin(the_geom, NEW.the_geom, 0.01);
			IF v_feature IS NULL THEN
				SELECT arc_id, 'arc'::text INTO v_feature, v_tablefeature FROM v_edit_arc WHERE st_dwithin(the_geom, NEW.the_geom, 0.01);		
				IF v_feature IS NULL AND v_project_type='UD' THEN
					SELECT gully_id, 'gully'::text INTO v_feature, v_tablefeature FROM v_edit_gully WHERE st_dwithin(the_geom, NEW.the_geom, 0.01);
				END IF;
			END IF;
		END IF;
	END IF;
 	
	-- INSERT
	IF TG_OP = 'INSERT' THEN

		-- element_id
		IF (NEW.element_id IS NULL) THEN
			PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
			NEW.element_id:= (SELECT nextval('urn_id_seq'));
		END IF;

		-- Cat element
		IF (NEW.elementcat_id IS NULL) THEN
			NEW.elementcat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='edit_elementcat_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
	
		-- Verified
		IF (NEW.verified IS NULL) THEN
			NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_verified_vdefault' AND "cur_user"="current_user"() LIMIT 1);
		END IF;
	
		-- State
		IF (NEW.state IS NULL) THEN
			NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_state_vdefault' AND "cur_user"="current_user"());
		END IF;
        
		-- State type
		IF (NEW.state_type IS NULL) THEN
			NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='state_type_vdefault' AND "cur_user"="current_user"());
		END IF;
	
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
       				 "data":{"message":"2012", "function":"1114","debug_msg":"'||NEW.element_id||'"}}$$);';
				END IF;		
			END IF;
		END IF;		

		-- Enddate
		IF (NEW.state > 0) THEN
			NEW.enddate := NULL;
		END IF;

		--Inventory	
		NEW.inventory := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_inventory_sysvdefault');

		--Publish
		NEW.publish := (SELECT "value" FROM config_param_system WHERE "parameter"='edit_publish_sysvdefault');	

		-- Element id 
		IF (NEW.element_id IS NULL) THEN
			NEW.element_id:= (SELECT nextval('urn_id_seq'));
		END IF;
		
		SELECT code_autofill INTO v_code_autofill_bool FROM element_type join cat_element on element_type.id=cat_element.elementtype_id where cat_element.id=NEW.elementcat_id;

		--Copy id to code field
		IF (NEW.code IS NULL AND v_code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.element_id;
		END IF;

		-- LINK
		IF (SELECT "value" FROM config_param_system WHERE "parameter"='edit_automatic_insert_link')::boolean=TRUE THEN
			NEW.link=NEW.element_id;
		END IF;

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

		v_doublegeometry = (SELECT isdoublegeom FROM cat_element WHERE id = NEW.elementcat_id);

		-- double geometry
		IF v_insert_double_geom AND v_doublegeometry AND NEW.elementcat_id IS NOT NULL THEN

			v_length = (SELECT geom1 FROM cat_element WHERE id=NEW.elementcat_id);
			v_width = (SELECT geom2 FROM cat_element WHERE id=NEW.elementcat_id);

			IF v_length IS NULL OR v_length = 0 THEN
			
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3152", "function":"1114","debug_msg":"'||NEW.elementcat_id::text||'"}}$$);';

			ELSIF v_length IS NOT NULL AND (v_width IS NULL OR v_width = 0) THEN

				-- get element dimensions to generate CIRCULARE geometry
				PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
				v_new_pol_id:= (SELECT nextval('urn_id_seq'));
				INSERT INTO polygon(sys_type, the_geom, pol_id) VALUES ('ELEMENT', St_Multi(ST_buffer(NEW.the_geom, v_length*0.01*v_unitsfactor/2)),v_new_pol_id);

			ELSIF v_length*v_width != 0 THEN
 
				-- get element dimensions
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
				
				PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
				v_new_pol_id:= (SELECT nextval('urn_id_seq'));

				INSERT INTO polygon(sys_type, the_geom, pol_id) VALUES ('ELEMENT', v_the_geom_pol, v_new_pol_id);
			END IF;
		END IF;
		
		-- FEATURE INSERT      
		INSERT INTO element (element_id, code, elementcat_id, serial_number, "state", state_type, observ, "comment", function_type, category_type, location_type, 
		workcat_id, workcat_id_end, buildercat_id, builtdate, enddate, ownercat_id, rotation, link, verified, the_geom, label_x, label_y, label_rotation, publish, 
		inventory, undelete, expl_id, num_elements, pol_id)
		VALUES (NEW.element_id, NEW.code, NEW.elementcat_id, NEW.serial_number, NEW."state", NEW.state_type, NEW.observ, NEW."comment", 
		NEW.function_type, NEW.category_type, NEW.location_type, NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, NEW.builtdate, NEW.enddate, 
		NEW.ownercat_id, NEW.rotation, NEW.link, NEW.verified, NEW.the_geom, NEW.label_x, NEW.label_y, NEW.label_rotation, NEW.publish, 
		NEW.inventory, NEW.undelete, NEW.expl_id, NEW.num_elements, v_new_pol_id);

		-- update element_x_feature table
		IF v_tablefeature IS NOT NULL AND v_feature IS NOT NULL THEN
			EXECUTE 'INSERT INTO element_x_'||v_tablefeature||' ('||v_tablefeature||'_id, element_id) VALUES ('||v_feature||','||NEW.element_id||') ON CONFLICT 
			('||v_tablefeature||'_id, element_id) DO NOTHING';
		END IF;
			
		RETURN NEW;			

	-- UPDATE
	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE element
		SET element_id=NEW.element_id, code=NEW.code,  elementcat_id=NEW.elementcat_id, serial_number=NEW.serial_number, "state"=NEW."state", state_type=NEW.state_type, observ=NEW.observ, "comment"=NEW."comment", 
		function_type=NEW.function_type, category_type=NEW.category_type,  location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end, 
		buildercat_id=NEW.buildercat_id, builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, rotation=NEW.rotation, link=NEW.link, verified=NEW.verified, 
		the_geom=NEW.the_geom, label_x=NEW.label_x, label_y=NEW.label_y, label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, undelete=NEW.undelete,expl_id=NEW.expl_id, num_elements=NEW.num_elements,
		lastupdate=now(), lastupdate_user=current_user
		WHERE element_id=OLD.element_id;

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


		v_doublegeometry = (SELECT isdoublegeom FROM cat_element WHERE id = NEW.elementcat_id);

		-- double geometry catalog update
		IF v_insert_double_geom AND v_doublegeometry AND (NEW.elementcat_id != OLD.elementcat_id OR NEW.the_geom::text <> OLD.the_geom::text) THEN

			v_length = (SELECT geom1 FROM cat_element WHERE id=NEW.elementcat_id);
			v_width = (SELECT geom2 FROM cat_element WHERE id=NEW.elementcat_id);


			IF v_length IS NULL OR v_length = 0 THEN
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"3152", "function":"1114","debug_msg":"'||NEW.elementcat_id::text||'"}}$$);';

			ELSIF v_length IS NOT NULL AND (v_width IS NULL OR v_width = 0) THEN

				PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
				v_new_pol_id:= (SELECT nextval('urn_id_seq'));

				-- get element dimensions to generate CIRCULARE geometry
				IF (SELECT pol_id FROM element WHERE element_id = NEW.element_id) IS NULL THEN
					INSERT INTO polygon(sys_type, the_geom, pol_id) VALUES 
					('ELEMENT', St_multi(ST_buffer(NEW.the_geom, v_length*0.01*v_unitsfactor/2)),v_new_pol_id);
					UPDATE element SET pol_id=v_new_pol_id WHERE element_id = NEW.element_id;
				ELSE									
					UPDATE polygon SET the_geom = St_multi(ST_buffer(NEW.the_geom, v_length*0.01*v_unitsfactor/2)) 
					WHERE pol_id = (SELECT pol_id FROM element WHERE element_id = NEW.element_id);
				END IF;

			ELSIF v_length*v_width != 0 THEN

				-- get grate dimensions
				v_unitsfactor = 0.01*v_unitsfactor; -- using 0.01 to convert from cms of catalog  to meters of the map
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

				PERFORM setval('urn_id_seq', gw_fct_setvalurn(),true);
				v_new_pol_id:= (SELECT nextval('urn_id_seq'));

				IF (SELECT pol_id FROM element WHERE element_id = NEW.element_id) IS NULL THEN
					INSERT INTO polygon(sys_type, the_geom,pol_id) VALUES ('ELEMENT', v_the_geom_pol,v_new_pol_id);
					UPDATE element SET pol_id=v_new_pol_id WHERE element_id = NEW.element_id;

				ELSE
					UPDATE polygon SET the_geom = v_the_geom_pol WHERE pol_id = (SELECT pol_id FROM element WHERE element_id = NEW.element_id);
				END IF;
				
			END IF;
		END IF;		

		RETURN NEW;
    
	-- DELETE
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM element WHERE element_id=OLD.element_id;

        RETURN NULL;
   
	END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

