/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2720


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_node_interpolate(float, float, text, text);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node_interpolate(p_data json)
RETURNS json AS

$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_node_interpolate ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"INTERPOLATE""x":419161.98499003565, "y":4576782.72778585, "node1":"117", "node2":"119"}}}$$);

SELECT SCHEMA_NAME.gw_fct_node_interpolate ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"action":"EXTRAPOLATE", "x":419161.98499003565, "y":4576782.72778585, "node1":"117", "node2":"119"}}}$$);

SELECT * FROM audit_check_data WHERE fid=213

--fid: 213

*/

DECLARE

p_action text;

v_srid integer;
v_geom0 public.geometry;
v_geom1 public.geometry;
v_geom2 public.geometry;
v_distance01 float;
v_distance02 float;
v_distance12 float;
v_distance012 float;
v_proportion1 float;
v_proportion2 float;
v_top0 float;
v_top1 float;
v_top2 float;
v_elev1 float;
v_elev2 float;
v_elev0 float;
v_top json;
v_elev json;
v_ang210 float;
v_ang120 float;
v_ymax json;
v_version text;
v_project text;
v_depth1 float;
v_depth2 float;

p_x float;
p_y float;
p_node1 integer;
p_node2 integer;

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

v_col_top text;
v_col_ymax text;
v_col_elev text;

