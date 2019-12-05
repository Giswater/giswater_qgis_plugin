/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2124

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(character varying[], character varying);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_connect_to_network(
    connec_array character varying[],
    feature_type_aux character varying)
  RETURNS integer AS
$BODY$

/*
GOAL:
This function have been refactorized on 2019/04/24 changing the full strategy of vnode and links (according with the trigger of v_edit_vnode)

MAIN CHANGES
- Vnode_type = 'CUSTOM' dissapears. Only 'AUTO' is possible. 
- Vnode geometry is only updateable. It's no posible to create a new one using ToC layer
- It's forbidden to connec links on vnode without arcs.
- Connect_to_network works also with node/connec/gully as endpoints (deprecated)

EXAMPLE:
select SCHEMA_NAME.gw_fct_connect_to_network((select array_agg(connec_id)from SCHEMA_NAME.connec where connec_id IN ('3097')), 'CONNEC')
select SCHEMA_NAME.gw_fct_connect_to_network((select array_agg(connec_id)from SCHEMA_NAME.connec where connec_id='30123237'), 'CONNEC')
select SCHEMA_NAME.gw_fct_connect_to_network((select array_agg(gully_id)from SCHEMA_NAME.gully where gully_id='30108'), 'GULLY')
*/

DECLARE
	v_connect record;
	v_link record;
	v_exit record;
	v_arc record;
	v_vnode record;
	connect_id_aux  varchar;
	v_exit_id text;
	point_aux public.geometry;
	aux_geom public.geometry;
	v_node_proximity double precision;
	v_projecttype text;
	v_endfeature_geom public.geometry;
	v_pjointtype text;
	v_pjointid text;
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='node_proximity';
    IF v_node_proximity IS NULL THEN v_node_proximity=0.01; END IF;

    -- select project type
    SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

    -- Main loop
    IF connec_array IS NOT NULL THEN
	
	FOREACH connect_id_aux IN ARRAY connec_array
	LOOP	
		-- get link information (if exits)
		SELECT * INTO v_link FROM link WHERE feature_id = connect_id_aux AND feature_type=feature_type_aux;

		-- get feature information
		IF feature_type_aux ='CONNEC' THEN          
			SELECT * INTO v_connect FROM connec WHERE connec_id = connect_id_aux;
		ELSIF feature_type_aux ='GULLY' THEN 
			SELECT * INTO v_connect FROM gully WHERE gully_id = connect_id_aux;
		END IF;
		
		--raise exception 'LINK: % CONNECT % ', v_link, v_connect;

		-- exception control. It's no possible to create another link when already exists for the connect
		IF v_connect.state=2 AND v_link.exit_id IS NOT NULL THEN
			IF feature_type_aux = 'CONNEC' THEN
				RAISE EXCEPTION 'The connect2network tool is not enabled to work with connec''s with state=2. For planned connec''s you must to create the links for that connec (one link for each alternative and each connec) by using the psector form and relate the connec using the arc_id field. After that you will can customize the link''s geometry. connec_id: %' ,connect_id_aux;
			ELSIF feature_type_aux = 'GULLY' THEN
				RAISE EXCEPTION 'The connect2network tool is not enabled to work with gully''s with state=2. For planned gully''s you must to create the links for that gully (one link for each alternative and each gully) by using the psector form and relate the gully using the arc_id field. After that you will can customize the link''s geometry. gully_id: %' ,connect_id_aux;
			END IF;
		END IF;

		
		-- get values from old vnode
		SELECT * INTO v_exit FROM vnode WHERE vnode_id::text=v_link.exit_id;
	
		-- get arc_id (if feature does not have) using buffer  
		IF v_connect.arc_id IS NULL AND v_link.exit_id IS NULL THEN
			WITH index_query AS(
			SELECT ST_Distance(the_geom, v_connect.the_geom) as distance, arc_id FROM v_edit_arc WHERE state>0 ORDER BY the_geom <-> v_connect.the_geom LIMIT 50)
			SELECT arc_id INTO v_connect.arc_id FROM index_query ORDER BY distance limit 1;
			
		ELSIF v_connect.arc_id IS NULL AND v_link.exit_id IS NOT NULL THEN
			WITH index_query AS(
			SELECT ST_Distance(the_geom, v_exit.the_geom) as distance, arc_id FROM v_edit_arc WHERE state>0 ORDER BY the_geom <-> v_exit.the_geom LIMIT 50)
			SELECT arc_id INTO v_connect.arc_id FROM index_query ORDER BY distance limit 1;			
		END IF;
			
		-- get v_edit_arc information
		SELECT * INTO v_arc FROM arc WHERE arc_id = v_connect.arc_id;

		raise notice 'v_connect.arc_id %, v_arc: % ', v_connect.arc_id, v_arc;

		-- state control
		IF v_arc.state=2 AND v_connect.state=1 THEN
			RAISE EXCEPTION 'It is not possible to relate connects with state=1 to arcs with state=2. Please check your map';
		END IF;

		-- compute link
		IF v_arc.the_geom IS NOT NULL THEN

			IF v_link.userdefined_geom IS TRUE THEN	

				-- get endfeature geometry
				IF v_link.exit_type='NODE' THEN
					SELECT node_id, the_geom INTO v_pjointid, v_endfeature_geom FROM node WHERE node_id=v_link.exit_id;
					v_pjointtype='NODE';
					
				ELSIF v_link.exit_type='CONNEC' THEN
					SELECT pjoint_type, pjoint_id, the_geom INTO v_pjointtype, v_pjointid, v_endfeature_geom FROM connec WHERE connec_id=v_link.exit_id;

				ELSIF v_link.exit_type='GULLY' THEN
					SELECT pjoint_type, pjoint_id, the_geom INTO v_pjointtype, v_pjointid, v_endfeature_geom FROM gully WHERE gully_id=v_link.exit_id;

				ELSIF v_link.exit_type='VNODE' THEN
					-- in this case whe don't use the v_link record variable because perhaps there is not link
					v_endfeature_geom = v_arc.the_geom;
				END IF;

				-- Reverse (if it's need) the existing link geometry
				IF (st_dwithin (st_startpoint(v_link.the_geom), v_connect.the_geom, 0.01)) IS FALSE THEN
					point_aux := St_closestpoint(v_endfeature_geom, St_startpoint(v_link.the_geom));
					v_link.the_geom = ST_SetPoint(v_link.the_geom, 0, point_aux) ; 
				ELSE
					point_aux := St_closestpoint(v_endfeature_geom, St_endpoint(v_link.the_geom));
					v_link.the_geom = ST_SetPoint(v_link.the_geom, (ST_NumPoints(v_link.the_geom) - 1),point_aux); 
				END IF;
				
			ELSE -- in this case only arc is posible (vnode)
			
				v_link.the_geom := ST_ShortestLine(v_connect.the_geom, v_arc.the_geom);
				v_link.userdefined_geom = FALSE;
				v_link.exit_type = 'VNODE';	
			END IF;

			v_exit.the_geom = ST_EndPoint(v_link.the_geom);
		END IF;

		raise notice 'v_endfeature_geom %',v_endfeature_geom;
		
		IF v_exit.the_geom IS NOT NULL THEN

			-- vnode, only for those links connected to vnode
			IF v_link.exit_type = 'VNODE' THEN
				DELETE FROM vnode WHERE vnode_id=v_exit.vnode_id::integer;			
				INSERT INTO vnode (vnode_id, vnode_type, state, sector_id, dma_id, expl_id, the_geom) 
				VALUES ((SELECT nextval('vnode_vnode_id_seq')), 'AUTO', v_arc.state, v_arc.sector_id, v_arc.dma_id, v_arc.expl_id, v_exit.the_geom) RETURNING vnode_id INTO v_exit_id;	
				v_link.exit_id = v_exit_id;
				v_pjointtype = v_link.exit_type;
				v_link.exit_type = 'VNODE';
				v_pjointid = v_link.exit_id;
			END IF;

			-- link for all links
			DELETE FROM link WHERE link_id=v_link.link_id;
			INSERT INTO link (link_id, the_geom, feature_id, feature_type, exit_type, exit_id, userdefined_geom, state, expl_id) 
			VALUES ((SELECT nextval('link_link_id_seq')), v_link.the_geom, connect_id_aux, feature_type_aux, v_link.exit_type, v_link.exit_id, 
			v_link.userdefined_geom, v_connect.state, v_arc.expl_id);

			IF v_pjointtype IS NULL THEN
				v_pjointtype = 'VNODE';
				v_pjointid = v_exit_id;
			END IF;

			-- Update connect attributes
			IF feature_type_aux ='CONNEC' THEN       
		   
				UPDATE connec SET arc_id=v_connect.arc_id, expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, pjoint_type=v_pjointtype, pjoint_id=v_pjointid
				WHERE connec_id = connect_id_aux;

				-- update specific fields for ws projects
				IF v_projecttype = 'WS' THEN
					UPDATE connec SET dqa_id=v_arc.dqa_id, minsector_id=v_arc.minsector_id,presszonecat_id=v_arc.presszonecat_id WHERE connec_id = connect_id_aux;
				END IF;
			
				-- Update state_type if edit_connect_update_statetype is TRUE
				IF (SELECT ((value::json->>'connec')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
					UPDATE connec SET state_type = (SELECT ((value::json->>'connec')::json->>'state_type')::int2 
					FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE connec_id=connect_id_aux;
				END IF;
			
			ELSIF feature_type_aux ='GULLY' THEN 
				UPDATE gully SET arc_id=v_connect.arc_id, expl_id=v_arc.expl_id, dma_id=v_arc.dma_id, sector_id=v_arc.sector_id, pjoint_type=v_pjointtype, pjoint_id=v_pjointid
				WHERE gully_id = connect_id_aux;

				-- Update state_type if edit_connect_update_statetype is TRUE
				IF (SELECT ((value::json->>'gully')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
					UPDATE gully SET state_type = (SELECT ((value::json->>'gully')::json->>'state_type')::int2 
					FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE gully_id=connect_id_aux;
				END IF;
			END IF;
			
		END IF;

		-- reset values
		v_connect := null;
		v_link := null;
		v_exit := null;
		v_arc := null;
		v_vnode := null;

	END LOOP;

    END IF;

    --PERFORM audit_function(0,2124);
    RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
