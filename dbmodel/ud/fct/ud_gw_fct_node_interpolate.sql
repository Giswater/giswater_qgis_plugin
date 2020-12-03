/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2720


DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_node_interpolate(float, float, text, text);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node_interpolate(p_data json)
RETURNS json AS

$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_node_interpolate ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
 "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"x":419161.98499003565, "y":4576782.72778585, "node1":"117", "node2":"119"}}}$$);
 
--fid: 213
 
*/

DECLARE

v_srid integer;
v_geom0 public.geometry;
v_geom1 public.geometry;
v_geom2 public.geometry;
v_distance10 float;
v_distance02 float;
v_distance12 float;
v_distance102 float;
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

p_x float;
p_y float;
p_node1 text;
p_node2 text;

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

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	SELECT  giswater INTO v_version FROM sys_version order by id desc limit 1;

	p_x = (((p_data ->>'data')::json->>'parameters')::json->>'x')::float;
	p_y = (((p_data ->>'data')::json->>'parameters')::json->>'y')::float;
	p_node1 = (((p_data ->>'data')::json->>'parameters')::json->>'node1')::text;
	p_node2 = (((p_data ->>'data')::json->>'parameters')::json->>'node2')::text;

	-- manage log (fid: 213)
	DELETE FROM audit_check_data WHERE fid=213 AND cur_user=current_user;
	INSERT INTO audit_check_data (fid, error_message) VALUES (213,  concat('NODE INTERPOLATE'));
	INSERT INTO audit_check_data (fid, error_message) VALUES (213,  concat('------------------------------'));

	-- Get SRID
	v_srid = (SELECT ST_srid (the_geom) FROM SCHEMA_NAME.sector limit 1);

	-- Make geom point
	v_geom0:= (SELECT ST_SetSRID(ST_MakePoint(p_x, p_y), v_srid));

	-- Get node1 system values
	v_geom1:= (SELECT the_geom FROM node WHERE node_id=p_node1);
	v_top1:= (SELECT sys_top_elev FROM v_edit_node WHERE node_id=p_node1);
	v_elev1:= (SELECT sys_elev FROM v_edit_node WHERE node_id=p_node1);
	
	INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('System values of node 1 - top elev:',v_top1 , ', elev:', v_elev1));

	-- Get node2 system values
	v_geom2:= (SELECT the_geom FROM node WHERE node_id=p_node2);
	v_top2:= (SELECT sys_top_elev FROM v_edit_node WHERE node_id=p_node2);
	v_elev2:= (SELECT sys_elev FROM v_edit_node WHERE node_id=p_node2);

	INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('System values of node 2 - top elev:',v_top2 , ', elev:', v_elev2));

	-- Calculate distances
	v_distance10 = (SELECT ST_distance (v_geom0 , v_geom1));
	v_distance02 = (SELECT ST_distance (v_geom0 , v_geom2));
	v_distance12 = (SELECT ST_distance (v_geom1 , v_geom2));
	v_distance102 = v_distance10 + v_distance02;
	v_proportion1 = v_distance10 / v_distance102;
	v_proportion2 = v_distance02 / v_distance102;


	-- Calculate angles
	v_ang120 = @(SELECT ST_Azimuth(v_geom1, v_geom2) - ST_Azimuth(v_geom1, v_geom0));
	v_ang210 = @(SELECT ST_Azimuth(v_geom2, v_geom1) - ST_Azimuth(v_geom2, v_geom0));

	raise notice 'v_ang210 % v_ang120 %',v_ang210 ,v_ang120;

	IF v_ang120 < 1.57 AND v_ang210 < 1.57 THEN
		-- Calculate interpolation values
		v_top0 = v_top1 + (v_top2 - v_top1)* v_proportion1;
		v_elev0 = v_elev1 + (v_elev2 - v_elev1)* v_proportion1;
	ELSE 	
		IF v_distance10 < v_distance02 THEN  
			-- Calculate extrapolation values (from node1)
			v_top0 = v_top1 + (v_top1 - v_top2)* v_proportion1;
			v_elev0 = v_elev1 + (v_elev1 - v_elev2)* v_proportion1;
		ELSE
			-- Calculate extrapolation values (from node2)
			v_top0 = v_top2 + (v_top2 - v_top1)* v_proportion2;
			v_elev0 = v_elev2 + (v_elev2 - v_elev1)* v_proportion2;
		END IF;	
	END IF;
		
		
	v_top:= (SELECT to_json(v_top0::numeric(12,3)::text));
	v_ymax = (SELECT to_json((v_top0-v_elev0)::numeric(12,3)::text));		
	v_elev:= (SELECT to_json(v_elev0::numeric(12,3)::text));

    INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('------------------------------'));

	INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('Final custom results for a selected node'));

    INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('Top elev:',v_top0::numeric(12,3)::text));

    INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('Ymax:',(v_top0-v_elev0)::numeric(12,3)::text));

    INSERT INTO audit_check_data (fid,  criticity, error_message)
    VALUES (213, 4, concat('Elev:',v_elev0::numeric(12,3)::text));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=213 order by
	criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result,'}');

	
	v_result_top= COALESCE(v_top::text,'""');
	v_result_ymax = COALESCE(v_ymax::text,'""');
	v_result_elev = COALESCE(v_elev::text,'""');
	
	v_result_fields = concat('[{"data_custom_top_elev":',v_result_top, ',"data_custom_ymax":',v_result_ymax, ',"data_custom_elev":',v_result_elev,'}]');

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
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
