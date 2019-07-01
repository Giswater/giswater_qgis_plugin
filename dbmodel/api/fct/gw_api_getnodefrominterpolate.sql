/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2722

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getnodefrominterpolate(p_data json)
  RETURNS json AS
$BODY$

/*
DEFINITION:
Function called wheh new node is inserted from a interpolation
EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getnodefrominterpolate($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"coordinates":{"x1":418924.6, "y1":4576556.2}, "node1":"2345", "node2":"3353"}}$$)
*/


--    Variables
    v_input_geometry public.geometry;
    v_device integer;
    v_infotype integer;
    v_x1 double precision;
    v_y1 double precision;
    v_node1 text;
    v_node2 text;
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
	v_ang210 float;
	v_ang120 float;
	v_ymax0 float;
	
BEGIN

	-- Set search path to local schema
	SET search_path = "ud_sample", public;

	-- Get SRID
	v_srid = (SELECT ST_srid (the_geom) FROM ud_sample.sector limit 1);

	-- getting input data 
	v_device := ((p_data ->>'client')::json->>'device')::integer;
	v_infotype :=  ((p_data ->>'client')::json->>'infoType')::integer;
	v_tablename :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_x1 := (((p_data ->>'data')::json->>'coordinates')::json->>'x1')::float;
	v_y1 := (((p_data ->>'data')::json->>'coordinates')::json->>'y1')::float;
	v_node1 := (((p_data ->>'data')::json->>'node1')::text;
	v_node2 := (((p_data ->>'data')::json->>'node2')::text;

	-- Make geom point
	v_geom0:= ST_SetSRID(ST_MakePoint(v_x1, v_y1),v_srid);


	-- Get node1, node2 values
	SELECT sys_top_elev, sys_elev, the_geom INTO v_top1, v_elev1, v_geom1 FROM v_edit_node WHERE node_id=p_node1;
	SELECT sys_top_elev, sys_elev, the_geom INTO v_top2, v_elev2, v_geom2 FROM v_edit_node WHERE node_id=p_node2;
	
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

	v_ymax0 = v_top0 - v_elev0;
		

	v_data := concat ('"nodeFromInterpolate":{"top_elev":"' ,v_top0, '", "elev":"', v_elev0 , '", "ymax":"'v_ymax0 '"}}')::json;

	
	-- Call gw_api_getinfofromid
	RETURN gw_api_getinfofromid(concat('{"client":',(p_data->>'client'),',"form":{"editable":"True"},"feature":{"tableName":"'
			,v_tablename,'","inputGeometry":"',v_input_geometry,'"},"data":{'||v_data||'}}')::json);

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
