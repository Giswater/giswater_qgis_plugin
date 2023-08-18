/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3264

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_minsector_inverted(p_result integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_minsector_inverted(p_result integer, p_step integer)
  RETURNS integer AS
$BODY$

-- fid: 129

DECLARE

rec_valve record;
rec_tank record;
rec_minsector record;
rec_mincut record;
rec_result record;
v_macroexpl integer;
v_minsector integer;
v_querytext text;
v_inletpath boolean;
v_cont1 integer = 0;
v_affected_rows integer;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	IF p_step = 1 THEN

		SELECT * INTO rec_mincut FROM temp_om_mincut;
		SELECT macroexpl_id INTO v_macroexpl FROM exploitation WHERE expl_id=rec_mincut.expl_id;

		-- this make sense when some of the proposed valves are not operative. Then inundation for that valve is needed in order to find next one
		IF (SELECT count(*) FROM temp_om_mincut_valve WHERE (broken or unaccess) and proposed) > 0 THEN
	
			-- create the graph
			INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf )
			SELECT node_id, minsector_1, minsector_2, 0, 0, 0 FROM minsector_graph WHERE expl_id = rec_mincut.expl_id
			UNION
			SELECT node_id, minsector_2, minsector_1, 0, 0, 0 FROM minsector_graph WHERE expl_id = rec_mincut.expl_id;

			-- setup valves enabled to participate
			UPDATE temp_t_anlgraph SET flag = 1 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE broken IS FALSE AND unaccess IS FALSE AND proposed IS not true);

			-- setup valves not enabled to participate
			UPDATE temp_t_anlgraph SET flag = 0 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE broken IS TRUE AND closed IS FALSE);

			-- set bonudary conditions with closed valves
			UPDATE temp_t_anlgraph SET flag = 1 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE closed is true);

			-- seting the starting elements to the right sense
			UPDATE temp_t_anlgraph SET water=1, trace = node_1::integer WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE (broken or unaccess) and proposed)
			AND node_1::integer = rec_mincut.minsector_id; 

			-- close the starting elements on the opossite sense
			UPDATE temp_t_anlgraph SET flag = 1 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE (broken or unaccess) and proposed)
			AND node_2::integer = rec_mincut.minsector_id; 
						
			--- start engine
			LOOP	
				v_cont1 = v_cont1+1;
				UPDATE temp_t_anlgraph n SET water = 1, trace = rec_mincut.minsector_id FROM v_t_anl_graph a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id;
				GET DIAGNOSTICS v_affected_rows =row_count;
				EXIT WHEN v_affected_rows = 0;
			END LOOP;

			-- insert arcs
			INSERT INTO temp_om_mincut_arc (result_id, arc_id, the_geom)
			SELECT p_result, arc_id, the_geom FROM arc WHERE minsector_id::text IN
			(SELECT node_1 FROM temp_t_anlgraph WHERE water = 1)
			ON CONFLICT (result_id, arc_id) DO NOTHING;

			-- insert nodes
			INSERT INTO temp_om_mincut_node (result_id, node_id, the_geom)
			SELECT p_result, node_id, the_geom FROM node WHERE minsector_id::text IN
			(SELECT node_1 FROM temp_t_anlgraph WHERE water = 1)
			ON CONFLICT (result_id, node_id) DO NOTHING;

			-- update proposed valves
			UPDATE temp_om_mincut_valve SET proposed = true 
			WHERE node_id IN (SELECT arc_id FROM temp_t_anlgraph WHERE water = 1);			
						
		END IF;

	ELSIF p_step = 2 THEN

		SELECT * INTO rec_mincut FROM temp_om_mincut;
		SELECT macroexpl_id INTO v_macroexpl FROM exploitation WHERE expl_id=rec_mincut.expl_id;

		-- Create the matrix to work with pgrouting
		INSERT INTO temp_t_mincut 
		SELECT a.id, a.source, a.target,
		(case when (a.id = b.id and a.source::text = b.source::text) then -1 else cost end) as cost, 			-- close especial case of config_graph_checkvalve only direct sense
		(case when (a.id = b.id and a.source::text != b.source::text) then -1 else reverse_cost end) as reverse_cost  	-- close especial case of config_graph_checkvalve only reverse sense
		FROM (
			SELECT arc.arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, 
			(case when a.closed=true then -1 else 1 end) as cost,
			(case when a.closed=true then -1 else 1 end) as reverse_cost
			FROM arc 
			JOIN exploitation USING (expl_id)
			LEFT JOIN (
				SELECT arc_id, true as closed FROM arc WHERE arc_id IN (SELECT arc_id FROM temp_om_mincut_arc)
				OR (node_1 IN (SELECT node_id FROM temp_om_mincut_valve WHERE closed=TRUE AND proposed IS NOT TRUE))					
				OR (node_2 IN (SELECT node_id FROM temp_om_mincut_valve WHERE closed=TRUE AND proposed IS NOT TRUE))	
				UNION
				SELECT json_array_elements_text((parameters->>'inletArc')::json) as arc_id, true as closed FROM config_graph_inlet
				)a 
			ON a.arc_id=arc.arc_id
			WHERE node_1 is not null and node_2 is not null AND state = 1 and macroexpl_id = v_macroexpl
		)a	
		LEFT JOIN (SELECT to_arc::int8 AS id, node_id::int8 AS source FROM config_graph_checkvalve)b USING (id);

		-- Loop for all the proposed valves
		FOR rec_valve IN SELECT node_id FROM temp_om_mincut_valve WHERE proposed = TRUE and unaccess=FALSE AND broken=FALSE
		LOOP
			FOR rec_tank IN 
			SELECT v_edit_node.node_id, v_edit_node.the_geom FROM config_graph_inlet
			JOIN v_edit_node ON v_edit_node.node_id=config_graph_inlet.node_id
			JOIN exploitation ON exploitation.expl_id=config_graph_inlet.expl_id
			WHERE (is_operative IS TRUE) AND (exploitation.macroexpl_id=v_macroexpl) AND config_graph_inlet.active IS TRUE 
			AND v_edit_node.the_geom IS NOT NULL AND v_edit_node.node_id NOT IN (select node_id FROM temp_om_mincut_node)
			ORDER BY 1
			LOOP
				/*
				The aim of this query_text is to draw (if exists) routing from valve to tank defineds on the loop using the pgrouting function ''pgr_dijkstra''
				We need to create the network matrix (transfering the closed status of closed valves an proposed valves to the closests arcs) 
				In order to transfer this propierty to the arc we need to identify
					1) Arcs into the proposed sector with node1 or node2 as proposed valves
					2) Arcs out of the proposed sector with node1 or node2 as (closed valves and not proposed valves)
				*/

				v_querytext:= 'SELECT * FROM pgr_dijkstra( ''SELECT id, source, target, cost, reverse_cost 
							FROM temp_t_mincut'','||rec_valve.node_id||'::int8, '||rec_tank.node_id||'::int8)';

				IF v_querytext IS NOT NULL THEN	EXECUTE v_querytext INTO rec_result; END IF;

				IF rec_result IS NOT NULL THEN
					v_inletpath=true;
					RAISE NOTICE 'valve % tank % v_inletpath % ', rec_valve.node_id, rec_tank.node_id, v_inletpath;
					EXIT;
				ELSE 
					v_inletpath=false;
					RAISE NOTICE 'valve % tank % v_inletpath % ', rec_valve.node_id, rec_tank.node_id, v_inletpath;
				END IF;
			END LOOP;
			
			IF v_inletpath IS FALSE THEN
								
				--Valve has no exit. Update proposed value
				UPDATE temp_om_mincut_valve SET proposed=FALSE, flag=TRUE WHERE node_id=rec_valve.node_id;
			END IF;
		END LOOP;

		IF (SELECT count(*) FROM temp_om_mincut_valve WHERE flag) > 0 THEN

			-- create the graph
			DELETE FROM temp_t_anlgraph;
			INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf )
			SELECT node_id, minsector_1, minsector_2, 0, 0, 0 FROM minsector_graph WHERE expl_id = rec_mincut.expl_id
			UNION
			SELECT node_id, minsector_2, minsector_1, 0, 0, 0 FROM minsector_graph WHERE expl_id = rec_mincut.expl_id;

			-- open the starting elements
			UPDATE temp_t_anlgraph SET water=1, trace = node_1::integer WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE flag);

			-- setup the new boundary conditions broken
			UPDATE temp_t_anlgraph SET flag = 0 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE broken IS TRUE AND closed IS FALSE);

			-- set the closed valve
			UPDATE temp_t_anlgraph SET flag = 1 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE closed is true);

			-- close the starting elements on the opossite sense
			UPDATE temp_t_anlgraph SET flag = 1 WHERE arc_id IN (SELECT node_id FROM temp_om_mincut_valve WHERE flag)
			AND node_2::integer IN (SELECT DISTINCT minsector_id FROM temp_om_mincut_arc);
						
			--- start engine
			LOOP	
				v_cont1 = v_cont1+1;
				UPDATE temp_t_anlgraph n SET water = 1, trace = rec_mincut.minsector_id FROM v_t_anl_graph a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id;
				GET DIAGNOSTICS v_affected_rows =row_count;
				EXIT WHEN v_affected_rows = 0;
			END LOOP;

			-- insert arcs
			INSERT INTO temp_om_mincut_arc (result_id, arc_id, the_geom)
			SELECT p_result, arc_id, the_geom FROM arc WHERE minsector_id::text IN
			(SELECT node_1 FROM temp_t_anlgraph WHERE water = 1)
			ON CONFLICT (result_id, arc_id) DO NOTHING;

			-- insert nodes
			INSERT INTO temp_om_mincut_node (result_id, node_id, the_geom)
			SELECT p_result, node_id, the_geom FROM node WHERE minsector_id::text IN
			(SELECT node_1 FROM temp_t_anlgraph WHERE water = 1)
			ON CONFLICT (result_id, node_id) DO NOTHING;

			-- set proposed = false all those valves have been inundated
			UPDATE temp_om_mincut_valve SET proposed=FALSE WHERE node_id IN (SELECT arc_id FROM temp_t_anlgraph WHERE water = 1); 
		END IF;

	ELSIF p_step = 3 THEN -- when is called on mincut conflict

		SELECT * INTO rec_mincut FROM om_mincut;
		SELECT macroexpl_id INTO v_macroexpl FROM exploitation WHERE expl_id=rec_mincut.expl_id;

		DROP TABLE IF EXISTS temp_t_mincut;
		CREATE TEMP TABLE temp_t_mincut (LIKE SCHEMA_NAME.temp_mincut INCLUDING ALL);

		-- Create the matrix to work with pgrouting
		INSERT INTO temp_t_mincut 
		SELECT a.id, a.source, a.target,
		(case when (a.id = b.id and a.source::text = b.source::text) then -1 else cost end) as cost, 			-- close especial case of config_graph_checkvalve only direct sense
		(case when (a.id = b.id and a.source::text != b.source::text) then -1 else reverse_cost end) as reverse_cost  	-- close especial case of config_graph_checkvalve only reverse sense
		FROM (
			SELECT arc.arc_id::int8 as id, node_1::int8 as source, node_2::int8 as target, 
			(case when a.closed=true then -1 else 1 end) as cost,
			(case when a.closed=true then -1 else 1 end) as reverse_cost
			FROM arc 
			JOIN exploitation USING (expl_id)
			LEFT JOIN (
				SELECT arc_id, true as closed FROM arc WHERE arc_id IN (SELECT arc_id FROM om_mincut_arc WHERE result_id = -2)
				OR (node_1 IN (SELECT node_id FROM om_mincut_valve WHERE closed=TRUE AND proposed IS NOT TRUE AND result_id = -2))					
				OR (node_2 IN (SELECT node_id FROM om_mincut_valve WHERE closed=TRUE AND proposed IS NOT TRUE AND result_id = -2))	
				UNION
				SELECT json_array_elements_text((parameters->>'inletArc')::json) as arc_id, true as closed FROM config_graph_inlet
				)a 
			ON a.arc_id=arc.arc_id
			WHERE node_1 is not null and node_2 is not null AND state = 1 and macroexpl_id = v_macroexpl
		)a	
		LEFT JOIN (SELECT to_arc::int8 AS id, node_id::int8 AS source FROM config_graph_checkvalve)b USING (id);

		-- Loop for all the proposed valves
		FOR rec_valve IN SELECT node_id FROM om_mincut_valve WHERE proposed = TRUE and unaccess=FALSE AND broken=FALSE AND result_id = p_result
		LOOP
			FOR rec_tank IN 
			SELECT v_edit_node.node_id, v_edit_node.the_geom FROM config_graph_inlet
			JOIN v_edit_node ON v_edit_node.node_id=config_graph_inlet.node_id
			JOIN exploitation ON exploitation.expl_id=config_graph_inlet.expl_id
			WHERE (is_operative IS TRUE) AND (exploitation.macroexpl_id=v_macroexpl) AND config_graph_inlet.active IS TRUE 
			AND v_edit_node.the_geom IS NOT NULL AND v_edit_node.node_id NOT IN (select node_id FROM om_mincut_node WHERE result_id = p_result) 
			ORDER BY 1
			LOOP
				/*
				The aim of this query_text is to draw (if exists) routing from valve to tank defineds on the loop using the pgrouting function ''pgr_dijkstra''
				We need to create the network matrix (transfering the closed status of closed valves an proposed valves to the closests arcs) 
				In order to transfer this propierty to the arc we need to identify
					1) Arcs into the proposed sector with node1 or node2 as proposed valves
					2) Arcs out of the proposed sector with node1 or node2 as (closed valves and not proposed valves)
				*/

				v_querytext:= 'SELECT * FROM pgr_dijkstra( ''SELECT id, source, target, cost, reverse_cost 
							FROM temp_t_mincut'','||rec_valve.node_id||'::int8, '||rec_tank.node_id||'::int8)';

				IF v_querytext IS NOT NULL THEN	EXECUTE v_querytext INTO rec_result; END IF;

				IF rec_result IS NOT NULL THEN
					v_inletpath=true;
					RAISE NOTICE 'valve % tank % v_inletpath % ', rec_valve.node_id, rec_tank.node_id, v_inletpath;
					EXIT;
				ELSE 
					v_inletpath=false;
					RAISE NOTICE 'valve % tank % v_inletpath % ', rec_valve.node_id, rec_tank.node_id, v_inletpath;
				END IF;
			END LOOP;
			
			IF v_inletpath IS FALSE THEN				
				--Valve has no exit. Update proposed value
				UPDATE om_mincut_valve SET proposed=FALSE, flag=TRUE WHERE node_id=rec_valve.node_id AND result_id = p_result;
			END IF;
		END LOOP;

		IF (SELECT count(*) FROM om_mincut_valve WHERE flag AND result_id = p_result ) > 0 THEN

			DROP VIEW IF EXISTS v_t_anl_graph;
			DROP TABLE  IF EXISTS temp_t_anlgraph;

			-- create temporal tables
			CREATE TEMP TABLE temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);
			CREATE OR REPLACE TEMP VIEW v_t_anl_graph AS 
			SELECT t.arc_id,t.node_1,t.node_2,t.trace,t.flag,t.water
			FROM temp_t_anlgraph t
			     JOIN ( SELECT arc_id, node_1, node_2, water, flag FROM temp_t_anlgraph WHERE water = 1) a ON t.node_1::text = a.node_2::text
			     WHERE t.flag < 2 AND t.water = 0 AND a.flag = 0;

			-- create the graph
			INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf )
			SELECT node_id, minsector_1, minsector_2, 0, 0, 0 FROM minsector_graph WHERE expl_id = rec_mincut.expl_id
			UNION
			SELECT node_id, minsector_2, minsector_1, 0, 0, 0 FROM minsector_graph WHERE expl_id = rec_mincut.expl_id;

			-- set the closed valve
			UPDATE temp_t_anlgraph SET flag = 1, trace = 2 WHERE arc_id IN (SELECT node_id FROM om_mincut_valve WHERE result_id = -2 AND closed is true);

			-- open the starting elements
			UPDATE temp_t_anlgraph SET water=1, flag = 0 , trace = 3 WHERE arc_id IN (SELECT node_id FROM om_mincut_valve WHERE flag AND result_id = -2);

			--- start engine
			LOOP	
				v_cont1 = v_cont1+1;
				UPDATE temp_t_anlgraph n SET water = 1, trace = 4 FROM v_t_anl_graph a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id;
				GET DIAGNOSTICS v_affected_rows =row_count;
				EXIT WHEN v_affected_rows = 0;
			END LOOP;

			-- insert arcs
			INSERT INTO om_mincut_arc (result_id, arc_id, the_geom)
			SELECT p_result, arc_id, the_geom FROM arc WHERE minsector_id::text IN
			(SELECT node_1 FROM temp_t_anlgraph WHERE water = 1)
			ON CONFLICT (result_id, arc_id) DO NOTHING;

			-- insert nodes
			INSERT INTO om_mincut_node (result_id, node_id, the_geom)
			SELECT p_result, node_id, the_geom FROM node WHERE minsector_id::text IN
			(SELECT node_1 FROM temp_t_anlgraph WHERE water = 1)
			ON CONFLICT (result_id, node_id) DO NOTHING;

			-- set proposed = false all those valves have been inundated
			UPDATE om_mincut_valve SET proposed=FALSE WHERE node_id IN (SELECT arc_id FROM temp_t_anlgraph WHERE water = 1)  AND result_id = p_result; 
		END IF;

		DROP TABLE IF EXISTS temp_t_mincut;

	END IF;

	RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;