/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_node_interpolate_massive(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*

fid 496

FUNCTION
    gw_fct_node_interpolate_massive(p_data json)

PURPOSE
    This function calculates node invert elevations using different strategies
    depending on the requested calculation type.

SUPPORTED TYPES
    1) MASSIVE
       Legacy mode. For each node with sys_elev IS NULL, the function tries to
       identify upstream and downstream reference nodes with known elevation
       and delegates interpolation to gw_fct_node_interpolate.

    2) FLOWEXIT
       Advanced profile solver mode. The function:
         - computes the shortest path between node1 and node2,
         - treats node1 and node2 as fixed anchor points,
         - may stop earlier at an internal hard point,
         - validates the calculation window,
         - solves the profile globally using:
             minYmax,
             maxYmax,
             minSlope,
             maxSlope,
         - and assigns elevations according to profileMode.

    3) INIT
       Head node initialization mode. The function:
         - finds arcs whose node_1 is a head node
           (degree = 1, only connected to that arc),
         - requires node_2 to have a fixed elevation
           (sys_elev or custom_elev),
         - computes a feasible elevation interval for node_1 using:
             minYmax,
             maxYmax,
             minSlope,
             maxSlope,
         - updates node_1 when the interval is feasible,
         - and writes detailed log messages when the interval is infeasible.

ELEVATION MODEL
    - sys_elev is the authoritative known elevation.
    - custom_elev is the calculated elevation written by this function.
    - The function only writes custom_elev for nodes where sys_elev IS NULL.

ANCHORS
    - The downstream outlet node can be fixed by sys_elev.
    - Internal hard points can also be fixed by existing custom_elev when:
        * node degree > 2
        * at least one connected arc has slope
    - If node1 also has sys_elev, it is treated as an upstream fixed anchor.
    - Fixed anchors are never modified.

PROFILE MODES
    - DEEP:
        Selects the deepest feasible solution.
    - SHALLOW:
        Selects the shallowest feasible solution.
    - CENTERED:
        Selects the midpoint between the lower and upper feasible envelopes.
    - SMOOTH:
        Starts from a centered feasible solution and applies internal smoothing
        iterations while preserving feasibility and fixed anchors.

SMOOTH PARAMETERS
    - smoothAlpha:
        Strength of each smoothing iteration.
        Lower values = rougher / more conservative.
        Higher values = smoother / more aggressive.
    - smoothIterations:
        Number of smoothing iterations.
        Lower values = rougher profile.
        Higher values = smoother profile.

BUSINESS RULES
    - custom_elev is only written where sys_elev IS NULL.
    - MASSIVE interpolates node by node using nearby known references.
    - FLOWEXIT solves a constrained profile along shortest path(node1, node2).
    - In FLOWEXIT, node1 and node2 are always fixed anchors.
    - Internal hard points can also act as fixed anchors.
    - Hard points are nodes with degree > 2, existing custom_elev,
      and at least one connected arc with slope.
    - Hard points are not cleaned or recalculated.
    - INIT only processes head arcs where node_1 has degree = 1.
    - In INIT, node_2 must already have fixed elevation.
    - FLOWEXIT and INIT must satisfy Ymax and slope constraints.
    - Infeasible cases are logged in audit_check_data with detailed diagnostics.
*/

DECLARE
    v_version text;
    v_project text;
    v_fid integer := 496;
  
    v_type text;
    v_queryfilter text;
    v_node1 integer;
    v_node2 integer;
    v_minymax numeric(12,3);
    v_maxymax numeric(12,3);
    v_minslope numeric(12,6);
    v_maxslope numeric(12,6);
    v_profile_mode text;
   
    v_arc_len float;
    v_node1_top float;
    v_node2_elev float;
    v_low_elev float;
    v_high_elev float;
    v_calc_elev float;
     
    v_node record;
    v_querytext text;
    v_x float8;
    v_y float8;

    v_upstream_node integer;
    v_downstream_node integer;
    v_anchor_node integer;
    v_anchor_kind text;

    v_node1_is_fixed boolean := false;
    v_min_seq integer;
    v_max_seq integer;

    v_smooth_iterations integer := 25;
    v_smooth_alpha float8 := 0.35;
    v_arc record;

    v_result jsonb;
    v_result_info jsonb;
    v_result_point jsonb;
    v_result_line jsonb;
    v_status text := 'Accepted';
    v_message_level integer := 1;
    v_message_text text := 'Node interpolation done successfully';
    v_error_context text;
    v_fixchanges boolean := false;
    v_state_type int2 := 0;

    v_eps float8 := 1e-6;
    i integer;

