	/*
	This file is part of Giswater
	The program is free software: you can redistribute it and/or modify it under the terms of the GNU
	General Public License as published by the Free Software Foundation, either version 3 of the License,
	or (at your option) any later version.
	*/

	--FUNCTION CODE: 3066

	CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_arc_elev(p_data json) RETURNS json AS
	$BODY$
	/*EXAMPLE
	SELECT gw_fct_anl_arc_elev($${"client":{"device":4, "infoType":1, "lang":"ES"},
	"form":{},"feature":{"tableName":"ve_arc", "featureType":"ARC", "id":[]},
	"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
	"parameters":{}}}$$)::text

	-- fid: 390

	*/

	DECLARE

	v_id json;
	v_selectionmode text;
	v_worklayer text;
	v_result json;
	v_result_info json;
	v_result_line json;
	v_array text;
	v_version text;
	v_error_context text;
	v_count integer;

	BEGIN

		-- Search path
		SET search_path = "SCHEMA_NAME", public;

		-- select version
		SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

		-- getting input data
		v_id :=  ((p_data ->>'feature')::json->>'id')::json;
		v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
		v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

		select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

		-- Reset values
		DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=390;
		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=390;

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3066", "fid":"390", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';


		-- Computing process - check y1*elev1
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, y1, elev1, ''Values on y1 and elev1''  
		 			FROM '||v_worklayer||' WHERE y1*elev1 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, y1, elev1, ''Values on y1 and elev1'' 
		 			FROM '||v_worklayer||' WHERE y1*elev1 IS NOT NULL';
		END IF;

		-- Computing process - check y2*elev2
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y2,elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, y2, elev2, ''Values on y2 and elev2''  
		 			FROM '||v_worklayer||' WHERE y2*elev2 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state,y2, elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, y2, elev2, ''Values on y2 and elev2'' 
		 			FROM '||v_worklayer||' WHERE y2*elev2 IS NOT NULL';
		END IF;

	-- Computing process - check custom_y1*custom_elev1
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y1, custom_elev1, ''Values on custom_y1 and custom_elev1''  
		 			FROM '||v_worklayer||' WHERE custom_y1*custom_elev1 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y1, custom_elev1, ''Values on custom_y1 and custom_elev1''  
		 			FROM '||v_worklayer||' WHERE custom_y1*custom_elev1 IS NOT NULL';
		END IF;

		-- Computing process - check custom_y2*custom_elev2
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y2,elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y2, custom_elev2, ''Values on custom_y2 and custom_elev2''  
		 			FROM '||v_worklayer||' WHERE custom_y2*custom_elev2 IS NOT NULL  AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state,y2, elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y2, custom_elev2, ''Values on custom_y2 and custom_elev2''  
		 			FROM '||v_worklayer||' WHERE custom_y2*custom_elev2 IS NOT NULL';
		END IF;

	-- Computing process - check custom_y1*elev1
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y1, elev1, ''Values on custom_y1 and elev1''  
		 			FROM '||v_worklayer||' WHERE custom_y1*elev1 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y1, elev1, ''Values on custom_y1 and elev1''  
		 			FROM '||v_worklayer||' WHERE custom_y1*elev1 IS NOT NULL';
		END IF;

		-- Computing process - check custom_y2*elev2
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y2,elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y2, elev2, ''Values on custom_y2 and elev2'' 
		 			FROM '||v_worklayer||' WHERE custom_y2*elev2 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state,y2, elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y2, elev2, ''Values on custom_y2 and elev2''  
		 			FROM '||v_worklayer||' WHERE custom_y2*elev2 IS NOT NULL';
		END IF;

	-- Computing process - check y1*custom_elev1
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y1, custom_elev1, ''Values on y1 and custom_elev1''  
		 			FROM '||v_worklayer||' WHERE y1*custom_elev1 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y1,elev1, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y1, custom_elev1, ''Values on y1 and custom_elev1''  
		 			FROM '||v_worklayer||' WHERE y1*custom_elev1 IS NOT NULL';
		END IF;

		-- Computing process - check y2*custom_elev2
		IF v_selectionmode = 'previousSelection' THEN
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state, y2,elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y2, custom_elev2, ''Values on y2 and custom_elev2''  
		 			FROM '||v_worklayer||' WHERE y2*custom_elev2 IS NOT NULL AND arc_id IN ('||v_array||');';
		ELSE
			EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, the_geom, arccat_id, state,y2, elev2, descript)
		 			SELECT arc_id, expl_id, 390, the_geom, arccat_id, state, custom_y2, custom_elev2, ''Values on y2 and custom_elev2''  
		 			FROM '||v_worklayer||' WHERE y2*custom_elev2 IS NOT NULL';
		END IF;

		-- set selector
		DELETE FROM selector_audit WHERE fid=390 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (390, current_user);

	-- get results
	--line
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
  	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, ST_Transform(the_geom, 4326) as the_geom, fid
  	FROM  anl_arc WHERE cur_user="current_user"() AND fid=390) row) features;

	v_result_line := COALESCE(v_result, '{}');

		-- set selector
		DELETE FROM selector_audit WHERE fid=390 AND cur_user=current_user;
		INSERT INTO selector_audit (fid,cur_user) VALUES (390, current_user);

		SELECT count(DISTINCT arc_id) INTO v_count FROM anl_arc WHERE cur_user="current_user"() AND fid=390;

		IF v_count = 0 THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3960", "function":"3066", "fid":"390", "fcount":"'||v_count||'", "is_process":true}}$$)';
		ELSE
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3962", "function":"3066", "parameters":{"v_count":"'||v_count||'"}, "fid":"390", "fcount":"'||v_count||'", "is_process":true}}$$)';

			INSERT INTO audit_check_data(fid,  error_message, fcount)
			SELECT 390,  concat ('Arc_id: ',string_agg(distinct arc_id, ', '), '.' ), v_count
			FROM anl_arc WHERE cur_user="current_user"() AND fid=390;

		END IF;

		-- info
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=390 order by  id asc) row;
		v_result := COALESCE(v_result, '{}');
		v_result_info = concat ('{"values":',v_result, '}');

		--    Control nulls
		v_result_info := COALESCE(v_result_info, '{}');
		v_result_line := COALESCE(v_result_line, '{}');
		--  Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"line":'||v_result_line||
				'}}'||
		    '}')::json, 3066, null, null, null);

	END;
	$BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;
