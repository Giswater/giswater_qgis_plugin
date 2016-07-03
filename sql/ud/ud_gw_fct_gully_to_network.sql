/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_gully_to_network(gully_array varchar[]) RETURNS void AS $BODY$
DECLARE
    gully_id_aux  varchar;
    arc_geom       geometry;
    candidate_line integer;
    gully_geom   geometry;
    link           geometry;
    vnode          geometry;
    vnode_id       integer;
    vnode_id_aux   varchar;
    arc_id_aux     varchar;
    userDefined    boolean;
    sector_aux     varchar;


BEGIN

    SET search_path = "SCHEMA_NAME", public;

    -- Main loop
    FOREACH gully_id_aux IN ARRAY gully_array
    LOOP

        -- Control user defined
        SELECT b.userdefined_pos, b.vnode_id INTO userDefined, vnode_id_aux FROM vnode AS b WHERE b.vnode_id IN (SELECT a.vnode_id FROM link AS a WHERE gully_id = gully_id_aux) LIMIT 1;

        IF NOT FOUND OR (FOUND AND NOT userDefined) THEN

            -- Get gully geometry
            SELECT the_geom INTO gully_geom FROM gully WHERE gully_id = gully_id_aux;

            -- Improved version for curved lines (not perfect!)
            WITH index_query AS
            (
                SELECT ST_Distance(the_geom, gully_geom) as d, arc_id FROM arc ORDER BY the_geom <-> gully_geom LIMIT 10
            )
            SELECT arc_id INTO arc_id_aux FROM index_query ORDER BY d limit 1;
            
            -- Get arc geometry
            SELECT the_geom INTO arc_geom FROM arc WHERE arc_id = arc_id_aux;

            -- Compute link
            IF arc_geom IS NOT NULL THEN

                -- Link line
                link := ST_ShortestLine(gully_geom, arc_geom);

                -- Line end point
                vnode := ST_EndPoint(link);

                -- Delete old vnode
                DELETE FROM vnode AS a WHERE a.vnode_id = vnode_id_aux;

                -- Detect vnode sector
                SELECT sector_id INTO sector_aux FROM sector WHERE (the_geom @ sector.the_geom) LIMIT 1;
                
                -- Insert new vnode
                INSERT INTO vnode (sector_id, arc_id, vnode_type, userdefined_pos, the_geom) VALUES (sector_aux, arc_id_aux, 'gully', FALSE, vnode);
                vnode_id := currval('vnode_seq');

                -- Delete old link
                DELETE FROM link WHERE gully_id = gully_id_aux;
                
                -- Insert new link
                INSERT INTO link (the_geom, gully_id, vnode_id) VALUES (link, gully_id_aux, vnode_id);

            END IF;
            
        END IF;

    END LOOP;

    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
