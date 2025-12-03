/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2574

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getfeatureinsert(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatureinsert(p_data json)
  RETURNS json AS
$BODY$

/*
DEFINITION:
Function called wheh new geometry is inserted
EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getfeatureinsert($${
"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE},
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
v_epsg integer;
v_client_epsg integer;
v_version text;


BEGIN
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 
	v_device := ((p_data ->>'client')::json->>'device')::integer;
	v_infotype :=  ((p_data ->>'client')::json->>'infoType')::integer;
	v_client_epsg :=  ((p_data ->>'client')::json->>'epsg')::integer;
	v_tablename :=  ((p_data ->>'feature')::json->>'tableName')::text;
	v_x1 := (((p_data ->>'data')::json->>'coordinates')::json->>'x1')::float;
	v_y1 := (((p_data ->>'data')::json->>'coordinates')::json->>'y1')::float;
	v_x2 := (((p_data ->>'data')::json->>'coordinates')::json->>'x2')::float;
	v_y2 := (((p_data ->>'data')::json->>'coordinates')::json->>'y2')::float;
	
	--  get system values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	v_epsg = (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);	

	-- set geometry column (in this case is not need to transform using the client_epsg because qgis client sends the original geometry data 
	--because gets it not from canvas also from the specified feature (wichs has data on epsg from source)
	IF v_x2 IS NULL THEN
		v_input_geometry:= ST_SetSRID(ST_MakePoint(v_x1, v_y1),v_epsg);
		--v_input_geometry:= ST_Transform(ST_SetSRID(ST_MakePoint(v_x1, v_y1),v_client_epsg), v_epsg);
	ELSIF v_x2 IS NOT NULL THEN
		v_input_geometry:= ST_SetSRID(ST_MakeLine(ST_MakePoint(v_x1, v_y1), ST_MakePoint(v_x2, v_y2)),v_epsg);
		--v_input_geometry:= ST_Transform(ST_SetSRID(ST_MakeLine(ST_MakePoint(v_x1, v_y1), ST_MakePoint(v_x2, v_y2)),v_client_epsg), v_epsg);
	END IF;
	
	-- Call gw_fct_getinfofromid
	RETURN gw_fct_getinfofromid(concat('{"client":',(p_data->>'client'),',"form":{"editable":"True"},"feature":{"tableName":"',v_tablename,'","inputGeometry":"',v_input_geometry,'"},"data":{}}')::json);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN json_build_objects('status', 'Failed', 'NOSQLERR', SQLERRM, 'version', v_version, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
