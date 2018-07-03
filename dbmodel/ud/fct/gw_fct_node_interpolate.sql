/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_node_interpolate(p_x0 float, p_y0 float, p_x1 float, p_y1 float, p_top1 float, 
p_elev1 float, p_x2 float, p_y2 float, p_top2 float, p_elev2 float)
RETURNS json AS

$BODY$

DECLARE

--    Variables
	v_srid integer;
	v_geom0 public.geometry;
	v_geom1 public.geometry;
	v_geom2 public.geometry;
	v_distance01 float;
	v_distance02 float;
	v_proportion1 float;
	v_top0 float;
	v_elev0 float;
	v_top json;
	v_elev json;
	
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get SRID
	v_srid = (SELECT ST_srid (the_geom) FROM SCHEMA_NAME.sector limit 1);

	-- Make geom point
	v_geom0:= (SELECT ST_SetSRID(ST_MakePoint(p_x0, p_y0), v_srid));
          			
	-- Make geom1 point
	v_geom1:= (SELECT ST_SetSRID(ST_MakePoint(p_x1, p_y1), v_srid));
	
	-- Make geom2 point
	v_geom2:= (SELECT ST_SetSRID(ST_MakePoint(p_x2, p_y2), v_srid));

	-- Calculate distances
	v_distance01 = (SELECT ST_distance (v_geom0 , v_geom1));
	v_distance02 = (SELECT ST_distance (v_geom0 , v_geom2));

	-- Calculate proportionalposition
	v_proportion1 = v_distance01 / (v_distance01 + v_distance02);

	-- Calculate interpolation values
	v_top0 = p_top1 + (p_top2 - p_top1)* v_proportion1;
	v_elev0 = p_elev1 + (p_elev2 - p_elev1)* v_proportion1;
		
	v_top:= (SELECT to_json(v_top0::numeric(12,3)::text));
	v_elev:= (SELECT to_json(v_elev0::numeric(12,3)::text));

--    Control NULL's
    v_top := COALESCE(v_top, '{}');
    v_elev := COALESCE(v_elev, '{}');
    

--    Return
    RETURN ('{"status":"Accepted"' ||
	', "top_elev":' || v_top ||
        ', "elev":' || v_elev ||
        '}')::json;

--   Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 