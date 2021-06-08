	/*
	This file is part of Giswater 3
	The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	This version of Giswater is provided by Giswater Association
	*/

	--FUNCTION CODE: 3036

	CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_duplicated(p_data json) RETURNS json AS 
	$BODY$
	/*EXAMPLE
	SELECT SCHEMA_NAME.gw_fct_anl_arc_duplicated($${"client":{"device":4, "infoType":1, "lang":"ES"},
	"form":{},"feature":{"tableName":"v_edit_node", "featureType":"NODE", "id":[]}, 
	"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
	"parameters":{"checkType":"finalNodes"}}}$$)::JSON
	-- fid: 381

	*/

	DECLARE
	    
	v_id json;
	v_selectionmode text;
	v_worklayer text;
	v_result json;
	v_result_info json;
	v_result_point json;
	v_array text;
	v_version text;
	v_error_context text;
	v_count integer;
	v_checktype text;
	BEGIN

		-- Search path
		SET search_path = "SCHEMA_NAME", public;

		-- select version
		SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;
		
		-- getting input data 	
		v_id :=  ((p_data ->>'feature')::json->>'id')::json;
		v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
		v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
		v_checktype := ((p_data ->>'data')::json->>'parameters')::json->>'checkType';

		select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

		-- Reset values
		DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=381;
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=381;	
		
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (381, null, 4, concat('ARC DUPLICATED ANALYSIS'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (381, null, 4, '-------------------------------------------------------------');

		IF v_checktype='geometry' THEN
			-- Computing process
			IF v_selectionmode = 'previousSelection' THEN
				EXECUTE 'INSERT INTO anl_arc (arc_id, arccat_id, state, arc_id_aux, node_1, node_2, expl_id, fid, the_geom)
						SELECT arc_id, arccat_id, state1, arc_id_aux, node_1, node_2, expl_id, fid, the_geom FROM (
						SELECT DISTINCT t1.arc_id, t1.arccat_id, t1.state as state1, t2.arc_id as arc_id_aux, 
						t2.state as state2, t1.node_1, t1.node_2, t1.expl_id, 381 as fid, t1.the_geom
						FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 USING (the_geom)
						WHERE t1.arc_id != t2.arc_id AND t1.arc_id IN ('||v_array||') ORDER BY t1.arc_id ) a where a.state1 > 0 AND a.state2 > 0';
			ELSE
				EXECUTE 'INSERT INTO anl_arc (arc_id, arccat_id, state, arc_id_aux, node_1, node_2, expl_id, fid, the_geom)
						SELECT arc_id, arccat_id, state1, arc_id_aux, node_1, node_2, expl_id, fid, the_geom FROM (
						SELECT DISTINCT t1.arc_id, t1.arccat_id, t1.state as state1, t2.arc_id as arc_id_aux, 
						t2.state as state2, t1.node_1, t1.node_2, t1.expl_id, 381 as fid, t1.the_geom
						FROM '||v_worklayer||' AS t1 JOIN '||v_worklayer||' AS t2 USING(the_geom)
						WHERE t1.arc_id != t2.arc_id ORDER BY t1.arc_id ) a where a.state1 > 0 AND a.state2 > 0';
			END IF;
		ELSIF v_checktype='finalNodes' THEN
			-- Computing process
			IF v_selectionmode = 'previousSelection' THEN

				EXECUTE 'INSERT INTO anl_arc (arc_id, arccat_id, state,  node_1, node_2, expl_id, fid, the_geom)
				SELECT * FROM (SELECT DISTINCT ON (node_1, node_2) arc_id, arccat_id, state, node_1, node_2,expl_id, 381,the_geom 
				FROM  '||v_worklayer||'  WHERE  arc_id IN IN ('||v_array||') AND  CONCAT(node_1,'':'',node_2) IN
				(SELECT CONCAT(node_1,'':'',node_2) FROM '||v_worklayer||' WHERE arc_id IN IN ('||v_array||') GROUP BY node_1, node_2  HAVING count(*) >1))a';

				EXECUTE 'UPDATE anl_arc aa SET arc_id_aux=va.arc_id FROM '||v_worklayer||' va
				WHERE aa.node_1 = va.node_1 and aa.node_2=va.node_2 AND  aa.arc_id!=va.arc_id AND va.arc_id IN IN ('||v_array||') ;';

			ELSE
				EXECUTE 'INSERT INTO anl_arc (arc_id, arccat_id, state,  node_1, node_2, expl_id, fid, the_geom)
				SELECT * FROM (SELECT DISTINCT ON (node_1, node_2) arc_id, arccat_id, state, node_1, node_2,expl_id, 381,the_geom 
				FROM  '||v_worklayer||'  WHERE CONCAT(node_1,'':'',node_2) IN
				(SELECT CONCAT(node_1,'':'',node_2) FROM '||v_worklayer||' GROUP BY node_1, node_2  HAVING count(*) >1))a';

				EXECUTE 'UPDATE anl_arc aa SET arc_id_aux=va.arc_id FROM '||v_worklayer||' va
				WHERE aa.node_1 = va.node_1 and aa.node_2=va.node_2 AND  aa.arc_id!=va.arc_id;';
			END IF;
		END IF;

		-- set selector
		DELETE FROM selector_audit WHERE fid=381 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (381, current_user);

		-- get results
		--points
		v_result = null;
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, arc_id, arccat_id, state,  node_1, node_2, expl_id, fid, the_geom
	  	FROM  anl_arc WHERE cur_user="current_user"() AND fid=381) row) features;

		v_result := COALESCE(v_result, '{}'); 
		v_result_point = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 
	
		IF v_checktype='finalNodes' THEN
			SELECT count(*) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=381;
		ELSE
			SELECT count(*)/2 INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=381;
		END IF;
		

		IF v_count = 0 THEN
			INSERT INTO audit_check_data(fid,  error_message, fcount)
			VALUES (381,  'There are no duplicated arcs.', v_count);
		ELSE
			INSERT INTO audit_check_data(fid,  error_message, fcount)
			VALUES (381,  concat ('There are ',v_count,' duplicated arcs.'), v_count);

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 381,  concat ('Arc_id: ',string_agg(arc_id, ', '), '.' ), v_count 
			FROM anl_arc WHERE cur_user="current_user"() AND fid=381;

		END IF;
		
		-- info
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=381 order by  id asc) row;
		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		
		--    Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		v_result_point := COALESCE(v_result_point, '{}'); 

		--  Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"line":'||v_result_point||
				'}}'||
		    '}')::json, 3036, null, null, null);

		EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
		RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

	END;
	$BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;