/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2772

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_flowtrace(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_flowtrace(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_graphanalytics_flowtrace('{"data":{"parameters":{"graphClass":"DISCONNECTEDARCS", "exploitation": "[1]", "nodeId":"37"}}}');
SELECT SCHEMA_NAME.gw_fct_graphanalytics_flowtrace('{"data":{"parameters":{"graphClass":"CONNECTEDARCS","exploitation": "[557]",  "nodeId":"5100"}}}');

--RESULTS
SELECT * FROM anl_arc WHERE fid=193 AND cur_user=current_user
SELECT * FROM anl_arc WHERE fid=194 AND cur_user=current_user

-- fid, 193, 194

*/

DECLARE
affected_rows numeric;
v_count integer default 0;
v_nodeid integer;
v_sum integer = 0;
v_class text;
v_fid integer;
v_sign varchar(2);
v_expl json;
v_text text;
v_querytext text;
v_result text;
v_result_info json;
v_result_line json;
v_version text;
v_projectype varchar(2);
v_srid int4;
v_error_context text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
   	v_nodeid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'nodeId');
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'graphClass');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');

	-- select config values
	SELECT giswater, epsg, project_type INTO v_version, v_srid, v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- set values
	IF v_class = 'DISCONNECTEDARCS' THEN
		v_fid=193;
		v_sign = '=';
	ELSIF v_class = 'CONNECTEDARCS' THEN
		v_fid=194;
		v_sign = '>';
	END IF;

	-- reset graph & audit tables
	DELETE FROM anl_arc where cur_user=current_user AND fid=v_fid;
	DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;

	-- reset exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user)
		SELECT expl_id, current_user FROM exploitation WHERE expl_id IN	(SELECT (json_array_elements_text(v_expl))::integer);
	END IF;

	-- Starting process
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2772", "parameters":{"param1":"'||upper(v_class)||'"}, "fid":"'||v_fid||'", "is_header":true, "is_process":true}}$$)';

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2772", "fid":"'||v_fid||'", "is_header":true, "is_process":true, "label_id":"3001", "separator_id":"2014"}}$$)';


	CREATE TEMP TABLE temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);

CREATE OR REPLACE TEMP VIEW v_temp_anlgraph AS
 SELECT anl_graph.arc_id,
    anl_graph.node_1,
    anl_graph.node_2,
    anl_graph.flag,
    a.flag AS flagi
   FROM temp_t_anlgraph anl_graph
     JOIN ( SELECT anl_graph_1.arc_id,
            anl_graph_1.node_1,
            anl_graph_1.node_2,
            anl_graph_1.water,
            anl_graph_1.flag,
            anl_graph_1.checkf
           FROM temp_t_anlgraph anl_graph_1
          WHERE anl_graph_1.water = 1) a ON anl_graph.node_1::text = a.node_2::text
  WHERE anl_graph.flag < 2 AND anl_graph.water = 0 AND a.flag < 2;


	-- fill the graph table
	INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf)
	SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM ve_arc
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM ve_arc
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;


	-- set boundary conditions of graph table ONLY FOR WS (flag=1 it means water is disabled to flow)
	IF v_projectype = 'WS' THEN

		v_text = 'SELECT ((json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'')::integer as node_id from sector WHERE graphconfig IS NOT NULL';

		-- close boundary conditions setting flag=1 for all nodes that fits on graph delimiters and closed valves
		v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE 
			node_1 IN('||v_text||' UNION
			SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.node_type 
			LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer JOIN temp_t_anlgraph e ON a.node_id::integer=e.node_1::integer WHERE (''MINSECTOR'' = ANY(graph_delimiter) AND closed=TRUE))
			OR node_2 IN ('||v_text||' UNION
			SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.node_type 
			LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer JOIN temp_t_anlgraph e ON a.node_id::integer=e.node_1::integer WHERE (''MINSECTOR'' = ANY(graph_delimiter) AND closed=TRUE))';

		EXECUTE v_querytext;

		-- open boundary conditions set flag=0 for graph delimiters that have been setted to 1 on query before BUT ONLY ENABLING the right sense (to_arc)
		UPDATE temp_t_anlgraph SET flag=0 WHERE id IN (
			SELECT id FROM temp_t_anlgraph JOIN (
			SELECT ((json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent')::integer AS node_id,
			json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json)
			AS to_arc FROM sector
			WHERE graphconfig IS NOT NULL ORDER BY 1,2) a
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);
	END IF;

	-- init inlet
	UPDATE temp_t_anlgraph	SET flag=1, water=1 WHERE node_1 = v_nodeid;

	-- inundation process
	LOOP
		v_count = v_count+1;
                update temp_t_anlgraph n set water= 1, flag=n.flag+1 from v_temp_anlgraph a where n.node_1 = a.node_1  and n.arc_id = a.arc_id;

		GET DIAGNOSTICS affected_rows =row_count;
		exit when affected_rows = 0;
		EXIT when v_count = 400;

		v_sum = v_sum + affected_rows;
		RAISE NOTICE ' % % %', v_count, affected_rows, v_sum;
	END LOOP;

	-- insert into result table
	EXECUTE 'INSERT INTO anl_arc (fid, arc_id, the_geom, descript)
		SELECT DISTINCT ON (a.arc_id) '||v_fid||', a.arc_id, the_geom, '''||v_class||'''	FROM temp_t_anlgraph a
		JOIN arc b ON a.arc_id=b.arc_id GROUP BY a.arc_id, the_geom HAVING max(water) '||v_sign||' 0 ';

	-- count arcs
	EXECUTE 'SELECT count(*) FROM (SELECT DISTINCT ON (arc_id) count(*) FROM temp_t_anlgraph GROUP BY arc_id HAVING max(water)'||v_sign||' 0 )a'
		INTO v_count;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3516", "criticity":"1", "function":"2772", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'", "is_process":true}}$$)';


	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- arcs
	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT arc_id, arccat_id, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom FROM ve_arc WHERE arc_id::text IN
	(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid)) row) features;

	v_result_line := COALESCE(v_result, '{}');


	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	DROP VIEW v_temp_anlgraph;
	DROP TABLE temp_t_anlgraph;

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
					  '"line":'||v_result_line||
					  '}}}')::json, 2772, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;