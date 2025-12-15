/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3334

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_settempgeom(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_settempgeom(p_data json)
RETURNS json AS
$BODY$

/* Example:
SELECT gw_fct_graphanalytics_settempgeom('{"data":{"fid": 1, "updatemapzgeom":0, "geomparamupdate":2,
"table":"minsector", "field":"zone_id", "fieldmp":"minisector_id", "srid":SRID_VALUE}}');

Function to update the geometry of the mapzones in the temp_minsector table.
*/

DECLARE

    v_querytext TEXT;
    v_fid INTEGER;
    v_version TEXT;
    v_updatemapzgeom INTEGER;
    v_geomparamupdate FLOAT;
    v_concavehull FLOAT;
    v_geomparamupdate_divide FLOAT;
    v_table TEXT; -- minsector | mapzone
    v_field TEXT; -- zone_id
    v_fieldmp TEXT; -- minisector_id
    v_srid INTEGER; -- SRID_VALUE

BEGIN

    SET search_path = "SCHEMA_NAME", public;

    v_fid = (SELECT (p_data::json->>'data')::json->>'fid')::integer;
    v_version = (SELECT (p_data::json->>'data')::json->>'version')::text;
    v_updatemapzgeom = (SELECT (p_data::json->>'data')::json->>'updatemapzgeom')::integer;
    v_concavehull = (SELECT (p_data::json->>'data')::json->>'concavehull')::float;
    v_geomparamupdate = (SELECT (p_data::json->>'data')::json->>'geomparamupdate')::float;
    v_table = (SELECT (p_data::json->>'data')::json->>'table')::text;
    v_field = (SELECT (p_data::json->>'data')::json->>'field')::text;
    v_fieldmp = (SELECT (p_data::json->>'data')::json->>'fieldmp')::text;
    v_srid = (SELECT (p_data::json->>'data')::json->>'srid')::integer;


    RAISE NOTICE 'Creating geometry for %', v_table;

    -- Update temporary geometry
    IF v_updatemapzgeom = 0 OR v_updatemapzgeom IS NULL THEN
        -- update the_geom to NULL
        v_querytext := 'UPDATE temp_' || quote_ident(v_table) || ' AS temp_table SET the_geom = NULL';

        EXECUTE v_querytext;

    ELSIF v_updatemapzgeom = 1 THEN

        -- Concave polygon
        v_querytext := 'UPDATE temp_'||(v_table)||' SET the_geom = ST_Multi(a.the_geom)
                        FROM (
                            WITH polygon AS (
                                SELECT ST_Collect(arc.the_geom) AS g, '||quote_ident(v_field)||' 
                                FROM temp_pgr_arc a
                                JOIN arc ON a.arc_id = arc.arc_id
                                WHERE a.pgr_arc_id = a.arc_id::integer
                                GROUP BY '||quote_ident(v_field)||'
                            )
                            SELECT '||quote_ident(v_field)||', CASE WHEN ST_GeometryType(ST_ConcaveHull(g, '||v_concavehull||')) = ''ST_Polygon''::TEXT THEN
                                ST_Buffer(ST_ConcaveHull(g, '||v_concavehull||'), 2)::geometry(Polygon,'||(v_srid)||')
                            ELSE
                                ST_Expand(ST_Buffer(g, 3::DOUBLE PRECISION), 1::DOUBLE PRECISION)::geometry(Polygon,'||(v_srid)||') 
                            END AS the_geom FROM polygon
                        ) a
                        WHERE a.'||quote_ident(v_field)||' = temp_'||(v_table)||'.'||quote_ident(v_fieldmp);

        EXECUTE v_querytext;

    ELSIF v_updatemapzgeom = 2 THEN

        -- Pipe buffer
        v_querytext := 'UPDATE temp_'||(v_table)||' SET the_geom = geom 
                        FROM (
                            SELECT '||quote_ident(v_field)||', ST_Multi(ST_Buffer(ST_Collect(arc.the_geom), '||v_geomparamupdate||')) AS geom 
                            FROM temp_pgr_arc a 
                            JOIN arc ON a.arc_id = arc.arc_id
                            WHERE a.pgr_arc_id = a.arc_id::integer AND a.'||quote_ident(v_field)||' > 0 
                            GROUP BY '||quote_ident(v_field)||'
                        ) a
                        WHERE a.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp);

        EXECUTE v_querytext;

    ELSIF v_updatemapzgeom = 3 THEN

        -- Use plot and pipe buffer
        v_querytext := 'UPDATE temp_'||(v_table)||' SET the_geom = geom FROM (
                            SELECT '||quote_ident(v_field)||', ST_Multi(ST_Buffer(ST_Collect(geom), 0.01)) AS geom 
                            FROM (
                                SELECT '||quote_ident(v_field)||', ST_Buffer(ST_Collect(arc.the_geom), '||v_geomparamupdate||') AS geom 
                                FROM temp_pgr_arc a
                                JOIN arc ON a.arc_id = arc.arc_id
                                WHERE a.pgr_arc_id = a.arc_id::integer AND '||quote_ident(v_field)||' > 0 
                                GROUP BY '||quote_ident(v_field)||'
                                UNION
                                SELECT '||quote_ident(v_field)||', ST_Collect(ext_plot.the_geom) AS geom 
                                FROM temp_pgr_connec c, ext_plot
                                JOIN connec ON c.connec_id = connec.connec_id
                                WHERE '||quote_ident(v_field)||' > 0 AND ST_DWithin(connec.the_geom, ext_plot.the_geom, 0.001) 
                                GROUP BY '||quote_ident(v_field)||'	
                            ) a GROUP BY '||quote_ident(v_field)||'
                        ) b 
                        WHERE b.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp);

        EXECUTE v_querytext;

    ELSIF v_updatemapzgeom = 4 THEN

        v_geomparamupdate_divide = v_geomparamupdate/2;
		-- Use link and pipe buffer

        v_querytext := 'UPDATE temp_'||(v_table)||' SET the_geom = geom FROM (
                            SELECT '||quote_ident(v_field)||', ST_Multi(ST_Buffer(ST_Collect(geom),0.01)) AS geom 
                            FROM (
                                SELECT '||quote_ident(v_field)||', ST_Buffer(ST_Collect(arc.the_geom), '||v_geomparamupdate||') AS geom 
                                FROM temp_pgr_arc a 
                                JOIN arc ON a.arc_id = arc.arc_id
                                WHERE a.pgr_arc_id = a.arc_id::integer AND a.'||quote_ident(v_field)||' > 0 
                                GROUP BY '||quote_ident(v_field)||'
                                UNION
                                SELECT a.'||quote_ident(v_field)||', (ST_Buffer(ST_Collect(link.the_geom),'||v_geomparamupdate_divide||',''endcap=flat join=round'')) AS geom 
                                FROM temp_pgr_link l, temp_pgr_connec c
                                JOIN link ON l.link_id = link.link_id
                                WHERE c.'||quote_ident(v_field)||' > 0
                                AND temp_pgr_link.feature_id = connec_id AND temp_pgr_link.feature_type = ''CONNEC''
                                GROUP BY c.'||quote_ident(v_field)||'
                                UNION
                                SELECT a.'||quote_ident(v_field)||', (ST_Buffer(ST_Collect(link.the_geom),'||v_geomparamupdate_divide||',''endcap=flat join=round'')) AS geom 
                                FROM temp_pgr_link l, temp_pgr_connec c
                                JOIN link ON l.link_id = link.link_id
                                JOIN temp_pgr_node n ON c.arc_id IS NULL AND n.node_id = c.pjoint_id
                                WHERE c.'||quote_ident(v_field)||' > 0 AND temp_pgr_link.feature_id = connec_id AND temp_pgr_link.feature_type = ''CONNEC''
                                GROUP BY c.'||quote_ident(v_field)||'
                            ) c GROUP BY '||quote_ident(v_field)||'
                        ) b
                        WHERE b.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp);


        EXECUTE v_querytext;

    ELSIF v_updatemapzgeom = 5 THEN

        v_geomparamupdate_divide = v_geomparamupdate/2;

        /* Example of querytext that could be implemented on config_param_system
            UPDATE v_table SET the_geom = geom
            FROM (
                SELECT v_field, ST_Multi(ST_Buffer(ST_Collect(geom), 0.01)) AS geom
                FROM (
                    SELECT v_field, ST_Buffer(ST_Collect(the_geom), v_geomparamupdate) AS geom
                    FROM ve_arc arc
                    GROUP BY v_field
                    UNION
                    SELECT v_field, st_collect(z.geom) AS geom FROM v_crm_zone z
                    JOIN ve_node using (node_id)
                    WHERE v_field::INTEGER> 0 GROUP BY v_field
                ) a GROUP BY v_field
            ) b
            WHERE b.v_field = v_table.v_fieldmp
		*/

        SELECT value INTO v_querytext FROM config_param_system WHERE parameter='utils_graphanalytics_custom_geometry_constructor';

		EXECUTE 'SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('||quote_literal(v_querytext)||',''v_table'', '||quote_literal(v_table)||'),
		''v_fieldmp'', '||quote_literal(v_fieldmp)||'), ''v_field'', '||quote_literal(v_field)||'), ''v_fid'', '||quote_literal(v_fid)||'),
		 ''v_geomparamupdate'', '||quote_literal(v_geomparamupdate)||')'
		INTO v_querytext;

		EXECUTE v_querytext;

    END IF;


    RETURN jsonb_build_object(
        'status', 'Accepted',
        'message', jsonb_build_object(
            'level', 1,
            'text', 'The geometry has been updated successfully.'
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

    EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'status', 'Failed',
        'message', jsonb_build_object(
            'level', 3,
            'text', 'An error occurred while updating the geometry. ' || SQLERRM
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

	RETURN ('{"status":"Accepted"}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
