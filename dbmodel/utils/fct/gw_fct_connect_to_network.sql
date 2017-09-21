/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_connect_to_network(connec_array character varying[], featurecat_id character varying) RETURNS void AS $BODY$
DECLARE
    connec_id_aux  varchar;
    arc_geom       public.geometry;
    candidate_line integer;
    connect_geom   public.geometry;
    link_geom           public.geometry;
    vnode_geom          public.geometry;
    vnode_id       integer;
    vnode_id_aux   varchar;
    arc_id_aux     varchar;
    userDefined    boolean;
    sector_aux     varchar;
	expl_id_int integer;
	link_id integer;

	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Main loop
    FOR EACH connec_id_aux IN ARRAY connec_array
    LOOP

        -- Control user defined
        SELECT b.userdefined_pos, b.vnode_id INTO userDefined, vnode_id_aux FROM vnode AS b WHERE b.vnode_id IN (SELECT a.vnode_id FROM link AS a WHERE feature_id = connec_id_aux) LIMIT 1;

        IF NOT FOUND OR (FOUND AND NOT userDefined) THEN
			
		--	 Get connec or gully geometry
			IF featurecat_id ='connec' THEN          
				SELECT the_geom INTO connect_geom FROM connec WHERE connec_id = connec_id_aux;
			END IF;
			IF featurecat_id ='gully' THEN 
				SELECT the_geom INTO connect_geom FROM gully WHERE gully_id = connec_id_aux;
			END IF;
			RAISE NOTICE 'connect_geom %', connect_geom;
			
			-- Improved version for curved lines (not perfect!)
            WITH index_query AS
            (
                SELECT ST_Distance(the_geom, connect_geom) as d, arc_id FROM v_edit_arc ORDER BY the_geom <-> connect_geom LIMIT 10
            )
            SELECT arc_id INTO arc_id_aux FROM index_query ORDER BY d limit 1;
            
            -- Get v_edit_arc geometry
            SELECT the_geom INTO arc_geom FROM v_edit_arc WHERE arc_id = arc_id_aux;

            -- Compute link
            IF arc_geom IS NOT NULL THEN

                -- Link line
                link_geom := ST_ShortestLine(connect_geom, arc_geom);

                -- Line end point
                vnode_geom := ST_EndPoint(link_geom);

                -- Delete old vnode
                DELETE FROM vnode AS a WHERE a.vnode_id::text = vnode_id_aux;

                -- Detect vnode sector
                --SELECT sector_id INTO sector_aux FROM sector WHERE (the_geom @ sector.the_geom) LIMIT 1;
            
			-- New id
				--PERFORM setval('urn_id_seq', gw_fct_urn(),true);
				link_id:= (SELECT nextval('urn_id_seq'));
				vnode_id:= (SELECT nextval('urn_id_seq'));

			--Exploitation ID
				--expl_id_int := (SELECT expl_id FROM exploitation WHERE ST_DWithin(connect_geom, exploitation.the_geom,0.001) LIMIT 1);
				--RAISE NOTICE 'expl_id_int %', expl_id_int;
				
                -- Insert new vnode
                INSERT INTO vnode (vnode_id, arc_id, vnode_type, userdefined_pos, the_geom) VALUES (vnode_id, arc_id_aux, featurecat_id, FALSE, vnode_geom);
			RAISE NOTICE 'featurecat_id %', featurecat_id;	
                -- Delete old link
                DELETE FROM link WHERE feature_id = connec_id_aux;
					
                -- Insert new link
                INSERT INTO link (link_id, the_geom, feature_id, vnode_id,featurecat_id) VALUES (link_id,link_geom, connec_id_aux, vnode_id,featurecat_id);
			RAISE NOTICE 'featurecat_id %', featurecat_id;	
            END IF;
            
        END IF;

    END LOOP;

    --PERFORM audit_function(0,70);
    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