BEGIN
    SET search_path = "SCHEMA_NAME", public;

    SELECT giswater, upper(project_type)
    INTO v_version, v_project
    FROM sys_version
    ORDER BY id DESC
    LIMIT 1;

    v_queryfilter  := p_data->'data'->'parameters'->>'queryFilter';
    v_type         := upper(COALESCE(p_data->'data'->'parameters'->>'type', ''));
    v_node1        := (p_data->'data'->'parameters'->>'node1')::integer;
    v_node2        := (p_data->'data'->'parameters'->>'node2')::integer;
    v_minymax      := (p_data->'data'->'parameters'->>'minYmax')::numeric;
    v_maxymax      := (p_data->'data'->'parameters'->>'maxYmax')::numeric;
    v_minslope     := (p_data->'data'->'parameters'->>'minSlope')::numeric;
    v_maxslope     := (p_data->'data'->'parameters'->>'maxSlope')::numeric;
    v_profile_mode := upper(COALESCE(p_data->'data'->'parameters'->>'profileMode', 'SMOOTH'));

    v_fixchanges := COALESCE((p_data->'data'->'parameters'->>'fixChanges')::boolean, false);
    v_state_type := CASE WHEN v_fixchanges THEN 1 ELSE 0 END;

    v_smooth_alpha := COALESCE((p_data->'data'->'parameters'->>'smoothAlpha')::float8, 0.35);
    v_smooth_iterations := COALESCE((p_data->'data'->'parameters'->>'smoothIterations')::integer, 10);

    DROP TABLE IF EXISTS temp_anl_node;
    DROP TABLE IF EXISTS temp_anl_arc;

    CREATE TEMP TABLE temp_anl_node (LIKE anl_node INCLUDING ALL);
    CREATE TEMP TABLE temp_anl_arc  (LIKE anl_arc INCLUDING ALL);

    DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user = current_user;
    DELETE FROM anl_node WHERE fid = v_fid AND cur_user = current_user;
    DELETE FROM anl_arc  WHERE fid = v_fid AND cur_user = current_user;

    EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
             "data":{"function":"3248", "fid":"496", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';
   
            
    IF v_type = 'MASSIVE' THEN

        v_querytext := 'SELECT node_id, the_geom FROM ve_node WHERE sys_elev IS NULL ORDER BY node_id desc' || COALESCE(v_queryfilter, '');
       
        FOR v_node IN EXECUTE v_querytext
        LOOP
            v_x := ST_X(v_node.the_geom);
            v_y := ST_Y(v_node.the_geom);

            v_upstream_node := NULL;
            v_downstream_node := NULL;
           
            SELECT a.node_1
            INTO v_upstream_node
            FROM ve_arc a
            JOIN ve_node n ON a.node_1 = n.node_id
            WHERE a.node_2 = v_node.node_id
              AND a.node_1 IS NOT NULL
              AND n.sys_elev IS NOT NULL
            ORDER BY n.sys_elev ASC
            LIMIT 1;

            SELECT a.node_2
            INTO v_downstream_node
            FROM ve_arc a
            JOIN ve_node n ON a.node_2 = n.node_id
            WHERE a.node_1 = v_node.node_id
              AND a.node_2 IS NOT NULL
              AND n.sys_elev IS NOT NULL
            ORDER BY n.sys_elev ASC
            LIMIT 1;

            raise notice 'v_node % -UPSTREAM % -DOWNSTREAM %', v_node.node_id,v_upstream_node, v_downstream_node ;
                
            IF v_upstream_node IS NOT NULL AND v_downstream_node IS NOT NULL THEN
                v_querytext :=
                    'SELECT gw_fct_node_interpolate(''{"data":{"parameters":{"action":"MASSIVE-INTERPOLATE",
                    "TargetNode":'||v_node.node_id||',"node1":"' || v_upstream_node || '","node2":"' || v_downstream_node || '"}}}'')';

                raise notice 'v_querytext %', v_querytext;
                   
                EXECUTE v_querytext;
                         
	            INSERT INTO temp_anl_node (node_id, fid, the_geom, descript, top_elev, elev, ymax, cur_user, expl_id, state_type)
	            SELECT
	                node_id,
	                v_fid,
	                the_geom,
	                'MASSIVE',
	                sys_top_elev,
	                COALESCE(custom_elev, sys_elev),
	                sys_ymax,
	                current_user,
	                expl_id,
	                v_state_type
	            FROM ve_node
	            WHERE node_id = v_node.node_id;
            END IF;           
        END LOOP;
     
      	INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
        VALUES (v_fid, 'The process have been executed. See graphic log for more info', 1, current_user);
       
    ELSIF v_type = 'INIT' THEN

        IF v_minymax IS NULL OR v_maxymax IS NULL
           OR v_minslope IS NULL OR v_maxslope IS NULL THEN

            v_message_level := 2;
            v_message_text := 'INIT requires minYmaxNode1, maxYmaxNode1, minSlopeArc and maxSlopeArc.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minymax > v_maxymax THEN
            v_message_level := 2;
            v_message_text := 'INIT: minYmaxNode1 cannot be greater than maxYmaxNode1.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minslope < 0 OR v_maxslope < 0 THEN
            v_message_level := 2;
            v_message_text := 'INIT: minSlopeArc and maxSlopeArc must be greater than or equal to zero.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minslope > v_maxslope THEN
            v_message_level := 2;
            v_message_text := 'INIT: minSlopeArc cannot be greater than maxSlopeArc.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSE

            FOR v_arc IN
                SELECT
                    a.arc_id,
                    a.node_1,
                    a.node_2,
                    a.the_geom,
                    ST_Length(a.the_geom)::float8 AS arc_len,
                    n1.sys_top_elev::float8 AS node1_top_elev,
                    n1.sys_elev::float8 AS node1_sys_elev,
                    n1.custom_elev::float8 AS node1_custom_elev,
                    n1.the_geom AS node1_geom,
                    n1.expl_id AS node1_expl_id,
                    COALESCE(n2.sys_elev::float8, n2.custom_elev::float8) AS node2_anchor_elev,
                    n2.sys_top_elev::float8 AS node2_top_elev,
                    n2.expl_id AS arc_expl_id
                FROM arc a
                JOIN ve_node n1 ON n1.node_id = a.node_1
                JOIN ve_node n2 ON n2.node_id = a.node_2
                WHERE a.node_1 IS NOT NULL
                  AND a.node_2 IS NOT NULL
                  AND (
                      SELECT count(*)
                      FROM arc ax
                      WHERE ax.node_1 = a.node_1
                         OR ax.node_2 = a.node_1
                  ) = 1
                  AND COALESCE(n2.sys_elev, n2.custom_elev) IS NOT NULL
                  AND n1.sys_elev IS NULL
            LOOP

                v_arc_len := v_arc.arc_len;
                v_node1_top := v_arc.node1_top_elev;
                v_node2_elev := v_arc.node2_anchor_elev;

                IF v_node1_top IS NULL THEN
                    INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                    VALUES (
                        v_fid,
                        'INIT arc ' || v_arc.arc_id || ': node_1=' || v_arc.node_1 || ' not updated because sys_top_elev is null.',
                        2,
                        current_user
                    );

                ELSIF v_arc_len IS NULL OR v_arc_len <= 0 THEN
                    INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                    VALUES (
                        v_fid,
                        'INIT arc ' || v_arc.arc_id || ': node_1=' || v_arc.node_1 || ' not updated because arc length is not positive.',
                        2,
                        current_user
                    );

                ELSE
                    -- Node1 feasible interval from its top elevation and requested Ymax
                    v_low_elev := v_node1_top - v_maxymax;
                    v_high_elev := v_node1_top - v_minymax;

                    -- Intersect with slope constraints imposed by node2 anchor
                    v_low_elev := GREATEST(
                        v_low_elev,
                        v_node2_elev + v_minslope * v_arc_len
                    );

                    v_high_elev := LEAST(
                        v_high_elev,
                        v_node2_elev + v_maxslope * v_arc_len
                    );

                    IF v_low_elev > v_high_elev + v_eps THEN
                        INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                        VALUES (
                            v_fid,
                            concat(
                                'INIT arc ', v_arc.arc_id,
                                ': node_1=', v_arc.node_1,
                                ' not updated. gap=', round((v_low_elev - v_high_elev)::numeric, 3),
                                ' | lower=',
                                round(v_low_elev::numeric, 3),
                                ' | upper=',
                                round(v_high_elev::numeric, 3)
                            ),
                            2,
                            current_user
                        );

                        INSERT INTO temp_anl_node (node_id, fid, the_geom, descript, top_elev, elev, ymax, cur_user, expl_id, state_type)
                        VALUES (
                            v_arc.node_1,
                            v_fid,
                            v_arc.node1_geom,
                            'INIT - infeasible',
                            v_node1_top,
                            v_low_elev,
                            v_node1_top - v_low_elev,
                            current_user,
                            v_arc.node1_expl_id,
                            v_state_type
                        );

                    ELSE
                        -- choose centered solution for init
                        v_calc_elev := (v_low_elev + v_high_elev) / 2.0;

                        UPDATE ve_node n
                           SET custom_elev = v_calc_elev
                        WHERE n.node_id = v_arc.node_1
                          AND n.sys_elev IS NULL;

                        INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                        VALUES (
                            v_fid,
                            concat(
                                'INIT arc ', v_arc.arc_id,
                                ': node_1=', v_arc.node_1,
                                ' updated to elev=',
                                round(v_calc_elev::numeric, 3)
                            ),
                            4,
                            current_user
                        );

                        INSERT INTO temp_anl_node (node_id, fid, the_geom, descript, top_elev, elev, ymax, cur_user, expl_id, state_type)
                        VALUES (
                            v_arc.node_1,
                            v_fid,
                            v_arc.node1_geom,
                            'INIT',
                            v_node1_top,
                            v_calc_elev,
                            v_node1_top - v_calc_elev,
                            current_user,
                            v_arc.node1_expl_id,
                            v_state_type
                        );

                        INSERT INTO temp_anl_arc (arc_id, fid, the_geom, descript, cur_user, expl_id, state_type)
                        VALUES (
                            v_arc.arc_id,
                            v_fid,
                            v_arc.the_geom,
                            'INIT',
                            current_user,
                            v_arc.arc_expl_id,
                            v_state_type
                        );
                    END IF;
                END IF;
            END LOOP;

        END IF;

    ELSIF v_type = 'FLOWEXIT' THEN

        IF v_node1 IS NULL OR v_node2 IS NULL THEN
            v_message_level := 2;
            v_message_text := 'FLOWEXIT requires node1 and node2.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minymax IS NULL OR v_maxymax IS NULL OR v_minslope IS NULL OR v_maxslope IS NULL THEN
            v_message_level := 2;
            v_message_text := 'FLOWEXIT requires minYmax, maxYmax, minSlope and maxSlope.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minymax > v_maxymax THEN
            v_message_level := 2;
            v_message_text := 'minYmax cannot be greater than maxYmax.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minslope < 0 OR v_maxslope < 0 THEN
            v_message_level := 2;
            v_message_text := 'minSlope and maxSlope must be greater than or equal to zero.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_minslope > v_maxslope THEN
            v_message_level := 2;
            v_message_text := 'minSlope cannot be greater than maxSlope.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_profile_mode NOT IN ('DEEP', 'SHALLOW', 'CENTERED', 'SMOOTH') THEN
            v_message_level := 2;
            v_message_text := 'profileMode must be DEEP, SHALLOW, CENTERED or SMOOTH.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_smooth_alpha <= 0 OR v_smooth_alpha > 1 THEN
            v_message_level := 2;
            v_message_text := 'smoothAlpha must be greater than 0 and less than or equal to 1.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSIF v_smooth_iterations < 1 OR v_smooth_iterations > 500 THEN
            v_message_level := 2;
            v_message_text := 'smoothIterations must be between 1 and 500.';
            INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
            VALUES (v_fid, v_message_text, 1, current_user);

        ELSE
            SELECT EXISTS (
                SELECT 1
                FROM ve_node
                WHERE node_id = v_node1
                  AND sys_elev IS NOT NULL
            )
            INTO v_node1_is_fixed;

            DROP TABLE IF EXISTS temp_path_raw;
            DROP TABLE IF EXISTS temp_path_window;
            DROP TABLE IF EXISTS temp_profile_down_lower;
            DROP TABLE IF EXISTS temp_profile_down_upper;
            DROP TABLE IF EXISTS temp_profile_up_bounds;
            DROP TABLE IF EXISTS temp_profile_bounds;
            DROP TABLE IF EXISTS temp_profile_final;
            DROP TABLE IF EXISTS temp_profile_work;

            CREATE TEMP TABLE temp_path_raw AS
            WITH route AS (
                SELECT *
                FROM pgr_dijkstra(
                    'SELECT
                        arc_id AS id,
                        node_1 AS source,
                        node_2 AS target,
                        ST_Length(the_geom)::float8 AS cost,
                        ST_Length(the_geom)::float8 AS reverse_cost
                     FROM arc
                     WHERE node_1 IS NOT NULL
                       AND node_2 IS NOT NULL',
                    v_node1,
                    v_node2,
                    false
                )
            )
            SELECT
                r.path_seq AS seq,
                r.node AS node_id,
                CASE WHEN r.edge = -1 THEN NULL ELSE r.edge END AS arc_id,
                CASE
                    WHEN LAG(r.agg_cost) OVER (ORDER BY r.path_seq) IS NULL THEN NULL
                    ELSE (r.agg_cost - LAG(r.agg_cost) OVER (ORDER BY r.path_seq))::float8
                END AS step_len
            FROM route r
            ORDER BY r.path_seq;
           
         	CREATE INDEX IF NOT EXISTS idx_temp_path_raw_seq  ON temp_path_raw(seq);
		   	CREATE INDEX IF NOT EXISTS idx_temp_path_raw_node_id  ON temp_path_raw(node_id);
           
              	raise notice '1.1';

			
			-- disabling temporary triggers in order to make faster transactions
			UPDATE config_param_user SET value='true' WHERE parameter = 'edit_disable_noderotation_complete' and cur_user = current_user;
			UPDATE config_param_user SET value='true' WHERE parameter = 'edit_disable_statetopocontrol' and cur_user = current_user;
			UPDATE config_param_user SET value='true' WHERE parameter = 'edit_disable_planpsector_node' and cur_user = current_user;
			UPDATE config_param_user SET value='true' WHERE parameter = 'edit_disable_topocontrol_complete' and cur_user = current_user;
			UPDATE config_param_user SET value='true' WHERE parameter = 'edit_disable_arc_divide' and cur_user = current_user;
			
            -- Clean previous custom_elev only on nodes that are not hard points
            UPDATE ve_node n
               SET custom_elev = NULL
            FROM temp_path_raw p
            WHERE n.node_id = p.node_id
              AND n.custom_elev IS NOT null
              AND n.node_id <> v_node1
			  AND n.node_id <> v_node2
              AND NOT (
                  (
                      SELECT count(*)
                      FROM arc a
                      WHERE a.node_1 = n.node_id
                         OR a.node_2 = n.node_id
                  ) > 2
                  AND n.custom_elev IS NOT NULL
                  AND EXISTS (
                      SELECT 1
                      FROM ve_arc a
                      WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id)
                        AND a.slope IS NOT NULL
                  )
              );

            IF NOT EXISTS (SELECT 1 FROM temp_path_raw) THEN
                v_message_level := 2;
                v_message_text := 'No shortest path was found between node1 and node2.';
                INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                VALUES (v_fid, v_message_text, 1, current_user);

            else
                          
                           
                CREATE TEMP TABLE temp_path_window AS
				WITH
				path_limits AS (
				    SELECT MIN(seq) AS min_seq
				    FROM temp_path_raw
				),
				arc_stats AS (
				    SELECT
				        node_id,
				        COUNT(*) AS arc_count,
				        BOOL_OR(slope IS NOT NULL) AS has_slope
				    FROM (
				        SELECT node_1 AS node_id, slope FROM ve_arc
				        UNION ALL
				        SELECT node_2 AS node_id, slope FROM ve_arc
				    ) q
				    GROUP BY node_id
				),
				first_anchor AS (
				    SELECT MIN(r.seq) AS stop_seq
				    FROM temp_path_raw r
				    JOIN path_limits pl ON true
				    JOIN ve_node n ON n.node_id = r.node_id
				    LEFT JOIN arc_stats s ON s.node_id = r.node_id
				    WHERE r.seq > pl.min_seq
				      AND (
				          n.sys_elev IS NOT NULL
				          OR (
				              COALESCE(s.arc_count, 0) > 2
				              AND n.custom_elev IS NOT NULL
				              AND COALESCE(s.has_slope, false)
				          )
				      )
				)
				SELECT
				    r.seq,
				    r.node_id,
				    r.arc_id,
				    r.step_len,
				    v_minslope::float8 AS minslope,
				    v_maxslope::float8 AS maxslope,
				    n.sys_top_elev::float8 AS top_elev,
				    (n.sys_top_elev::float8 - v_maxymax::float8) AS min_bound,
				    (n.sys_top_elev::float8 - v_minymax::float8) AS max_bound,
				    n.sys_elev::float8 AS sys_elev,
				    n.custom_elev::float8 AS custom_elev,
				    COALESCE(n.sys_elev::float8, n.custom_elev::float8) AS anchor_elev,
				    n.the_geom,
				    n.expl_id
				FROM temp_path_raw r
				JOIN ve_node n ON n.node_id = r.node_id
				CROSS JOIN first_anchor fa
				WHERE fa.stop_seq IS NOT NULL
				  AND r.seq <= fa.stop_seq
				ORDER BY r.seq;
                           
                           /*
                           
                CREATE TEMP TABLE temp_path_window AS
                WITH first_anchor AS (
                    SELECT MIN(r.seq) AS stop_seq
                    FROM temp_path_raw r
                    JOIN ve_node n ON n.node_id = r.node_id
                    WHERE r.seq > (SELECT MIN(seq) FROM temp_path_raw)
                      AND (
                          n.sys_elev IS NOT NULL
                          OR (
                              (
                                  SELECT count(*)
                                  FROM ve_arc a
                                  WHERE a.node_1 = r.node_id
                                     OR a.node_2 = r.node_id
                              ) > 2
                              AND n.custom_elev IS NOT NULL
                              AND EXISTS (
                                  SELECT 1
                                  FROM ve_arc a
                                  WHERE (a.node_1 = r.node_id OR a.node_2 = r.node_id)
                                    AND a.slope IS NOT NULL
                              )
                          )
                      )
                )
                SELECT
                    r.seq,
                    r.node_id,
                    r.arc_id,
                    r.step_len,
                    v_minslope::float8 AS minslope,
                    v_maxslope::float8 AS maxslope,
                    n.sys_top_elev::float8 AS top_elev,
                    (n.sys_top_elev::float8 - v_maxymax::float8) AS min_bound,
                    (n.sys_top_elev::float8 - v_minymax::float8) AS max_bound,
                    n.sys_elev::float8 AS sys_elev,
                    n.custom_elev::float8 AS custom_elev,
                    COALESCE(n.sys_elev::float8, n.custom_elev::float8) AS anchor_elev,
                    n.the_geom,
                    n.expl_id
                FROM temp_path_raw r
                JOIN ve_node n ON n.node_id = r.node_id
                CROSS JOIN first_anchor fa
                WHERE fa.stop_seq IS NOT NULL
                  AND r.seq <= fa.stop_seq
                ORDER BY r.seq;

                IF EXISTS (SELECT 1 FROM temp_path_window) THEN
                    SELECT
                        p.node_id,
                        CASE
                            WHEN p.sys_elev IS NOT NULL THEN 'sys_elev'
                            WHEN (
                                (
                                    SELECT count(*)
                                    FROM arc a
                                    WHERE a.node_1 = p.node_id
                                       OR a.node_2 = p.node_id
                                ) > 2
                                AND p.custom_elev IS NOT NULL
                                AND EXISTS (
                                    SELECT 1
                                    FROM ve_arc a
                                    WHERE (a.node_1 = p.node_id OR a.node_2 = p.node_id)
                                      AND a.slope IS NOT NULL
                                )
                            ) THEN 'hard_point'
                            ELSE 'unknown'
                        END
                    INTO v_anchor_node, v_anchor_kind
                    FROM temp_path_window p
                    WHERE p.seq = (SELECT MAX(seq) FROM temp_path_window);

                    IF v_anchor_node IS NOT NULL THEN
                        INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                        VALUES (
                            v_fid,
                            'FLOWEXIT anchor node detected (' || v_anchor_kind || '): node_id=' || v_anchor_node,
                            4,
                            current_user
                        );
                    END IF;
                END IF;

                INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                SELECT
                    v_fid,
                    'FLOWEXIT hard point detected: node_id=' || p.node_id || ' (>2 connected arcs with slope and custom_elev)',
                    2,
                    current_user
                FROM temp_path_window p
                WHERE p.seq = (SELECT MAX(seq) FROM temp_path_window)
                  AND (
                      SELECT count(*)
                      FROM arc a
                      WHERE a.node_1 = p.node_id
                         OR a.node_2 = p.node_id
                  ) > 2
                  AND p.custom_elev IS NOT NULL
                  AND EXISTS (
                      SELECT 1
                      FROM ve_arc a
                      WHERE (a.node_1 = p.node_id OR a.node_2 = p.node_id)
                        AND a.slope IS NOT NULL
                  );

                IF NOT EXISTS (SELECT 1 FROM temp_path_window) THEN
                    v_message_level := 2;
                    v_message_text := 'No downstream fixed anchor was found inside the selected corridor.';
                    INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                    VALUES (v_fid, v_message_text, 1, current_user);

                    INSERT INTO temp_anl_arc (arc_id, fid, the_geom, descript, cur_user, expl_id, state_type)
                    SELECT
                        a.arc_id,
                        v_fid,
                        a.the_geom,
                        'FLOWEXIT corridor without downstream fixed anchor',
                        current_user,
                        a.expl_id,
                        v_state_type
                    FROM arc a
                    JOIN temp_path_raw r ON r.arc_id = a.arc_id
                    WHERE r.arc_id IS NOT NULL;

                ELSIF EXISTS (
                    SELECT 1
                    FROM temp_path_window
                    WHERE top_elev IS NULL
                ) THEN
                    v_message_level := 2;
                    v_message_text := 'The calculation window contains nodes without sys_top_elev.';
                    INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                    VALUES (v_fid, v_message_text, 1, current_user);

                ELSIF EXISTS (
                    SELECT 1
                    FROM temp_path_window
                    WHERE step_len IS NOT NULL
                      AND step_len <= 0
                ) THEN
                    v_message_level := 2;
                    v_message_text := 'The calculation window contains arcs with non-positive length.';
                    INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                    VALUES (v_fid, v_message_text, 1, current_user);

                ELSIF NOT EXISTS (
                    SELECT 1
                    FROM temp_path_window
                    WHERE seq = (SELECT MAX(seq) FROM temp_path_window)
                      AND anchor_elev IS NOT NULL
                ) THEN
                    v_message_level := 2;
                    v_message_text := 'The effective outlet node does not have a fixed elevation (sys_elev/custom_elev).';
                    INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                    VALUES (v_fid, v_message_text, 1, current_user);

                ELSE
                    SELECT MIN(seq), MAX(seq)
                    INTO v_min_seq, v_max_seq
                    FROM temp_path_window;

                    CREATE TEMP TABLE temp_profile_down_lower AS
                    WITH RECURSIVE rec AS (
                        SELECT
                            p.seq,
                            p.node_id,
                            p.arc_id,
                            p.step_len,
                            p.minslope,
                            p.maxslope,
                            p.top_elev,
                            p.min_bound,
                            p.max_bound,
                            p.sys_elev,
                            p.custom_elev,
                            p.anchor_elev,
                            p.the_geom,
                            p.anchor_elev::float8 AS down_low
                        FROM temp_path_window p
                        WHERE p.seq = v_max_seq

                        UNION ALL

                        SELECT
                            up.seq,
                            up.node_id,
                            up.arc_id,
                            up.step_len,
                            up.minslope,
                            up.maxslope,
                            up.top_elev,
                            up.min_bound,
                            up.max_bound,
                            up.sys_elev,
                            up.custom_elev,
                            up.anchor_elev,
                            up.the_geom,
                            GREATEST(
                                up.min_bound,
                                downrec.down_low + COALESCE(downrec.minslope, 0::float8) * COALESCE(downrec.step_len, 0::float8)
                            ) AS down_low
                        FROM rec downrec
                        JOIN temp_path_window up
                          ON up.seq = downrec.seq - 1
                    )
                    SELECT *
                    FROM rec
                    ORDER BY seq;

                    CREATE TEMP TABLE temp_profile_down_upper AS
                    WITH RECURSIVE rec AS (
                        SELECT
                            p.seq,
                            p.node_id,
                            p.arc_id,
                            p.step_len,
                            p.minslope,
                            p.maxslope,
                            p.top_elev,
                            p.min_bound,
                            p.max_bound,
                            p.sys_elev,
                            p.custom_elev,
                            p.anchor_elev,
                            p.the_geom,
                            p.anchor_elev::float8 AS down_high
                        FROM temp_path_window p
                        WHERE p.seq = v_max_seq

                        UNION ALL

                        SELECT
                            up.seq,
                            up.node_id,
                            up.arc_id,
                            up.step_len,
                            up.minslope,
                            up.maxslope,
                            up.top_elev,
                            up.min_bound,
                            up.max_bound,
                            up.sys_elev,
                            up.custom_elev,
                            up.anchor_elev,
                            up.the_geom,
                            LEAST(
                                up.max_bound,
                                downrec.down_high + COALESCE(downrec.maxslope, 0::float8) * COALESCE(downrec.step_len, 0::float8)
                            ) AS down_high
                        FROM rec downrec
                        JOIN temp_path_window up
                          ON up.seq = downrec.seq - 1
                    )
                    SELECT *
                    FROM rec
                    ORDER BY seq;

                    IF v_node1_is_fixed THEN
                        CREATE TEMP TABLE temp_profile_up_bounds AS
                        WITH RECURSIVE rec AS (
                            SELECT
                                p.seq,
                                p.node_id,
                                p.arc_id,
                                p.step_len,
                                p.minslope,
                                p.maxslope,
                                p.top_elev,
                                p.min_bound,
                                p.max_bound,
                                p.sys_elev,
                                p.custom_elev,
                                p.anchor_elev,
                                p.the_geom,
                                p.sys_elev::float8 AS up_low,
                                p.sys_elev::float8 AS up_high
                            FROM temp_path_window p
                            WHERE p.seq = v_min_seq

                            UNION ALL

                            SELECT
                                dn.seq,
                                dn.node_id,
                                dn.arc_id,
                                dn.step_len,
                                dn.minslope,
                                dn.maxslope,
                                dn.top_elev,
                                dn.min_bound,
                                dn.max_bound,
                                dn.sys_elev,
                                dn.custom_elev,
                                dn.anchor_elev,
                                dn.the_geom,
                                GREATEST(
                                    dn.min_bound,
                                    upr.up_low - COALESCE(dn.maxslope, 0::float8) * COALESCE(dn.step_len, 0::float8)
                                ) AS up_low,
                                LEAST(
                                    dn.max_bound,
                                    upr.up_high - COALESCE(dn.minslope, 0::float8) * COALESCE(dn.step_len, 0::float8)
                                ) AS up_high
                            FROM rec upr
                            JOIN temp_path_window dn
                              ON dn.seq = upr.seq + 1
                        )
                        SELECT *
                        FROM rec
                        ORDER BY seq;
                    ELSE
                        CREATE TEMP TABLE temp_profile_up_bounds AS
                        SELECT
                            p.seq,
                            p.node_id,
                            p.arc_id,
                            p.step_len,
                            p.minslope,
                            p.maxslope,
                            p.top_elev,
                            p.min_bound,
                            p.max_bound,
                            p.sys_elev,
                            p.custom_elev,
                            p.anchor_elev,
                            p.the_geom,
                            p.min_bound AS up_low,
                            p.max_bound AS up_high
                        FROM temp_path_window p
                        ORDER BY p.seq;
                    END IF;

                    CREATE TEMP TABLE temp_profile_bounds AS
                    SELECT
                        p.seq,
                        p.node_id,
                        p.arc_id,
                        p.step_len,
                        p.minslope,
                        p.maxslope,
                        p.top_elev,
                        p.min_bound,
                        p.max_bound,
                        p.sys_elev,
                        p.custom_elev,
                        p.anchor_elev,
                        p.the_geom,
                        GREATEST(
                            p.min_bound,
                            dl.down_low,
                            ub.up_low
                        ) AS low_elev,
                        LEAST(
                            p.max_bound,
                            du.down_high,
                            ub.up_high
                        ) AS high_elev
                    FROM temp_path_window p
                    JOIN temp_profile_down_lower dl USING (seq, node_id)
                    JOIN temp_profile_down_upper du USING (seq, node_id)
                    JOIN temp_profile_up_bounds ub USING (seq, node_id)
                    ORDER BY p.seq;

                    IF EXISTS (
                        SELECT 1
                        FROM temp_profile_bounds b
                        WHERE b.low_elev > b.high_elev + v_eps
                    ) THEN
                        v_message_level := 2;
                        v_message_text := 'No feasible profile satisfies minYmax, maxYmax, minSlope and maxSlope. Check anl_node (fid=496) for more details.';

                        INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                        VALUES (v_fid, v_message_text, 1, current_user);

                        INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
                        SELECT
                            v_fid,
                            concat(
                                'Node ', b.node_id,
                                ' -> gap=', round((b.low_elev - b.high_elev)::numeric, 3),
                                ' | lower: ',
                                CASE
                                    WHEN abs(b.low_elev - b.min_bound) <= v_eps THEN 'maxYmax=' || round(b.min_bound::numeric, 3)::text
                                    WHEN abs(b.low_elev - dl.down_low) <= v_eps THEN 'minSlope=' || round(dl.down_low::numeric, 3)::text
                                    WHEN abs(b.low_elev - ub.up_low) <= v_eps THEN 'upstream=' || round(ub.up_low::numeric, 3)::text
                                    ELSE round(b.low_elev::numeric, 3)::text
                                END,
                                ' | upper: ',
                                CASE
                                    WHEN abs(b.high_elev - b.max_bound) <= v_eps THEN 'minYmax=' || round(b.max_bound::numeric, 3)::text
                                    WHEN abs(b.high_elev - du.down_high) <= v_eps THEN 'maxSlope=' || round(du.down_high::numeric, 3)::text
                                    WHEN abs(b.high_elev - ub.up_high) <= v_eps THEN 'upstream=' || round(ub.up_high::numeric, 3)::text
                                    ELSE round(b.high_elev::numeric, 3)::text
                                END
                            ),
                            2,
                            current_user
                        FROM temp_profile_bounds b
                        JOIN temp_profile_down_lower dl USING (seq, node_id)
                        JOIN temp_profile_down_upper du USING (seq, node_id)
                        JOIN temp_profile_up_bounds ub USING (seq, node_id)
                        WHERE b.low_elev > b.high_elev + v_eps
                        ORDER BY b.seq;

                        INSERT INTO temp_anl_node (node_id, fid, the_geom, descript, top_elev, elev, ymax, cur_user, expl_id, state_type)
                        SELECT
                            b.node_id,
                            v_fid,
                            b.the_geom,
                            'FLOWEXIT - Infeasible: low_elev > high_elev',
                            b.top_elev,
                            b.low_elev,
                            (b.top_elev - b.low_elev),
                            current_user,
                            n.expl_id,
                            0
                        FROM temp_profile_bounds b
                        JOIN node n USING (node_id)
                        WHERE b.low_elev > b.high_elev + v_eps;

                    ELSE
                        CREATE TEMP TABLE temp_profile_final AS
                        SELECT
                            b.seq,
                            b.node_id,
                            b.arc_id,
                            b.step_len,
                            b.minslope,
                            b.maxslope,
                            b.top_elev,
                            b.min_bound,
                            b.max_bound,
                            b.sys_elev,
                            b.custom_elev,
                            b.anchor_elev,
                            b.the_geom,
                            b.low_elev,
                            b.high_elev,
                            CASE
                                WHEN b.seq = v_max_seq THEN b.anchor_elev::float8
                                WHEN b.seq = v_min_seq AND v_node1_is_fixed THEN b.sys_elev::float8
                                WHEN v_profile_mode = 'DEEP' THEN b.low_elev
                                WHEN v_profile_mode = 'SHALLOW' THEN b.high_elev
                                WHEN v_profile_mode = 'CENTERED' THEN (b.low_elev + b.high_elev) / 2.0
                                WHEN v_profile_mode = 'SMOOTH' THEN b.high_elev
                            END AS calc_elev
                        FROM temp_profile_bounds b
                        ORDER BY b.seq;

                        IF NOT v_node1_is_fixed THEN
                            UPDATE temp_profile_final f0
                            SET calc_elev = adj.new_elev
                            FROM (
                                SELECT
                                    f.seq,
                                    CASE
                                        WHEN v_profile_mode = 'DEEP' THEN
                                            GREATEST(
                                                f.low_elev,
                                                LEAST(
                                                    f.high_elev,
                                                    f1.calc_elev + COALESCE(f1.minslope, 0::float8) * COALESCE(f1.step_len, 0::float8)
                                                )
                                            )
                                        WHEN v_profile_mode = 'SHALLOW' THEN
                                            GREATEST(
                                                f.low_elev,
                                                LEAST(
                                                    f.high_elev,
                                                    f1.calc_elev + COALESCE(f1.maxslope, 0::float8) * COALESCE(f1.step_len, 0::float8)
                                                )
                                            )
                                        ELSE
                                            (
                                                GREATEST(
                                                    f.low_elev,
                                                    f1.calc_elev + COALESCE(f1.minslope, 0::float8) * COALESCE(f1.step_len, 0::float8)
                                                )
                                                +
                                                LEAST(
                                                    f.high_elev,
                                                    f1.calc_elev + COALESCE(f1.maxslope, 0::float8) * COALESCE(f1.step_len, 0::float8)
                                                )
                                            ) / 2.0
                                    END AS new_elev
                                FROM temp_profile_final f
                                JOIN temp_profile_final f1
                                  ON f1.seq = (
                                      SELECT MIN(seq)
                                      FROM temp_profile_final
                                      WHERE seq > f.seq
                                  )
                                WHERE f.seq = v_min_seq
                            ) adj
                            WHERE f0.seq = adj.seq;
                        END IF;

                        IF v_profile_mode = 'SMOOTH' THEN
                            FOR i IN 1..v_smooth_iterations LOOP
                                DROP TABLE IF EXISTS temp_profile_work;

                                CREATE TEMP TABLE temp_profile_work AS
                                SELECT
                                    cur.seq,
                                    cur.node_id,
                                    cur.arc_id,
                                    cur.step_len,
                                    cur.minslope,
                                    cur.maxslope,
                                    cur.top_elev,
                                    cur.low_elev,
                                    cur.high_elev,
                                    cur.sys_elev,
                                    cur.custom_elev,
                                    cur.anchor_elev,
                                    cur.calc_elev,
                                    prv.calc_elev AS prev_elev,
                                    nxt.calc_elev AS next_elev,
                                    cur.step_len AS len_prev_to_cur,
                                    nxt.step_len AS len_cur_to_next
                                FROM temp_profile_final cur
                                LEFT JOIN temp_profile_final prv ON prv.seq = cur.seq - 1
                                LEFT JOIN temp_profile_final nxt ON nxt.seq = cur.seq + 1
                                ORDER BY cur.seq;

                                UPDATE temp_profile_final f
                                SET calc_elev = upd.new_elev
                                FROM (
                                    SELECT
                                        w.seq,
                                        CASE
                                            WHEN w.seq = v_max_seq THEN w.calc_elev
                                            WHEN w.seq = v_min_seq AND v_node1_is_fixed THEN w.calc_elev
                                            WHEN w.seq = v_min_seq AND NOT v_node1_is_fixed THEN
                                                GREATEST(
                                                    GREATEST(
                                                        w.low_elev,
                                                        w.next_elev + COALESCE(w.minslope, 0::float8) * COALESCE(w.len_cur_to_next, 0::float8)
                                                    ),
                                                    LEAST(
                                                        LEAST(
                                                            w.high_elev,
                                                            w.next_elev + COALESCE(w.maxslope, 0::float8) * COALESCE(w.len_cur_to_next, 0::float8)
                                                        ),
                                                        (1.0 - v_smooth_alpha) * w.calc_elev
                                                        + v_smooth_alpha * (
                                                            w.next_elev + (
                                                                (COALESCE(w.minslope, 0::float8) + COALESCE(w.maxslope, 0::float8)) / 2.0
                                                            ) * COALESCE(w.len_cur_to_next, 0::float8)
                                                        )
                                                    )
                                                )
                                            WHEN w.prev_elev IS NULL OR w.next_elev IS NULL THEN w.calc_elev
                                            ELSE
                                                GREATEST(
                                                    GREATEST(
                                                        w.low_elev,
                                                        w.next_elev + COALESCE(w.minslope, 0::float8) * COALESCE(w.len_cur_to_next, 0::float8),
                                                        w.prev_elev - COALESCE(w.maxslope, 0::float8) * COALESCE(w.len_prev_to_cur, 0::float8)
                                                    ),
                                                    LEAST(
                                                        LEAST(
                                                            w.high_elev,
                                                            w.next_elev + COALESCE(w.maxslope, 0::float8) * COALESCE(w.len_cur_to_next, 0::float8),
                                                            w.prev_elev - COALESCE(w.minslope, 0::float8) * COALESCE(w.len_prev_to_cur, 0::float8)
                                                        ),
                                                        (1.0 - v_smooth_alpha) * w.calc_elev
                                                        + v_smooth_alpha * (
                                                            CASE
                                                                WHEN COALESCE(w.len_prev_to_cur, 0) + COALESCE(w.len_cur_to_next, 0) = 0
                                                                    THEN (w.prev_elev + w.next_elev) / 2.0
                                                                ELSE
                                                                    (
                                                                        COALESCE(w.len_cur_to_next, 0) * w.prev_elev +
                                                                        COALESCE(w.len_prev_to_cur, 0) * w.next_elev
                                                                    ) / NULLIF(COALESCE(w.len_prev_to_cur, 0) + COALESCE(w.len_cur_to_next, 0), 0)
                                                            END
                                                        )
                                                    )
                                                )
                                        END AS new_elev
                                    FROM temp_profile_work w
                                ) upd
                                WHERE f.seq = upd.seq;
                            END LOOP;
                        END IF;

                        INSERT INTO temp_anl_node (node_id, fid, the_geom, descript, cur_user, state_type, expl_id)
                        SELECT
                            s.node_id,
                            v_fid,
                            s.the_geom,
                            'FLOWEXIT(' || v_profile_mode || ') from node ' || v_node1 || ' to node ' || v_node2,
                            current_user,
                            v_state_type,
                            n.expl_id
                        FROM temp_profile_final s
                        JOIN ve_node n ON n.node_id = s.node_id;

                        UPDATE ve_node n
                           SET custom_elev = s.calc_elev
                        FROM temp_profile_final s
                        WHERE n.node_id = s.node_id
                          AND n.node_id <> v_node1
						  AND n.node_id <> v_node2
                          AND NOT (
                              (
                                  SELECT count(*)
                                  FROM arc a
                                  WHERE a.node_1 = n.node_id
                                     OR a.node_2 = n.node_id
                              ) > 2
                              AND n.custom_elev IS NOT NULL
                              AND EXISTS (
                                  SELECT 1
                                  FROM ve_arc a
                                  WHERE (a.node_1 = n.node_id OR a.node_2 = n.node_id)
                                    AND a.slope IS NOT NULL
                              )
                              AND s.seq <> v_min_seq
                              AND s.seq <> v_max_seq
                          );
                         
                          raise notice '3';
                         
                         update arc set custom_elev1 = s.calc_elev FROM temp_profile_final s where 
                         s.node_id = node_1 AND s.node_id <> v_node1 AND s.node_id <> v_node2;
                        
                         raise notice '4';
                        
                         update arc set custom_elev2 = s.calc_elev FROM temp_profile_final s where 
                         s.node_id = node_2 AND s.node_id <> v_node1 AND s.node_id <> v_node2;                        
						 
						-- restoring the rest of the triggers
   						UPDATE config_param_user SET value='false' WHERE parameter = 'edit_disable_topocontrol_complete' and cur_user = current_user;
						UPDATE config_param_user SET value='false' WHERE parameter = 'edit_disable_noderotation_complete' and cur_user = current_user;
						UPDATE config_param_user SET value='false' WHERE parameter = 'edit_disable_statetopocontrol' and cur_user = current_user;
						UPDATE config_param_user SET value='false' WHERE parameter = 'edit_disable_planpsector_node' and cur_user = current_user;
						UPDATE config_param_user SET value='false' WHERE parameter = 'edit_disable_arc_divide' and cur_user = current_user;		  
						  
                        INSERT INTO temp_anl_arc (arc_id, fid, the_geom, descript, cur_user, expl_id, state_type)
                        SELECT
                            a.arc_id,
                            v_fid,
                            a.the_geom,
                            'FLOWEXIT(' || v_profile_mode || ') from node ' || v_node1 || ' to node ' || v_node2,
                            current_user,
                            a.expl_id,
                            v_state_type
                        FROM arc a
                        JOIN temp_path_window p
                          ON p.arc_id = a.arc_id
                        WHERE p.arc_id IS NOT NULL;
                    END IF;
                END IF;
            END IF;
        END IF;

    ELSE
        v_message_level := 2;
        v_message_text := 'Unknown type. Allowed values are MASSIVE and FLOWEXIT.';
        INSERT INTO audit_check_data (fid, error_message, criticity, cur_user)
        VALUES (v_fid, v_message_text, 1, current_user);
    END IF;

    DELETE FROM anl_node
    WHERE cur_user = current_user
      AND fid = v_fid;

    INSERT INTO anl_node
    SELECT * FROM temp_anl_node;

    DELETE FROM anl_arc
    WHERE cur_user = current_user
      AND fid = v_fid;

    INSERT INTO anl_arc
    SELECT * FROM temp_anl_arc;

    SELECT array_to_json(array_agg(row_to_json(row)))
    INTO v_result
    FROM (
        SELECT id, error_message AS message
        FROM audit_check_data
        WHERE cur_user = current_user
          AND fid = v_fid
        ORDER BY criticity DESC, id ASC
    ) row;

    v_result := COALESCE(v_result, '[]');
    v_result_info := concat('{"values":', v_result, '}');

    v_result := NULL;
    SELECT jsonb_build_object(
        'type', 'FeatureCollection',
        'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
    )::jsonb
    INTO v_result
    FROM (
        SELECT jsonb_build_object(
            'type', 'Feature',
            'geometry', ST_AsGeoJSON(the_geom)::jsonb,
            'properties', to_jsonb(row) - 'the_geom'
        ) AS feature
        FROM (
            SELECT
                id,
                node_id,
                nodecat_id,
                state,
                expl_id,
                descript,
                top_elev, elev, ymax,
                fid,
                ST_Transform(the_geom, 4326) AS the_geom
            FROM temp_anl_node
            WHERE cur_user = current_user
              AND fid = v_fid
        ) row
    ) features;

    v_result_point := COALESCE(v_result, '{"type":"FeatureCollection","features":[]}'::jsonb)::json;

    v_result := NULL;
    SELECT jsonb_build_object(
        'type', 'FeatureCollection',
        'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
    )
    INTO v_result
    FROM (
        SELECT jsonb_build_object(
            'type', 'Feature',
            'geometry', ST_AsGeoJSON(the_geom)::jsonb,
            'properties', to_jsonb(row) - 'the_geom'
        ) AS feature
        FROM (
            SELECT
                id,
                arc_id,
                arccat_id,
                state,
                expl_id,
                descript,
                fid,
                ST_Transform(the_geom, 4326) AS the_geom
            FROM temp_anl_arc
            WHERE cur_user = current_user
              AND fid = v_fid
        ) row
    ) features;

    v_result_line := COALESCE(v_result, '{"type":"FeatureCollection","features":[]}'::jsonb);

    v_version      := COALESCE(v_version, '');
    v_result_info  := COALESCE(v_result_info, '{"values":[]}'::jsonb);
    v_result_point := COALESCE(v_result_point, '{"type":"FeatureCollection","features":[]}'::jsonb);
    v_result_line  := COALESCE(v_result_line, '{"type":"FeatureCollection","features":[]}'::jsonb);

    DROP TABLE IF EXISTS temp_anl_node;
    DROP TABLE IF EXISTS temp_anl_arc;

    RETURN (
        '{"status":"' || v_status || '", "message":{"level":' || v_message_level || ', "text":"' ||
        replace(v_message_text, '"', '\"') || '"}, "version":"' || replace(v_version, '"', '\"') || '"' ||
        ',"body":{"form":{}' ||
        ',"data":{"info":' || v_result_info::text || ',' ||
        '"point":' || v_result_point::text || ',' ||
        '"line":' || v_result_line::text || '}' ||
        '}}'
    )::json;

	EXCEPTION
	WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RAISE EXCEPTION 'gw_fct_node_interpolate_massive error: % | context: %', SQLERRM, v_error_context;
END;
$function$
;