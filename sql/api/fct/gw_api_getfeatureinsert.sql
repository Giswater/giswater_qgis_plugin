/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2574

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getfeatureinsert(p_data json)
  RETURNS json AS
$BODY$

/*
DEFINITION:
Function called wheh new geometry is inserted to control topological geometry
EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getfeatureinsert($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_arc_pipe"},
"data":{"coordinates":{"x1":418924.6, "y1":4576556.2, "x2":419034.8, "y2":4576634.0}}}$$)
*/

DECLARE
    v_input_geometry public.geometry;
    v_device integer;
    v_infotype integer;
    v_tablename character varying;
    v_x1 double precision;
    v_y1 double precision;
    v_x2 double precision;
    v_y2 double precision;

BEGIN
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 
	v_device := ((p_data ->>'client')::json->>'device')::integer;
	v_infotype :=  ((p_data ->>'client')::json->>'infoType')::integer;
	v_tablename :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_x1 := (((p_data ->>'data')::json->>'coordinates')::json->>'x1')::float;
	v_y1 := (((p_data ->>'data')::json->>'coordinates')::json->>'y1')::float;
	v_x2 := (((p_data ->>'data')::json->>'coordinates')::json->>'x2')::float;
	v_y2 := (((p_data ->>'data')::json->>'coordinates')::json->>'y2')::float;

	-- Geometry column
	IF v_x2 IS NULL THEN
		v_input_geometry:= ST_SetSRID(ST_MakePoint(v_x1, v_y1),(SELECT ST_srid (the_geom) FROM sector limit 1));
	ELSIF v_x2 IS NOT NULL THEN
		v_input_geometry:= ST_SetSRID(ST_MakeLine(ST_MakePoint(v_x1, v_y1), ST_MakePoint(v_x2, v_y2)),(SELECT ST_srid (the_geom) FROM sector limit 1));
	END IF;
	
	-- Call gw_api_getinfofromid
	RETURN SCHEMA_NAME.gw_api_getinfofromid(concat('{"client":',(p_data->>'client'),',"form":{"editable":"True"},"feature":{"tableName":"'
			,v_tablename,'","inputGeometry":"',v_input_geometry,'"},"data":{}}')::json);

--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
