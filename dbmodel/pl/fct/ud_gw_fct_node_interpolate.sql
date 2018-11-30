/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node_interpolate(p_x float, p_y float, p_node1 text, p_node2 text)
RETURNS json AS

$BODY$

DECLARE

--    Variables
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
	
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get SRID
	v_srid = (SELECT ST_srid (the_geom) FROM SCHEMA_NAME.sector limit 1);

	-- Make geom point
	v_geom0:= (SELECT ST_SetSRID(ST_MakePoint(p_x, p_y), v_srid));
          			
	-- Get node1 values
	v_geom1:= (SELECT the_geom FROM node WHERE node_id=p_node1);
	v_top1:= (SELECT top_elev FROM node WHERE node_id=p_node1);
	v_elev1:= (SELECT elev FROM node WHERE node_id=p_node1);
	
	-- Get node2 values
	v_geom2:= (SELECT the_geom FROM node WHERE node_id=p_node2);
	v_top2:= (SELECT top_elev FROM node WHERE node_id=p_node2);
	v_elev2:= (SELECT elev FROM node WHERE node_id=p_node2);

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
	v_elev:= (SELECT to_json(v_elev0::numeric(12,3)::text));

--      Control NULL's
	v_top := COALESCE(v_top, '{}');
	v_elev := COALESCE(v_elev, '{}');
    

--    Return
    RETURN ('{"status":"Accepted"' ||
	', "top_elev":' || v_top ||
        ', "elev":' || v_elev ||
        '}')::json;

--   Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 