v_node integer;
v_querytext text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get system variables
	SELECT  giswater, upper(project_type) INTO v_version, v_project FROM sys_version order by id desc limit 1;
	SELECT value INTO v_value FROM config_param_user WHERE parameter = 'edit_node_interpolate' AND cur_user = current_user;
	v_srid = (SELECT epsg FROM sys_version limit 1);

	-- get parameters
	p_x = (((p_data ->>'data')::json->>'parameters')::json->>'x')::float;
	p_y = (((p_data ->>'data')::json->>'parameters')::json->>'y')::float;
	p_node1 = (((p_data ->>'data')::json->>'parameters')::json->>'node1')::integer;
	p_node2 = (((p_data ->>'data')::json->>'parameters')::json->>'node2')::integer;
	p_action = (((p_data ->>'data')::json->>'parameters')::json->>'action');
	v_node  = (((p_data ->>'data')::json->>'parameters')::json->>'TargetNode');

	IF v_project='UD' THEN
		v_top_status := (v_value->>'topElev')::json->>'status';
		v_elev_status := (v_value->>'elev')::json->>'status';
		v_ymax_status := (v_value->>'ymax')::json->>'status';

		v_col_top = (v_value->>'topElev')::json->>'column';
		v_col_ymax = (v_value->>'ymax')::json->>'column';
		v_col_elev = (v_value->>'elev')::json->>'column';
	ELSE
		v_top_status := (v_value->>'topElev')::json->>'status';
		v_ymax_status := (v_value->>'depth')::json->>'status';
		v_col_top = (v_value->>'topElev')::json->>'column';
		v_col_ymax = (v_value->>'depth')::json->>'column';
	END IF;

	IF p_action IS NULL THEN
		p_action = 'INTERPOLATE';
	END IF;

	-- manage log (fid: 213)
	DELETE FROM audit_check_data WHERE fid=213 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, error_message) VALUES (213,  concat('NODE ',upper(p_action),' TOOL'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (213,  concat('--------------------------------'));

	if v_node is not null then
		v_geom0:= (select the_geom from node where node_id = v_node);
	else
		-- Make geom point
		v_geom0:= (SELECT ST_SetSRID(ST_MakePoint(p_x, p_y), v_srid));
		--getting node_id
		SELECT node_id INTO v_node FROM ve_node WHERE st_equals(the_geom, v_geom0) LIMIT 1;
	end if;


	-- Get node1 system values
	v_geom1:= (SELECT the_geom FROM node WHERE node_id=p_node1);
	IF v_project='UD' THEN
		v_top1:= (SELECT sys_top_elev FROM ve_node WHERE node_id=p_node1);
		v_elev1:= (SELECT sys_elev FROM ve_node WHERE node_id=p_node1);
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (213, 4, concat('System values of node 1 (',p_node1,') - top elev:',v_top1 , ', elev:', v_elev1));
	ELSE
		v_top1:= (SELECT sys_top_elev FROM ve_node WHERE node_id=p_node1);
		v_elev1:= (SELECT top_elev - depth FROM ve_node WHERE node_id=p_node1);
		v_depth1:= (SELECT depth FROM ve_node WHERE node_id=p_node1);
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (213, 4, concat('System values of node 1 (',p_node1,') - top elev:',v_top1 , ', depth:', v_depth1));

	END IF;


	-- Get node2 system values
	v_geom2:= (SELECT the_geom FROM node WHERE node_id=p_node2);
	IF v_project='UD' THEN
		v_top2:= (SELECT sys_top_elev FROM ve_node WHERE node_id=p_node2);
		v_elev2:= (SELECT sys_elev FROM ve_node WHERE node_id=p_node2);
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (213, 4, concat('System values of node 2 (',p_node2,') - top elev:',v_top2 , ', elev:', v_elev2));
	ELSE
		v_top2:= (SELECT sys_top_elev FROM ve_node WHERE node_id=p_node2);
		v_elev2:= (SELECT top_elev - depth FROM ve_node WHERE node_id=p_node2);
		v_depth2:= (SELECT depth FROM ve_node WHERE node_id=p_node2);
		INSERT INTO audit_check_data (fid,  criticity, error_message)
		VALUES (213, 4, concat('System values of node 2 (',p_node2,') - top elev:',v_top2 , ', depth:', v_depth2));
	END IF;

	-- Calculate distances
	v_distance01 = (SELECT ST_distance (v_geom0 , v_geom1));
	v_distance02 = (SELECT ST_distance (v_geom0 , v_geom2));
	v_distance12 = (SELECT ST_distance (v_geom1 , v_geom2));
	v_distance012 = v_distance01 + v_distance02;
	v_proportion1 = v_distance01 / v_distance012;
	v_proportion2 = v_distance02 / v_distance012;

	IF p_action =  'INTERPOLATE' OR  p_action =  'MASSIVE-INTERPOLATE' THEN
		-- Calculate interpolation values
		v_top0 = v_top1 + (v_top2 - v_top1)* v_proportion1;
		v_elev0 = v_elev1 + (v_elev2 - v_elev1)* v_proportion1;
	ELSE
		IF v_distance01 < v_distance02 THEN
			-- Calculate extrapolation values (from node1)
			v_top0 = v_top1 + (v_top1 - v_top2)* v_proportion1;
			v_elev0 = v_elev1 + (v_elev1 - v_elev2)* v_proportion1;
		ELSE
			-- Calculate extrapolation values (from node2)
			v_top0 = v_top2 + (v_top2 - v_top1)* v_proportion2;
			v_elev0 = v_elev2 + (v_elev2 - v_elev1)* v_proportion2;
		END IF;
	END IF;

	-- update values
	IF v_project='UD' THEN

		IF v_top_status THEN
			v_top:= (SELECT to_json(v_top0::numeric(12,3)::text));
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (213, 4, concat('Top elev:',v_top0::numeric(12,3)::text));

			IF p_action =  'MASSIVE-INTERPOLATE' AND v_node IS NOT NULL THEN
				v_querytext =  'UPDATE node SET '||v_col_top||' = '||v_top0::numeric(12,3)||' WHERE node_id = '||v_node||'::text';
				EXECUTE v_querytext;
			END IF;
		END IF;

		IF v_ymax_status THEN
			v_ymax = (SELECT to_json((v_top0-v_elev0)::numeric(12,3)::text));
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (213, 4, concat('Ymax:',(v_top0-v_elev0)::numeric(12,3)::text));

			IF p_action =  'MASSIVE-INTERPOLATE' AND v_node IS NOT NULL THEN
				v_querytext =  'UPDATE node SET '||v_col_ymax||' = '||(v_top0-v_elev0)::numeric(12,3)||' WHERE node_id = '||v_node||'::text';
				EXECUTE v_querytext;
			END IF;
		END IF;

		IF v_elev_status THEN
			v_elev:= (SELECT to_json(v_elev0::numeric(12,3)::text));
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (213, 4, concat('Elev:',v_elev0::numeric(12,3)::text));

			IF p_action =  'MASSIVE-INTERPOLATE' AND v_node IS NOT NULL THEN
				v_querytext =  'UPDATE node SET '||v_col_elev||' = '||v_elev0::numeric(12,3)||' WHERE node_id = '||v_node||'::text';
				EXECUTE v_querytext;
			END IF;
		END IF;

	ELSE
		IF v_top_status THEN
			v_top:= (SELECT to_json(v_top0::numeric(12,3)::text));
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (213, 4, concat('Elevation:',v_top0::numeric(12,3)::text));
		END IF;

		IF v_ymax_status THEN
			v_ymax = (SELECT to_json((v_top0-v_elev0)::numeric(12,3)::text));
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (213, 4, concat('Depth:',(v_top0-v_elev0)::numeric(12,3)::text));
		END IF;


	END IF;

	INSERT INTO audit_check_data (fid,  criticity, error_message)
	VALUES (213, 4, 'INFO: In order to configure columns updated by the process upsert user variable edit_node_interpolate');

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=213 order by
	criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result,'}');

	-- control nulls
	v_col_top= COALESCE(v_col_top::text,'');
	v_col_ymax = COALESCE(v_col_ymax::text,'');
	v_col_elev = COALESCE(v_col_elev::text,'');
	v_result_top= COALESCE(v_top::text,'""');
	v_result_ymax = COALESCE(v_ymax::text,'""');
	v_result_elev = COALESCE(v_elev::text,'""');

	IF v_project='UD' THEN
		v_result_fields = concat('[{"tab_data_',v_col_top,'":',v_result_top,',"tab_data_',v_col_ymax,'":',v_result_ymax, ',"tab_data_',v_col_elev,'":',v_result_elev,'}]');
	ELSE
		v_result_fields = concat('[{"tab_data_',v_col_top,'":',v_result_top,',"tab_data_',v_col_ymax,'":',v_result_ymax,'}]');
	END IF;


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
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
