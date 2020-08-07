/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2534
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_repair_link(integer, bigint , bigint);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_link_repair( p_link_id integer, counter bigint default 0, total bigint default 0)
RETURNS character varying AS

$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_link_repair(link_id, (row_number() over (order by link_id)), (select count(*) from SCHEMA_NAME.link)) FROM SCHEMA_NAME.link;
*/

DECLARE

v_connec record;
v_gully record;
v_link record;
v_arc record;
v_node record;
v_id integer;
v_end_point public.geometry;
v_status text ;

BEGIN

	-- set set path
	SET search_path='SCHEMA_NAME', public;

	-- get values
	SELECT * INTO v_link FROM link WHERE link_id=p_link_id;

	-- reconnect links to nodes (any way connec or gully)
	IF v_link.exit_type='NODE' THEN

		-- getting node with infinity buffer
		WITH index_query AS(
			SELECT ST_Distance(the_geom, v_link.the_geom) as d, node.* FROM node WHERE state=1 ORDER BY the_geom <-> v_link.the_geom LIMIT 5)
			SELECT * INTO v_node FROM index_query ORDER BY d limit 1;
			
		-- Update the end point link geometry
		v_end_point = (ST_ClosestPoint(v_node.the_geom, (ST_endpoint(v_link.the_geom))));
		v_link.the_geom = (ST_SetPoint(v_link.the_geom, -1, v_end_point));
	
		UPDATE link SET the_geom = v_link.the_geom WHERE link_id = p_link_id;

		return p_link_id;
		
	ELSIF v_link.exit_type='VNODE' THEN
		DELETE FROM vnode WHERE vnode_id=v_link.exit_id::integer;	
	END IF;

	IF v_link.feature_type = 'CONNEC' THEN
	
		-- reconnect links to only feature (only connec) if it exists
		SELECT connec.* INTO v_connec FROM connec WHERE ST_DWithin(ST_startpoint(v_link.the_geom), connec.the_geom, 0.5)
		ORDER BY ST_Distance(connec.the_geom, ST_startpoint(v_link.the_geom)) LIMIT 1;

		
		IF v_connec.connec_id IS NULL THEN 

			-- reconnect to connec and reverse geometry (if exists)
			SELECT connec.* INTO v_connec FROM connec WHERE ST_DWithin(ST_endpoint(v_link.the_geom), connec.the_geom, 0.5)
			ORDER BY ST_Distance(connec.the_geom, ST_endpoint(v_link.the_geom)) LIMIT 1;

			IF v_connec.connec_id IS NOT NULL THEN 

				-- reverse geometry
				UPDATE link SET the_geom = ST_reverse(the_geom) WHERE link_id=p_link_id;
				-- Update the start point link geometry
				UPDATE link SET the_geom = ST_SetPoint(v_link.the_geom, 0, v_connec.the_geom) WHERE link_id = p_link_id;
				-- update link values
				UPDATE link SET feature_type='CONNEC', feature_id= v_connec.connec_id WHERE link_id=p_link_id;			
			END IF;
		END IF;

		-- reconnect links to arcs
		IF v_connec.connec_id IS NOT NULL THEN

			-- reconnect to arc
			-- getting arc with infinity buffer
			WITH index_query AS(
				SELECT ST_Distance(the_geom, v_link.the_geom) as d, arc.* FROM arc WHERE state=1 ORDER BY the_geom <-> v_link.the_geom LIMIT 5)
				SELECT * INTO v_arc FROM index_query ORDER BY d limit 1;
				
			-- Update the end point link geometry
			v_end_point = (ST_ClosestPoint(v_arc.the_geom, (ST_endpoint(v_link.the_geom))));
			v_link.the_geom = (ST_SetPoint(v_link.the_geom, -1, v_end_point));
	
			UPDATE link SET the_geom = v_link.the_geom WHERE link_id = p_link_id;

			-- insert vnode on the end point geometry
			INSERT INTO vnode (state, the_geom) 
			VALUES (v_connec.state, v_end_point) RETURNING vnode_id INTO v_id;
	
			-- update link values
			UPDATE link SET exit_id= v_id, exit_type='VNODE' WHERE link_id=p_link_id;

			-- update connec values
			UPDATE connec SET arc_id= v_arc.arc_id WHERE connec_id=v_connec.connec_id; 

			-- Update the start point link geometry
			UPDATE link SET the_geom = ST_SetPoint(v_link.the_geom, 0, v_connec.the_geom) WHERE link_id = p_link_id;
			
			-- update link values
			UPDATE link SET feature_type='CONNEC', feature_id= v_connec.connec_id WHERE link_id=p_link_id;

			v_status = 'RECONNECTED';

		ELSE
			-- INSERT ON LOG TABLE THE LINK NOT FOUND WITH CONNEC CLOSE TO IT
			v_status = 'No connec found. Nothing done';

		END IF;

	ELSIF v_link.feature_type = 'GULLY' THEN

		-- reconnect links to only feature (gully) if it exists
		SELECT gully.* INTO v_gully FROM gully WHERE ST_DWithin(ST_startpoint(v_link.the_geom), gully.the_geom, 0.5)
		ORDER BY ST_Distance(gully.the_geom, ST_startpoint(v_link.the_geom)) LIMIT 1;


		IF v_gully.gully_id IS NULL THEN 

			-- reconnect to gully and reverse geometry (if exists)
			SELECT gully.* INTO v_gully FROM gully WHERE ST_DWithin(ST_endpoint(v_link.the_geom), gully.the_geom, 0.5)
			ORDER BY ST_Distance(gully.the_geom, ST_endpoint(v_link.the_geom)) LIMIT 1;


			IF v_gully.gully_id IS NOT NULL THEN 

				-- reverse geometry
				UPDATE link SET the_geom = ST_reverse(the_geom) WHERE link_id=p_link_id;
				-- Update the start point link geometry
				UPDATE link SET the_geom = ST_SetPoint(v_link.the_geom, 0, v_gully.the_geom) WHERE link_id = p_link_id;
				-- update link values
				UPDATE link SET feature_type='GULLY', feature_id= v_gully.gully_id WHERE link_id=p_link_id;			
			END IF;
		END IF;

		-- reconnect links to arcs
		IF v_gully.gully_id IS NOT NULL THEN

			-- reconnect to arc
			-- getting arc with infinity buffer
			WITH index_query AS(
				SELECT ST_Distance(the_geom, v_link.the_geom) as d, arc.* FROM arc WHERE state=1 ORDER BY the_geom <-> v_link.the_geom LIMIT 5)
				SELECT * INTO v_arc FROM index_query ORDER BY d limit 1;
				
			-- Update the end point link geometry
			v_end_point = (ST_ClosestPoint(v_arc.the_geom, (ST_endpoint(v_link.the_geom))));
			v_link.the_geom = (ST_SetPoint(v_link.the_geom, -1, v_end_point));
	
			UPDATE link SET the_geom = v_link.the_geom WHERE link_id = p_link_id;

			-- insert vnode on the end point geometry
			INSERT INTO vnode (state, the_geom) 
			VALUES (v_gully.state, v_end_point) RETURNING vnode_id INTO v_id;
	
			-- update link values
			UPDATE link SET exit_id= v_id, exit_type='VNODE' WHERE link_id=p_link_id;

			-- update connec values
			UPDATE gully SET arc_id= v_arc.arc_id WHERE gully_id=v_gully.gully_id; 

			-- Update the start point link geometry
			UPDATE link SET the_geom = ST_SetPoint(v_link.the_geom, 0, v_gully.the_geom) WHERE link_id = p_link_id;
			
			-- update link values
			UPDATE link SET feature_type='GULLY', feature_id= v_gully.gully_id WHERE link_id=p_link_id;

			v_status = 'RECONNECTED';

		ELSE
			-- INSERT ON LOG TABLE THE LINK NOT FOUND WITH CONNEC CLOSE TO IT
			v_status = 'No gully found. Nothing done';
		END IF;

	END IF;

	-- raise notice
	IF counter>0 AND total>0 THEN
		RAISE NOTICE '[%/%] link id: %, status: % ', counter, total, p_link_id, v_status;
	ELSIF counter>0 THEN
		RAISE NOTICE '[%] link id: %, status: %', counter, p_link_id, v_status;
	ELSE
		RAISE NOTICE 'link id: %, status: %', p_link_id, v_status ;
	END IF;

	RETURN p_link_id;

END; 

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
