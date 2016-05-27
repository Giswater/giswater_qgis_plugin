/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_node2arc"(node_id_arg varchar) RETURNS "pg_catalog"."int2" AS $BODY$
DECLARE
    node_geom	geometry;
    arc_id_aux	varchar;
    arc_geom	geometry;
    epa_type_aux	varchar;
    line1		geometry;
    line2		geometry;
    rec_aux		record;
    rec_aux2	"SCHEMA_NAME".arc;
    intersect_loc	double precision;

BEGIN

    --	Search path
    SET search_path = "SCHEMA_NAME", public;

    --	Get connec geometry
    SELECT the_geom INTO node_geom FROM node WHERE node_id = node_id_arg;

    --	Get node tolerance from config table
    SELECT node2arc INTO rec_aux FROM config;

    --	Find closest pipe inside tolerance
    SELECT arc_id, the_geom, epa_type INTO arc_id_aux, arc_geom, epa_type_aux  FROM arc AS a WHERE ST_DWithin(node_geom, a.the_geom, rec_aux.node2arc) ORDER BY ST_Distance(node_geom, a.the_geom) LIMIT 1;


    --	Compute cut
    IF arc_geom IS NOT NULL AND (epa_type_aux = 'PIPE' OR epa_type_aux = 'CONDUIT') THEN

        --	Locate position of the nearest point
        intersect_loc := ST_LineLocatePoint(arc_geom, node_geom);

        --	Compute pieces
        line1 := ST_LineSubstring(arc_geom, 0.0, intersect_loc);
        line2 := ST_LineSubstring(arc_geom, intersect_loc, 1.0);

        --	Get arc data
        SELECT * INTO rec_aux2 FROM arc WHERE arc_id = arc_id_aux;

        --	New arc_id
        rec_aux2.arc_id := nextval('SCHEMA_NAME.arc_id_seq');

        --	Check longest
        IF ST_Length(line1) > ST_Length(line2) THEN

            --	Update pipe
            UPDATE arc SET (node_2, the_geom) = (node_id_arg, line1) WHERE arc_id = arc_id_aux;

            --	Insert new
            rec_aux2.the_geom := line2;
            rec_aux2.node_1 := node_id_arg;

        ELSE

            --	Update pipe
            UPDATE arc SET (node_1, the_geom) = (node_id_arg, line2) WHERE arc_id = arc_id_aux;

            --	Insert new
            rec_aux2.the_geom := line1;
            rec_aux2.node_2 := node_id_arg;

        END IF;

        --	Insert new record into arc table
        INSERT INTO arc SELECT rec_aux2.*;

    END IF;

    RETURN 0;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE COST 100;

