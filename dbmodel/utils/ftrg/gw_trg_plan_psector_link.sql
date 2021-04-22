/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2938

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_link()
  RETURNS trigger AS
$BODY$

/*
This trigger CREATES the initial geometry of planned link (always forced for planned connects) working only with links class 3. 
Also UPDATES the link and vnode geometry for psector tables. On create and update works in combination with arc_id
*/

DECLARE 
    
v_link_geom public.geometry;
v_table_name text;
v_feature_geom public.geometry;
v_point_aux public.geometry;
v_arc_geom public.geometry;
v_userdefined_geom boolean;
v_idlink text;
v_idvnode text;
v_channel text;
v_schemaname text;
v_arc_id text;
v_projecttype text;
v_exit_type text;
v_connect text;
	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_table_name:= TG_ARGV[0];
	v_schemaname='SCHEMA_NAME';

	v_projecttype = (SELECT project_type FROM sys_version LIMIT 1);

	IF NEW.arc_id='' THEN NEW.arc_id=NULL; END IF;

	-- getting table and exit_type
	IF v_table_name = 'connec' THEN
		SELECT the_geom INTO v_feature_geom FROM connec WHERE connec_id=NEW.connec_id;
		SELECT exit_type, the_geom INTO v_exit_type, v_link_geom FROM v_edit_link WHERE feature_id =  NEW.connec_id;
		
	ELSIF v_table_name = 'gully' THEN
		SELECT the_geom INTO v_feature_geom FROM gully WHERE gully_id=NEW.gully_id;
		SELECT exit_type, the_geom INTO v_exit_type, v_link_geom FROM v_edit_link WHERE feature_id =  NEW.gully_id;
	END IF;

	IF v_exit_type ='VNODE' THEN -- link_class =  3
	
		-- getting arc_geom
		IF NEW.arc_id IS NOT NULL THEN
			v_arc_geom =  (SELECT the_geom FROM arc WHERE arc_id=NEW.arc_id);
		ELSE
		
			IF v_table_name = 'connec' THEN
				-- getting closest arc
				SELECT a.arc_id INTO v_arc_id FROM v_edit_arc a, v_edit_connec c WHERE st_dwithin(a.the_geom, c.the_geom, 1000) AND connec_id = NEW.connec_id AND a.state > 0
				ORDER BY st_distance (a.the_geom, c.the_geom) LIMIT 1;

				-- this update makes a recall of self.trigger but in this case with NEW.arc_id IS NOT NULL recall will finish next one
				UPDATE plan_psector_x_connec SET arc_id = v_arc_id WHERE id=NEW.id;

				RETURN NEW;
				
			ELSIF v_table_name = 'gully' THEN
				-- getting closest arc
				SELECT a.arc_id INTO v_arc_id FROM v_edit_arc a, v_edit_gully g WHERE st_dwithin(a.the_geom, g.the_geom, 1000) AND gully_id = NEW.gully_id AND a.state > 0
				ORDER BY st_distance (a.the_geom, g.the_geom) LIMIT 1;

				-- this update makes a recall of self.trigger but in this case with NEW.arc_id IS NOT NULL recall will finish next one
				UPDATE plan_psector_x_gully SET arc_id = v_arc_id WHERE id=NEW.id;

				RETURN NEW;
			END IF;	
		END IF;

		IF v_arc_geom IS NOT NULL THEN
	   
			-- update values on plan psector table
			IF NEW.userdefined_geom IS NOT TRUE THEN
				v_link_geom := ST_ShortestLine(v_feature_geom, v_arc_geom);
				v_userdefined_geom=FALSE;
			ELSE	
				v_point_aux := St_closestpoint(v_arc_geom, St_endpoint(v_link_geom));
				v_link_geom  := ST_SetPoint(v_link_geom, ST_NumPoints(v_link_geom) - 1, v_point_aux);
				v_userdefined_geom = TRUE;
			END IF;
					
			-- update plan_psector table			
			IF v_table_name = 'connec' THEN
				UPDATE plan_psector_x_connec SET link_geom=v_link_geom, userdefined_geom=v_userdefined_geom WHERE id=NEW.id;
			ELSIF v_table_name = 'gully' THEN
				UPDATE plan_psector_x_gully SET link_geom=v_link_geom, userdefined_geom=v_userdefined_geom WHERE id=NEW.id;
			END IF;	
		ELSE
			IF v_table_name = 'connec' THEN
				UPDATE plan_psector_x_connec SET link_geom=NULL, userdefined_geom=NULL WHERE id=NEW.id;

			ELSIF v_table_name = 'gully' THEN
				UPDATE plan_psector_x_gully SET link_geom=NULL, userdefined_geom=NULL WHERE id=NEW.id;

			END IF;	
		END IF;
	END IF;

	-- reconnect connects
	IF v_table_name = 'connec' THEN
	
		-- looking for related connecs
		FOR v_connect IN SELECT connec_id FROM connec JOIN link l ON l.feature_id = connec_id WHERE l.feature_type = 'CONNEC' AND exit_type = 'CONNEC' and exit_id = NEW.connec_id
		LOOP
			UPDATE connec SET arc_id = NEW.arc_id WHERE connec_id = v_connect;
			UPDATE plan_psector_x_connec SET arc_id = NEW.arc_id WHERE connec_id = v_connect;
		END LOOP;
		
		-- looking for related gullies
		IF v_projecttype = 'UD' THEN
			FOR v_connect IN SELECT gully_id FROM gully JOIN link l ON l.feature_id = gully_id WHERE l.feature_type = 'GULLY' AND exit_type = 'CONNEC' and exit_id = NEW.connec_id
			LOOP
				UPDATE gully SET arc_id = NEW.arc_id WHERE gully_id = v_connect;
				UPDATE plan_psector_x_gully SET arc_id = NEW.arc_id WHERE gully_id = v_connect;
			END LOOP;
		END IF;	
	
	ELSIF v_table_name = 'gully' THEN
	
		-- looking for related connecs
		FOR v_connect IN SELECT connec_id FROM connec JOIN link l ON l.feature_id = connec_id WHERE l.feature_type = 'CONNEC' AND exit_type = 'GULLY' and exit_id = NEW.gully_id
		LOOP
			UPDATE connec SET arc_id = NEW.arc_id WHERE connec_id = v_connect;
			UPDATE plan_psector_x_connec SET arc_id = NEW.arc_id WHERE connec_id = v_connect;
		END LOOP;
		
		-- looking for related gullies
		FOR v_connect IN SELECT gully_id FROM gully JOIN link l ON l.feature_id = gully_id WHERE l.feature_type = 'GULLY' AND exit_type = 'GULLY' and exit_id = NEW.gully_id
		LOOP
			UPDATE gully SET arc_id = NEW.arc_id WHERE gully_id = v_connect;
			UPDATE plan_psector_x_gully SET arc_id = NEW.arc_id WHERE gully_id = v_connect;
		END LOOP;
		
	END IF;	

	-- notify to qgis in order to reindex geometries for snapping
	v_channel := replace (current_user::text,'.','_');
	PERFORM pg_notify (v_channel, '{"functionAction":{"functions":[{"name":"set_layer_index","parameters":{"tableName":"v_edit_link"}},
	{"name":"refresh_canvas", "parameters":{"tableName":"v_edit_connec"}}],"user":"'	||current_user||'","schema":"'||v_schemaname||'"}}');

	RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;