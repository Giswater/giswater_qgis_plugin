/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

The code of this inundation function has been provided by Claudia Dragoste (Aigues de Manresa, S.A.)
*/

-- FUNCTION CODE: 3332

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_settempgeom(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_settempgeom(p_data json)
RETURNS json
LANGUAGE plpgsql
AS $function$

/* Example:
SELECT gw_fct_graphanalytics_settempgeom('{"data":{"updatemapzgeom":0}}');

Function to update the geometry of the mapzones in the temp_minsector table.
*/

DECLARE

    v_updatemapzgeom integer;

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    v_updatemapzgeom = (SELECT (p_data::json->>'data')::json->>'updatemapzgeom')::integer;


    -- Update minsector temporary geometry
    IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN
		EXECUTE 'UPDATE temp_minsector m SET the_geom = NULL FROM temp_pgr_arc t WHERE t.zone_id = m.minsector_id';

    ELSIF v_updatemapzgeom = 1 THEN
        -- Concave polygon
		v_querytext := 'UPDATE temp_minsector SET the_geom = ST_Multi(b.the_geom) 
            FROM (
                WITH polygon AS (
                    SELECT ST_Collect(the_geom) AS g, zone_id FROM temp_pgr_arc a GROUP BY zone_id
                )
                SELECT zone_id, CASE WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_geomparamupdate||')) = ''ST_Polygon''::TEXT THEN
                    ST_Buffer(ST_ConcaveHull(g, '||v_concavehull||'), 3)::geometry(Polygon, '||v_srid||')
                ELSE
                    ST_Expand(ST_Buffer(g, 3::DOUBLE PRECISION), 1::DOUBLE PRECISION)::geometry(Polygon, '||v_srid||')
                END AS the_geom FROM polygon
            ) b WHERE b.zone_id = temp_minsector.minsector_id';
        EXECUTE v_querytext;
    ELSIF v_updatemapzgeom = 2 THEN
        -- Pipe buffer
		v_querytext := 'UPDATE temp_minsector SET the_geom = ST_Multi(geom) FROM (
                SELECT zone_id, ST_Buffer(ST_Collect(the_geom), '||v_geomparamupdate||') AS geom FROM temp_pgr_arc a WHERE zone_id > 0 GROUP BY zone_id
            ) b WHERE b.zone_id = temp_minsector.minsector_id';
        EXECUTE v_querytext;

        RAISE NOTICE ' %', v_querytext;
    ELSIF v_updatemapzgeom = 3 THEN
        -- Use plot and pipe buffer
		v_querytext := 'UPDATE temp_minsector SET the_geom = geom FROM (
                SELECT zone_id, ST_Multi(ST_Buffer(ST_Collect(geom), 0.01)) AS geom FROM (
                    SELECT zone_id, ST_Buffer(ST_Collect(the_geom), '||v_geomparamupdate||') AS geom FROM temp_pgr_arc a
                    WHERE zone_id::INTEGER > 0 GROUP BY zone_id
                    UNION
                    SELECT zone_id, ST_Collect(ext_plot.the_geom) AS geom FROM temp_t_connec a, ext_plot
                    WHERE zone_id::INTEGER > 0 AND ST_DWithin(a.the_geom, ext_plot.the_geom, 0.001) GROUP BY zone_id
                ) c GROUP BY zone_id
            ) b WHERE b.zone_id = temp_minsector.minsector_id';
        EXECUTE v_querytext;
    END IF;


	RETURN ('{"status":"Accepted"}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
