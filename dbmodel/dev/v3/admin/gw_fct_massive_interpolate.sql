-- FUNCTION: SHCEMA_NAME.gw_fct_massive_interpolate(json)

-- DROP FUNCTION IF EXISTS SHCEMA_NAME.gw_fct_massive_interpolate(json);
--9900
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_massive_interpolate(
	p_data json)
    RETURNS json
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
/*
SELECT SHCEMA_NAME.gw_fct_massive_interpolate ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"INTERPOLATE"}}}$$);

SELECT SHCEMA_NAME.gw_fct_node_interpolate ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"INTERPOLATE","x":419161.98499003565, "y":4576782.72778585, "node1":"117", "node2":"119"}}}$$);

SELECT SHCEMA_NAME.gw_fct_node_interpolate ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"EXTRAPOLATE", "x":419161.98499003565, "y":4576782.72778585, "node1":"117", "node2":"119"}}}$$);

SELECT * FROM audit_check_data WHERE fid=213

--fid: 980

*/

DECLARE

p_action text;

v_srid integer;
v_version text;
v_project text;

v_result text;
v_result_info json;
v_result_point json;
v_result_polygon json;
v_result_line json;
v_result_fields text;
v_result_ymax text;
v_result_top text;
v_result_elev text;
v_error_context text;

v_value json;
v_top_status boolean;
v_elev_status boolean;
v_ymax_status boolean;

v_id json;
v_selectionmode text;
v_array text;

