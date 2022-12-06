/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2938

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_plan_psector_link()
  RETURNS trigger AS
$BODY$


DECLARE 
    
v_link_geom public.geometry;
v_table_name text;
v_feature_geom public.geometry;
v_point_aux public.geometry;
v_idlink text;
v_channel text;
v_schemaname text;
v_arc_id text;
v_projecttype text;
v_exit_type text;
v_connect text;
v_featuretype text;
v_arc record;
v_link integer;
v_feature text;
	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_table_name:= TG_ARGV[0];
	v_schemaname='SCHEMA_NAME';
	v_projecttype = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
	
	IF NEW.arc_id='' THEN NEW.arc_id=NULL; END IF;

	-- getting variables in function of table
	IF v_table_name = 'connec' THEN
		v_featuretype = 'CONNEC';
		v_feature = NEW.connec_id;
		v_feature_geom = (SELECT the_geom FROM connec WHERE connec_id = NEW.connec_id);

	ELSIF v_table_name = 'gully' THEN
		v_featuretype = 'GULLY';
		v_feature = NEW.gully_id;
		v_feature_geom = (SELECT the_geom FROM gully WHERE gully_id = NEW.gully_id);
	END IF;

	SELECT * INTO v_arc FROM arc WHERE arc_id = NEW.arc_id;

	-- executing options
	IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') AND NEW.state = 0 THEN

		IF v_table_name = 'connec' THEN
			v_link = (SELECT link_id FROM link WHERE feature_id = NEW.connec_id AND state = 1);
			UPDATE plan_psector_x_connec SET link_id = v_link WHERE id = NEW.id;
			
		ELSIF v_table_name = 'gully' THEN
			v_link = (SELECT link_id FROM link WHERE feature_id = NEW.gully_id AND state = 1);
			UPDATE plan_psector_x_gully SET link_id = v_link WHERE id = NEW.id;
		END IF;	

	ELSIF TG_OP = 'INSERT' AND NEW.state = 1 THEN 
	
		IF NEW.arc_id IS NOT NULL THEN

			-- link ID
			v_link := (SELECT nextval('link_link_id_seq'));
			v_link_geom := ST_ShortestLine(v_feature_geom, v_arc.the_geom);
		
			IF v_projecttype = 'WS' THEN
				INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom, sector_id, fluid_type, dma_id, dqa_id, 
				presszone_id, minsector_id)
				VALUES (v_link, v_featuretype, v_feature, v_arc.expl_id, NEW.arc_id, 'ARC', FALSE, 2, v_link_geom, v_arc.sector_id, v_arc.fluid_type, v_arc.dma_id, v_arc.dqa_id, 
				v_arc.presszone_id, v_arc.minsector_id);
			ELSIF  v_projecttype = 'UD' THEN
				INSERT INTO link (link_id, feature_type, feature_id, expl_id, exit_id, exit_type, userdefined_geom, state, the_geom, sector_id, fluid_type, dma_id)
				VALUES (v_link, v_featuretype, v_feature,v_arc.expl_id, NEW.arc_id, 'ARC', FALSE, 2, v_link_geom, v_arc.sector_id, v_arc.fluid_type, v_arc.dma_id);
			END IF;

			UPDATE plan_psector_x_connec SET link_id = v_link WHERE id = NEW.id;
		END IF;

	ELSIF TG_OP = 'UPDATE' AND NEW.state = 1 AND COALESCE(NEW.arc_id,'') != COALESCE(OLD.arc_id,'') THEN

		SELECT * INTO v_arc FROM arc WHERE arc_id = NEW.arc_id;
		SELECT the_geom INTO v_link_geom FROM link WHERE link_id = NEW.link_id;

		-- getting the new geometry of link
		IF  (SELECT exit_type FROM link WHERE link_id = NEW.link_id) = 'ARC' THEN
			IF (SELECT userdefined_geom FROM link WHERE link_id = NEW.link_id) IS FALSE THEN
				v_link_geom := ST_ShortestLine(v_feature_geom, v_arc.the_geom);

			ELSIF (SELECT userdefined_geom FROM link WHERE link_id = NEW.link_id) IS TRUE THEN 
				IF v_link_geom IS NULL THEN v_link_geom := ST_ShortestLine(v_feature_geom, v_arc.the_geom); END IF;
				v_point_aux := St_closestpoint(v_arc.the_geom, St_endpoint(v_link_geom));
				v_link_geom  := ST_SetPoint(v_link_geom, ST_NumPoints(v_link_geom) - 1, v_point_aux);
			END IF;
			
			IF v_projecttype = 'WS' THEN
				UPDATE link SET the_geom = v_link_geom, exit_id = v_arc.arc_id, exit_type='ARC', sector_id = v_arc.sector_id, fluid_type = v_arc.fluid_type, 
				dma_id = v_arc.dma_id, dqa_id = v_arc.dqa_id, presszone_id = v_arc.presszone_id, minsector_id = v_arc.minsector_id
				WHERE link_id = NEW.link_id;
			
			ELSIF v_projecttype = 'UD' THEN
				UPDATE link SET the_geom = v_link_geom, exit_id = v_arc.arc_id, exit_type='ARC', sector_id = v_arc.sector_id, fluid_type = v_arc.fluid_type, 
				dma_id = v_arc.dma_id WHERE link_id = NEW.link_id;
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

	RETURN NEW;

END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;