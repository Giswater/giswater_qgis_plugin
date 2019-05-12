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
- Connect_to_network works also with node/connec/gully as endpoints

EXAPLE:
select SCHEMA_NAME.gw_fct_connect_to_network((select array_agg(connec_id)from SCHEMA_NAME.connec where connec_id IN ('3112')), 'CONNEC')
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

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='node_proximity';
    IF v_node_proximity IS NULL THEN v_node_proximity=0.01; END IF;

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
		
		raise notice 'LINK: %', v_link;
		raise notice 'C0NNECT: %', v_connect;

		-- starting process
		IF v_link.exit_type='VNODE' OR v_link.exit_type IS NULL THEN

			-- get values from old vnode
			SELECT * INTO v_exit FROM vnode WHERE vnode_id::text=v_link.exit_id;

			RAISE NOTICE 'vnode %', v_exit;
			RAISE NOTICE 'vnode %', v_exit;

	
			-- get arc_id (if feature does not have) using buffer  
			IF v_connect.arc_id IS NULL AND v_link.exit_id IS NULL THEN
				WITH index_query AS(
				SELECT ST_Distance(the_geom, v_connect.the_geom) as distance, arc_id FROM v_edit_arc WHERE state=1 ORDER BY the_geom <-> v_connect.the_geom LIMIT 10)
				SELECT arc_id INTO v_connect.arc_id FROM index_query ORDER BY distance limit 1;
				
			ELSIF v_connect.arc_id IS NULL AND v_link.exit_id IS NOT NULL THEN
				raise notice 'gashasrfh';
				WITH index_query AS(
				SELECT ST_Distance(the_geom, v_exit.the_geom) as distance, arc_id FROM v_edit_arc WHERE state=1 ORDER BY the_geom <-> v_exit.the_geom LIMIT 10)
				SELECT arc_id INTO v_connect.arc_id FROM index_query ORDER BY distance limit 1;			
			END IF;
			
			-- get v_edit_arc information
			SELECT * INTO v_arc FROM v_edit_arc WHERE state=1 AND arc_id = v_connect.arc_id;

			RAISE NOTICE 'v_arc %', v_arc;

			-- compute link
			IF v_arc.the_geom IS NOT NULL THEN

				IF v_link.userdefined_geom IS TRUE THEN	        

					-- Reverse (if it's need) the existing link geometry
					IF (st_dwithin (st_startpoint(v_link.the_geom), v_connect.the_geom, 0.01)) IS FALSE THEN
						point_aux := St_closestpoint(v_arc.the_geom, St_startpoint(v_link.the_geom));
						v_link.the_geom = ST_SetPoint(v_link.the_geom, 0, point_aux) ; 
					ELSE
						point_aux := St_closestpoint(v_arc.the_geom, St_endpoint(v_link.the_geom));
						v_link.the_geom = ST_SetPoint(v_link.the_geom, (ST_NumPoints(v_link.the_geom) - 1),point_aux); 
					END IF;
				ELSE	
					v_link.the_geom := ST_ShortestLine(v_connect.the_geom, v_arc.the_geom);
					v_link.userdefined_geom = FALSE;	
				END IF;

				v_exit.the_geom = ST_EndPoint(v_link.the_geom);
			END IF;

			-- Insert new vnode
			DELETE FROM vnode WHERE vnode_id=v_exit.vnode_id::integer;
			INSERT INTO vnode (vnode_id, vnode_type, state, sector_id, dma_id, expl_id, the_geom) 
			VALUES ((SELECT nextval('vnode_vnode_id_seq')), 'AUTO', v_arc.state, v_arc.sector_id, v_arc.dma_id, v_arc.expl_id, v_exit.the_geom) RETURNING vnode_id INTO v_exit_id;
	
			v_link.exit_type = 'VNODE';

				
		ELSIF v_link.exit_type='NODE' THEN
				SELECT * INTO v_exit FROM node WHERE node_id=v_link.exit_id;
				v_exit_id = v_exit.node_id;
				v_connect.arc_id = (SELECT arc_id FROM arc WHERE state=1 AND node_1=v_link.exit_id LIMIT 1);
		END IF;

		-- redraw link according situation of exit feature
		IF v_link.exit_type IS NOT NULL THEN
			v_link.the_geom = ST_SetPoint(v_link.the_geom, (ST_NumPoints(v_link.the_geom) - 1), v_exit.the_geom); 
		END IF;
  
		-- Insert new link
		IF v_link.link_id IS NULL THEN
			INSERT INTO link (link_id, the_geom, feature_id, feature_type, exit_type, exit_id, userdefined_geom, state, expl_id) 
			VALUES ((SELECT nextval('link_link_id_seq')), v_link.the_geom, connect_id_aux, feature_type_aux, v_link.exit_type, v_exit_id, v_link.userdefined_geom, v_connect.state, v_connect.expl_id);
		ELSE
			UPDATE link SET the_geom=v_link.the_geom, exit_type=v_link.exit_type, exit_id=v_exit_id WHERE link_id=v_link.link_id;
		END IF;

		-- Update feaute arc_id and state_type
		IF feature_type_aux ='CONNEC' THEN          
			UPDATE connec SET arc_id=v_connect.arc_id WHERE connec_id = connect_id_aux;
			
			-- Update state_type if edit_connect_update_statetype is TRUE
			IF (SELECT ((value::json->>'connec')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
				UPDATE connec SET state_type = (SELECT ((value::json->>'connec')::json->>'state_type')::int2 
				FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE connec_id=connect_id_aux;
			END IF;
		ELSIF feature_type_aux ='GULLY' THEN 
			UPDATE gully SET arc_id=v_connect.arc_id  WHERE gully_id = connect_id_aux;

			-- Update state_type if edit_connect_update_statetype is TRUE
			IF (SELECT ((value::json->>'gully')::json->>'status')::boolean FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') IS TRUE THEN
				UPDATE gully SET state_type = (SELECT ((value::json->>'gully')::json->>'state_type')::int2 
				FROM config_param_system WHERE parameter = 'edit_connect_update_statetype') WHERE gully_id=connect_id_aux;
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
