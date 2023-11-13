/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2218

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_flow_trace(character varying);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_flow_trace(json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_graphanalytics_upstream(p_data json)  
RETURNS json AS 

$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_graphanalytics_upstream($${
"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
"feature":{"id":["20607"]},
"data":{}}$$);

SELECT SCHEMA_NAME.gw_fct_graphanalytics_upstream($${
"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"postgres"},
"feature":{},
"data":{"coordinates":{"xcoord":419278.0533606678,"ycoord":4576625.482073168,"zoomRatio":437.2725774103561}}}$$)

--fid: 220;

*/
DECLARE

v_affectrow numeric;

v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer;
v_version text;

v_debug boolean;
v_error_context text;
v_audit_result text;

v_level integer;
v_status text;
v_message text;

v_project_type text;
v_node integer;
v_point public.geometry;
v_sensibility_f float;
v_sensibility float;
v_zoomratio float;
v_fid integer=220;
v_cur_user text;
v_device integer;
v_xcoord float;
v_ycoord float;
v_epsg integer;
v_client_epsg integer;
v_prev_cur_user text;

v_count_connec integer;
v_count_gully integer;
v_count_node integer;
v_length_arc numeric;

BEGIN 
	
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';
	v_node = json_array_elements_text(json_extract_path_text(p_data,'feature','id')::json)::integer;

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;
	
	v_prev_cur_user = current_user;
	IF v_cur_user IS NOT NULL THEN
		EXECUTE 'SET ROLE "'||v_cur_user||'"';
	END IF;
	
	-- select config values
	SELECT giswater, upper(project_type) INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	CREATE TEMP TABLE temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);

	CREATE OR REPLACE TEMP VIEW v_temp_graphanalytics_upstream AS
	 SELECT temp_t_anlgraph.arc_id,
	    temp_t_anlgraph.node_1,
	    temp_t_anlgraph.node_2,
	    temp_t_anlgraph.flag,
	    a2.flag AS flagi,
	    a2.value,
	    a2.trace,
	    v.cat_geom1
	   FROM temp_t_anlgraph
	     JOIN ( SELECT temp_t_anlgraph_1.arc_id,
	            temp_t_anlgraph_1.node_1,
	            temp_t_anlgraph_1.node_2,
	            temp_t_anlgraph_1.water,
	            temp_t_anlgraph_1.flag,
	            temp_t_anlgraph_1.checkf,
	            temp_t_anlgraph_1.value,
	            temp_t_anlgraph_1.trace
	           FROM temp_t_anlgraph temp_t_anlgraph_1
	          WHERE temp_t_anlgraph_1.water = 1) a2 ON temp_t_anlgraph.node_2::text = a2.node_1::text
	     JOIN v_edit_arc v ON temp_t_anlgraph.arc_id::text = v.arc_id::text
	  WHERE temp_t_anlgraph.flag < 2 AND temp_t_anlgraph.water = 0 AND a2.flag = 0;


	--Look for closest node using coordinates
	IF v_node IS NULL THEN 
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;
		SELECT node_id INTO v_node FROM v_edit_node WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
		IF v_node IS NULL THEN
			SELECT node_2 INTO v_node FROM v_edit_arc WHERE ST_DWithin(the_geom, v_point,100)  order by st_distance (the_geom, v_point) LIMIT 1;
		END IF;
	END IF;

	-- fill the graph table
	INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf)
	SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND value_state_type.is_operative=TRUE AND v_edit_arc.state > 0;
		
	-- Close mapzone headers
	EXECUTE 'UPDATE temp_t_anlgraph SET flag=0, water=1, trace = 1::integer  WHERE node_2::integer IN ('||v_node||')';

	-- inundation process
		LOOP						
			v_count = v_count+1;
			UPDATE temp_t_anlgraph n SET water=1, trace = a.trace FROM v_temp_graphanalytics_upstream a where n.node_1::integer = a.node_1::integer AND n.arc_id = a.arc_id;	
			GET DIAGNOSTICS v_affectrow = row_count;
			raise notice 'v_count --> %' , v_count;
			EXIT WHEN v_affectrow = 0;
			EXIT WHEN v_count = 5000;
		END LOOP;

		RAISE NOTICE 'Finish engine....';


	-- info
	--affected network
		SELECT count(*) INTO v_count_connec FROM v_anl_flow_connec;
		SELECT count(*) INTO v_count_gully FROM v_anl_flow_gully;
		SELECT count(*) INTO v_count_node FROM v_anl_flow_node JOIN cat_feature_node cn ON cn.id=node_type WHERE isprofilesurface IS TRUE;
		SELECT round(sum(st_length(the_geom))::numeric,2) INTO v_length_arc FROM v_anl_flow_arc;

		select json_build_object(
		'affectedNetwork',json_build_object('length',v_length_arc,
		'nodesIsprofileTrue',v_count_node, 'numConnecs', v_count_connec, 'numGully', v_count_gully) )
		INTO v_result;

		v_result := COALESCE(v_result, '{}');  
		v_result_info := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

        -- Reset values
        DELETE FROM anl_arc WHERE cur_user="current_user"() AND (fid = 220 or fid=221);
        DELETE FROM anl_node WHERE cur_user="current_user"() AND (fid = 220 or fid=221);

        INSERT INTO anl_arc (arc_id, fid, arccat_id, expl_id, the_geom)
        SELECT arc_id, v_fid, arc_type, expl_id, the_geom	FROM temp_t_anlgraph
        join arc using(arc_id) where water=1;

        INSERT INTO anl_node (node_id, nodecat_id,state, expl_id, fid, the_geom)
        SELECT node_id, node_type, state, expl_id, v_fid, the_geom
        FROM v_edit_node WHERE node_id IN (SELECT  node_1 from temp_t_anlgraph where water=1 union SELECT  node_2 from temp_t_anlgraph where water=1);

        DROP VIEW v_temp_graphanalytics_upstream;
        DROP TABLE temp_t_anlgraph;

		IF v_device = 5 THEN
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
		  	SELECT jsonb_build_object(
		     'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom',
		    'crs',concat('EPSG:',ST_SRID(the_geom))
		  	) AS feature
		  	FROM (SELECT arc_id, arc_type, context, expl_id, st_length(the_geom) as length, the_geom
		  	FROM  v_anl_flow_arc) row) features;

				v_result := COALESCE(v_result, '{}'); 
				v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}'); 	
				
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
		  	SELECT jsonb_build_object(
				'type',       'Feature',
				'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
				'properties', to_jsonb(row) - 'the_geom',
				'crs',concat('EPSG:',ST_SRID(the_geom))
		  	) AS feature
		  	FROM (SELECT node_id as feature_id, node_type as feature_type, context, expl_id, the_geom
		  	FROM  v_anl_flow_node
		  	UNION 
		  	SELECT connec_id,'CONNEC', context, expl_id, the_geom
		 	FROM  v_anl_flow_connec
		 	UNION 
		 	SELECT gully_id,'GULLY', context, expl_id, the_geom
			FROM  v_anl_flow_gully) row) features;

			v_result := COALESCE(v_result, '{}'); 
			v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 

			v_result_polygon = '{"geometryType":"", "features":[]}';

		ELSE
			v_result_polygon = '{"geometryType":"", "features":[]}';
			v_result_line = '{"geometryType":"", "features":[]}';
			v_result_point = '{"geometryType":"", "features":[]}';

		END IF;
		
	EXECUTE 'SET ROLE "'||v_prev_cur_user||'"';
		
	v_status = 'Accepted';
	v_level = 3;
	v_message = 'Flow  analysis done succesfully';

	--  Return

	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
				   ',"body":{"form":{}'||
				   ',"data":{ "info":'||v_result_info||','||
				      '"initPoint":'||v_node||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||','||
					  '"polygon":'||v_result_polygon||'}'||
					 '}'
		'}')::json, 2218, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

