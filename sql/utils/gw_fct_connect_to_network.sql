CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_connect_to_network(connec_param varchar[]) RETURNS void AS $BODY$
DECLARE
    connec_id_aux  varchar;
    arc_geom       geometry;
    candidate_line integer;
    connect_geom   geometry;
    link           geometry;
    vnode          geometry;
    vnode_id       integer;
    arc_id_aux     varchar;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    -- Main loop
    FOREACH connec_id_aux IN ARRAY connec_array
    LOOP

        -- Get connec geometry
        SELECT the_geom INTO connect_geom FROM connec WHERE connec_id = connec_id_aux;

        -- Find closest arc
        SELECT arc_id INTO arc_id_aux FROM arc ORDER BY the_geom <-> connect_geom LIMIT 1;

        -- Get arc geometry
        SELECT the_geom INTO arc_geom FROM arc WHERE arc_id = arc_id_aux;

        -- Compute link
        IF arc_geom IS NOT NULL THEN

            -- Link line
            link := ST_ShortestLine(connect_geom, arc_geom);

            -- Line end point
            vnode := ST_EndPoint(link);

            -- Delete old vnode
            DELETE FROM vnode WHERE connec_id = connec_id_aux;
            
            -- Insert new vnode
            INSERT INTO vnode (connec_id, userdefined_pos, the_geom) VALUES (connec_id_aux, FALSE, vnode);
            vnode_id := currval('vnode_seq');

            -- Delete old link
            DELETE FROM link WHERE connec_id = connec_id_aux;
            
            -- Insert new link
            INSERT INTO link (the_geom, connec_id, vnode_id) VALUES (link, connec_id_aux, vnode_id);

        END IF;

    END LOOP;

    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

