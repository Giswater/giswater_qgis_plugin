-- Function: "SCHEMA_NAME".gw_fct_node2arc(character varying)

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_node2arc(character varying);

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node2arc(node_id_arg character varying)
RETURNS void AS

$BODY$
DECLARE

	node_geom      geometry;
	arc_id_aux     varchar;
	arc_geom       geometry;
	link           geometry;
	end_point      geometry;
	start_point    geometry;
	epa_type_aux   varchar;
	line1          geometry;
	line2          geometry;
	rec_aux        record;
	rec_aux2       "SCHEMA_NAME".arc;
	


BEGIN


--	Get connec geometry
	SELECT the_geom INTO node_geom FROM "SCHEMA_NAME".node WHERE node_id = node_id_arg;

--	Get node tolerance from config table
	SELECT node_proximity INTO rec_aux FROM "SCHEMA_NAME".config;
    
--	Find closest pipe inside tolerance
	SELECT arc_id, the_geom, epa_type INTO arc_id_aux, arc_geom, epa_type_aux  FROM "SCHEMA_NAME".arc AS a WHERE ST_DWithin(node_geom, a.the_geom, rec_aux.node_proximity) ORDER BY ST_Distance(node_geom, a.the_geom) LIMIT 1;


--	Compute cut
	IF arc_geom IS NOT NULL AND (epa_type_aux = 'PIPE' OR epa_type_aux = 'CONDUIT') THEN

--		Line end point
		start_point:= ST_StartPoint(arc_geom);
		end_point := ST_EndPoint(arc_geom);

--		Compute pieces
		line1 := ST_MakeLine(start_point, node_geom);
		line2 := ST_MakeLine(node_geom, end_point);

--		Get arc data
		SELECT * INTO rec_aux2 FROM "SCHEMA_NAME".arc WHERE arc_id = arc_id_aux;

--		New arc_id
		rec_aux2.arc_id := nextval('SCHEMA_NAME.arc_id_seq');

--		Check longest
		IF ST_Length(line1) > ST_Length(line2) THEN

--			Update pipe
			UPDATE "SCHEMA_NAME".arc SET (node_2, the_geom) = (node_id_arg, line1) WHERE arc_id = arc_id_aux;

--			Insert new
			rec_aux2.the_geom := line2;
			rec_aux2.node_1 := node_id_arg;


		ELSE

--			Update pipe
			UPDATE "SCHEMA_NAME".arc SET (node_1, the_geom) = (node_id_arg, line2) WHERE arc_id = arc_id_aux;

--			Insert new
			rec_aux2.the_geom := line1;
			rec_aux2.node_2 := node_id_arg;

		END IF;

--		Insert new record into arc table
		INSERT INTO "SCHEMA_NAME".arc SELECT rec_aux2.*;




	END IF;

	RETURN;

		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "SCHEMA_NAME".gw_fct_node2arc(character varying)
  OWNER TO geoserver;






