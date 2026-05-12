/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3160;

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_graphanalytics_hydrant(p_data json)
RETURNS json AS

$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_graphanalytics_hydrant($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},
"form":{}, "feature":{"tableName":"ve_node_hydrant", "featureType":"NODE", "id":["1054"]},
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection","parameters":{"distance":"50"}}}$$);

-- fid: 463, 464

*/

DECLARE

v_result_json json;
v_result json;
v_result_info text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_error_context text;
v_version text;
v_status text;
v_level integer;
v_message text;
v_audit_result text;

v_fid integer=463;
v_fid_result integer=464;
v_fid_proposal integer=468;

v_closest_street text;
v_street_geom  public.geometry;
v_intersect_loc  numeric;
v_line1  public.geometry;
v_line2  public.geometry;
rec_point  record;
v_node_duplicated  text;
v_node_json json;
v_node_array integer[];
v_proposal_array integer[];
v_tablename text;
rec_hydrant text;
v_dist_street numeric;
v_mode integer;
v_distance numeric;
v_use_propsal boolean;
v_use_psector boolean;
v_query text;
v_hidrant_array text;
v_max_hydr_id integer;
v_max_prop_hydr_id integer;
v_expl_array text;
v_count integer;
BEGIN

-- Search path
SET search_path = "SCHEMA_NAME", public;

	v_tablename := (p_data ->> 'feature')::json->> 'tableName'::text;
	v_node_json = ((p_data ->>'feature')::json->>'id'::text);
	v_mode=json_extract_path_text(p_data, 'data','parameters','mode')::integer;
	v_use_propsal=json_extract_path_text(p_data, 'data','parameters','useProposal')::boolean;
	v_use_psector=json_extract_path_text(p_data, 'data','parameters','usePsector')::boolean;
	/*mode: 0 -influence area, 1:hydrant proposal*/

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	--create temp tables
	CREATE TEMP TABLE IF NOT EXISTS temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_t_table (LIKE SCHEMA_NAME.temp_table INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_t_arc (LIKE SCHEMA_NAME.temp_arc INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_t_node (LIKE SCHEMA_NAME.temp_node INCLUDING ALL);
	CREATE TEMP TABLE IF NOT EXISTS temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3160", "fid":"'||v_fid||'", "criticity":"4", "tempTable":"temp_", "is_process":true, "is_header":"true"}}$$)';

	--store psector selector values
	IF v_use_psector IS NOT TRUE THEN
			-- save psector selector
			DELETE FROM temp_t_table WHERE fid=288 AND cur_user=current_user;
			INSERT INTO temp_t_table (fid, text_column)
			SELECT 288, (array_agg(psector_id)) FROM selector_psector WHERE cur_user=current_user;

			-- set psector selector
			DELETE FROM selector_psector WHERE cur_user=current_user;
	END IF;

	--CREATE ARRAY OF HYDRANTS
	select array_agg(a) into v_node_array from json_array_elements_text(v_node_json) a WHERE a::integer IN (SELECT node_id FROM man_hydrant);
	select string_agg(a,', ') into v_hidrant_array from json_array_elements_text(v_node_json) a WHERE a::integer IN (SELECT node_id FROM man_hydrant);

	IF v_node_array is null THEN
		EXECUTE 'SELECT array_agg(a.node_id) from (SELECT node_id FROM '||v_tablename||' join man_hydrant using (node_id))a'
		into v_node_array;
		EXECUTE 'SELECT string_agg(a.node_id::text,'', '') from (SELECT n.node_id FROM '||v_tablename||' n join man_hydrant using (node_id))a'
		into v_hidrant_array;
	END IF;


	EXECUTE 'SELECT DISTINCT string_agg(expl_id::text,'', '') FROM node WHERE node_id::integer IN ('||v_hidrant_array||')'
	INTO v_expl_array;
	EXECUTE 'SELECT count(*) FROM om_streetaxis WHERE expl_id IN ('||v_expl_array||')' INTO v_count;

	IF v_count = 0 THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3248", "function":"3160","parameters":null, "is_process":true}}$$);' INTO v_audit_result;
	END IF;

	IF v_node_array IS NOT NULL THEN

			FOREACH rec_hydrant IN ARRAY(v_node_array) LOOP
				--locate hydrant on the closest street
				EXECUTE 'SELECT closest_street.id, dist
				FROM '||v_tablename||' a
				CROSS JOIN LATERAL
				(SELECT id, a.the_geom<-> b.the_geom as dist
				FROM om_streetaxis b
				WHERE a.expl_id = b.expl_id 
				ORDER BY a.the_geom <-> b.the_geom
				LIMIT 1) AS closest_street  WHERE a.node_id='||quote_literal(rec_hydrant)||''
				INTO v_closest_street, v_dist_street;

				IF v_dist_street < 50 THEN

					SELECT (ST_Dump(the_geom)).geom INTO v_street_geom FROM om_streetaxis WHERE id=v_closest_street;

					--insert point located on the closest street to the temporal table
					EXECUTE 'INSERT INTO temp_t_node(result_id, node_id, the_geom)
					SELECT '||v_fid||', '||rec_hydrant||', ST_ClosestPoint(s.the_geom, n.the_geom)
					FROM '||v_tablename||' n, om_streetaxis s WHERE n.node_id='||quote_literal(rec_hydrant)||' AND s.id='||quote_literal(v_closest_street)||';';

					--divide street on which hydrant is located and insert on temp table
					EXECUTE 'SELECT ST_LineLocatePoint('||quote_literal(v_street_geom::text)||', temp_t_node.the_geom) FROM temp_t_node WHERE node_id='||quote_literal(rec_hydrant)||' and result_id='''||v_fid||''''
					INTO v_intersect_loc;

					v_line1 := ST_LineSubstring(v_street_geom, 0.0, v_intersect_loc);
					v_line2 := ST_LineSubstring(v_street_geom, v_intersect_loc, 1.0);

					IF ST_GeometryType(v_line1) = 'ST_Point' THEN
						v_line1=NULL;
					END IF;
					IF ST_GeometryType(v_line2) = 'ST_Point' THEN
						v_line2=NULL;
					END IF;

					INSERT INTO temp_t_arc(result_id, arc_id,the_geom, annotation)
					SELECT distinct v_fid,row_number()over() as row_id, the_geom, id FROM
					(SELECT v_line1  as the_geom,v_closest_street as id
					UNION SELECT v_line2  as the_geom,v_closest_street as id)a;
				ELSE
					v_node_array = array_remove(v_node_array::TEXT[],rec_hydrant);
				END IF;
			END LOOP;

			IF v_use_propsal IS TRUE THEN
				EXECUTE 'SELECT array_agg(a.node_id::integer) from (SELECT node_id FROM anl_node where fid='||v_fid_proposal||' AND cur_user=current_user)a'
				into v_proposal_array;

				IF v_proposal_array IS NOT NULL THEN
					FOREACH rec_hydrant IN ARRAY(v_proposal_array) LOOP
						--locate hydrant on the closest street
						EXECUTE 'SELECT closest_street.id, dist
						FROM anl_node a
						CROSS JOIN LATERAL
						(SELECT id, a.the_geom<-> b.the_geom as dist
						FROM om_streetaxis b
						WHERE a.expl_id = b.expl_id 
						ORDER BY a.the_geom <-> b.the_geom
						LIMIT 1) AS closest_street  WHERE a.node_id='||quote_literal(rec_hydrant)||' AND cur_user=current_user AND fid='||v_fid_proposal||''
						INTO v_closest_street, v_dist_street;

						IF v_dist_street < 50 THEN

						SELECT (ST_Dump(the_geom)).geom INTO v_street_geom FROM om_streetaxis WHERE id=v_closest_street;

						--insert point located on the closest street to the temporal table
						EXECUTE 'INSERT INTO temp_t_node(result_id, node_id, the_geom)
						SELECT '||v_fid||', '||rec_hydrant||', ST_ClosestPoint(s.the_geom, n.the_geom)
						FROM anl_node n, om_streetaxis s WHERE n.node_id='||quote_literal(rec_hydrant)||' AND s.id='||quote_literal(v_closest_street)||'
						AND cur_user=current_user AND fid='||v_fid_proposal||';';

						--divide street on which hydrant is located and insert on temp table
						EXECUTE 'SELECT ST_LineLocatePoint('||quote_literal(v_street_geom::text)||', temp_t_node.the_geom) FROM temp_t_node WHERE node_id='||quote_literal(rec_hydrant)||' and result_id='''||v_fid||''''
						INTO v_intersect_loc;

						v_line1 := ST_LineSubstring(v_street_geom, 0.0, v_intersect_loc);
						v_line2 := ST_LineSubstring(v_street_geom, v_intersect_loc, 1.0);

						IF ST_GeometryType(v_line1) = 'ST_Point' THEN
							v_line1=NULL;
						END IF;
						IF ST_GeometryType(v_line2) = 'ST_Point' THEN
							v_line2=NULL;
						END IF;

						INSERT INTO temp_t_arc(result_id, arc_id,the_geom, annotation)
						SELECT distinct v_fid,row_number()over() as row_id, the_geom, id FROM
						(SELECT v_line1  as the_geom,v_closest_street as id
						UNION SELECT v_line2  as the_geom,v_closest_street as id)a;
					ELSE
						v_proposal_array = array_remove(v_proposal_array::TEXT[],rec_hydrant);
					END IF;
				END LOOP;
			END IF;
		END IF;

		--insert final street points on temp_t_node table
		FOR rec_point IN (SELECT v_fid , ST_EndPoint((ST_Dump(s.the_geom)).geom) as the_geom, s.id
		FROM om_streetaxis s WHERE s.the_geom is not null UNION
		SELECT  v_fid , ST_StartPoint((ST_Dump(the_geom)).geom) AS geom, id
		FROM  om_streetaxis s  WHERE the_geom is not null) LOOP

			SELECT id INTO v_node_duplicated FROM temp_t_node WHERE ST_DWithin(rec_point.the_geom, temp_t_node.the_geom, 0.001) AND result_id=v_fid::text;

			IF v_node_duplicated IS NULL THEN
				INSERT INTO temp_t_node(result_id, the_geom, annotation)
				VALUES (v_fid , rec_point.the_geom, rec_point.id);
			END IF;

		END LOOP;

		--insert streets on temp_t_arc table
		INSERT INTO temp_t_arc(result_id, arc_id,the_geom, annotation)
		SELECT distinct v_fid,row_number()over() as row_id, the_geom, id FROM
		(select (ST_Dump(the_geom)).geom as the_geom, id
		FROM  om_streetaxis s where id not in (select annotation from temp_t_arc WHERE result_id= v_fid::text))a;

		--update temp tables with new temporal ids
		SELECT max(x) into v_max_hydr_id FROM unnest(v_node_array)as x;

		IF v_use_propsal IS TRUE THEN
			SELECT max(x) into v_max_prop_hydr_id FROM unnest(v_proposal_array) as x;
			IF v_max_prop_hydr_id is not null and v_max_prop_hydr_id > v_max_hydr_id THEN
				v_max_hydr_id=v_max_prop_hydr_id;
			END IF;
		ELSE
		END IF;

		UPDATE temp_t_node a SET node_id=b.row_id from (select v_max_hydr_id + row_number()over() as row_id, id from temp_t_node)b where a.id=b.id and node_id is null;
		UPDATE temp_t_arc a SET arc_id=b.row_id from (select row_number()over() as row_id, id from temp_t_arc where result_id=v_fid::text)b where a.id=b.id and result_id=v_fid::text;

		--update temp_t_arc with values of node_1, node_2 from temp_t_node
		UPDATE temp_t_arc a SET node_1=node_id FROM temp_t_node n WHERE ST_dwithin(St_startpoint(a.the_geom),n.the_geom,0.01) AND (n.result_id=v_fid::text ) AND node_1 IS NULL;

		UPDATE temp_t_arc a SET node_2=node_id FROM temp_t_node n WHERE ST_dwithin(St_endpoint(a.the_geom),n.the_geom,0.01) AND (n.result_id=v_fid::text) AND node_2 IS NULL;

		--duplicate distance on proposal mode
		IF v_mode=1 THEN
			v_distance=json_extract_path_text(p_data, 'data','parameters','distance')::numeric;
			v_distance=2*v_distance;
			EXECUTE 'SELECT jsonb_set('||quote_literal(p_data)||',''{data,parameters,distance}'',''"'||v_distance||'"'');'
			into p_data;
		END IF;

		IF v_use_propsal is true AND v_proposal_array IS NOT NULL THEN
			v_node_array=array_cat(v_node_array, v_proposal_array);
		END IF;

		--execute function for each hydrant
		FOREACH rec_hydrant IN ARRAY(v_node_array) LOOP

			UPDATE temp_t_arc SET flag=null where result_id=v_fid::text;
			DELETE FROM temp_anl_node WHERE cur_user="current_user"() AND (fid = v_fid OR fid=v_fid_result);
			-- log
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3514", "function":"3160", "parameters":{"rec_hydrant":"'||rec_hydrant||'"}, "fid":"'||v_fid||'", "criticity":"4", "tempTable":"temp_", "is_process":true}}$$)';

			p_data=p_data::jsonb||concat('{"nodeId":"',rec_hydrant,'","hydrantId":"',rec_hydrant,'"}')::jsonb;

			-- Compute the tributary area using recursive function
			EXECUTE 'SELECT gw_fct_graphanalytics_hydrant_recursive($$'||p_data||'$$);'
			INTO v_result_json;
		END LOOP;
	END IF;


	-- get results
	--lines
	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	 	SELECT jsonb_build_object(
	  'type',       'Feature',
	  'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	  'properties', to_jsonb(row) - 'the_geom' - 'srid'
	 	) AS feature
	FROM (SELECT ST_Transform(ST_Union(the_geom), 4326) as the_geom, ST_SRID(ST_Union(the_geom)) as srid, node_1 as hydrant_id
	FROM  temp_anl_arc WHERE cur_user="current_user"() AND (fid=v_fid_result Or fid=v_fid) group by node_1) row) features;

	v_result_line = v_result;

	IF v_use_propsal is true then
		v_query='SELECT DISTINCT ON (node_id)  node_id::text, nodecat_id, expl_id,the_geom
		 	FROM node WHERE node_id::integer =ANY(ARRAY['||v_hidrant_array||'])
		 	UNION SELECT node_id::text, ''HYDRANT PROPOSAL'',expl_id, the_geom FROM temp_anl_node WHERE fid='||v_fid_proposal||' AND cur_user=current_user';
	else
		v_query='SELECT DISTINCT ON (node_id)  node_id::text, nodecat_id, expl_id,the_geom
		 	FROM node WHERE node_id::integer =ANY(ARRAY['||v_hidrant_array||'])';
	end if;
	--points-hydrants
	v_result = null;
	EXECUTE 'SELECT jsonb_build_object(
	        ''type'', ''FeatureCollection'',
	        ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
	    ) 
	FROM (
		SELECT jsonb_build_object(
	  ''type'',       ''Feature'',
	  ''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
	  ''properties'', to_jsonb(row) - ''the_geom'' - ''srid''
	 	) AS feature
	FROM (SELECT *, ST_SRID(the_geom) as srid FROM ('||v_query||') sub)row) features'
	 INTO v_result;

	v_result_point = v_result;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- restore state selector (if it's needed)
	IF v_use_psector IS NOT TRUE THEN
		INSERT INTO selector_psector (psector_id, cur_user)
		select unnest(text_column::integer[]), current_user from temp_t_table where fid=288 and cur_user=current_user
		ON CONFLICT (psector_id, cur_user) DO NOTHING;
	END IF;

	-- Reset values, insert results
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND (fid = v_fid OR fid = v_fid_result);
	DELETE FROM anl_node WHERE cur_user="current_user"() AND (fid = v_fid OR fid = v_fid_result);
	DELETE FROM audit_check_data WHERE (fid = v_fid) and cur_user="current_user"();

	INSERT INTO anl_node SELECT * FROM temp_anl_node;
	INSERT INTO anl_arc SELECT * FROM temp_anl_arc;
	INSERT INTO audit_check_data SELECT * FROM temp_audit_check_data;

	--drop temp tables
	DROP TABLE temp_anl_arc;
	DROP TABLE temp_anl_node;
	DROP TABLE temp_t_table;
	DROP TABLE temp_t_arc;
	DROP TABLE temp_t_node;
	DROP TABLE temp_audit_check_data;

	IF (v_result_json->>'status')::TEXT = 'Accepted' THEN

		IF v_audit_result is null THEN
			v_status = 'Accepted';
			v_level = 3;
			--v_message = 'Process done successfully';
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3430", "function":"3160", "is_process":true}}$$)::JSON->>''text''' INTO v_message;


		ELSE

			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status;
			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

		END IF;

		v_result_info := COALESCE(v_result, '{}');
		v_result_info = concat ('{"values":',v_result_info, '}');
		v_result_polygon = '{}';

		--return '{"status":"done"}';
		--  Return
		RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
						   ',"body":{"form":{}'||
						   ',"data":{ "info":'||v_result_info||','||
							  '"point":'||v_result_point||','||
							  '"line":'||v_result_line||','||
							  '"polygon":'||v_result_polygon||'}'||
							 '}'
					  '}')::json, 3160, null, null, null);
	ELSE
		RETURN v_result_json;
	END IF;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;