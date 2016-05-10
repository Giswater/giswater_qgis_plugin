-- Function: "SCHEMA_NAME".gw_fct_connect_to_network(json)

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(json);

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_connect_to_network(connec_json json)
RETURNS void AS

$BODY$
DECLARE

--	JSON variables
	connec_array   varchar[];
	connec_id_aux  varchar;
	arc_geom       geometry;
	candidate_line integer;
	connect_geom   geometry;
	link           geometry;
	vnode          geometry;
	vnode_id       integer;
	arc_id_aux     varchar;

BEGIN



--	Convert JSON to array to loop
	connec_array := ARRAY(SELECT trim(elem::text, '"') FROM json_array_elements(connec_json->'connec') elem); 

--	Main loop
	FOREACH connec_id_aux IN ARRAY connec_array
	LOOP

--		Get connec geometry
		SELECT the_geom INTO connect_geom FROM "SCHEMA_NAME".connec WHERE connec_id = connec_id_aux;

--		Find closest arc
		SELECT arc_id INTO arc_id_aux FROM "SCHEMA_NAME".arc ORDER BY the_geom <-> connect_geom LIMIT 1;

--		Get arc geometry
		SELECT the_geom INTO arc_geom FROM "SCHEMA_NAME".arc WHERE arc_id = arc_id_aux;


--		Compute link
		IF arc_geom IS NOT NULL THEN

--			Link line		
			link := ST_ShortestLine(connect_geom, arc_geom);

--			Line end point
			vnode := ST_EndPoint(link);

--			Delete old vnode
			DELETE FROM "SCHEMA_NAME".vnode WHERE connec_id = connec_id_aux;
--			Insert new vnode
			INSERT INTO "SCHEMA_NAME".vnode (connec_id, userdefined_pos, the_geom) VALUES (connec_id_aux, FALSE, vnode);
			vnode_id := currval('"SCHEMA_NAME".vnode_seq');


--			Delete old link
			DELETE FROM "SCHEMA_NAME".link WHERE connec_id = connec_id_aux;
--			Insert new link
			INSERT INTO "SCHEMA_NAME".link (the_geom, connec_id, vnode_id) VALUES (link, connec_id_aux, vnode_id);

		END IF;


	END LOOP;	

--		RAISE NOTICE 'another_func(%,%)',m[1], m[2];

	RETURN;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "SCHEMA_NAME".gw_fct_connect_to_network(json)
  OWNER TO geoserver;






