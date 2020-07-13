/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2786
--SELECT SCHEMA_NAME.gw_fct_check_importdxf();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_importdxf()
RETURNS json AS
$BODY$

-- fid: 206

DECLARE 

v_incorrect_arc text[];
v_count integer;
v_errortext text;
v_start_point public.geometry(Point,SRID_VALUE);
v_end_point public.geometry(Point,SRID_VALUE);
v_query text;
rec record;
v_result json;
v_result_info json;
v_result_point json;
v_project_type text;
v_version text;
v_result_polygon json;
v_result_line json;
v_missing_cat_node text;
v_missing_cat_arc text;
v_incorrect_start text[];
v_incorrect_end text[];
v_error_context text;
 
BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fid = 206 AND cur_user=current_user;
	DELETE FROM anl_node WHERE fid = 206 AND cur_user=current_user;
	
	-- Starting process
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 4, concat('CHECK IMPORT DXF'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 4, '-------------------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 3, 'CRITICAL ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 3, '----------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 1, '-------');

	
	IF 'DXF_JUN' NOT IN (SELECT id FROM cat_feature) OR 'DXF_JUN_CAT' NOT IN (SELECT id FROM cat_node) THEN
		INSERT INTO cat_feature(id, system_id, feature_type, parent_layer, active)
		VALUES ('DXF_JUN', 'JUNCTION', 'NODE','v_edit_node', TRUE) ON CONFLICT DO NOTHING;
		--create child view
		PERFORM gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
		"feature":{"catFeature":"DXF_JUN"}, "data":{"filterFields":{}, "pageInfo":{}, "multi_create":"False" }}$$);

		IF v_project_type = 'WS' THEN
			INSERT INTO cat_feature_node(id, type, epa_default, man_table, epa_table, choose_hemisphere,
		            isarcdivide, graf_delimiter)
			VALUES ('DXF_JUN', 'JUNCTION','JUNCTION','man_junction', 'inp_junction',  false, true ,'NONE') 
			ON CONFLICT DO NOTHING;

			INSERT INTO cat_node(id, nodetype_id, active)
			VALUES ('DXF_JUN_CAT', 'DXF_JUN', true) ON CONFLICT DO NOTHING;
		ELSIF v_project_type = 'UD' THEN
			INSERT INTO cat_feature_node(id, type, epa_default, man_table, epa_table, isarcdivide, choose_hemisphere)
			VALUES ('DXF_JUN', 'JUNCTION','JUNCTION','man_junction', 'inp_junction', true, false) 
			ON CONFLICT DO NOTHING;

			INSERT INTO cat_node(id, active)
			VALUES ('DXF_JUN_CAT', true) ON CONFLICT DO NOTHING;
		END IF;

		v_errortext=concat('INFO: Insert DXF_JUN into cat_feature, cat_feature_node and DXF_JUN_CAT into cat_node.');
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, v_errortext);

		v_errortext=concat('INFO: Create view for cat_feature DXF_JUN.');
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 1, v_errortext);
	END IF;

	--check if there are nodes coming from dxf that overlap nodes existing in the network
	v_count=0;
	FOR rec IN SELECT * FROM temp_table WHERE temp_table.geom_point IS NOT NULL AND fid = 206 LOOP
		IF (SELECT node_id FROM node WHERE ST_DWithin(rec.geom_point,node.the_geom,0.01)) IS NOT NULL THEN
			v_count=+1;
			
			INSERT INTO anl_node(nodecat_id, fid, the_geom, descript)
			VALUES ('DXF_JUN_CAT'::text, 206,rec.geom_point,'DUPLICATED');
		END IF;
	END LOOP;

	IF v_count > 0 THEN

		v_errortext=concat('WARNING: There are ', v_count, ' nodes from dxf that overlap nodes existing in the network.');

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 2, v_errortext);
	END IF;

	--check if arcs have final nodes
	select distinct array_agg(id) INTO v_incorrect_start from temp_table 
	WHERE temp_table.geom_line is not null and fid = 206 AND id not IN
	(SELECT a.id FROM temp_table a,temp_table b WHERE ST_DWithin(ST_startpoint(a.geom_line), b.geom_point, 0.01)
	AND a.fid = 206 and b.fid = 206);

	select distinct array_agg(id) INTO v_incorrect_end from temp_table 
	WHERE temp_table.geom_line is not null and fid = 206 AND id not IN
	(SELECT a.id FROM temp_table a,temp_table b WHERE ST_DWithin(ST_endpoint(a.geom_line), b.geom_point, 0.01)
	AND a.fid = 206 and b.fid = 206);

	v_incorrect_arc=ARRAY(SELECT DISTINCT UNNEST(array_cat(v_incorrect_start,v_incorrect_end)));

	--v_count = array_length(v_incorrect_start,1) + array_length(v_incorrect_end,1);

	v_count = array_length(v_incorrect_arc,1);
	
	IF v_count > 0 THEN

		v_errortext=concat('WARNING: There are ', v_count, ' arcs without final nodes in dxf.');

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 2, v_errortext);
	END IF;

	--check if there is a node located in the close distance from the missing end 
	--insert final node into anl_node if there is none found
	FOR rec IN SELECT * FROM temp_table WHERE temp_table.geom_line IS NOT NULL AND (id::text = ANY(v_incorrect_start) OR id::text = ANY(v_incorrect_end)) LOOP

		SELECT ST_Endpoint(geom_line) into v_start_point FROM temp_table WHERE temp_table.geom_line IS NOT NULL AND id=rec.id;
		SELECT ST_startpoint(geom_line) into v_end_point FROM temp_table WHERE temp_table.geom_line IS NOT NULL AND id=rec.id;

		IF (SELECT node_id FROM node WHERE ST_DWithin(the_geom,v_start_point,0.1) LIMIT 1) IS NULL THEN
			IF NOT EXISTS (SELECT * FROM temp_table WHERE fid = 206 AND geom_point=v_start_point) THEN
				IF NOT EXISTS (SELECT * FROM anl_node WHERE fid = 206 AND the_geom=v_start_point) THEN
							
					INSERT INTO anl_node(nodecat_id, fid, the_geom, descript)
					VALUES ('DXF_JUN_CAT'::text, 206,v_start_point,'NEW');
				END IF;
			END IF;
		ELSE
			INSERT INTO anl_node(node_id, nodecat_id, state,expl_id, fid, the_geom,descript)
			SELECT node_id, nodecat_id, state,expl_id,206,the_geom,'EXISTS'
			FROM node WHERE ST_DWithin(the_geom,v_start_point,0.1);
       
		END IF;

		IF (SELECT node_id FROM node WHERE ST_DWithin(the_geom,v_end_point,0.1) LIMIT 1) IS NULL THEN	
			IF NOT EXISTS (SELECT * FROM temp_table WHERE fid = 206 AND geom_point=v_end_point) THEN
				IF NOT EXISTS (SELECT * FROM anl_node WHERE fid = 206 AND the_geom=v_end_point) THEN
					raise notice 'insert end';

					INSERT INTO anl_node(nodecat_id, fid, the_geom, descript)
					VALUES ('DXF_JUN_CAT'::text, 206,v_end_point,'NEW');
				END IF;
			END IF;
		ELSE
			INSERT INTO anl_node(node_id, nodecat_id, state,expl_id, fid, the_geom, descript)
			SELECT node_id, nodecat_id, state,expl_id,206,the_geom, 'EXISTS'
			FROM node WHERE ST_DWithin(the_geom,v_end_point,0.1); 
		END IF;
		
	END LOOP;

	--check if there are catalogs from dxf are the same as those defined in giswater
	select replace(replace(string_agg(a::text,', '),'(',''),')','') into v_missing_cat_node FROM 
	(SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
	WHERE fid = 206 and geom_point IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_node) ) a;

	IF v_missing_cat_node IS NOT NULL THEN
		v_errortext=concat('WARNING: There are nodes which are not defined in cat_node: ',v_missing_cat_node,'.');

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 2, v_errortext);
	END IF;

	select replace(replace(string_agg(a::text,', '),'(',''),')','') into v_missing_cat_arc FROM 
	(SELECT DISTINCT (text_column::json)->>'Layer' FROM temp_table 
	WHERE fid = 206 and geom_line IS NOT NULL AND (text_column::json)->>'Layer' not in (SELECT id FROM cat_arc) ) a;

	IF v_missing_cat_arc IS NOT NULL THEN
		v_errortext=concat('WARNING: There are arcs which are not defined in cat_arc: ',v_missing_cat_arc,'.');

		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (206, 2, v_errortext);
	END IF;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 1, null);
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (206, null, 1, 'PRESS RUN TO EXECUTE INSERT');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data 
	WHERE cur_user="current_user"() AND fid = 206 ORDER BY criticity desc, id asc) row;
	
	v_result_info := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

	--points
	v_result = null;

	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id as feature_id, nodecat_id as feature_catalog, state, expl_id, descript,fid, the_geom
	FROM anl_node WHERE cur_user="current_user"() AND fid = 206) row;

	v_result := COALESCE(v_result, '{}'); 
	
	v_result = null;
	
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
     'type',       'Feature',
    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
    'properties', to_jsonb(row) - 'the_geom'
  	) AS feature
  	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fid, the_geom
  	FROM  anl_node WHERE cur_user="current_user"() AND fid = 206) row) features;

	v_result := COALESCE(v_result, '{}'); 
	
	IF v_result::text = '{}' THEN 
		v_result_point = '{"geometryType":"", "values":[]}';
	ELSE 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result,',"category_field":"descript","size":4}'); 
	END IF;

	v_result_line = '{"geometryType":"", "features":[],"category_field":""}';
	v_result_polygon = '{"geometryType":"", "features":[],"category_field":""}';

	--  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Check import dxf done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||'}'||
		       '}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

