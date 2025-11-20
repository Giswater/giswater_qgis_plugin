/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2826

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_lrs(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_lrs(
	p_data json)
    RETURNS json
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$


/*

SELECT SCHEMA_NAME.gw_fct_graphanalytics_lrs('{"data":{"parameters":{"exploitation":"1"}}}');

*/

DECLARE
v_acc_value numeric(12,3);
v_affectedrows numeric;
v_feature record;
v_expl json;
v_fid integer;
v_querytext text;
v_input json;
v_visible_layer text;
v_error_context text;
v_querynode text;
v_queryarc text;
v_costfield text;
v_valuefield text;
v_headerfield text;
v_header_arc text;
v_last_arc text;
v_current_value numeric;
v_current_arc text;
v_header_node TEXT;
v_end_node TEXT;
v_node_list text[];
v_node_string text;
v_bifurcation integer;
v_bif_header_arc text;
v_bif_header_node text;
v_count_feature integer;
v_bif_acc_value numeric;

rec record;

v_result_info json;
v_result_point json;
v_result_line json;
v_result_fields json;
v_result_polygon json;
v_result text;
v_version text;
v_debug json;
v_header json;
v_end_bifurc text;

BEGIN

	-- init path
	SET search_path = "SCHEMA_NAME", public, pg_catalog;

	-- get variables (from input)
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_expl=json_agg(v_expl);

	-- get variables (from config_param_system)
	v_costfield = (SELECT (value::json->>'arc')::json->>'costField' FROM config_param_system WHERE parameter='utils_graphanalytics_lrs_graph');
	v_valuefield = (SELECT (value::json->>'nodeChild')::json->>'valueField' FROM config_param_system WHERE parameter='utils_graphanalytics_lrs_feature');
	v_headerfield = (SELECT (value::json->>'nodeChild')::json->>'headerField' FROM config_param_system WHERE parameter='utils_graphanalytics_lrs_feature');

	-- setting cost field when has not configure value
	IF v_costfield IS NULL THEN
		v_costfield =  '1::float';
	END IF;

	v_version = (SELECT giswater FROM sys_version ORDER BY id DESC LIMIT 1);

	-- set variables
	v_fid=376;

	-- data quality analysis
	v_input = '{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}'::json;
	PERFORM gw_fct_om_check_data(v_input);

	-- todo: manage result of quality data in case of errors


	-- Starting process
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('DYNAMIC LINEAR REFERENCING SYSTEM'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('---------------------------------------------------'));

	-- reset tables (graph & audit_log)
	DELETE FROM audit_log_data WHERE fid=v_fid AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;

	CREATE OR REPLACE TEMP VIEW v_anl_graph AS
	 SELECT anl_graph.arc_id,
	    anl_graph.node_1,
	    anl_graph.node_2,
	    anl_graph.flag,
	    a.flag AS flagi,
	    a.value
	   FROM temp_anlgraph anl_graph
	     JOIN ( SELECT anl_graph_1.arc_id,
	            anl_graph_1.node_1,
	            anl_graph_1.node_2,
	            anl_graph_1.water,
	            anl_graph_1.flag,
	            anl_graph_1.checkf,
	            anl_graph_1.value
	           FROM temp_anlgraph anl_graph_1
	          WHERE anl_graph_1.water = 1) a ON anl_graph.node_1::text = a.node_2::text
	  WHERE anl_graph.flag < 2 AND anl_graph.water = 0 AND a.flag < 2;


	-- reset user's state
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid,
	concat('INFO: State have been forced to ''1'''));

	-- reset user's psectors
	DELETE FROM selector_psector WHERE cur_user=current_user;
	INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid,
	concat('INFO: All psectors have been disabled to execute this analysis'));

	-- reset user's exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation where macroexpl_id IN
		(SELECT distinct(macroexpl_id) FROM exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
	END IF;

	-- water:  dry (0) wet (1)
	-- flag: open (0) closed (1)
	-- checkf: not used (0) used (1)
	-- length: arc length
	-- cost: cost value (only when lrs analytics is used)
	-- value: result value (only when lrs analytics is used)

	-- create graph (all boundary conditions are opened, flag=0)

	v_queryarc = 'SELECT json_array_elements_text((value::json->>''ignoreArc'')::json) 
				FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph''';

	EXECUTE 'INSERT INTO temp_anlgraph ( arc_id, node_1, node_2, water, flag, checkf, length, cost, value )
	SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0, st_length(the_geom), '||v_costfield||', 0 FROM ve_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE AND arc_id NOT IN ('||v_queryarc||')
	UNION
	SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0, st_length(the_geom), '||v_costfield||', 0 FROM ve_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE AND arc_id NOT IN ('||v_queryarc||');';

	-- getting v_querys of node header (node_id and toarc) from config variable
	v_querynode = 'SELECT json_array_elements_text((value::json->>''headers'')::json)::json->>''node'' AS node_id 
				  FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph''';

	v_queryarc =  'SELECT json_array_elements_text((value::json->>''headers'')::json)::json->>''node'' as node_id,
			      json_array_elements_text(((json_array_elements_text((value::json->>''headers'')::json))::json->>''toArc'')::json) as to_arc 
				  FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph'' order by 1,2';


	EXECUTE 'select array_agg(a.node_id) from(
	SELECT json_array_elements_text((value::json->>''headers'')::json)::json->>''node'' AS node_id 
	FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph'')a'
	into v_node_list;
	--raise notice 'v_node_list,%',v_node_list;
	-- close boundary conditions, setting flag=1 for all nodes that fits on graph delimiters
	EXECUTE 'UPDATE temp_anlgraph SET flag=1 WHERE node_1::text IN ('||v_querynode||') OR  node_2::text IN ('||v_querynode||')';

	-- open boundary conditions, setting again flag=0 for graph delimiters that have been setted to 1 on query before BUT ONLY ENABLING the right sense (to_arc)
	EXECUTE 'UPDATE temp_anlgraph SET flag=0 WHERE id IN (SELECT id FROM temp_anlgraph 
								JOIN ('||v_queryarc||') a ON to_arc::integer=arc_id::integer 
								WHERE node_id::integer=node_1::integer)';
	--list only to_arc
	v_queryarc =  'select json_array_elements_text(((json_array_elements_text((value::json->>''headers'')::json))::json->>''toArc'')::json) as to_arc 
	FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph'' order by 1';

	-- starting process
	LOOP

		-- looking to pick one graph header
		--select header node and correct to_arc direction
		v_querytext = 'SELECT * FROM temp_anlgraph WHERE node_1::text IN ('||v_querynode||') AND checkf = 0 
		AND arc_id::TEXT IN ('||v_queryarc||')  LIMIT 1';


		IF v_querytext IS NOT NULL THEN
			EXECUTE v_querytext INTO v_feature;

			--set value of accumulation sum
			v_acc_value = 0;
			--RAISE NOTICE 'v_acc_value_BEGIN,%',v_acc_value;

		END IF;

		v_header_arc = v_feature.arc_id::text;
		v_header_node = v_feature.node_1::text;

		EXIT WHEN v_feature.node_1 IS NULL;

		-- reset water flag
		UPDATE temp_anlgraph SET water=0;

		-- set the starting element
		v_querytext = 'UPDATE temp_anlgraph SET water=1 WHERE node_1='||quote_literal(v_feature.node_1)||' AND flag=0';
		EXECUTE v_querytext;

		-- set the starting element (check)
		v_querytext = 'UPDATE temp_anlgraph SET checkf=1 WHERE arc_id='||quote_literal(v_feature.arc_id)||'';
		EXECUTE v_querytext;


		-- inundation process
		LOOP

			IF v_feature.node_1::text = v_header_node then
				v_acc_value=0;
				v_current_value=0;
			end if;

			SELECT node_2::text INTO v_end_node FROM temp_anlgraph WHERE arc_id::text=v_header_arc AND node_1::text = v_header_node limit 1;

			SELECT length * cost INTO v_current_value FROM temp_anlgraph WHERE arc_id::text = v_header_arc LIMIT 1;


			v_acc_value = v_acc_value + v_current_value;

			IF v_header_arc IS NOT NULL THEN

				EXECUTE 'INSERT INTO temp_anl_node (fid, nodecat_id, node_id, the_geom, descript) 
				SELECT DISTINCT ON (node_id) '||v_fid||', nodecat_id, '||v_end_node::text||', the_geom, 
				concat (''{"value":"'','||v_acc_value||',''", "header":"'||v_feature.node_1||'"}'')
				FROM ve_node WHERE node_id= '''||v_end_node||''';';

				EXECUTE 'UPDATE temp_anlgraph n SET water= 1, flag=n.flag+1, checkf=1, value = '||v_acc_value||'
				FROM v_anl_graph a WHERE n.node_1::integer = a.node_1::integer AND n.arc_id = a.arc_id and a.arc_id='''||v_header_arc::text||''';';

			ELSE
				EXIT;
			END IF;

			EXECUTE 'SELECT count(arc_id) FROM temp_anlgraph WHERE node_1::text = '''||v_end_node||''' AND arc_id::text NOT IN ('||v_queryarc||') 
			and flag=0;'
			INTO v_count_feature;

			IF v_count_feature >1 THEN
				--raise notice 'v_bifurcation,%',v_bifurcation;
				--case when bifurcation node is also the beginning of new branch, and arcs depend to 2 different branches
				IF v_end_node = ANY(v_node_list) THEN
					v_bifurcation = 0;

					EXECUTE 'SELECT arc_id::text FROM temp_anlgraph WHERE checkf= 0 AND node_1::text = '||v_end_node||'::text 
					AND arc_id::text !='||v_header_arc||'::text and arc_id::TEXT not in ('||v_queryarc||') limit 1'
					INTO v_header_arc;

					v_bif_header_arc = null;
					v_header_node = v_end_node::text;
					v_bif_header_node = null;
					INSERT INTO audit_check_data (fid, error_message)
					VALUES (v_fid, concat('INFO: Bifurcation on node',v_end_node,'. Arcs belong to different branches.'));
				ELSE
				--case when bifurcation node and arcs belong to the same branch
					v_bifurcation = 1;
					v_header_arc = (SELECT arc_id::text FROM temp_anlgraph WHERE checkf= 0 AND node_1::text = v_end_node AND arc_id::text !=v_header_arc limit 1);
					v_bif_header_arc = (SELECT arc_id::text FROM temp_anlgraph WHERE checkf= 0 AND node_1::text = v_end_node AND arc_id::text !=v_header_arc limit 1);

					v_header_node = v_end_node::text;
					v_bif_header_node = v_end_node::text;
					v_bif_acc_value = v_acc_value;

					INSERT INTO audit_check_data (fid, error_message)
					VALUES (v_fid, concat('INFO: Bifurcation on node',v_end_node,'. One arc is the continuation of a previous branch.'));
				END IF;

			ELSIF v_count_feature = 0 and v_bifurcation= 1 THEN
				--calculation on one branch came to an end, setting back the header node and arc to calculte the second branch
				v_bifurcation = 0;
				v_header_node = v_bif_header_node;
				v_header_arc = v_bif_header_arc;
				v_acc_value = v_bif_acc_value;
			ELSE
				-- setting the header node of the next arc in order of spreading
				v_bifurcation = 0;
				v_header_arc = (SELECT arc_id::text FROM temp_anlgraph WHERE node_1::text = v_end_node AND arc_id::text !=v_header_arc limit 1);

				v_header_node = v_end_node::text;

				--in case of one no bifurcation finish the process if end node is on the ist of header nodes

				EXIT WHEN v_end_node = ANY(v_node_list);
				EXECUTE 'SELECT a.end FROM (SELECT ((json_array_elements_text((value::json->>''headers'')::json))::json->>''node'') as node,
				((json_array_elements_text((value::json->>''headers'')::json))::json->>''end'') as end 
				FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph'' order by 1)a where a.node='''||v_feature.node_1||''';'
				INTO v_end_bifurc;
				--raise notice 'v_end_bifurc,%',v_end_bifurc;

				EXIT WHEN v_end_node = v_end_bifurc;
			END IF;


			GET DIAGNOSTICS v_affectedrows =row_count;
			EXIT WHEN v_header_arc = NULL;
			EXIT WHEN v_affectedrows = 0;

		END LOOP;


	END LOOP;

	--set header nodes value to 0, insert missing headers into anl_node
	EXECUTE 'select string_agg(quote_literal(a.node_id),'','') from(
	SELECT json_array_elements_text((value::json->>''headers'')::json)::json->>''node'' AS node_id 
	FROM config_param_system WHERE parameter=''graphanalytics_lrs_graph'')a'
	into v_node_string;

	--EXECUTE 'DELETE FROM anl_node WHERE fid = '||v_fid||' AND node_id::text IN ('||v_node_string||');';

	EXECUTE 'INSERT INTO temp_anl_node (fid, nodecat_id, node_id, the_geom, descript) 
	SELECT DISTINCT ON (node_id) '||v_fid||', nodecat_id,node_id, the_geom, 
	concat (''{"value":"0", "header":"'',node_id,''"}'')
	FROM ve_node WHERE ve_node.node_id::text IN ('||v_node_string||') AND node_id NOT IN (select node_id FROM temp_anl_node WHERE fid = '||v_fid||');';

	-- update fields for node layers (value and header)
	FOR rec IN execute 'SELECT * FROM cat_feature JOIN sys_addfields on cat_feature_id=cat_feature.id 
 	WHERE param_name ='''|| v_valuefield||''''
	LOOP
		v_querytext =  'UPDATE '||rec.child_layer||' SET '||v_valuefield||' = a.descript::json->>''value'', '||v_headerfield||
		' = a.descript::json->>''header'' FROM temp_anl_node a WHERE fid='||v_fid||' AND a.node_id='||rec.child_layer||'.node_id AND cur_user=current_user';
		EXECUTE v_querytext;

		EXECUTE 'UPDATE temp_anl_node SET result_id = '||v_fid||' WHERE fid='||v_fid||' 
		AND node_id IN (SELECT node_id::text FROM '||rec.child_layer||')';

	END LOOP;

	INSERT INTO audit_check_data (fid, error_message)
	VALUES (v_fid, concat('WARNING-376: LRS attributes on node features have been updated'));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by id) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


   	--points
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
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript::json, fid, ST_Transform(the_geom, 4326) as the_geom
  	FROM  temp_anl_node WHERE cur_user="current_user"() AND fid=116 and result_id = '116') row) features;

   	v_result_point := COALESCE(v_result, '{}');

--      Control NULL's
	v_version:=COALESCE(v_version,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');
	v_result_point:=COALESCE(v_result_point,'{}');
	v_result_line:=COALESCE(v_result_line,'{}');
	v_result_polygon:=COALESCE(v_result_polygon,'{}');
	v_result_fields:=COALESCE(v_result_fields,'{}');

	DROP VIEW IF EXISTS v_anl_graph;

	--return definition for v_audit_check_result
	RETURN  gw_fct_json_create_return(('{"status":"Accepted", "message":{"priority":1, "text":"LRS process done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json, 2826, null, null, null);

END;
$BODY$;