rec record;
rec_arc_1 record;
rec_arc_2 record;
v_sys_top_elev1 float;
v_sys_elev1 float;
v_sys_top_elev2 float;
v_sys_elev2 float;
v_ymax2 float;
v_query text;
v_return json;
v_data_custom_top_elev text;
v_data_custom_ymax text;
v_data_custom_elev text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT  giswater, upper(project_type) INTO v_version, v_project FROM sys_version order by id desc limit 1;
	v_srid = (SELECT epsg FROM SHCEMA_NAME.sys_version limit 1);

	SELECT value INTO v_value FROM config_param_user WHERE parameter = 'edit_node_interpolate' AND cur_user = current_user;

	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	-- manage log (fid: 980)
	DELETE FROM audit_check_data WHERE fid=980 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('MASSIVE NODE INTERPOLATE'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('--------------------------------'));

	IF v_selectionmode = 'previousSelection' THEN
		v_query = 'SELECT * FROM ve_node WHERE sys_ymax IS NULL AND the_geom IS NOT NULL AND node_id IN ('||v_array ||')';
	ELSE
		v_query = 'SELECT * FROM ve_node WHERE sys_ymax IS NULL AND the_geom IS NOT NULL';
	END IF;

	FOR rec IN EXECUTE v_query LOOP

		SELECT arc_id, node_1 as node_id INTO rec_arc_1 FROM ve_arc WHERE state=1 and node_2 = rec.node_id;
		SELECT arc_id, node_2 as node_id  INTO rec_arc_2 FROM ve_arc WHERE  state=1 and node_1 = rec.node_id;


		SELECT sys_top_elev, sys_elev INTO v_sys_top_elev1, v_sys_elev1 FROM ve_node WHERE state=1 and node_id=rec_arc_1.node_id;
		SELECT sys_top_elev, sys_elev INTO v_sys_top_elev2, v_sys_elev2 FROM ve_node WHERE state=1 and node_id=rec_arc_2.node_id;


		IF v_sys_top_elev1 IS NOT NULL AND v_sys_elev1 IS NOT NULL AND v_sys_top_elev2 IS NOT NULL AND v_sys_elev2 IS NOT NULL AND
		v_sys_top_elev1 !=0 AND v_sys_elev1  !=0 AND v_sys_top_elev2  !=0 AND v_sys_elev2  !=0 THEN

			EXECUTE 'SELECT gw_fct_node_interpolate($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":'||v_srid||'}, 
			"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
			"parameters":{"action":"INTERPOLATE", "x":'||ST_X(rec.the_geom)||', "y":'||ST_Y(rec.the_geom)||', 
			"node1":'||quote_ident(rec_arc_1.node_id)||', "node2":'||quote_ident(rec_arc_2.node_id)||'}}}$$);'
			INTO v_return;
			INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('NODE: ',rec.node_id,' - INTERPOLATE'));

		ELSIF v_sys_top_elev1 IS NOT NULL AND v_sys_elev1 IS NOT NULL AND ((v_sys_top_elev2 IS NULL OR v_sys_elev2 IS NULL) OR (v_sys_top_elev2 = 0 OR v_sys_elev2= 0)) THEN


			SELECT arc_id, node_1 as node_id  INTO rec_arc_2 FROM ve_arc WHERE state=1 and node_2 = rec_arc_1.node_id;
			SELECT sys_top_elev, sys_elev INTO v_sys_top_elev2, v_sys_elev2 FROM ve_node WHERE state=1 and node_id=rec_arc_2.node_id;

			if v_sys_top_elev2 IS NOT NULL and v_sys_elev2 IS NOT NULL THEN
				EXECUTE 'SELECT gw_fct_node_interpolate($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":'||v_srid||'}, 
				"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
				"parameters":{"action":"EXTRAPOLATE", "x":'||ST_X(rec.the_geom)||', "y":'||ST_Y(rec.the_geom)||', 
				"node1":'||quote_ident(rec_arc_1.node_id)||', "node2":'||quote_ident(rec_arc_2.node_id)||'}}}$$);'
				INTO v_return;
				INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('NODE: ',rec.node_id,' - EXTRAPOLATE'));
			else
				INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('NODE: ',rec.node_id));
			end if;
		ELSIF ((v_sys_top_elev1 IS NULL OR v_sys_elev1 IS NULL) OR (v_sys_top_elev1 = 0 OR v_sys_elev1 = 0) ) AND v_sys_top_elev2 IS NOT NULL AND v_sys_elev2 IS NOT NULL THEN


			SELECT arc_id, node_2 AS node_id  INTO rec_arc_1 FROM ve_arc WHERE state=1 and node_1 = rec_arc_2.node_id;
			SELECT sys_top_elev, sys_elev INTO v_sys_top_elev1, v_sys_elev1 FROM ve_node WHERE state=1 and node_id=rec_arc_1.node_id;

			if v_sys_top_elev1 IS NOT NULL AND v_sys_elev1 IS NOT NULL then
				EXECUTE 'SELECT gw_fct_node_interpolate($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":'||v_srid||'}, 
				"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, 
				"parameters":{"action":"EXTRAPOLATE", "x":'||ST_X(rec.the_geom)||', "y":'||ST_Y(rec.the_geom)||', 
				"node1":'||quote_ident(rec_arc_1.node_id)||', "node2":'||quote_ident(rec_arc_2.node_id)||'}}}$$);'
				INTO v_return;

				INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('NODE: ',rec.node_id,' - EXTRAPOLATE'));
			else
				INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('NODE: ',rec.node_id));
			end if;

		ELSE
			INSERT INTO audit_check_data (fid, error_message) VALUES (980,  concat('NODE: ',rec.node_id));

		END IF;

		IF json_extract_path_text(v_return, 'status') = 'Accepted' THEN
				raise notice 'v_return,%',v_return;
				SELECT json_extract_path_text(json_array_elements(json_extract_path_text(v_return,'body','data', 'fields')::json), 'data_custom_top_elev')
				INTO v_data_custom_top_elev;
				SELECT json_extract_path_text(json_array_elements(json_extract_path_text(v_return,'body','data', 'fields')::json), 'data_custom_ymax')
				INTO v_data_custom_ymax;
				SELECT json_extract_path_text(json_array_elements(json_extract_path_text(v_return,'body','data', 'fields')::json), 'data_custom_elev')
				INTO v_data_custom_elev;

				IF v_data_custom_top_elev!=''  AND json_extract_path_text(v_value::json,'topElev', 'status')::BOOLEAN IS TRUE THEN
					EXECUTE 'UPDATE node SET custom_top_elev =  '||v_data_custom_top_elev::float||'
					WHERE node_id='||quote_literal(rec.node_id)||' AND top_elev IS NULL;';
				END IF;

				IF v_data_custom_ymax!='' AND json_extract_path_text(v_value::json,'ymax', 'status')::BOOLEAN IS TRUE THEN
					EXECUTE 'UPDATE node SET custom_ymax = '||v_data_custom_ymax::float||' WHERE node_id='||quote_literal(rec.node_id)||' AND custom_ymax IS NULL;';
				END IF;

				IF v_data_custom_ymax='' AND v_data_custom_elev !='' AND json_extract_path_text(v_value::json,'elev', 'status')::BOOLEAN IS TRUE THEN
					EXECUTE 'UPDATE node SET custom_elev = '||v_data_custom_elev::float||' WHERE node_id='||quote_literal(rec.node_id)||'AND custom_elev IS NULL;';
				END IF;

				IF v_data_custom_ymax!='' OR v_data_custom_ymax!='' OR v_data_custom_elev !='' THEN
					EXECUTE 'INSERT INTO anl_node (node_id,  descript,  fid, the_geom)
					SELECT node_id, ''Interpolated data.'', 980, n.the_geom
					FROM ve_node n WHERE node_id='||quote_literal(rec.node_id)||';';

					INSERT INTO audit_check_data (fid, error_message)
					SELECT 980, message FROM
					(select json_extract_path_text(json_array_elements(json_extract_path_text(v_return,
					'body', 'data','info', 'values')::json), 'message') as message)a
					WHERE message ilike 'System%' or message ilike 'Top%' or message ilike 'Ymax%'  or message ilike 'Elev%';
				ELSE
					INSERT INTO audit_check_data (fid, error_message)
					VALUES (980, 'Missing data, can''t proceed with the process');
				END IF;
			END IF;

	END LOOP;

	-- get results

	-- get results
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
	    FROM (SELECT DISTINCT ON (node_id) id, node_id,  descript,fid, ST_Transform(the_geom, 4326) as the_geom
	    FROM  anl_node WHERE cur_user="current_user"() AND fid=980 ) row) features;

	  	v_result_point := COALESCE(v_result, '{}');


	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=980 order by
	criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result,'}');

	-- control nulls
	/*v_col_top= COALESCE(v_col_top::text,'');
	v_col_ymax = COALESCE(v_col_ymax::text,'');
	v_col_elev = COALESCE(v_col_elev::text,'');*/

	-- Control NULL's
	v_version:=COALESCE(v_version,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');
	v_result_point:=COALESCE(v_result_point,'{}');
	v_result_line:=COALESCE(v_result_line,'{}');
	v_result_polygon:=COALESCE(v_result_polygon,'{}');
	v_result_fields:=COALESCE(v_result_fields,'{}');

	--return definition for v_audit_check_result
	RETURN  ('{"status":"Accepted", "message":{"level":1, "text":"Node interpolation done successfully"}, "version":"'||v_version||'"'||
		     ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||','||
					'"fields":'||v_result_fields||'}'||
			      '}}');

	--  Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	--RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$;

ALTER FUNCTION SHCEMA_NAME.gw_fct_massive_interpolate(json)
    OWNER TO role_admin;

GRANT EXECUTE ON FUNCTION SHCEMA_NAME.gw_fct_massive_interpolate(json) TO PUBLIC;

GRANT EXECUTE ON FUNCTION SHCEMA_NAME.gw_fct_massive_interpolate(json) TO role_admin;

GRANT EXECUTE ON FUNCTION SHCEMA_NAME.gw_fct_massive_interpolate(json) TO role_basic;

/*

INSERT INTO SHCEMA_NAME.sys_function(
id, function_name, project_type, function_type, input_params, return_type, descript, sys_role,  source)
VALUES (9900, 'gw_fct_massive_interpolate', 'ud', 'function', 'json', 'json', 'Function for executing massive interpolation process', 'role_admin',  'core');

INSERT INTO SHCEMA_NAME.sys_fprocess(fid, fprocess_name, project_type,  source, isaudit, fprocess_type)
VALUES (980, 'Massive interpolate', 'ud', 'core', false, 'Function process');

INSERT INTO SHCEMA_NAME.config_function(	id, function_name, style )
VALUES (9900,'gw_fct_massive_interpolate', '{"style":{"point":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}},
"line":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}},
"polygon":{"style":"unique", "values":{"width":3, "color":[255,1,1], "transparency":0.5}}}}');

INSERT INTO SHCEMA_NAME.config_toolbox(id, alias, functionparams,   active)
VALUES (9900, 'Massive interpolate', '{"featureType":["node"]}',true);

*/