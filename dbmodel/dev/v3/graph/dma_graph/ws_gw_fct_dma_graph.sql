/*
This file IS part of Giswater 3
The program IS free software: you can redistribute it and/or modify it under the terms of the GNU General Public License AS published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater IS provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_dma_graph(p_data json)
	RETURNS json
	LANGUAGE plpgsql
AS $function$

-- Function code: 3326

/*

SELECT SCHEMA_NAME.gw_fct_dma_graph($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{},"data":{"parameters":{"explId":513, "searchDistRouting":999}}}$$);

*/

DECLARE 
-- input params --
v_expl_id INTEGER;
v_search_dist INTEGER;

-- vars --
v_srid INTEGER;
rec_meter RECORD;
v_tank_id INTEGER;
rec RECORD;
v_sql_pgrouting TEXT;

-- return --
v_version TEXT;
v_result_info TEXT;


BEGIN
	
	-- NOTE: Search path
	SET search_path = "SCHEMA_NAME", public;


	-- NOTE: Input params
	v_expl_id = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'explId')::integer;
	v_search_dist = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'searchDistRouting')::integer;

	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version LIMIT 1;


	-- PART 1 (embeded in  gw_fct_mapzonesanalitics)

	-- NOTE: Reset values
	DELETE FROM dma_graph_meter WHERE expl_id = v_expl_id;
	DELETE FROM dma_graph_object WHERE expl_id = v_expl_id;
	DELETE FROM temp_dma_order WHERE meter_id IN (SELECT node_id::INT FROM node WHERE expl_id = v_expl_id);
	
	
	-- NOTE: Get topology of dma's
	v_sql_pgrouting = 'WITH entr AS (SELECT node_id, dma_id AS dma_2 FROM om_waterbalance_dma_graph WHERE flow_sign = 1),
	sort AS (SELECT node_id, dma_id AS dma_1 FROM om_waterbalance_dma_graph WHERE flow_sign = -1)
	SELECT node_id::int AS id, 
	case when dma_1 is null then 0 else dma_1 end AS source,
	case when dma_2 is null then 0 else dma_2 end AS target, 
	1 AS cost FROM entr 
	LEFT JOIN sort USING (node_id)
	JOIN node n using (node_id) 
	where n.state = 1 
	AND n.expl_id = '||v_expl_id||'';


	-- NOTE: Get the flooding order of the dma's using previous query
	FOR rec in execute 'SELECT DISTINCT "source" from ('||v_sql_pgrouting||')a'
	LOOP
		
		execute '
		INSERT INTO temp_dma_order (meter_id, dma_1, dma_2, agg_cost)
		SELECT edge AS meter_id, '||rec."source"||' AS dma_1, node AS dma_2, agg_cost 
		FROM pgr_drivingDistance('||quote_literal(v_sql_pgrouting)||', '||rec."source"||', '||v_search_dist||')
		ON CONFLICT (meter_id, dma_1, dma_2) DO NOTHING
		';

	END LOOP;
	
	
	-- SECTION: STEP 1.1 Fill the table dma_graph_meter (the tanks are represented with meter_id = 0)
	INSERT INTO dma_graph_meter (meter_id, object_1, object_2, expl_id, attrib, the_geom, order_id) 
	SELECT a.meter_id, a.dma_1, a.dma_2, n.expl_id, 
    json_build_object(
    'networkPressureType', n.category_type,
    'meterId', a.meter_id,
    'meterTransmission', c.matcat_id
    ) AS attributs,
    --st_makeline(array[st_centroid(d.the_geom), n.the_geom, st_centroid(e.the_geom)]) AS the_geom,
    st_makeline(CASE WHEN d.the_geom IS NULL THEN n.the_geom ELSE st_centroid(d.the_geom) end, st_centroid(e.the_geom)) AS the_geom,    
    a.agg_cost AS order_id
    FROM temp_dma_order a
    JOIN node n ON a.meter_id::text = n.node_id
    JOIN cat_node c ON c.id = n.nodecat_id
    LEFT JOIN dma d ON d.dma_id = a.dma_1 
    LEFT JOIN dma e ON e.dma_id = a.dma_2
    WHERE n.expl_id = v_expl_id AND a.agg_cost = 1
    ON CONFLICT (meter_id, expl_id) DO NOTHING;

	-- !SECTION
   	
   	-- SECTION: STEP 1.2 Fill the table dma_graph_object (it has dma's AND tanks)

	-- NOTE: Insert dmas
	INSERT INTO dma_graph_object (object_id, expl_id, object_type, the_geom, order_id)
	SELECT DISTINCT dma_id, d.expl_id, 'DMA', st_centroid(the_geom), min(b.agg_cost) 
	FROM om_waterbalance_dma_graph 
	LEFT JOIN dma d using (dma_id) 
	LEFT JOIN temp_dma_order b ON dma_id = b.dma_2
	WHERE expl_id = v_expl_id
	group by dma_id, expl_id, st_centroid(the_geom)
	ON CONFLICT (object_id, expl_id) DO NOTHING;

	-- NOTE: Insert tanks 
	-- (pgr_drivingdistnace): take them from the meter_id WHERE dma_1 = 0 AND dma_2 > 0

	-- !SECTION

	-- SECTION: prepare graph: go backward from the meter to look for the tank upstream
	v_sql_pgrouting = '
	SELECT arc_id::int AS id, node_1::int AS source, node_2::int AS target,
	CASE WHEN mv1.closed IS true or mv2.closed then -1
	WHEN a.dma_id = 0 then 1 
	ELSE -1 END AS cost,
	CASE WHEN mv1.closed IS true or mv2.closed then -1
	WHEN a.dma_id = 0 then 1 
	ELSE -1 END AS reverse_cost
	FROM arc a
	LEFT JOIN man_valve mv1 ON node_1=mv1.node_id
	LEFT JOIN man_valve mv2 ON node_2=mv2.node_id
	WHERE a.node_1 IS NOT NULL AND a.node_2 IS NOT NULL AND a.state = 1 AND a.dma_id <1
	AND (mv1.closed IS NOT true OR mv2.closed IS NOT true) 
	AND a.expl_id = '||v_expl_id||'
	';

   	-- LOOP for each meter_id WHERE dma_1 = 0 AND dma_2 > 0 -> AND then, find the tank (=last node_id)
   	FOR rec_meter IN SELECT meter_id::INT FROM temp_dma_order WHERE dma_1 = 0 AND dma_2 > 0
   	LOOP

		-- flood all the pipes upstream from the meter AND AVOID the pipes that have closed valves AS node_1 or node_2
	   	EXECUTE '
	   	SELECT a.node FROM pgr_drivingdistance ('||quote_literal(v_sql_pgrouting)||', '||rec_meter.meter_id||', 1000) a
		JOIN node n ON node = n.node_id::int WHERE n.nodecat_id LIKE ''%DEP%''
		ORDER BY a.agg_cost ASC LIMIT 1
    	' INTO v_tank_id;
    
    	RAISE NOTICE 'v_tank_id %', v_tank_id;
  	   	
   	   
   	   	IF v_tank_id IS NOT NULL THEN -- there IS a tank upstream FROM the meter_is
   	   	
   	   		EXECUTE 'INSERT INTO dma_graph_meter (meter_id, expl_id, object_1, object_2, order_id)
   	   		VALUES ('||v_tank_id||', '||v_expl_id||', '||v_tank_id||', '||rec_meter.meter_id||', 1)
			ON CONFLICT (meter_id, expl_id) DO NOTHING';
   	   	
   	   		EXECUTE 'UPDATE dma_graph_meter SET object_1 = '||v_tank_id||' WHERE meter_id = '||rec_meter.meter_id||'';
   	   		
   	   		EXECUTE '
	   	   	INSERT INTO dma_graph_object (object_id, object_type, expl_id, order_id) 
			SELECT  '||v_tank_id||', ''TANK'', '||v_expl_id||', b.agg_cost FROM dma_graph_meter a 
			LEFT JOIN temp_dma_order b using (meter_id)
			LEFT JOIN node c ON b.meter_id = c.node_id::int
			WHERE b.meter_id = '||rec_meter.meter_id||'	
			';
		
			UPDATE dma_graph_object t SET the_geom = a.the_geom FROM (
				SELECT node_id, the_geom FROM node
			)a WHERE t.object_id = a.node_id::int;
		
	
		END IF;
	
			
	END LOOP;

	-- !SECTION

	-- NOTE: Stats of table dma_graph_object (table of nodes of the graph)
	UPDATE dma_graph_object t SET attrib = a.json_stats FROM (
		WITH dma_graph_stats AS (
		    WITH aa AS ( -- pipe len
		    SELECT dma_id, round(sum(st_length(the_geom)::numeric/1000), 2) AS pipe_length
		    FROM arc WHERE state = 1 GROUP BY dma_id
		    ), bb AS ( -- conexiones totales
		    SELECT dma_id, count(*) AS n_connecs
		    FROM connec WHERE state = 1 GROUP BY dma_id
		    ), cc AS ( -- abonados totales
		    SELECT c.dma_id, count(a.hydrometer_id) AS n_hydro FROM rtc_hydrometer_x_connec a 
		    JOIN connec c USING (connec_id) GROUP BY c.dma_id
		    ), dd AS ( -- count de bombas
		    SELECT a.dma_id, count(a.node_id) AS n_pump FROM node a 
		    LEFT JOIN cat_node b ON a.nodecat_id = b.id WHERE b.nodetype_id = 'BOMBA'
		    AND a.state = 1 GROUP BY b.nodetype_id, a.dma_id
		    ), ee AS ( -- count de valv reduc pres
		    SELECT a.dma_id, count(a.node_id) AS n_vrp FROM node a 
		    LEFT JOIN cat_node b ON a.nodecat_id = b.id WHERE b.nodetype_id = 'VALVULA_REDUCTORA_PRES'
		    AND a.state = 1 GROUP BY b.nodetype_id, a.dma_id
		    ), all_tab AS (
		    SELECT dma_id, 
		    coalesce(aa.pipe_length, 0) AS pipe_length, 
		    coalesce(bb.n_connecs, 0) AS n_connecs, 
		    coalesce(cc.n_hydro, 0) AS n_hydro, 
		    coalesce(dd.n_pump, 0) AS n_pump, 
		    coalesce(ee.n_vrp, 0) AS n_vrp FROM aa 
		        LEFT JOIN bb using (dma_id)
		        LEFT JOIN cc using (dma_id)
		        LEFT JOIN dd using (dma_id)
		        LEFT JOIN ee using (dma_id)
		    )
		    SELECT dma_id, json_build_object(
		    'pipeLength', pipe_length,
		    'numConnecs', n_connecs,
		    'numHydro', n_hydro,
		    'numPump', n_pump,
		    'numVrp', n_vrp
		    )::text AS json_stats FROM all_tab
		)
		SELECT DISTINCT a.dma_id AS object_id, a.json_stats FROM dma_graph_stats a
		LEFT JOIN dma b USING (dma_id)
		LEFT JOIN temp_dma_order c ON b.graphconfig -> 'use' -> 0 ->> 'nodeParent' = c.meter_id::text
	)a WHERE a.object_id = t.object_id;
	
	-- SECTION: Update values
	-- NOTE: Fill dma_graph_object
	UPDATE dma_graph_object set attrib = '{}' WHERE attrib IS NULL;
	UPDATE dma_graph_object t SET object_label = a.name FROM (SELECT node_id, name FROM man_tank)a WHERE t.object_id = a.node_id::int;
	UPDATE dma_graph_object t SET object_label = a.name FROM (SELECT dma_id, name FROM dma)a WHERE t.object_id = a.dma_id;
	UPDATE dma_graph_object SET coord_x = st_x(the_geom) WHERE expl_id = v_expl_id;
	UPDATE dma_graph_object SET coord_y = st_y(the_geom) WHERE expl_id = v_expl_id;

	-- NOTE: Update agg_cost for DMAs (object_1 and object_2)
	UPDATE dma_graph_object a SET order_id = b.max_cost FROM (
	SELECT a.object_1, max(b.agg_cost) AS max_cost FROM dma_graph_meter a 
	LEFT JOIN temp_dma_order b USING (meter_id) GROUP BY meter_id, expl_id, object_1, object_2, attrib, the_geom
	)b WHERE a.object_id = b.object_1;
	
	UPDATE dma_graph_object a SET order_id = b.max_cost FROM (
	SELECT a.object_2, max(b.agg_cost) AS max_cost FROM dma_graph_meter a 
	LEFT JOIN temp_dma_order b USING (meter_id) GROUP BY meter_id, expl_id, object_1, object_2, attrib, the_geom
	)b WHERE a.object_id = b.object_2;


	-- NOTE: Build topology of meters into table of nodes
	UPDATE dma_graph_object t SET meter_2 = a.meter_1 FROM (
		SELECT object_1, array_agg(meter_id) AS meter_1 
		FROM dma_graph_meter WHERE expl_id = v_expl_id 
		GROUP BY object_1
	)a WHERE t.object_id = a.object_1 AND t.expl_id = v_expl_id;

	UPDATE dma_graph_object t SET meter_1 = a.meter_2 FROM (
		SELECT object_2, array_agg(meter_id) AS meter_2 
		FROM dma_graph_meter WHERE expl_id = v_expl_id 
		GROUP BY object_2
	)a WHERE t.object_id = a.object_2 AND t.expl_id = v_expl_id;

	UPDATE dma_graph_object 
	SET meter_1 = array_remove(meter_1, object_id), meter_2 = array_remove(meter_2, object_id) 
	WHERE expl_id = v_expl_id;

	
	UPDATE dma_graph_meter t SET the_geom = a.line_tank FROM (
	SELECT a.meter_id, st_makeline(n.the_geom, st_centroid(b.the_geom)) AS line_tank FROM dma_graph_meter a
	LEFT JOIN node n ON a.object_1 = n.node_id::int
	LEFT JOIN dma b ON a.object_2 = b.dma_id::int
	WHERE st_makeline(n.the_geom, st_centroid(b.the_geom)) IS NOT NULL
	)a WHERE t.meter_id = a.meter_id;

	UPDATE dma_graph_meter t SET order_id = max_agg_cost FROM (
		SELECT a.meter_id, max(b.agg_cost) AS max_agg_cost from dma_graph_meter a 
		JOIN temp_dma_order b USING (meter_id)
		WHERE a.expl_id = v_expl_id
		GROUP BY meter_id, expl_id
	)a WHERE t.meter_id = a.meter_id;

	-- !SECTION

	-- clean data
	UPDATE dma_graph_object SET order_id = 0 WHERE object_type = 'TANK';
	
	update dma_graph_object set meter_1 = null WHERE object_type = 'TANK';

	delete from dma_graph_meter where meter_id = object_1 and expl_id = v_expl_id;


	v_version = COALESCE(v_version, '{}');
	v_result_info = COALESCE(v_result_info, '{}');


	execute 'SELECT gw_fct_dma_graph_json($${
	"client":{"device":4, "infoType":1, "lang":"ES"},
	"feature":{},"data":{"parameters":{"explId":'||v_expl_id||', "searchDistRouting":999}}}$$)';

	-- NOTE: Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"DMA graph successfully created"}, "version":"'||v_version||'"'||
				',"body":{"form":{}'||
				',"data":{ "info":'||v_result_info||'}}'||
			'}')::json, 3326, null, null, null);

END;

$function$
;