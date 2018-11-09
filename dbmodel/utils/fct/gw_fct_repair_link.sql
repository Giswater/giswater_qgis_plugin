/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2534

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_link( p_link_id integer, counter bigint default 0, total bigint default 0)
RETURNS character varying AS

$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_repair_link(link_id, (row_number() over (order by link_id)), (select count(*) from SCHEMA_NAME.link)) FROM SCHEMA_NAME.link
*/

DECLARE

v_connec record;
v_link record;
v_arc record;
v_id integer;
v_end_point public.geometry;
v_status text ;

BEGIN
	-- set set path
	SET search_path='SCHEMA_NAME', public;

	-- get values
	SELECT * INTO v_link FROM link WHERE link_id=p_link_id;

	-- delete vnode
	IF v_link.exit_type='VNODE' THEN
		DELETE FROM vnode WHERE vnode_id=v_link.exit_id::integer;
	END IF;
	
	-- reconnect to connec (if exists)
	SELECT connec.* INTO v_connec FROM connec WHERE ST_DWithin(ST_startpoint(v_link.the_geom), connec.the_geom, 0.5)
	ORDER BY ST_Distance(connec.the_geom, ST_startpoint(v_link.the_geom)) LIMIT 1;
	
	IF v_connec IS NOT NULL THEN 
		-- Update the start point link geometry
		UPDATE link SET the_geom = ST_SetPoint(v_link.the_geom, 0, v_connec.the_geom) WHERE link_id = p_link_id;
		-- update link values
		UPDATE link SET feature_type='CONNEC', feature_id= v_connec.connec_id WHERE link_id=p_link_id;
	END IF;

	IF v_connec.connec_id IS NULL THEN 

		-- reconnect to connec and reverse geometry (if exists)
		SELECT connec.* INTO v_connec FROM connec WHERE ST_DWithin(ST_endpoint(v_link.the_geom), connec.the_geom, 0.5)
		ORDER BY ST_Distance(connec.the_geom, ST_endpoint(v_link.the_geom)) LIMIT 1;

		IF v_connec IS NOT NULL THEN 
			-- reverse geometry
			UPDATE link SET the_geom = ST_reverse(the_geom) WHERE link_id=p_link_id;
			-- Update the start point link geometry
			UPDATE link SET the_geom = ST_SetPoint(v_link.the_geom, 0, v_connec.the_geom) WHERE link_id = p_link_id;
			-- update link values
			UPDATE link SET feature_type='CONNEC', feature_id= v_connec.connec_id WHERE link_id=p_link_id;			
		END IF;
	END IF;

	IF v_connec.connec_id IS NOT NULL THEN

		-- reconnect to arc
		-- getting arc with infinity buffer
		WITH index_query AS(
			SELECT ST_Distance(the_geom, v_link.the_geom) as d, arc.* FROM arc ORDER BY the_geom <-> v_link.the_geom LIMIT 5)
			SELECT * INTO v_arc FROM index_query ORDER BY d limit 1;
			
		-- Update the end point link geometry
		v_end_point = (ST_ClosestPoint(v_arc.the_geom, (ST_endpoint(v_link.the_geom))));
		v_link.the_geom = (ST_SetPoint(v_link.the_geom, ST_NumPoints(v_link.the_geom) - 1, v_end_point));
	
		UPDATE link SET the_geom = v_link.the_geom WHERE link_id = p_link_id;

		-- insert vnode on the end point geometry
		INSERT INTO vnode (vnode_type, sector_id, state, expl_id, the_geom) VALUES ('CUSTOM', v_connec.sector_id, v_connec.state, v_connec.expl_id, v_end_point) RETURNING vnode_id INTO v_id;

		-- update link values
		UPDATE link SET exit_id= v_id WHERE link_id=p_link_id;

		-- update connec values
		UPDATE connec SET arc_id= v_arc.arc_id WHERE connec_id=v_connec.connec_id; 

		v_status = 'RECONNECTED';

	ELSE
		-- INSERT ON LOG TABLE THE LINK NOT FOUNDED WITH CONNEC CLOSE TO IT
		v_status = 'No connec founded. Nothing done';

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